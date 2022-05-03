
# =============== BASIC MATH OPERATIONS ========================================
  # type into terminal:
    # 4/3
    # 4*3
    # (3 + 7) / 2
    # 4**2 (or 4^2)

# ================ VARIABLES ===================================================
  # variable types do not need to be declared
  # variables are flexible -- can hold an int, then a char, then an int again
  # can hold any R object such as a function, result of analysis, or plot
  # can contain any character, number, ".", or "_"
  # cannot start with "_" or a number
  
  # ==== DECLARING VARIABLES ====

    # <- , = ; <- is preferred method
    x <- -2
    x
    
    # can go both ways
    3 -> z
    3
    
    # simultaneous assignment
    a <- b <- 7
    a
    b
    
    # more laborious but sometimes necessary, using assign() function
    assign("j", 4)
  
  # ==== REMOVING VARIABLES ====
    
    # can be done using remove() or rm()
    rm(j)
    j
    # output: "Error in eval(expr, envir, enclos): object 'j' not found"
    
    # if want to remove all memory trace, use ge() which performs garbage
    # collection
    # not necessary tho, R does this periodically on its own
    
# ================ DATA TYPES ==================================================
    # most likely to be used:
    # numeric (float/double), character (string), Date/POSIXct (time-based), and
    # logical (TRUE/FALSE)
    
    # ====== NUMERIC / INTEGER / CHECKING DATA TYPES ======
      # the type of data contained in a variable is checked with the class()
      x <- 2
      class(x)
      class(4L)
      class(4.2)
      class(4L * 2.8)
      class(5L / 2L)
      
      # returns TRUE or FALSE
      is.numeric(x)
      y <- 5L
      is.integer(y) # ints are non-decimal numbers, must be declared with L
      # note: y will also return TRUE for is.numeric(y)
      # R promotes data types as needed (such as dividing two ints with decimal
      # result)
    
    # ====== CHARACTER DATA ======
      # case sensitive
      # two ways: character, factor
      
      # === CHARACTER ===
      x <- "data"
      x
      # output: [1] "data"
      
      # === FACTOR ===
      y <- factor("data")
      y
      # output: [1] data
      #         Levels: data
      
    # === LENGTH ===
      # find find length of character OR numeric, use nchar function
      # will NOT work for factor data
      nchar(x)
      nchar(y) # see above for factor data
      # output: [1] 4
      nchar("hello")
      nchar(356)
    
    # ===== DATE & TIME =====
      # Date stores just a date
      # POSIXct stores a date and time
      # both objects represented as the number of days (Date) or seconds
      # (POSIXct) since January 1, 1970
      
      date1 <- as.Date("2012-06-28")
      date1
      # output: "2012-06-28"
      class(date1)
      as.numeric(date1)
      # output: 15519
      
      date2 = as.POSIXct("2012-06-28 17:42")
      date2
      # output: "2012-06-28 17:42 EDT"
      class(date2)
      # output: "POSIXct" "POSIXct"
      as.numeric(date2)
      # output: [1] 1340919720
      
      # using functions such as as.numeric or as.Date changes the underlying
      # type; NOT just the formatting
      # ***********
      # lubridate and chron packes make manipulation easier
      class(date1)
      # output: [1] "Date"
      class(as.numeric(date1))
      # output: [1] "numeric"
      
    # ====== LOGICAL ======
      # TRUE (1) or FALSE (0)
      TRUE * 5 # = 5
      FALSE * 5 # = 0
      k <- TRUE
      class(k) # "logical"
      is.logical(k) # TRUE
      
      # can use comparison operator == to return T or F
      2 == 3 # FALSE
      2 != 3 # TRUE
      2 < 3 # TRUE
      2 > 3 # FALSE
      2 >= 3 # FALSE
      "data" == "stats" # FALSE
      "data" < "stats" # TRUE
      
    # ====== VECTORS ======
      # a collection of elements all of the same type -- CANNOT be mixed type
      # R is a vector language -- operations applied to each element in the
      # vector automatically (no looping needed!)
      # non-dimensional (no column/row vector)
      
      # === CREATING A VECTOR ===
        # use 'c' for combine
        x <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
        x
        # outputs vector without brackets or commas, only spaced apart
        x * 3 # multiplies each element by 3
        x / 3
        x + 3
        x - 3
        x^2
        sqrt(x)
        
        # quick creation: sequential ordering between two numbers
        1:10 # output: [1] 1 2 3 4 5 6 7 8 9 10
        10:1 # output: [1] 10 9 8 7 6 5 4 3 2 1
        -2:3 # output: [1] -2 -1 0 1 2 3
        5:-7 # output: [1] 5 4 3 2 1 0 -1 -2 -3 -4 -5 -6 -7
        
        # vector operations can be extended if vectors are of even length
        x <- 1:10
        y <- -5:4
        x + y
        x - y
        x ^ y
        x  / y # so on
        
        length(x)
        length(y)
        length(x+y)
        
        # if vectors are of uneven length, shorted vector repeats itself
        # warning is displayed if longer vector is not multiple of shorter
        # comparison T/F also works on vectors
        x <- 10:1
        y <- -4:5
        any(x < y)
        all(x < y)
        
        # length
        q <- c("sports", "foosball", "hi")
        nchar(q)
        
        # accessing elements
        # use [ ]; first element x[1], the first two elements x[1:2], etc.
        x[1]
        x[1:2]
        x[3]
        x[3:2]
        
        # naming a vector
        # first create the vector
        w <- 1:3
        # then name the vector
        names(w) <- c("a", "b", "c")
        w
        
      # === FACTOR VECTORS ===
        q2 <- c("Hockey", "Football", "Baseball", "Curling", "Rugby",
                "Lacrosse", "Basketball", "Tennis", "Cricket", "Soccer",
                "Hockey", "Lacrosse", "Hockey", "Water Polo", 
                "Hockey", "Lacrosse")
        q2Factor <- as.factor(q2)
        q2Factor
        as.numeric(q2Factor)
        factor(x=c("High School", "College", "Masters", "Doctorate"),
               levels=c("High School", "College", "Masters", "Doctorate"),
               ordered=TRUE)
    # ====== MISSING DATA ======
        # declared used NA
        z <- c(1, 2, NA, 8, 3, NA, 3)
        z
        is.na(z)
        mean(z) # returns NA if a single NA is found
        mean(z, na.rm=TRUE) # removes NA entries to calculate mean
                            # also works for sum, min, max, var, sd, etc.
        
        # packages for handling missing data: mi, mice, and Amelia
        
        # NULL
          # absence of anything -- different than NA
          # cannot exist within a vector
          # if used in a vector, it WILL disappear
          # test:
          z <- c(1, NULL, 3)
          z # observe no NULL
          d <- NULL
          is.null(d) # TRUE
          is.null(7) # FALSE
    # ====== PIPES ======
      library(magrittr)
          x <- 1:10
          mean(x)
          x %>% mean(x)
          # results are the same, pipes most useful when chaining together
          # a series of function calls
          z <- c(1, 2, NA, 8, 3, NA, 3)
          sum(is.na(z))
          # done using pipes:
          z %>% is.na %>% sum
          z %>% mean(na.rm=TRUE)