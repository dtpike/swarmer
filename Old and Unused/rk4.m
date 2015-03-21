function yOut = rk4(y, dydx, n, x, h, ode, a)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  function rk4 - This function performs a Runge-Kutta 4 integration 
%     Parameters:
%          y     - Value of the function at x
%          dydx  - Derivative of y at x
%          n     - Dimension of the output of the function
%          x     - Point where the function will be evaluated
%          h     - Step size
%          ode   - Pointer to the derivative function
%          param - Parameters for the derivative function (optional)
%          a      - Contains the u vaule need for the derive function
%     Output:
%          yout  - Evaluation of the function at (x+h)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialize intermediate values for the function and its derivatives
dym = zeros(1,n);
dyt = zeros(1,n);
yt  = zeros(1,n);

% Steps for the Runge-Kutta procedure
hh  = h/2;

% Next step
xh  = x + hh;                                           %x + h/2

% Evaluate function at next step
yt  = y+hh*dydx;                                        %y + k1/2

% Get the derivative of the function at trial point xh  %k2 ??
%dyt = feval(ode,xh,yt,param,a);
dyt = feval(ode,yt,a);

% Calculate the value of the function at xh
yt  = y+hh*dyt;                                         %y + k2/2

% Get the derivative with new initial conditions        %k3
%dym = feval(ode,xh,yt,param,a);
dym = feval(ode,yt,a);

% Recalculate the value of the function at xh
yt  = y+hh*dym;
dym = dym + dyt;                                        %k2 + k3

% Calculate the derivative of the function at (x+h)     %k4
%dyt = feval(ode,x+h,yt,param,a);
dyt = feval(ode,yt,a);

% Return the value of the function at (x+h)
yOut = y + h/6 * (dydx+dyt+2*dym);