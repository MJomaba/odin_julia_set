mod <- odin.dust::odin_dust("iim_julia.R")

#c is the complex constant in the quadratic polynomial z^2+c
c <- c(-0.8,0.156)
n_samples <- 100000
julia <- mod$new(pars = list(x_c=c[1], y_c=c[2]), 0, n_samples)
init_set <- julia$state()

#vector of colour
#red -> initialise in the upper circle, blue -> lower
upper_circle <- atan2(init_set[2,],init_set[1,]) > 0
col_samples <- rep("blue",n_samples)
col_samples[upper_circle] <- "red"

#Run for n iterations
n_iter <- 17

z <- julia$run(n_iter)

#Plot resulting set
plot(z[1,],z[2,],
     pch=".",
     col=col_samples,
     axes=F,
     frame.plot=F,
     main=paste0("c =", c[1], " + ", c[2], "i"),
     xlab="",
     ylab="")
