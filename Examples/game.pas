Program Game;
Var       
    target, guess: Integer;

Begin 
	guess  := 10;
	target := random(guess);

	Writeln('Guess a number between 0 and 10:'); 
	Read(guess);

	repeat		
		if guess > target then
		begin
			Writeln('Too much, try again');
			Read(guess);
		end
		else
		begin
			Writeln('Too low, try again');
			Read(guess);
		end
	until target = guess;
	Writeln('You won!')
End.  