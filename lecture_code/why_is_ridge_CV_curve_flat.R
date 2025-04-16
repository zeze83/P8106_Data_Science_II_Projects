set.seed(2)
cvSplits <- vfold_cv(data.frame(Salary = y, x), v = 10) 
M <- 10
lambda.grid <- exp(seq(5, -2, length = 100))
rmse_r <- rmse_r_tm <- matrix(NA, ncol = 100, nrow = M)
for (m in 1:M)
{
  tsdata <- analysis(cvSplits[[1]][[m]]) 
  vsdata <- assessment(cvSplits[[1]][[m]]) 
  
  x1 <- as.matrix(tsdata[,-1])
  y1 <- tsdata[,1]
  x2 <- as.matrix(vsdata[,-1])
  y2 <- vsdata[,1]
  
  fit <- glmnet(x1, y1, alpha = 0, 
                lambda = lambda.grid)
  
  # tidymodels/caret implementation did not specify lambda
  # the default grid of lambda is different from lambda.grid
  fit_tm <- glmnet(x1, y1, alpha = 0)
  
  pred <- predict(fit, newx = x2, s = lambda.grid)
  pred_tm <- predict(fit_tm, newx = x2, s = lambda.grid)
  
  rmse_r[m,] <- sqrt(colMeans((y2 - pred)^2))
  rmse_r_tm[m,] <- sqrt(colMeans((y2 - pred_tm)^2))
}

# curve from glmnet (correct)
plot(log(lambda.grid), colMeans(rmse_r), col = 3)

# curve from tidymodels
points(seq(-2, 5, length = 100), 
       as.vector(ridge_tune %>% collect_metrics() %>% filter(.metric == "rmse") %>% select(mean))[[1]],
       col = 2)
# try to reproduce tidymodels results from scratch
points(log(lambda.grid), colMeans(rmse_r_tm), col = 4)


