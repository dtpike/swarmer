function strng = array2str (array)
%ARRAY2STR faster way to turn an array of integers [2 3 4 5] into a string
% '2 3 4 5'
%Seems to be considerably faster than int2str (takes ~ half the time)
%
% Written by Alan Richards - alarobric@gmail.com
% Summer 2010


if length(array) == 1
    strng = sprintf('%d', array);
else
    strng = sprintf('%d ', array);
end

%previous versions - slower

%{
if length(array) == 1 
    strng = sprintf('%d', array);
elseif length(array) < 5
    strng = sprintf('%d %d %d %d', array);
elseif length(array) < 9
    strng = sprintf('%d %d %d %d %d %d %d %d', array);
elseif length(array) < 15
    strng = sprintf('%d %d %d %d %d %d %d %d %d %d %d %d %d %d', array);
else
    strng = int2str(array);
end
%}
%2.145s, .760s   2.170s, .689s,        2.203s, .735s

%{
if length(array) == 1 
    strng = sprintf('%d', array);
elseif length(array) == 2
    strng = sprintf('%d %d', array);
elseif length(array) == 3
    strng = sprintf('%d %d %d', array);
elseif length(array) < 6
    strng = sprintf('%d %d %d %d %d', array);
elseif length(array) < 9
    strng = sprintf('%d %d %d %d %d %d %d %d', array);
elseif length(array) < 13
    strng = sprintf('%d %d %d %d %d %d %d %d %d %d %d %d', array);
else
    strng = int2str(array);
end
%}
%2.168, .793     2.142, .737        2.167, .778

%strng = int2str(array);
%3.953s, 2.359s       3.999, 2.466        4.040s, 2.229s

%strng = num2str(array);
%4.619s, 3.136        4.619, 3.182

%strng = sprintf('%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d', array);
%3.231,  1.729       3.192, 1.924