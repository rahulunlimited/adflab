﻿CREATE FUNCTION [UTIL].[fnGetLocalDateTime]
(
) 
RETURNS DATETIME 
BEGIN

    DECLARE @var DateTime
    SELECT @var =  CONVERT(DATETIME, GETUTCDATE() AT TIME ZONE 'AUS Eastern Standard Time')
   
    RETURN @var

END
