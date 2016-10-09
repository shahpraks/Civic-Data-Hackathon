
install.packages('sqldf')
require(sqldf)

RoadRating = read.csv("~/Downloads/RoadRatings2015.csv")
                      
a = read.csv("~/Downloads/potholes.csv")

colnames(RoadRating)
colnames(a)

sqldf1 <- sqldf("select RoadRating.streetID, a.streetName , RoadRating.overall , RoadRating.patch, RoadRating.crack
FROM RoadRating 
               INNER JOIN a
               ON RoadRating.streetID = a.streetID")

#sqldf3 <- sqldf("select RoadRating.streetID, RoadRating.streetName from RoadRating except select sqldf1.streetID,sqldf1.streetName from sqldf1")

sqldf2 <- sqldf("SELECT td.streetID, td.streetName, td.overall, td.patch , td.crack
FROM RoadRating AS td
WHERE (NOT EXISTS
       (SELECT d.streetID,d.streetName,d.overall, d.patch , d.crack
       FROM sqldf1 AS d
       WHERE ( d.streetID = td.streetID)))")

sqldf2$Sum <- sqldf2$patch + sqldf2$crack

sqldf3 <- sqldf("select streetName,Sum,overall from sqldf2 where sum <= '6' and overall <= '5'")

sqldf4 <- sqldf("select * from sqldf3 group by streetName")

plot(sqldf4$overall,)

qplot(sqldf4$Sum,data=sqldf4,xlab = "Sum of Rating of Patch and Crack", ylab = "Count of Street impact",color = 'cyl', fill = 'gear' )

hist(tapply(sqldf4$streetName,sqldf4$Sum,length))
install.packages("plotly")
library(plotly)
plot_ly(data = sqldf4, x = ~overall, y = ~Sum)

sqldf[,sqldf4$streetName)]
