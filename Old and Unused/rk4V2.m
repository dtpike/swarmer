function yOut = rk4V2 (y, x, derFunc, h, u, uMag)
%where f(x,y)=y'
%y = value of function at x
%x = time to start from
%derFunc = function handle with call yPrime = derFunc(x, y) returning
        %derivative of y at x
%h = stepsize
k1 = h * feval(derFunc, x, y, u, uMag);
k2 = h * feval(derFunc, x + h/2, y + k1/2, u, uMag);
k3 = h * feval(derFunc, x + h/2, y + k2/2, u, uMag);
k4 = h * feval(derFunc, x + h, y + k3, u, uMag);
yOut = y + 1/6*(k1 + 2*k2 + 2*k3 + k4);