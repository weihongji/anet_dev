DECLARE 
    @input_str varchar(256) = '123456789', 
    @orig_key varchar(256) = 'Sacramento', 
    @encrypted_str VARCHAR(256) = '6A1C2DC31527FA40' 


--SELECT dbo.ANET_RC4_ENCRYT(@input_str, @orig_key) 
SELECT dbo.ANET_RC4_DECRYT(@encrypted_str, @orig_key) 