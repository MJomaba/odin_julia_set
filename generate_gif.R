julia_mod <- odin.dust::odin_dust("iim_julia.R")
mod <- odin.dust::odin_dust("iim_sierpinski.R")


sierpinski <- mod$new(pars=list(), 0, 100000)
png(file="animations/temp_image%02d.png", width=400, height=400)
for(i in 0:30){
  z <- sierpinski$run(i)
  plot(z[1,],z[2,],
       pch=".",
       col="blue",
       axes=F,
       frame.plot=F,
       main=paste0("n = ",i),
       xlab="",
       ylab="")
}
dev.off()


r2 <- image_read(paste0("animations/temp_image",sprintf("%02d", 1),".png"))
for(i in 2:31){
  r1 <- image_read(paste0("animations/temp_image",sprintf("%02d", i),".png"))
  r2 <- c(r2,r1)
}
file.remove(list.files(pattern=".png"))
animation<- image_animate(r2, fps = 1, dispose = "previous")
image_write(animation, "animations/odin_sierpinski.gif")

c <- c(-0.8,0.156)
julia <- julia_mod$new(pars=list(x_c=c[1], y_c=c[2]), 0, 100000)
#Creating countdown .png files from 10 to "GO!"
png(file="animations/temp_image%02d.png", width=600, height=400)
for(i in 0:30){
  z <- julia$run(i)
  y_spread <- range(z[2,])
  plot(z[1,],z[2,],
       pch=".",
       col="blue",
       axes=F,
       frame.plot=F,
       main=paste0("n = ",i),
       xlim = y_spread*1.5*1.1,
       ylim = y_spread*1.1,
       xlab="",
       ylab="")
}
dev.off()


r2 <- image_read(paste0("animations/temp_image",sprintf("%02d", 1),".png"))
for(i in 2:31){
  r1 <- image_read(paste0("animations/temp_image",sprintf("%02d", i),".png"))
  r2 <- c(r2,r1)
}
file.remove(Sys.glob("animations/*.png"))
animation<- image_animate(r2, fps = 1, dispose = "previous")
image_write(animation, "animations/odin_julia.gif")



