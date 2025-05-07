x_c <- parameter()
y_c <- parameter()

x_minus_c <- x-x_c
y_minus_c <- y-y_c

rho <- (x_minus_c^2 + y_minus_c^2)^0.25
phi <- atan2(y_minus_c, x_minus_c)/2 + Binomial(1, 0.75)*3.141593

update(x) <- rho*cos(phi)
update(y) <- rho*sin(phi)

initial(x) <- Normal(0, 1)
initial(y) <- Normal(0, 1)
