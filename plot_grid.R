source("script.R")

a <- -1.5
b <- 1.5
n <- 30
n_samp <- 100000
z <- cbind(sample(0:n, n_samp, replace = T)/n, runif(n_samp))
z_plus <- z
z_minus <- z

for(i in 1:n_samp){
  if(sample(c(T,F), 1)){
    z[i,] <- z[i,2:1]
  }
}

z[,1] <- a+z[,1]*(b-a)
z[,2] <- a+z[,2]*(b-a)

#plot(z[,1],z[,2], pch=".", col = "grey")

c <- c(-0.8,0.156)

x_c <- c[1]
y_c <- c[2]
for(i in 1:n_samp){
  x_minus_c <- z[i,1]-x_c
  y_minus_c <- z[i,2]-y_c

  rho <- (x_minus_c^2 + y_minus_c^2)^0.25
  phi <- atan2(y_minus_c, x_minus_c)/2

  z_plus[i,1] <- rho*cos(phi)
  z_plus[i,2] <- rho*sin(phi)
  z_minus[i,1] <- rho*cos(phi+3.141593)
  z_minus[i,2] <- rho*sin(phi+3.141593)
}

z_julia <- dust2::dust_system_simulate(julia, times = n_iter)
plot(z_julia[1,,1],z_julia[2,,1],
       pch=".", xlim=c(-2,2), ylim=c(-1.5,1.5))
points(z_plus[,1],z_plus[,2], pch=".", col="red")
points(z_minus[,1],z_minus[,2], pch=".", col="blue")
points(z[,1],z[,2],
     pch=".", col="grey")

