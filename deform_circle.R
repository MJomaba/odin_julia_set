library(odin2)
library(dust2)

julia_mod <- odin2::odin("iim_julia_init.R")

set.seed(42)
n_samples <- 10000
init_angle <- runif(n_samples) * 2 * pi

pars <- lapply(init_angle, function(theta) { list(x_c=c[1], y_c=c[2],
                                                  p=.75,
                                                  x0 = cos(theta),
                                                  y0 = sin(theta)) })

c <- c(-0.8,0.156)
n_p <- 1
julia <- dust2::dust_system_create(generator = julia_mod,
                                   pars = pars,
                                   n_particles = n_p,
                                   n_groups = n_samples)
dust_system_set_state_initial(julia)

# Simulate / plot Julia set points
n_iter <- 1:50
z_julia <- dust2::dust_system_simulate(julia, times = n_iter)

plot(z_julia[1, , 15], z_julia[2, , 15], pch = ".")

for(i in 1:n_samples)
{
  points(pars[[i]]$x0, pars[[i]]$y0, pch= ".")
}
