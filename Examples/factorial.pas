program Main;
var input, result: integer;

function Factorial(number: Integer): Integer;
begin
if (number > 1) then
    Factorial := number * Factorial(number-1)
else
    Factorial := 1
end;

begin { Main }
read(input);
result := Factorial(input);
writeln(result)
end.  { Main }