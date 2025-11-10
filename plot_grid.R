# Assumes script.R defines: julia (dust model), n_iter
source("script.R")

set.seed(1)
a <- -1.5; b <- 1.5
n <- 30
n_samp <- 100000L

# Mixed discrete/continuous axes, with random swap of columns
x1 <- sample(0:n, n_samp, replace = TRUE) / n
x2 <- runif(n_samp)
swap <- sample(c(TRUE, FALSE), n_samp, replace = TRUE)

z <- cbind(x1, x2)
z[swap, ] <- z[swap, 2:1]
z <- a + z * (b - a)  # map to [a,b]

# Parameter c for z^2 + c
c_re <- -0.8; c_im <- 0.156

dx <- z[,1] - c_re
dy <- z[,2] - c_im

# Vectorised inverse square-root branches
rho <- (dx*dx + dy*dy)^(0.25)       # = |z-c|^{1/2}
phi <- atan2(dy, dx) / 2

z_plus  <- cbind(rho * cos(phi),         rho * sin(phi))
z_minus <- cbind(rho * cos(phi + pi),    rho * sin(phi + pi))

# Simulate / plot Julia set points (depends on what script.R defines)
z_julia <- dust2::dust_system_simulate(julia, times = 1:n_iter)

plot(z_julia[1,,1], z_julia[2,,1],
     pch = ".", xlim = c(-2, 2), ylim = c(-1.5, 1.5))
points(z_plus[,1],  z_plus[,2],  pch = ".", col = "red")
points(z_minus[,1], z_minus[,2], pch = ".", col = "blue")
points(z[,1],       z[,2],       pch = ".", col = "grey")
