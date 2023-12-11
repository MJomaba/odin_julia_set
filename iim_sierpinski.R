x_t <- (x/2)-1/4
y_t <- (y/2)-sqrt(3)/12

theta <- rbinom(2,0.5)* 2.094395

update(x) <- x_t*cos(theta) - y_t*sin(theta)
update(y) <- x_t*sin(theta) + y_t*cos(theta)

initial(x) <- rnorm(0, 1)
initial(y) <- rnorm(0, 1)
