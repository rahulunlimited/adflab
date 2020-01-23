CREATE FUNCTION [UTIL].[fnGetParameterValue](@ParameterName VARCHAR(50))
RETURNS VARCHAR(50)
AS
/****************************************************************
Name	: UTIL.fnGetParameterValue
Date	: 19-Jun-2017
Author	: Rahul Agrawal 
Description
The function returns the Parameter from the Parameter Table based on the Parameter Name
****************************************************************/

BEGIN

	DECLARE @ParameterValue VARCHAR(50)

	SELECT @ParameterValue = ParameterValue
	FROM UTIL.[Parameter]
	WHERE ParameterName = @ParameterName
	AND Active = 1

	IF @ParameterValue = '' SET @ParameterValue = NULL

	RETURN @ParameterValue
END