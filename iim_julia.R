x_c <- user()
y_c <- user()
phi_0 <- runif(0, 6.283185) #angle between 0 and 2*pi

x_minus_c <- x-x_c
y_minus_c <- y-y_c

rho <- (x_minus_c^2 + y_minus_c^2)^0.25
phi <- atan2(y_minus_c, x_minus_c)/2 + rbinom(1,0.5)*3.141593

update(x) <- rho*cos(phi)
update(y) <- rho*sin(phi)

initial(x) <- cos(phi_0)
initial(y) <- sin(phi_0)
