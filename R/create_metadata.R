#' create metadata function
#'
#' This function imports your otu table metadata. You must have a csv file with "meta" in the file name in the current working directory.
#' @param  date argument to format dates in your metadata, your csv file must have a column named "date", defaults to TRUE
#' @keywords metadata
#' @export
#' @examples
#' metadata <- create_metadata()
create_metadata <- function(data, date=TRUE, return_clean_data=FALSE){
  files <- dir(pattern = "*.csv") # get file names
  meta <- as.data.frame(read.csv(files[grep("meta", files)], header = TRUE, stringsAsFactors=FALSE), stringsAsFactors=FALSE)
  test_names <- as.vector(unlist(meta[1])[(!unlist(meta[1]) %in% rownames(data))])
  test_names_rev <- as.vector(rownames(data)[(!rownames(data) %in% unlist(meta[1]))])
  if(length(test_names)>0){
    test_names <- which(unlist(meta) %in% test_names)
    meta <- meta[-test_names,]
    meta <- meta[match(rownames(data), meta[,1]),]
  }else if(length(test_names_rev)>0){
    test_names_rev <- which(rownames(data) %in% test_names_rev)
    data <- data[-test_names_rev,]
    data <- data[match(rownames(data), meta[,1]),]
  }else{
    meta <- meta
  }
  if(date==TRUE){
  meta$date <- paste0(lubridate::month(lubridate::mdy(meta$date), label = TRUE),".", lubridate::year(lubridate::mdy(meta$date)))
  meta
  }else{
    meta
  }
  if(return_clean_data==TRUE){
    data
  }else{
    meta
  }
}
