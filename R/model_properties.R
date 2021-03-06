#' Get the model's name
#'
#' \code{getModelName} gives the name of the model.
#'
#' @param model a model object
#' @return name
#' @seealso \code{\link{setModelName}}
#' @family model property functions
#' @export
getModelName <- function(model = getCurrentModel()) {
  c_datamodel <- assert_datamodel(model)
  
  c_datamodel$getModel()$getObjectName()
}

#' Set a model's name
#'
#' \code{setModelName} sets the name of the model.
#'
#' @param name the new model name
#' @param model a model object
#' @seealso \code{\link{getModelName}}
#' @family model property functions
#' @export
setModelName <- function(name, model = getCurrentModel()) {
  c_datamodel <- assert_datamodel(model)
  assert_that(is.string(name))
  
  assert_that(
    c_datamodel$getModel()$setObjectName(name),
    msg = "Setting model name failed."
  )
  
  invisible()
}

#' Get the unit of time
#'
#' \code{getTimeUnit} gets the unit used for time.
#'
#' @param model a model object
#' @return unit of time
#' @seealso \code{\link{setTimeUnit}}
#' @family model property functions
#' @export
getTimeUnit <- function(model = getCurrentModel()) {
  c_datamodel <- assert_datamodel(model)
  
  c_datamodel$getModel()$getTimeUnit()
}

#' Set the unit of time
#'
#' \code{setTimeUnit} sets the unit used for time.
#'
#' @param unit string
#' @param model a model object
#' @seealso \code{\link{getTimeUnit}}
#' @family model property functions
#' @export
setTimeUnit <- function(unit, model = getCurrentModel()) {
  c_datamodel <- assert_datamodel(model)
  assert_that(is.string(unit))
  
  c_unit <- grab_msg(CUnit(unit))
  c_unit$buildExpression()
  unit <- c_unit$getExpression()
  
  assert_that(
    c_unit$isUnitType("time"),
    msg = paste0(unit, " is not a valid time unit.")
  )
  
  assert_that(
    grab_msg(c_datamodel$getModel()$setTimeUnitFromString(unit)),
    msg = "Setting time unit failed."
  )
  
  invisible()
}

#' Get the unit of quantity
#'
#' \code{getQuantityUnit} gets the unit used for quantity.
#'
#' @param model a model object
#' @return unit of quantity
#' @seealso \code{\link{setQuantityUnit}}
#' @family model property functions
#' @export
getQuantityUnit <- function(model = getCurrentModel()) {
  c_datamodel <- assert_datamodel(model)
  
  c_datamodel$getModel()$getQuantityUnit()
}

#' Set the unit of quantity
#'
#' \code{setQuantityUnit} sets the unit used for quantity.
#'
#' @param unit string
#' @param model a model object
#' @seealso \code{\link{getQuantityUnit}}
#' @family model property functions
#' @export
setQuantityUnit <- function(unit, model = getCurrentModel()) {
  c_datamodel <- assert_datamodel(model)
  assert_that(is.string(unit))
  
  c_unit <- grab_msg(CUnit(unit))
  c_unit$buildExpression()
  unit <- c_unit$getExpression()
  
  assert_that(
    # type quantity needs an extra check because quanitity only works for "1" and "#".
    c_unit$isUnitType("quantity"),
    msg = paste0(unit, " is not a valid quantity unit.")
  )
  
  assert_that(
    grab_msg(c_datamodel$getModel()$setQuantityUnitFromString(unit)),
    msg = "Setting quantity unit failed."
  )
  
  invisible()
}

#' Get the unit of volume
#'
#' \code{getVolumeUnit} gets the unit used for volume.
#'
#' @param model a model object
#' @return unit of volume
#' @seealso \code{\link{setVolumeUnit}}
#' @family model property functions
#' @export
getVolumeUnit <- function(model = getCurrentModel()) {
  c_datamodel <- assert_datamodel(model)
  
  c_datamodel$getModel()$getVolumeUnit()
}

#' Set the unit of volume
#'
#' \code{setVolumeUnit} sets the unit used for volume.
#'
#' @param unit string
#' @param model a model object
#' @seealso \code{\link{getVolumeUnit}}
#' @family model property functions
#' @export
setVolumeUnit <- function(unit, model = getCurrentModel()) {
  c_datamodel <- assert_datamodel(model)
  assert_that(is.string(unit))
  
  c_unit <- grab_msg(CUnit(unit))
  c_unit$buildExpression()
  unit <- c_unit$getExpression()
  
  assert_that(
    c_unit$isUnitType("volume"),
    msg = paste0(unit, " is not a valid volume unit.")
  )
  
  assert_that(
    grab_msg(c_datamodel$getModel()$setVolumeUnitFromString(unit)),
    msg = "Setting volume unit failed."
  )
  
  invisible()
}

