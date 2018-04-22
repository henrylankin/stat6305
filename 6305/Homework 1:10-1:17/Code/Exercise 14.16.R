# given information
t <- 4
alpha <- 0.05
beta <- 0.10
D <- 30
sd <- 12.25

# calculating parameters: need to pick values for r first
power <- 1 - beta
phi <- sqrt(r*D^2/(2*t*sd^2))
v.1 <- t-1
v.2 <- t*(r-1)

print(v.2)
print(phi)

## Alternative method: calculating the power table

# values of replications to test
r <-c(3, 7, 5, 6)

# degrees of freedom for F-dist
v.1 <- t-1
v.2 <- t*(r-1)
df.1 <- v.1
df.2 <- v.2

# We use the non-centrality parameter, ncp, of the F-distribution instead of the psi parameter of the book
ncp <- r*D^2/(2*sd^2)
F.alpha <- qf(1-alpha, df.1, df.2)

# The power is P(F > F(alpha, t−1,t(r−1),ncp))
power <- 1- pf(F.alpha, df.1, df.2, ncp = ncp)

# Form the table as a data.frame
table.power <- data.frame(r, v.2, ncp, power)

print(table.power)
