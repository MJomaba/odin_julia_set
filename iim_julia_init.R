x_c <- parameter()
y_c <- parameter()
p <- parameter(0.75)

x_minus_c <- x-x_c
y_minus_c <- y-y_c

rho <- (x_minus_c^2 + y_minus_c^2)^0.25
phi <- atan2(y_minus_c, x_minus_c)/2 + Binomial(1, p)*3.141593

update(x) <- rho*cos(phi)
update(y) <- rho*sin(phi)

x0 <- parameter()
y0 <- parameter()

initial(x) <- x0
initial(y) <- y0
