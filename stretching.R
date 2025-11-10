## Inverse-branch stretching heatmap with legend + optional Julia overlay
## Stretch: |g'(z)| = 1 / (2 * |z - c|^{1/2})

# --- Parameters ---------------------------------------------------------------
c_re <- -0.8
c_im <-  0.156
nx   <- 800                   # grid along Re(z)
ny   <- 600                   # grid along Im(z)
xr   <- c(-1.5, 1.5)
yr   <- c(-1.0, 1.0)

pal <- colorRampPalette(c("#0d0887", "#6a00a8", "#b12a90",
                          "#e16462", "#fca636", "#f0f921"))

# --- Grid & stretching --------------------------------------------------------
x <- seq(xr[1], xr[2], length.out = nx)
y <- seq(yr[1], yr[2], length.out = ny)

# r2[i,j] = (x[i]-c_re)^2 + (y[j]-c_im)^2
r2 <- outer(x, y, function(xx, yy) (xx - c_re)^2 + (yy - c_im)^2)
r  <- sqrt(r2)

stretch <- 1 / (2 * sqrt(pmax(r, .Machine$double.eps)))  # |g'(z)|

# cap for readable colours
cap <- as.numeric(quantile(stretch, 0.99, na.rm = TRUE))
stretch_cap <- pmin(stretch, cap)

# --- Layout: main + legend ----------------------------------------------------
op <- par(no.readonly = TRUE)
layout(matrix(c(1, 2), ncol = 2), widths = c(4, 1))

## Main heatmap
par(mar = c(4, 4, 3, 1))
image(x, y, stretch_cap,
      col = pal(256), useRaster = TRUE, asp = 1,
      xlab = "Re(z)", ylab = "Im(z)",
      main = expression(paste("Inverse stretching  |g'(z)| = 1/(2|z - c|^{1/2})")),
      xaxs = "i", yaxs = "i")
box()
points(c_re, c_im, pch = 3, cex = 1.2)  # mark c

# Optional Julia set overlay (if available)
if (exists("z_julia")) {
  points(z_julia[1, , 30], z_julia[2, , 30], pch = ".", col = "black")
}

## Colour legend (proper rectangular bar)
par(mar = c(4, 1, 3, 5))
zvals <- seq(min(stretch_cap), max(stretch_cap), length.out = 256)

# x has length 2, y has length 256 → z must be 2 × 256
z_mat <- matrix(rep(zvals, each = 2), nrow = 2)

image(x = 1:2, y = zvals, z = z_mat,
      col = pal(256), useRaster = TRUE,
      xaxt = "n", yaxt = "n", xlab = "", ylab = "")
box()
axis(4, at = pretty(range(zvals)), las = 1)
mtext(expression("|g'(z)|   (capped at 99th pct)"), side = 4, line = 2.5)

# restore
par(op); layout(1)
