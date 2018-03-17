CREATE Function maximum(@x money,@y money) returns money as 
	  Begin 
          if @x > @y 
            return @x
          return @y
        End