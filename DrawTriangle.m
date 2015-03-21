function DrawTriangle (x, u, h, b, color)
%DRAWTRIANGLE Draws an isoceles triangle
%INPUT  centre at point x
%       pointing in direction u (unit vector)
%       height h
%       base 2b
%       colour color
%Adapted from code by Gilles Labonté to 2-dimensions
%
% Written by Alan Richards - alarobric@gmail.com
% Summer 2010

%Quicker plot method, simply uses a matlab marker instead of drawing a full
%triangle
%plot(x(1),x(2),color, 'Marker', '^');
%return

MP = [0, -1; 1, 0];

%Le sommet est à: 
P1 = x + h*u/2;

%Compute the point x that is at the center the height of the triangle 
x = x - h*u/2;

%The two ends of the basis are now calculated
%A vector perpendicular to u is w:
w = u*MP;
  
P2 = x + b*w;
P3 = x - b*w;

%Lines to draw triangle
M = [P1;P2;P3;P1];
plot(M(:,1), M(:,2),color, 'LineWidth',2,'EraseMode','none');

end
