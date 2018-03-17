CREATE Function minimum(@x money,@y money) returns money as 
	  Begin 
          if @y > @x
            return @x
          return @y
        End