library(odin2)
library(dust2)

julia_mod <- odin2::odin("iim_julia.R")

c <- c(-0.8,0.156)
julia <- dust2::dust_system_create(generator = julia_mod,
                                   pars=list(x_c=c[1], y_c=c[2]),
                                   n_particles = 1000000)

# for(i in 0:30){
#   z <- julia$run(i)
#   y_spread <- range(z[2,])
#   plot(z[1,],z[2,],
#        pch=".",
#        col="blue")}

julia_t <- dust_system_simulate(julia, times = 1:30)

plot(julia_t[1,,25:30], julia_t[2,,25:30], pch=".")
