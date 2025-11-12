library(odin2)
library(dust2)

julia_mod <- odin2::odin("iim_julia_init_stretch.R")

set.seed(42)
n_samples <- 10000
init_angle <- runif(n_samples) * 2 * pi

c <- c(-0.8,0.156)
pars <- lapply(init_angle, function(theta) { list(x_c=c[1], y_c=c[2],
                                                  p=.75,
                                                  x0 = cos(theta),
                                                  y0 = sin(theta)) })
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
  points(pars[[i]]$x0, pars[[i]]$y0, pch= ".")

points(c[1], c[2], pch=19, col = "red")

stretch <- function(x) {
  return(1/(2*sqrt(sqrt((x[1]-c[1])^2 + (x[2]-c[2])^2))))
}

# theta <- seq(from = 0, to = 2 * pi, length.out = 1000)
# plot(theta, sapply(theta,
#                    function(theta) {stretch(c(cos(theta), sin(theta)))}),
#      type = "l")

lines(c(-2, c[1]), c(c[2], c[2]), lty = 3 )

eps_y <- 0.02
rect(-2, c[2] - eps_y, c[1], c[2], col = "#ff000033", border = NA)
rect(-2, c[2] + eps_y, c[1], c[2], col = "#0000ff33", border = NA)

