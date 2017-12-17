Program Numbers;
Var       
    Num1, Num2, Sum : Integer;

Begin {no semicolon}
	Write('Input number 1:'); 
	Read(Num1);
	Write('Input number 2:');
	Read(Num2);
	Sum := Num1 + Num2; {addition} 
	Writeln();
	Writeln(Num1,'+', Num2,'=', Sum);
End.  