.onAttach <- function(libname, pkgname){
  RFver <- read.dcf(file=system.file("DESCRIPTION", package=pkgname),
                    fields="Version")
  packageStartupMessage(paste("Reinforcement Learning Trees (", pkgname, ") v", RFver, "\n",
                              "Experimental version at https://github.com/teazrq/RLT", sep = ""))
}
