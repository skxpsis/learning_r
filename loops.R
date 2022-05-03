# =============== for loop =====================================================
# iterates over an index (provided as a vector)
# and performs some operations

for(i in 1:10)
  {
    print(i)
}

# same thing accomplished by using built on vectorization of print function
print(1:10)

# doesn't have to be numeric
fruit <- c("Apples", "Bananas", "Raspberries", "Blueberries", "Starberries")
fruitLength <- rep(NA, length(fruit))
fruitLength
names(fruitLength) <- fruit
fruitLength

# length of entry in fruit
for(a in fruit)
{
  fruitLength[a] <- nchar(a)
}
fruitLength

# or an easier way..
fruitLength2 <- nchar(fruit)
names(fruitLength2) <- fruit
fruitLength2

identical(fruitLength, fruitLength2)


# =============== while loop ===================================================
x <- 1
while(x <= 5)
{
  print(x)
  x <- x + 1
}

# =============== controlling loops ============================================
for(i in 1:10)
{
  if(i == 3)
  {
    # next # skips 3
    break # breaks loop completely
  }
  print(i)
}