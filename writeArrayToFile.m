function writeArrayToFile(fid,array)
%MUST BE CALLED FROM SINGLE THREAD

fprintf(fid,'%0.2f,%0.2f,%d,%0.2f',array(1),array(2),array(3),array(4));
for i=5:size(array,2)
    fprintf(fid,',%0.2f',array(i));
end

fprintf(fid,'\n');

end