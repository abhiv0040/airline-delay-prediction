# Project (Continued)

setwd("C:/Users/mukes/OneDrive/Desktop/SAS + R Project")
getwd()

airlinedata_final_log <- read.csv("airlinedata_final_log.csv")

str(airlinedata_final_log)

# Step-wise Logistic Regression Model
# Load Libraries
library(pROC)
library(caret)
library(ggplot2)

# STEP 1: Define 'high_delay_rate' based on 65thth percentile
threshold <- quantile(airlinedata_final_log$DelayRate, 0.65, na.rm = TRUE)
airlinedata_final_log$high_delay_rate <- factor(ifelse(airlinedata_final_log$DelayRate > threshold, 1, 0))

# STEP 2: Recode factors (ensure modeling won't fail)
airlinedata_final_log$SeasonalQuarter <- factor(airlinedata_final_log$SeasonalQuarter)
airlinedata_final_log$BusyAirportFlag <- factor(airlinedata_final_log$BusyAirportFlag)
airlinedata_final_log$LogCarrierSize <- factor(airlinedata_final_log$LogCarrierSize)

# STEP 3: Train-test split (70% train, 30% test)
set.seed(2216385)
split <- createDataPartition(airlinedata_final_log$high_delay_rate, p = 0.7, list = FALSE)
train <- airlinedata_final_log[split, ]
test <- airlinedata_final_log[-split, ]

# STEP 4: Fit full logistic regression model
full_model <- glm(high_delay_rate ~ log_carrier_delay + log_weather_delay +
                    log_nas_delay + log_security_delay + log_late_aircraft_delay,
                  data = train, family = binomial)

# STEP 5: Perform stepwise selection (both directions)
step_model <- step(full_model, direction = "both", trace = FALSE)

# STEP 6: Summary of selected model
summary(step_model)

# STEP 7: Predict probabilities on test set
probs <- predict(step_model, newdata = test, type = "response")

# STEP 8: Classify using 0.4 threshold
preds <- factor(ifelse(probs >= 0.4, 1, 0), levels = c(0, 1))

# STEP 9: Evaluate confusion matrix
conf_matrix <- confusionMatrix(preds, test$high_delay_rate)
print(conf_matrix)

# STEP 10: ROC curve and AUC
roc_obj <- roc(test$high_delay_rate, probs)
plot(roc_obj, col = "blue", lwd = 2, main = "ROC Curve - Stepwise Logistic Model")
abline(a = 0, b = 1, col = "gray", lty = 2)
cat("AUC =", auc(roc_obj), "\n")






# Random Forest Model

# Load required libraries
library(randomForest)
library(pROC)
library(caret)

# STEP 0: Create the binary classification target
threshold <- quantile(airlinedata_final_log$DelayRate, 0.65, na.rm = TRUE)
airlinedata_final_log$high_delay_rate <- ifelse(airlinedata_final_log$DelayRate > threshold, 1, 0)

# STEP 1: Select relevant variables for modeling
rf_vars <- c("log_carrier_delay", "log_weather_delay", "log_nas_delay",
             "log_security_delay", "log_late_aircraft_delay", "high_delay_rate")
airline_rf <- airlinedata_final_log[, rf_vars]
airline_rf$high_delay_rate <- as.factor(airline_rf$high_delay_rate)

# STEP 2: Train-Test Split (70/30)
set.seed(2216385)
split_idx <- sample(nrow(airline_rf), round(0.7 * nrow(airline_rf)))
train1 <- airline_rf[split_idx, ]
test1  <- airline_rf[-split_idx, ]

# STEP 3: Random Forest Model (initial version)
set.seed(2216385)
rf0 <- randomForest(high_delay_rate ~ ., data = train1, mtry = 2, ntree = 500)
print(rf0)

# STEP 4: Predict on test data
rfhat0 <- predict(rf0, newdata = test1, type = "prob")[, 2]

# STEP 5: Confusion Matrix at 0.4 cutoff
pred_class <- ifelse(rfhat0 > 0.4, 1, 0)
conf_matrix <- table(Predicted = pred_class, Actual = as.numeric(as.character(test1$high_delay_rate)))
print(conf_matrix)

# STEP 6: ROC & AUC
roc_rf <- roc(as.numeric(as.character(test1$high_delay_rate)), rfhat0)
plot(roc_rf, col = "blue", lwd = 2, main = "ROC Curve - Random Forest")
abline(a = 0, b = 1, col = "gray", lty = 2)
cat("AUC =", auc(roc_rf), "\n")

# Vector to store OOB error values for different mtry values
oob.values <- vector(length = 3)

# Loop over mtry values from 1 to 3
for (i in 1:3) {
  temp.model <- randomForest(formula = high_delay_rate ~ ., 
                             data = train1, 
                             mtry = i, 
                             ntree = 500)
  oob.values[i] <- temp.model$err.rate[nrow(temp.model$err.rate), "OOB"]
}

# Display the mtry values and corresponding OOB errors
print(cbind(mtry = 1:3, OOB_Error = round(oob.values, 5)))

# Based on the consensus, the best mtry = 1

# Set seed for reproducibility
set.seed(2216385)

# Fit random forest model with a large ntree
rf_tree <- randomForest(formula = high_delay_rate ~ ., 
                        data = train1, 
                        mtry = 1, 
                        ntree = 1000)

# Extract OOB error values
Trees <- 1:nrow(rf_tree$err.rate)
OOB_Error <- rf_tree$err.rate[, "OOB"]

# Plot OOB Error vs Trees
plot(Trees, OOB_Error, type = "l", col = "red", lwd = 2,
     main = "OOB Error vs. Number of Trees",
     xlab = "Number of Trees",
     ylab = "OOB Error Rate")
grid()

# Find the ntree with the lowest OOB error
best_ntree <- Trees[which.min(OOB_Error)]
min_oob <- min(OOB_Error)

# Print the result
cat("Best ntree =", best_ntree, "\n")
cat("Minimum OOB Error =", round(min_oob, 5), "\n")


# Selecting the Final Random Forest model

# Set seed for reproducibility
set.seed(2216385)

# Train the Random Forest model
rf_model <- randomForest(
  formula = high_delay_rate ~ ., 
  data = train1, 
  mtry = 1, 
  ntree = 897
)

# Predict probabilities on the test set
rf_probs <- predict(rf_model, newdata = test1, type = "prob")[,2]

# Apply threshold (0.4) to convert probabilities to class predictions
rf_pred_class <- ifelse(rf_probs > 0.4, 1, 0)

# Convert to factors for evaluation
predicted <- factor(rf_pred_class, levels = c(0,1))
actual <- factor(test1$high_delay_rate, levels = c(0,1))

# Confusion matrix
conf_matrix <- confusionMatrix(predicted, actual, positive = "1")
print(conf_matrix)

# AUC Plot
roc_obj <- roc(actual, rf_probs)
plot(roc_obj, main = "Random Forest (mtry = 1, ntree = 897) - ROC Curve")
auc_val <- auc(roc_obj)
cat(sprintf("AUC: %.4f\n", auc_val))























