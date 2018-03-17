CREATE procedure NEXT_AUTONUM 

	@tablename nvarchar(100),

	@increment int,

	@initialnum int,

	@nextnum money output

as 

             -- Define sql to update the nextnumber and fetch it

            DECLARE @SQLQuery AS NVARCHAR(100)

            SET @SQLQuery = 'UPDATE AutoNumber SET @nextnumOUT = nextnumber += @increment where tablename=@tablename'

            Declare @ParamDefinition AS NVARCHAR(100)

            SET @ParamDefinition = '@increment INT, @tablename NVARCHAR(100), @nextnumOUT MONEY OUTPUT'

            -- Execute update/set sql, will set nextnum output value

            Execute sp_Executesql @SQLQuery,

                            @ParamDefinition,

                            @increment, @tablename, @nextnumOUT=@nextnum OUTPUT



            -- if the requested tablename wasn't found then insert record now

            if @@rowcount=0

                    begin

                        -- Define sql to insert record and set initial value

                        SET @SQLQuery = N'INSERT into AutoNumber (tablename,nextnumber) values (@tablename,@initialnum + @increment)'

                        SET @ParamDefinition = '@tablename NVARCHAR(100), @initialnum INT, @increment INT'

                        -- Execute insert sql

                        Execute sp_Executesql @SQLQuery,

                                                        @ParamDefinition,

                                                        @tablename, @initialnum, @increment

                        -- if row inserted then update nextnum output value

                        if @@rowcount=1

                                SET @nextnum = @initialnum + @increment

                    end

	