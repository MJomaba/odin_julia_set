julia_mod <- odin2::odin("iim_julia.R")

#c is the complex constant in the quadratic polynomial z^2+c
c <- c(-0.8,0.156)
n_p <- 10000
julia <- dust2::dust_system_create(generator = julia_mod,
                                   pars=list(x_c=c[1], y_c=c[2], p=.75),
                                   n_particles = n_p)

#Run for n iterations
n_iter <- 50
z <- dust2::dust_system_simulate(julia, times = n_iter)

#Plot resulting set
plot(z[1,,1],z[2,,1],
     pch=".",
     col="blue",
     axes=F,
     frame.plot=F,
     main=paste0("c =", c[1], " + ", c[2], "i"),
     xlab="",
     ylab="")
