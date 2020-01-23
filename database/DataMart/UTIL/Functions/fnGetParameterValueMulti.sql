CREATE FUNCTION [UTIL].[fnGetParameterValueMulti](@ParameterName VARCHAR(50))
RETURNS @ParameterTable TABLE (
	ParameterValue VARCHAR(50) )
AS
/****************************************************************
Name	: UTIL.fnGetParameterValueMulti
Date	: 19-Jun-2017(Velrada)
Description
The function returns the Parameter from the Parameter Table based on the Parameter Name
****************************************************************/

BEGIN

	INSERT INTO @ParameterTable
	SELECT ParameterValue
	FROM UTIL.Parameter
	WHERE ParameterName = @ParameterName
	AND Active = 1

	RETURN 
END