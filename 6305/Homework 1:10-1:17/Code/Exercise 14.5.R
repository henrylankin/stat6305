# given information about the experiment
n <- 20
t <- 4
alpha <- 0.05

# point estimates of the means
incentive.means <- c(514.1, 557.2, 628.3, 649.8)

# from ANOVA output
MSE <- 39107
df.errors <- 76

# Fisher's LSD procedure
sd.errors <- sqrt(MSE)
t.value <- qt(alpha/2, df.errors, lower.tail = FALSE)
LSD <- t.value*sd.errors*sqrt(2/n)
print(sprintf("LSD = %f", LSD))

# differences in the means
diffCombn.matrix <- combn(incentive.means, 2)
means.diff <- diffCombn.matrix[2,] - diffCombn.matrix[1,]

print("Pairs to subtract listed for each possible combination by column:")
print(diffCombn.matrix)
print("Differences for each pair in relative order to the matrix above:")
print(means.diff)