#' Get the unit of area
#'
#' \code{getAreaUnit} gets the unit used for area.
#'
#' @param model a model object
#' @return unit of area
#' @seealso \code{\link{setAreaUnit}}
#' @family model property functions
#' @export
getAreaUnit <- function(model = getCurrentModel()) {
  c_datamodel <- assert_datamodel(model)
  
  c_datamodel$getModel()$getAreaUnit()
}

#' Set the unit of area
#'
#' \code{setAreaUnit} sets the unit used for area.
#'
#' @param unit string
#' @param model a model object
#' @seealso \code{\link{getAreaUnit}}
#' @family model property functions
#' @export
setAreaUnit <- function(unit, model = getCurrentModel()) {
  c_datamodel <- assert_datamodel(model)
  assert_that(is.string(unit))
  
  c_unit <- grab_msg(CUnit(unit))
  c_unit$buildExpression()
  unit <- c_unit$getExpression()
  
  assert_that(
    c_unit$isUnitType("area"),
    msg = paste0(unit, " is not a valid area unit.")
  )
  
  assert_that(
    grab_msg(c_datamodel$getModel()$setAreaUnitFromString(unit)),
    msg = "Setting area unit failed."
  )
  
  invisible()
}

#' Get the unit of length
#'
#' \code{getLengthUnit} gets the unit used for length.
#'
#' @param model a model object
#' @return unit of length
#' @seealso \code{\link{setLengthUnit}}
#' @family model property functions
#' @export
getLengthUnit <- function(model = getCurrentModel()) {
  c_datamodel <- assert_datamodel(model)
  
  c_datamodel$getModel()$getLengthUnit()
}

#' Set the unit of length
#'
#' \code{setLengthUnit} sets the unit used for length.
#'
#' @param unit string
#' @param model a model object
#' @seealso \code{\link{getLengthUnit}}
#' @family model property functions
#' @export
setLengthUnit <- function(unit, model = getCurrentModel()) {
  c_datamodel <- assert_datamodel(model)
  assert_that(is.string(unit))
  
  c_unit <- grab_msg(CUnit(unit))
  c_unit$buildExpression()
  unit <- c_unit$getExpression()
  
  assert_that(
    c_unit$isUnitType("length"),
    msg = paste0(unit, " is not a valid length unit.")
  )
  
  assert_that(
    grab_msg(c_datamodel$getModel()$setLengthUnitFromString(unit)),
    msg = "Setting length unit failed."
  )
  
  invisible()
}

#' Get the model's initial time
#'
#' \code{getInitialTime} gets the initial time of the model.
#'
#' @param model a model object
#' @seealso \code{\link{setInitialTime}}
#' @family model property functions
#' @export
getInitialTime <- function(model = getCurrentModel()) {
  c_datamodel <- assert_datamodel(model)
  
  c_datamodel$getModel()$getInitialTime()
}

#' Set the model's initial time
#'
#' \code{setInitialTime} sets the initial time of the model.
#'
#' @param time numeric
#' @param model a model object
#' @seealso \code{\link{getInitialTime}}
#' @family model property functions
#' @export
setInitialTime <- function(time, model = getCurrentModel()) {
  c_datamodel <- assert_datamodel(model)
  assert_that(is.number(time), time >= 0)
  
  c_model <- c_datamodel$getModel()
  
  assert_that(
    !c_model$isAutonomous(),
    msg = "Can't set initial time for autonomous models."
  )
  
  c_model$setInitialTime(time)
  
  invisible()
}

#' Get stoichiometry matrix
#' 
#' @param model a model object
#' @return stoichiometry matrix matrix
#' @seealso \code{\link{getReducedStoichiometryMatrix}}
#' @family model property functions
#' @export
getStoichiometryMatrix <- function(model = getCurrentModel()) {
  c_datamodel <- assert_datamodel(model)
  
  c_model <- c_datamodel$getModel()
  
  # c_model$buildStoi()
  
  # mb should be integer matrix
  get_annotated_matrix(
    c_model$getStoiAnnotation()
  )
}

#' Get reduced stoichiometry matrix
#' 
#' @param model a model object
#' @return reduced stoichiometry matrix
#' @seealso \code{\link{getStoichiometryMatrix}}
#' @family model property functions
#' @export
getReducedStoichiometryMatrix <- function(model = getCurrentModel()) {
  c_datamodel <- assert_datamodel(model)

  c_model <- c_datamodel$getModel()

  # c_model$buildRedStoi()
  
  # mb should be integer matrix
  get_annotated_matrix(
    c_model$getRedStoiAnnotation()
  )
}

#' Get link matrix
#' 
#' @param model a model object
#' @return matrix
#' @family model property functions
#' @export
getLinkMatrix <- function(model = getCurrentModel()) {
  c_datamodel <- assert_datamodel(model)

  c_model <- c_datamodel$getModel()
  
  # mb should be integer matrix
  get_annotated_matrix(
    c_model$getLAnnotation()
  )
}
