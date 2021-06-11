#### packages ####

library(RColorBrewer)
library(data.table)
# library("rvest")
library(rgdal)
library(classInt)

#### read data ####

df <- read.csv("data/NLZ_data.csv", sep = ";")
df$Location <- gsub("[[:space:]]", "", df$Location)
setDT(df)[, paste0(c("latitude", "longitude")) := tstrsplit(Location, ",")]
df$Location <- NULL
df$longitude <- as.numeric(df$longitude)
df$latitude <- as.numeric(df$latitude)
df <- df[!Verein =="FC Rot-Weiß Erfurt"]

#### create colors ####

tab     <- table(df$Bundesland)
class   <- classIntervals(tab, style="pretty", intervallClosure = "left")
plotclr <- brewer.pal(4,"YlOrRd")
colcode <- findColours(class, plotclr)

#### plot map ####

gadm <- readRDS("data/gadm36_DEU_1_sp.rds")

pdf_datei <- paste0("DFB_NLZ_MAP.pdf")
cairo_pdf( pdf_datei, width = 9, height = 9)
par(mar = c(0,0,3,0), 
	family = "Lato Light", 
	bg = "grey90")
plot(gadm , border='grey90', col = colcode)
mtext("DFB Nachwuchsleistungszentren in Deutschland", adj = 0, side = 3, line = 2, family = "Lato Black", cex = 1.3)
mtext("Quelle: Wikipedia Stand April 2020/update Juli 2020", side = 1, line = -1, font = 3, cex = 0.6, adj = 1)
x <- names(attr(colcode, "table"))
x <- c("1 bis 2",
	   "2 bis 4",
	   "4 bis 6",
	   "6 bis 8", 
	   "8 bis 10",
	   "10 bis 12", 
	   "12 bis 14")
legend("topright", 
	   legend = x  , 
	   fill  = attr(colcode, "palette"), 
	   border=FALSE, 
	   cex = 1.2, 
	   bty = "n",
	   title = "Anzahl der Zentren")
dev.off()

