# Automate the making of the package
#
#

##################################################################
#
.setEnv <- function(computer=c("HOME", "LAPTOP", "WORK"))
{
  if (computer=="WORK"){
    pkgdir  <<- "H:/user/R/Adrian/findataweb/temp/xlsx/"
    outdir  <<- "H:/"
    Rcmd    <<- "S:/All/Risk/Software/R/R-2.10.1/bin/Rcmd"
  } else if (computer == "LAPTOP"){
    pkgdir  <<- "C:/Users/adrian/R/findataweb/temp/xlsxjars/"
    outdir  <<- "C:/"
    Rcmd    <<- '"C:/Program Files/R/R-2.10.1/bin/Rcmd"'
  } else if (computer == "HOME"){
  } else {
  }

  invisible()
}


##################################################################
#
.update.DESCRIPTION <- function(packagedir, version)
{
  file <- paste(packagedir, "DESCRIPTION", sep="") 
  DD  <- readLines(file)
  ind  <- grep("Version: ", DD)
  aux <- strsplit(DD[ind], " ")[[1]]
  
  if (is.null(version)){   # increase by one 
    vSplit    <- strsplit(aux[2], "\\.")[[1]]
    vSplit[3] <- as.character(as.numeric(vSplit[3])+1) 
    version <- paste(vSplit, sep="", collapse=".")
  }   
  DD[ind] <- paste(aux[1], version)

  ind <- grep("Date: ", DD)
  aux <- strsplit(DD[ind], " ")[[1]]
  DD[ind] <- paste(aux[1], Sys.Date())
  
  writeLines(DD, con=file)
  return(version)
}


##################################################################
##################################################################

version <- NULL        # keep increasing the minor
version <- "0.1.0"     # if you want to set it by hand

.setEnv("LAPTOP")   # "LAPTOP", "WORK"

# change the version
version <- .update.DESCRIPTION(pkgdir, version)

# make the package
setwd(outdir)
cmd <- paste(Rcmd, "build --force --binary --no-vignette", pkgdir)
print(cmd)
system(cmd)

install.packages(paste(outdir, "xlsxjars_", version,".zip", sep=""),
                 repos=NULL)


# make the source for CRAN
cmd <- paste(Rcmd, "build", pkgdir)
print(cmd)
system(cmd)

# pass the checks?
cmd <- paste(Rcmd, "check", pkgdir)
print(cmd)
system(cmd)

