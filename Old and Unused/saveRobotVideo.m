function saveRobotVideo(VidArray)
%this function takes in argument VidArray
%saves the array of images as an AVI file to a user-specified location
%
% Written by Atif Rahman and later edited by Alan Richards - alarobric@gmail.com
% Summer 2010
 
%popup window to select filename to save as
%can add or remove allowed filetypes from the list
[filename, pathname] = uiputfile({ '*.avi', 'AudioVideo Interleaved (*.avi)';}, ... 
        'Save video as','*.avi');
 
%if user cancels save command, nothing happens
if isequal(filename,0) || isequal(pathname,0)
    return
end

%save the original path in a variable
origpath = pwd;
%move to path specified by user
cd(pathname);
%the line below may not  be needed.
uiwait(msgbox('Please wait while we save your video file... Press OK to save', 'Please wait'));
%save video in user defined path
movie2avi(VidArray, filename, 'keyframe', 60, 'compression', 'cinepak'); 
uiwait(msgbox({['Video saved as ',pathname, filename]}, 'Video has been saved'));
%revert back to original path
cd(origpath);
 
end