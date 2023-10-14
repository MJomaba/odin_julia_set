mod <- odin.dust::odin_dust("iim_julia.R")

#c is the complex constant in the quadratic polynomial z^2+c
c <- c(-0.4,0.6)
julia <- mod$new(pars = list(x_c=c[1], y_c=c[2], phi_0=1), 0, 500000)

#Run for n iterations
n_iter <- 25
z <- julia$run(n_iter)

#Plot resulting set
plot(z[1,],z[2,], pch=".", col="blue")
