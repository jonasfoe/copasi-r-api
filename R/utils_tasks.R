# List of all available tasks
#' @include swig_wrapper.R
task_enum <-
  names(.__E___CTaskEnum__Task) %>%
  .[. != "UnsetTask" & . != "__SIZE"]

# Push transient values from mathcontainer back to the model.
# Mostly called after task execution to update model values.
update_model_from_mc <- function(c_mathcontainer) {
  c_mathcontainer$updateSimulatedValues(FALSE);
  c_mathcontainer$updateTransientDataValues();
  c_mathcontainer$pushAllTransientValues();
}

#' Autoplot method for copasi timeseries objects.
#'
#' Uses ggplot2 to plot timeseries.
#' The plot has a geom_line layer.
#'
#' @param object The data to be plotted, as returned by \code{\link{runTimeCourse}}. This object is of type \code{copasi_ts}.
#' @param \dots Column names selected for plotting, as strings. Uses partial matching. Also accepts full keys.
#' @param use_concentrations Whether to print concentrations or particle numbers for species, as flag.
#' @return A ggplot2 plot
# #' @importFrom ggplot2 autoplot
#' @export autoplot.copasi_ts
'autoplot.copasi_ts' <- function(object, ..., use_concentrations = TRUE) {
  # make sure ggplot2 is available
  loadNamespace("ggplot2")
  
  assert_that(is.flag(use_concentrations) && noNA(use_concentrations))
  
  validate_copasi_ts(object)
  
  if (use_concentrations)
    tc <- object$result
  else
    tc <- object$result_number
  
  names_vec <- flatten_chr(list(...))
  
  # prefer full match to keys
  matches <- match(names_vec, object$column_keys)
  matched <- !is.na(matches)
  
  if (!all(matched)) {
    # then use partial matching
    matches[!matched] <- pmatch(names_vec[!matched], names(tc))
    matched <- !is.na(matches)
    
    if (!all(matched)) {
      warning("Partial matching failed for some entities")
      matches <- matches[!is.na(matches)]
    }
  }
  
  # only add entities selected in ...
  if (!is_empty(matches))
    tc <- dplyr::select(tc, .data$Time, !!!matches)
  
  units <- object$units
  
  x_label <- paste0("Time (", units$time, ")")
  
  if (use_concentrations)
    y_label <- paste0("Concentration (", units$concentration, ")")
  else
    y_label <- paste0("Number")
  
  # reshape data frame for ggplot and define the plot
  tc %>%
    tidyr::gather("Entities", "Concentration", -.data$Time) %>%
    ggplot2::ggplot(ggplot2::aes_(x = ~ Time, y = ~ Concentration, group = ~ Entities, color = ~ Entities)) +
    ggplot2::geom_line() +
    ggplot2::labs(
      x = x_label,
      y = y_label
    )
}

# CParameter gives us only feedback on what kind of value it needs.
# It is our responsibility to call the right function which is why this list is needed.
cparameter_control_functions <-
  list(
    DOUBLE = function(x) {is_scalar_integer(x) || is_scalar_double(x)},
    UDOUBLE = function(x) {(is_scalar_integer(x) || is_scalar_double(x)) && x >= 0},
    INT = rlang::is_scalar_integerish,
    UINT = function(x) {rlang::is_scalar_integerish(x) && x >= 0},
    BOOL = function(x) {length(x) != 0L && (x == 1L || x == 0L)},
    STRING = is_scalar_character,
    GROUP = NULL,
    CN = is_scalar_character,
    KEY = is_scalar_character,
    FILE = is_scalar_character,
    EXPRESSION = NULL,
    INVALID = NULL
  )

