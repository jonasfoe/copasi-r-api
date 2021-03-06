% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/task_timecourse.R
\name{getTimeCourseSettings}
\alias{getTimeCourseSettings}
\alias{getTC}
\title{Get time course settings}
\usage{
getTimeCourseSettings(model = getCurrentModel())

getTC(model = getCurrentModel())
}
\arguments{
\item{model}{a model object}
}
\value{
A list of time course task settings including method options.
}
\description{
\code{getTimeCourseSettings} gets time course task settings including method options.
}
\details{
The \href{https://jpahle.github.io/CoRC/articles/task_management.html}{online article on managing tasks} provides some further context.
}
\seealso{
Other time course: 
\code{\link{runTimeCourse}()},
\code{\link{setTimeCourseSettings}()}
}
\concept{time course}
