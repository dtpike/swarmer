function DrawSquare(x, w, color)
%DRAWSQUARE Draws an square
%INPUT  centre at point x
%       side width w
%       with colour color
%
% Written by Alan Richards - alarobric@gmail.com
% Summer 2010

%MAYBE Quicker draw method. Simply uses matlab markers instead of drawing a
%square. Needs to be tested - seems slightly slower actually
%plot(x(1),x(2),color, 'Marker', 's');
%return

%get all four corners
P1 = x + w/2;
P2 = x + [w/2 -w/2];
P3 = x - w/2;
P4 = x - [w/2 -w/2];

%draws the lines connecting them
M = [P1;P2;P3;P4;P1];
plot(M(:,1), M(:,2),color, 'LineWidth',2,'EraseMode','none');

end

