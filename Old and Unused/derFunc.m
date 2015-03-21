function yPrime = derFunc(x, y, u, uMag)
%returns derivative of y at x
%y = 2d position vector
%u = 2d velocity/heading unit vector
%uMag = velocity magnitude

yPrime = uMag * u;  %gives xy position at next time unit

%derivative of turn

