##### JSON Tutorial in R #####
# -- Warum? -- ###############
# Viele APIs stellen Daten im JSON-Format bereit
# auch beim DataFest liegen einige Daten nur als JSON vor.
# ############################

# load package
library(jsonlite)

##############################
##### Basics #################
# ein data frame kann auch als JSON-Datei dargestellt werden
head(mtcars)

# output im JSON-Format
jsoncars <- toJSON(head(mtcars), pretty=TRUE)
cat(jsoncars)


# Parse it back
fromJSON(jsoncars)

###############################
##### JSON-Dateien können sehr einfach aus dem Internet eingelesen werden.
# Beispiel:
# Projekte von Hadley Wickham: https://github.com/hadley?tab=repositories

# API-Adresse:
url <- "https://api.github.com/users/hadley/repos"

fromJSON(url, flatten = TRUE)

###############################
##### Streaming
# Problem: Verarbeiten großer Daten im JSON-Format ist nicht ohne weiteres möglich, da die gesamte Datei zusammenhängt
# Alternative: JSON-Streaming-Format
# jede Zeile enthält einen eigenen JSON-Eintrag

# Beispiel für Konsolenoutput:
stream_out(head(mtcars), con = stdout())

# Abspeichern einer Datei
stream_out(mtcars, con = file("mtcars.json"))

# Laden der Datei
mtcars2 <- stream_in(file("mtcars.json"))
all.equal(mtcars2, as.data.frame(mtcars))

##### Umgang mit factual-Daten ##

# laden den Factual-Datensatz
factual <- readLines("C:/Users/mschierh/Downloads/factual.json")
head(factual)

# zerlege jede Zeile in die ID (vorne) und JSON (hinten) anhand des Tabs (\t)
fac <- strsplit(factual, "\t")

# Behalte nur den JSON-Teil und speichere ihn in einem Vector
fac <- lapply(fac, FUN = function(row) row[2])
fac <- unlist(fac)

# Der Einfachheit und Schnelligkeit halber parsen wir nur die ersten 50 Zeilen:
fact <- stream_in(textConnection(fac[1:50]))

# und was steht da jetzt drin?
str(fact) # komplex, viele geschachtelte Listen

names(fact)
names(fact$geographic)
names(fact$geographic$countries)
names(fact$geographic$countries$"08d549a4-8f76-11e1-848f-cfd5bf3ef515")
fact$geographic$countries$"08d549a4-8f76-11e1-848f-cfd5bf3ef515"$name
fact$geographic$countries$"08d549a4-8f76-11e1-848f-cfd5bf3ef515"$percentage

data.frame(countryName = fact$geographic$countries$"08d549a4-8f76-11e1-848f-cfd5bf3ef515"$name,
      countryPercentage = fact$geographic$countries$"08d549a4-8f76-11e1-848f-cfd5bf3ef515"$percentage)

###############################
# Die Datei mit Angaben zu den verschiedenen Apps ist etwas größer
# pls <- readLines("pls.json")

# Nicht gezeigt:
# jsonlite unterstützt Filter, siehe ?stream_in
# weitere Packages zum Einlesen von Json existieren.
# Unter http://cran.r-project.org/web/views/WebTechnologies.html wird aber jsonlite empfohlen.