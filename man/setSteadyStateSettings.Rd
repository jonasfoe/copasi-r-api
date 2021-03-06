% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/task_steadystate.R
\name{setSteadyStateSettings}
\alias{setSteadyStateSettings}
\alias{setSS}
\title{Set steady state settings}
\usage{
setSteadyStateSettings(
  calculate_jacobian = NULL,
  perform_stability_analysis = NULL,
  update_model = NULL,
  executable = NULL,
  method = NULL,
  model = getCurrentModel()
)

setSS(
  calculate_jacobian = NULL,
  perform_stability_analysis = NULL,
  update_model = NULL,
  executable = NULL,
  method = NULL,
  model = getCurrentModel()
)
}
\arguments{
\item{calculate_jacobian}{flag}

\item{perform_stability_analysis}{flag}

\item{update_model}{flag}

\item{executable}{flag}

\item{method}{list}

\item{model}{a model object}
}
\description{
\code{setSteadyStateSettings} sets steady state task settings including method options.
}
\details{
The \href{https://jpahle.github.io/CoRC/articles/task_management.html}{online article on managing tasks} provides some further context.
}
\seealso{
Other steady state: 
\code{\link{getSteadyStateSettings}()},
\code{\link{runSteadyState}()}
}
\concept{steady state}
