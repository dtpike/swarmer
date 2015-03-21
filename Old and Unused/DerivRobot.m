function dy = DerivRobot(heading, u)
% This function takes the robots position and the u value and combines the
% values with the kinematic equations of the robot

%t - stepsize
%y - position [x y heading]
%param - robots parameters? - [Speed, x2, start angle]??? huh?
%a - current speed

V = (1.17*50 -42.65)/2;
R = (1.17*50 -42.65)*13/5;



dy  = [ V * cos(heading);...
        V * sin(heading);...
        (V/R)*u];