cparameter_get_functions <-
  list(
    DOUBLE = CCopasiParameter_getDblValue,
    UDOUBLE = CCopasiParameter_getUDblValue,
    INT = CCopasiParameter_getIntValue,
    UINT = CCopasiParameter_getUIntValue,
    BOOL = CCopasiParameter_getBoolValue,
    STRING = CCopasiParameter_getStringValue,
    # GROUP = CCopasiParameter_getGroupValue,
    GROUP = function(self) {"UNSUPPORTED_PARAMETER"},
    CN = function(self) {
      CCopasiParameter_getCNValue(self)$getString()
    },
    KEY = CCopasiParameter_getKeyValue,
    FILE = CCopasiParameter_getFileValue,
    EXPRESSION = function(self) {"UNSUPPORTED_PARAMETER"},
    INVALID = function(self) {"UNSUPPORTED_PARAMETER"}
  )

cparameter_set_functions <-
  list(
    DOUBLE = CCopasiParameter_setDblValue,
    UDOUBLE = CCopasiParameter_setUDblValue,
    INT = CCopasiParameter_setIntValue,
    UINT = CCopasiParameter_setUIntValue,
    BOOL = CCopasiParameter_setBoolValue,
    STRING = CCopasiParameter_setStringValue,
    GROUP = CCopasiParameter_setGroupValue,
    CN = function(self, x) {
      CCopasiParameter_setCNValue(self, CCommonName(x))
    },
    KEY = CCopasiParameter_setKeyValue,
    FILE = CCopasiParameter_setFileValue,
    EXPRESSION = NULL,
    INVALID = NULL
  )

methodstructure <- function(c_method) {
  struct <-
    tibble::tibble(
      object      = map(seq_along_v(c_method), c_method$getParameter),
      name        = map_swig_chr(.data$object, "getObjectName") %>% transform_names_worker(),
      type        = map_swig_chr(.data$object, "getType"),
      control_fun = cparameter_control_functions[.data$type],
      get_fun     = cparameter_get_functions[.data$type],
      set_fun     = cparameter_set_functions[.data$type]
    )
  
  if (has_element(struct$control_fun, NULL))
    warning("Internal: Unknown type found with parameters: ", paste(struct$name[map_lgl(struct$control_fun, is.null)], collapse = "; "))
  
  struct
}

get_method_settings <- function(c_method, with_name = FALSE) {
  struct <- methodstructure(c_method)
  ret <- list()
  
  if (with_name) ret$method <- c_method$getSubType()
  
  params <- map2(struct$get_fun, struct$object, ~ .x(.y))
  names(params) <- struct$name
  
  c(ret, params)
}

set_method_settings <- function(values, c_method) {
  # parameter "method" is reserved for CoRC
  # if a parameter "method" is ever created in CoRC, adjust methodstructure() to call it "method_"
  values <- values[names(values) != "method"]
  
  if (is_empty(values))
    return()
  
  struct <- methodstructure(c_method) %>% tibble::rowid_to_column()
  
  data <-
    tibble::tibble(value = values) %>%
    dplyr::mutate(rowid = pmatch(names(values), struct$name))
  
  matched <- !is.na(data$rowid)
  
  assert_that(
    all(matched),
    msg = paste0(
      "Bad method parameter names.\n",
      '"', names(values)[!matched][1], '" should be one of "',
      paste0(struct$name, collapse = '", "'), '".'
    )
  )
  
  data <-
    data %>%
    dplyr::filter(map_lgl(.data$value, negate(is.null))) %>%
    dplyr::left_join(struct, by = "rowid")
  
  skipped <- map_lgl(data$control_fun, is.null)
  
  skipped %>%
    which() %>%
    walk(~
      warning('Parameter "', data$name[.x], '" was skipped because it is of unsupported type "', data$struct[.x], '".')
    )
  
  data <- dplyr::filter(data, !skipped)
  
  allowed <- map2_lgl(data$control_fun, data$value, ~ .x(.y))
  
  assert_that(
    all(allowed),
    msg = paste0(
      'Method parameter "', data$name[!allowed][1], '" has to be of type "', data$type[!allowed][1], '".'
    )
  )
  
  success <- pmap_lgl(
    data,
    function(set_fun, object, value, ...) {
      set_fun(object, value)
    }
  )
  
  assert_that(
    all(success),
    msg = paste0('Method parameter "', data$name[!success][1], '" could not be set.')
  )
}