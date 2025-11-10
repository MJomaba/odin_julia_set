## Stretching heatmaps: z-plane and preimage (w-plane)
## ---------------------------------------------------

# --- Parameters ---------------------------------------------------------------
c_re <- -0.8
c_im <-  0.156
nx   <- 800                   # grid along Re
ny   <- 600                   # grid along Im
xr_z <- c(-1.5, 1.5)          # z-plane window (Re)
yr_z <- c(-1.0, 1.0)          # z-plane window (Im)
xr_w <- c(-1.5, 1.5)          # w-plane window (you can adjust)
yr_w <- c(-1.0, 1.0)

pal <- colorRampPalette(c("#0d0887", "#6a00a8", "#b12a90",
                          "#e16462", "#fca636", "#f0f921"))

# --- Grids --------------------------------------------------------------------
xz <- seq(xr_z[1], xr_z[2], length.out = nx)
yz <- seq(yr_z[1], yr_z[2], length.out = ny)
xw <- seq(xr_w[1], xr_w[2], length.out = nx)
yw <- seq(yr_w[1], yr_w[2], length.out = ny)

# --- Stretch in z-plane: |g'(z)| = 1 / (2 * |z - c|^{1/2}) -------------------
r2_z <- outer(xz, yz, function(xx, yy) (xx - c_re)^2 + (yy - c_im)^2)
r_z  <- sqrt(r2_z)
stretch_z <- 1 / (2 * sqrt(pmax(r_z, .Machine$double.eps)))

# --- Stretch pulled back to w-plane: |g'(f(w))| = 1 / (2 * |w|) ---------------
r2_w <- outer(xw, yw, function(xx, yy) xx^2 + yy^2)
r_w  <- sqrt(r2_w)
stretch_w <- 1 / (2 * pmax(r_w, .Machine$double.eps))

# --- Shared colour cap (for comparability) -----------------------------------
cap_z <- as.numeric(quantile(stretch_z, 0.99, na.rm = TRUE))
cap_w <- as.numeric(quantile(stretch_w, 0.99, na.rm = TRUE))
cap   <- max(cap_z, cap_w)

sz <- pmin(stretch_z, cap)
sw <- pmin(stretch_w, cap)

# --- Layout: two rows, each with heatmap + legend -----------------------------
layout(matrix(c(1,2, 3,4), nrow = 2, byrow = TRUE),
       widths = c(4, 1), heights = c(1, 1))

op <- par(no.readonly = TRUE)

# ---------- (1) z-plane heatmap ----------------------------------------------
par(mar = c(4,4,3,1))
image(xz, yz, sz,
      col = pal(256), useRaster = TRUE, asp = 1,
      xlab = "Re(z)", ylab = "Im(z)",
      main = expression(paste("z-plane:  |g'(z)| = 1/(2*|z - c|^{1/2})")),
      xaxs = "i", yaxs = "i")
box()
points(c_re, c_im, pch = 3, cex = 1.1)   # mark c
if (exists("z_julia")) {
  points(z_julia[1, , 30], z_julia[2, , 30], pch = ".", col = "black")
}

# Legend for z-plane
par(mar = c(4,1,3,5))
zvals <- seq(0, cap, length.out = 256)
z_mat <- matrix(rep(zvals, each = 2), nrow = 2)  # 2 x 256 to fill the box
image(x = 1:2, y = zvals, z = z_mat,
      col = pal(256), useRaster = TRUE,
      xaxt = "n", yaxt = "n", xlab = "", ylab = "")
box()
axis(4, at = pretty(range(zvals)), las = 1)
mtext(expression("|g'(z)|  (shared scale, 99th pct cap)"), side = 4, line = 2.5)

# ---------- (2) w-plane (preimage) heatmap -----------------------------------
par(mar = c(4,4,3,1))
image(xw, yw, sw,
      col = pal(256), useRaster = TRUE, asp = 1,
      xlab = "Re(w)", ylab = "Im(w)",
      main = expression(paste("w-plane (preimage):  |g'(f(w))| = 1/(2*|w|)")),
      xaxs = "i", yaxs = "i")
box()
points(0, 0, pch = 3, cex = 1.1)  # singularity at w = 0

# Legend for w-plane (same scale)
par(mar = c(4,1,3,5))
w_mat <- matrix(rep(zvals, each = 2), nrow = 2)
image(x = 1:2, y = zvals, z = w_mat,
      col = pal(256), useRaster = TRUE,
      xaxt = "n", yaxt = "n", xlab = "", ylab = "")
box()
axis(4, at = pretty(range(zvals)), las = 1)
mtext(expression("|g'(f(w))|  (shared scale)"), side = 4, line = 2.5)

# Restore
par(op); layout(1)

