## plotFVARanges.R

## Take in the flux ranges from FVA and plot them
data <- data.frame(x = 1:5, minFlux = c(60,90,55,0,66),
        maxFlux = c(75,90,80,100,73))

## Initial Attempt
png("test.png")

for 
plot(x = rep(xs[1],2),y = y1,type = 'l',lwd = 3,xlim = c(0,6),ylim = c(0,100))
lines(x = rep(xs[2],2),y = y2,type = 'l',lwd = 3)
lines(x = rep(xs[3],2),y = y3,type = 'l',lwd = 3)
lines(x = rep(xs[4],2),y = y4,type = 'l',lwd = 3)
lines(x = rep(xs[5],2),y = y5,type = 'l',lwd = 3)
dev.off()