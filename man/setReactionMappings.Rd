% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/entity_accessors.R
\name{setReactionMappings}
\alias{setReactionMappings}
\title{Set reaction parameter mappings}
\usage{
setReactionMappings(key, mappings, model = getCurrentModel())
}
\arguments{
\item{key}{Identify which reaction to edit by specifying it's key, as string.
Also supports fragments of keys, if uniquely matching one reaction.}

\item{mappings}{Parameter mappings, as named list.
Names are the parameters of the kinetic function.
Values are either entity keys valid for the specific type of parameter or a numeric value in case of a local parameter.}

\item{model}{A model object.}
}
\description{
\code{setReactionMappings} sets reaction parameter mappings for a reaction.
}
\details{
The \href{https://jpahle.github.io/CoRC/articles/entity_management.html}{online article on managing model entities} provides some further context.
}
\seealso{
\code{\link{getReactionMappings}}

Other reaction functions: 
\code{\link{clearCustomKineticFunctions}()},
\code{\link{deleteKineticFunction}()},
\code{\link{deleteReaction}()},
\code{\link{entity_finders}},
\code{\link{getParameterReferences}()},
\code{\link{getParameters}()},
\code{\link{getReactionMappings}()},
\code{\link{getReactionReferences}()},
\code{\link{getReactions}()},
\code{\link{getValidReactionFunctions}()},
\code{\link{newKineticFunction}()},
\code{\link{newReaction}()},
\code{\link{setParameters}()},
\code{\link{setReactionFunction}()},
\code{\link{setReactions}()}
}
\concept{reaction functions}
