x_c <- parameter()
y_c <- parameter()

x_minus_c <- x-x_c
y_minus_c <- y-y_c

rho <- (x_minus_c^2 + y_minus_c^2)^0.25
phi1 <- atan2(y_minus_c, x_minus_c)/2
phi2 <- phi1 + 3.141593

x1 <- rho*cos(phi1)
y1 <- rho*sin(phi1)
x2 <- rho*cos(phi2)
y2 <- rho*sin(phi2)

s1 <- 1/(2*sqrt(sqrt((x1-x_c)^2 + (y1-y_c)^2)))
s2 <- 1/(2*sqrt(sqrt((x2-x_c)^2 + (y2-y_c)^2)))

phi <- phi1 + Binomial(1, s2/ ( s1 + s2 ) ) * 3.141593

update(x) <- rho * cos(phi)
update(y) <- rho * sin(phi)

x0 <- parameter()
y0 <- parameter()

initial(x) <- x0
initial(y) <- y0
