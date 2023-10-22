mod <- odin.dust::odin_dust("iim_julia.R")

#c is the complex constant in the quadratic polynomial z^2+c
c <- c(-0.8,0.156)
julia <- mod$new(pars = list(x_c=c[1], y_c=c[2]), 0, 1000000)

#Run for n iterations
n_iter <- 50
z <- julia$run(n_iter)

#Plot resulting set
plot(z[1,],z[2,],
     pch=".",
     col="blue",
     axes=F,
     frame.plot=F,
     main=paste0("c =", c[1], " + ", c[2], "i"),
     xlab="",
     ylab="")
