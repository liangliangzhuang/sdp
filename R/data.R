#' NASA 锂电池数据
#'
#' @description
#' 该数据是 NASA Ames Prognostics Center of Fxcellence (PCoF）对商用锂离子 18650 电池进行充、放电试验获得的一组蓄电池容量变化数据。试验过程中，锂离子在室温下 经历 3 种不同的运行剖面，即充电、放电和测量 EIS。
#' 充电是以恒流模式(CC)进行，在 1.5A 电流下直到电池电压达到4.2V，然后以恒压模式(CV)继续充电直到电流降到 20mA。
#' 放电也以恒流模式进行，放电电流为2A，直到电池电压降低到2.7V。
#' 重复充电和放电将导致蓄电池老化。
#' @format ## `lithium_battery`
#' A data frame with 7,240 rows and 60 columns:
#' \describe{
#'   \item{country}{Country name}
#'   \item{iso2, iso3}{2 & 3 letter ISO country codes}
#'   \item{year}{Year}
#'   ...
#' }
#' @source <https://c3.ndc.nasa.gov/dashlink/resources/133/>
"lithium_battery"









