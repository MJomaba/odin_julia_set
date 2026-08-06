library(odin2)
library(dust2)

## Self-consistent (fixed-point) density correction for the IIM Julia set.
##
## Rather than guessing a one-shot branch-selection bias (e.g. weighting by
## the *next* step's stretch factor, as in
## odin_models/iim_julia_init_stretch.R), this looks for an actual fixed
## point: it repeatedly (1) simulates with the current per-cell weight grid,
## (2) measures the resulting point density on a grid, (3) nudges the
## weights so under-visited cells are favoured next round - until the
## measured density stops changing. See odin_models/iim_julia_density_weighted.R
## for the model that consumes the weight grid.

c_re <- -0.8
c_im <- 0.156

# Grid used both for the correction weights and to measure resulting density.
nx <- 40
ny <- 40
xr <- c(-1.5, 1.5)
yr <- c(-1.5, 1.5)

n_particles <- 20000
n_burnin <- 40   # iterations discarded so particles reach the attractor
n_collect <- 20  # further iterations whose positions are pooled into the histogram
n_rounds <- 30
alpha <- 0.3       # damping: 1 = full correction each round, < 1 = partial step
clip <- c(0.5, 2)  # clamp the per-round multiplicative weight update
w_range <- c(0.05, 20) # clamp the *cumulative* weight so per-round updates can't compound unboundedly

mod <- odin2::odin("odin_models/iim_julia_density_weighted.R", check_bounds = "disabled")

grid_index <- function(v, r, n) {
  pmin(n, pmax(1, floor((v - r[1]) / (r[2] - r[1]) * n) + 1))
}

run_round <- function(w) {
  sys <- dust2::dust_system_create(
    mod(),
    pars = list(x_c = c_re, y_c = c_im, w = w,
                xmin = xr[1], xmax = xr[2], ymin = yr[1], ymax = yr[2]),
    n_particles = n_particles)
  dust2::dust_system_set_state_initial(sys)
  z <- dust2::dust_system_simulate(sys, times = 1:(n_burnin + n_collect))

  # pool the last n_collect iterations so the histogram has more samples
  x <- as.vector(z[1, , (n_burnin + 1):(n_burnin + n_collect)])
  y <- as.vector(z[2, , (n_burnin + 1):(n_burnin + n_collect)])
  ix <- grid_index(x, xr, nx)
  iy <- grid_index(y, yr, ny)
  lin <- (iy - 1) * nx + ix
  counts <- matrix(tabulate(lin, nbins = nx * ny), nrow = nx, ncol = ny)

  list(counts = counts, x = x, y = y)
}

update_weights <- function(w, counts, mask) {
  target <- mean(counts[mask])
  ratio <- target / pmax(counts, 1)
  ratio[!mask] <- 1 # leave cells the orbit never visits alone
  ratio <- ratio^alpha
  ratio <- pmin(clip[2], pmax(clip[1], ratio)) # pmin/pmax drop the matrix dim, restore it below
  dim(ratio) <- dim(w)
  w_new <- pmin(w_range[2], pmax(w_range[1], w * ratio))
  dim(w_new) <- dim(w)
  w_new
}

w <- matrix(1, nx, ny) # round 1 = unbiased (equivalent to p = 0.5 every step)
cv_history <- numeric(n_rounds)
mask <- NULL
first_round <- NULL
result <- NULL

for (round in seq_len(n_rounds)) {
  result <- run_round(w)
  counts <- result$counts
  if (round == 1) {
    mask <- counts > 0
    first_round <- result
  }
  cv_history[round] <- sd(counts[mask]) / mean(counts[mask])
  cat(sprintf("round %d: mean=%.1f  sd=%.1f  CV=%.3f\n",
              round, mean(counts[mask]), sd(counts[mask]), cv_history[round]))
  if (round < n_rounds) {
    w <- update_weights(w, counts, mask)
  }
}

op <- par(mfrow = c(1, 3))
plot(first_round$x, first_round$y, pch = ".", col = "blue",
     xlim = xr, ylim = yr, main = "round 1 (unbiased)", xlab = "", ylab = "")
plot(result$x, result$y, pch = ".", col = "blue",
     xlim = xr, ylim = yr,
     main = sprintf("round %d (self-consistent)", n_rounds), xlab = "", ylab = "")
plot(seq_len(n_rounds), cv_history, type = "b", pch = 19,
     xlab = "round", ylab = "CV of grid-cell counts",
     main = "density unevenness vs round")
par(op)
