context("Rtsne main function")

# Prepare iris dataset
iris_unique <- unique(iris) # Remove duplicates
Xscale <- scale(as.matrix(iris_unique[,1:4]), 
                center = TRUE, scale=FALSE)
Xscale <- scale(Xscale,
                center=FALSE, 
                scale=rep(1/max(Xscale),4))
distmat <- as.matrix(dist(Xscale))

# Run models to compare to
set.seed(50)
tsne_out_matrix <- Rtsne(as.matrix(iris_unique[,1:4]),verbose=FALSE, is_distance = FALSE,theta=0.0,max_iter=200,pca=FALSE)
set.seed(50)
tsne_out_matrix_bh <- Rtsne(as.matrix(iris_unique[,1:4]),verbose=FALSE, is_distance = FALSE,theta=0.1,pca=FALSE,max_iter=200)

test_that("Manual distance calculation equals C++ distance calculation", {
  
  # Exact
  # Note: only the same in the first few iterations
  set.seed(50)
  tsne_matrix <- Rtsne(as.matrix(iris_unique[,1:4]),verbose=FALSE, is_distance = FALSE,theta=0.0,max_iter=10,pca=FALSE)
  set.seed(50)
  tsne_dist <- Rtsne(distmat, verbose=FALSE, is_distance = TRUE,theta = 0.0,max_iter=10)
  expect_equal(tsne_matrix$Y,tsne_dist$Y,tolerance=10e-5)
  
  # Inexact
  set.seed(50)
  tsne_matrix <- Rtsne(as.matrix(iris_unique[,1:4]),verbose=FALSE, is_distance = FALSE,theta=0.1,max_iter=10,pca=FALSE)
  
  set.seed(50)
  tsne_dist <- Rtsne(distmat, verbose=FALSE, is_distance = TRUE,theta = 0.1,max_iter=10)
  expect_equal(tsne_matrix$Y,tsne_dist$Y,tolerance=10e-5)
})

test_that("Accepts dist", {
  # Exact
  set.seed(50)
  tsne_out_dist_matrix <- Rtsne(distmat, is_distance = TRUE, theta=0.0, max_iter=200)
  set.seed(50)
  tsne_out_dist <- Rtsne(dist(Xscale),theta=0.0,max_iter=200)
  expect_equal(tsne_out_dist$Y,tsne_out_dist_matrix$Y)
  
  # Inexact
  set.seed(50)
  tsne_out_dist_matrix <- Rtsne(distmat, is_distance = TRUE, theta=0.1, max_iter=200)
  set.seed(50)
  tsne_out_dist <- Rtsne(dist(Xscale),theta=0.1,max_iter=200)
  expect_equal(tsne_out_dist$Y,tsne_out_dist_matrix$Y)
})

test_that("Accepts data.frame", {
  #Exact
  set.seed(50)
  tsne_out_df <- Rtsne(iris_unique[,1:4],verbose=FALSE, is_distance = FALSE,theta=0.0,pca=FALSE,max_iter=200)
  expect_equal(tsne_out_matrix$Y,tsne_out_df$Y)
  
  #Inexact
  set.seed(50)
  tsne_out_df <- Rtsne(iris_unique[,1:4],verbose=FALSE, is_distance = FALSE,theta=0.1,pca=FALSE,max_iter=200)
  expect_equal(tsne_out_matrix_bh$Y,tsne_out_df$Y)
})

# test_that("Continuing from initilization gives approximately the same result as direct run", {
#   #Exact
#   set.seed(50)
#   tsne_out_full <- Rtsne(iris_unique[,1:4],verbose=FALSE, is_distance = FALSE,theta=0.0,pca=FALSE,max_iter=2000)
#   set.seed(50)
#   tsne_out_part1 <- Rtsne(iris_unique[,1:4],verbose=FALSE, is_distance = FALSE,theta=0.0,pca=FALSE,max_iter=500)
#   tsne_out_part2 <- Rtsne(iris_unique[,1:4],verbose=FALSE, is_distance = FALSE,theta=0.0,pca=FALSE,max_iter=1500,Y_init=tsne_out_part1$Y)
#   expect_equal(tsne_out_full$Y,tsne_out_part2$Y, tolerance = .001,scale=1)
#   
#   #Inexact
#   set.seed(50)
#   tsne_out_full <- Rtsne(iris_unique[,1:4],verbose=FALSE, is_distance = FALSE,theta=0.1,pca=FALSE,max_iter=1000)
#   set.seed(50)
#   tsne_out_part1 <- Rtsne(iris_unique[,1:4],verbose=FALSE, is_distance = FALSE,theta=0.1,pca=FALSE,max_iter=750)
#   tsne_out_part2 <- Rtsne(iris_unique[,1:4],verbose=FALSE, is_distance = FALSE,theta=0.1,pca=FALSE,max_iter=250,Y_init=tsne_out_part1$Y)
#   expect_equal(tsne_out_full$Y,tsne_out_part2$Y+0.5, tolerance = .001,scale=1)
# })
