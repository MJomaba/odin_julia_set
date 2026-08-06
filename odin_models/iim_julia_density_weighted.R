x_c <- parameter()
y_c <- parameter()

x_minus_c <- x - x_c
y_minus_c <- y - y_c

rho <- (x_minus_c^2 + y_minus_c^2)^0.25
phi1 <- atan2(y_minus_c, x_minus_c) / 2
phi2 <- phi1 + pi

x1 <- rho * cos(phi1)
y1 <- rho * sin(phi1)
x2 <- rho * cos(phi2)
y2 <- rho * sin(phi2)

# Look up a (self-consistently estimated) target density at each candidate
# branch's destination, on a fixed grid supplied from R, and bias the branch
# choice towards whichever destination is under-represented relative to it.
w <- parameter()
dim(w) <- parameter(rank = 2)
nx <- nrow(w)
ny <- ncol(w)

xmin <- parameter()
xmax <- parameter()
ymin <- parameter()
ymax <- parameter()

ix1 <- min(nx, max(1, floor((x1 - xmin) / (xmax - xmin) * nx) + 1))
iy1 <- min(ny, max(1, floor((y1 - ymin) / (ymax - ymin) * ny) + 1))
ix2 <- min(nx, max(1, floor((x2 - xmin) / (xmax - xmin) * nx) + 1))
iy2 <- min(ny, max(1, floor((y2 - ymin) / (ymax - ymin) * ny) + 1))

w1 <- w[ix1, iy1]
w2 <- w[ix2, iy2]

phi <- phi1 + Binomial(1, w2 / (w1 + w2)) * pi

update(x) <- rho * cos(phi)
update(y) <- rho * sin(phi)

initial(x) <- Normal(0, 1)
initial(y) <- Normal(0, 1)
