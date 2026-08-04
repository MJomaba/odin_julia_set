# odin_julia_set

Exploring the **inverse iteration method (IIM)** for drawing Julia sets (and a
Sierpiński triangle) using [`odin`](https://mrc-ide.github.io/odin2/) /
[`dust`](https://mrc-ide.github.io/dust2/), R packages for writing and running
stochastic simulations. Instead of iterating $z \mapsto z^2 + c$ forward and
testing for escape, IIM starts from a point on the set and repeatedly applies
a randomly-chosen inverse branch $z \mapsto \pm\sqrt{z - c}$; the resulting
orbit fills in the attractor (the Julia set, or the Sierpiński triangle for
an analogous 3-branch map).

The repo is a collection of exploratory scripts built up over time rather
than a packaged project, so file names don't always describe stable APIs.
This README maps out what each file does and how to run it.

## Requirements

R with the following packages:

- [`odin2`](https://github.com/mrc-ide/odin2) and [`dust2`](https://github.com/mrc-ide/dust2) — current modelling framework used by most scripts.
- [`odin.dust`](https://github.com/mrc-ide/odin.dust) — older framework, still used by `script_with_colour.R` and `generate_gif.R`.
- `magick` — used by `generate_gif.R` to assemble PNG frames into an animated GIF.

Install with:

```r
install.packages(c("odin.dust", "magick"))
# odin2 / dust2 are on the mrc-ide r-universe:
install.packages(c("odin2", "dust2"), repos = c("https://mrc-ide.r-universe.dev", "https://cloud.r-project.org"))
```

Open `odin_julia_set.Rproj` in RStudio (or just set the working directory to
the repo root) before running any script — all paths are relative to the
repo root, e.g. `odin2::odin("iim_julia.R")`.

## odin models

These files aren't run directly; they're compiled with `odin2::odin()` or
`odin.dust::odin_dust()` and define one step of the inverse-iteration
Markov chain.

| File | Description |
| --- | --- |
| [iim_julia.R](iim_julia.R) | Core IIM model for the quadratic Julia set. State `(x, y)` represents $z$; each step picks one of the two square-root branches of $z - c$ (via `Binomial(1, p)`) and moves to it. Initial state is drawn from `Normal(0, 1)`. |
| [iim_julia_init.R](iim_julia_init.R) | Same update step as `iim_julia.R`, but the initial `(x0, y0)` is a parameter instead of random, so callers can control/seed starting points (see `moving_2_odin2.R`, `deform_circle.R`). |
| [odin_models/iim_julia_init_stretch.R](odin_models/iim_julia_init_stretch.R) | Like `iim_julia_init.R`, but chooses between the two inverse branches with probability proportional to each branch's local stretching factor $\lvert g'(z) \rvert = 1/(2\sqrt{\lvert z-c\rvert})$, rather than a fixed 50/50 split. |
| [odin_models/iim_julia_init_stretch_and_track.R](odin_models/iim_julia_init_stretch_and_track.R) | Same stretch-weighted branch choice as above, plus an extra tracked state `s` that accumulates the branch-angle offset, used to colour/inspect orbits by branch history. |
| [odin_models/iim_sierpinski.R](odin_models/iim_sierpinski.R) | IIM model for the Sierpiński triangle: contracts towards one of 3 vertices (via a rotation by a random multiple of 120°) at each step. |

## Runnable scripts

| File | Description | Run |
| --- | --- | --- |
| [script.R](script.R) | Simplest example: builds `iim_julia.R` with `odin2`/`dust2`, runs 10,000 particles for 50 steps, plots the resulting Julia set for $c = -0.8 + 0.156i$. | `Rscript script.R` |
| [script_with_colour.R](script_with_colour.R) | Same model but built with the older `odin.dust`, coloured by whether each particle started in the upper or lower half of the initial circle, to visualise how the two halves interleave. | `Rscript script_with_colour.R` |
| [moving_2_odin2.R](moving_2_odin2.R) | Runs a small number of particles for 100,000 steps to trace out long individual orbits rather than a snapshot of many particles. | `Rscript moving_2_odin2.R` |
| [generate_gif.R](generate_gif.R) | Renders 31 frames (n = 0..30) of both the Sierpiński triangle and the Julia set as the orbit count grows, then stitches them into GIFs with `magick`. Writes temporary PNGs to `animations/` and cleans them up. Outputs [animations/odin_sierpinski.gif](animations/odin_sierpinski.gif) and [animations/odin_julia.gif](animations/odin_julia.gif). | `Rscript generate_gif.R` |
| [deform_circle.R](deform_circle.R) | Seeds particles evenly around the unit circle, runs the stretch-and-track model, and plots the resulting orbits alongside shaded regions near $c$ to illustrate how the inverse branches deform a circle into the Julia set. | `Rscript deform_circle.R` |
| [plot_grid.R](plot_grid.R) | Sources `script.R`, samples a grid of test points, applies both inverse branches analytically (`z_plus`/`z_minus`) and overlays them on the simulated Julia set to visualise one step of the inverse map. **Depends on `script.R`.** | `Rscript plot_grid.R` |
| [stretching.R](stretching.R) | Draws a heatmap of the local stretching factor $\lvert g'(z)\rvert = 1/(2\sqrt{\lvert z-c\rvert})$ over the plane, with a colour legend. If a `z_julia` variable already exists in the session (e.g. from `deform_circle.R`), overlays the Julia set points. | `Rscript stretching.R`, or source after one of the scripts above to get the overlay |
| [stretching_and_preimage.R](stretching_and_preimage.R) | Extends `stretching.R` with a second heatmap of the stretching factor pulled back to the "preimage" $w$-plane ($w^2 = z - c$), plotted on a shared colour scale for comparison. | Same as above |

## Notes

- `script.R`, `plot_grid.R`, and `stretching(_and_preimage).R` are meant to be
  run/sourced in sequence (each depends on objects defined by the previous
  one, e.g. `c`, `julia`, `n_iter`, `z_julia`) rather than standalone.
- `big_carpet.png` and `sierp.pdf` are pre-generated output images kept in
  the repo root from earlier runs.
- `animations/` holds the GIFs produced by `generate_gif.R`.
