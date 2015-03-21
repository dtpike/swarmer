function filenames = dirKPM(dirname, ext, prepend)
% READ_DIR Like the built-in dir command, but returns filenames as a cell array instead of a struct
%
% filenames = read_dir(dirname)
% returns all files
%
% filenames = read_dir('images', '*.jpg')
% filenames{1} = 'foo.jpg', filenames{2} = 'foo2.jpg', etc
%
% read_dir(dirname, ext, 1) prepends the directory name to the filenames
% eg filenames{1} = 'images/foo.jpg', filenames{2} = 'images/foo2.jpg', etc

if nargin < 2, ext = ''; end
if nargin < 3, prepend = 0; end

tmp = dir(fullfile(dirname, ext));
filenames = {tmp.name};
filenames = setdiff(filenames, {'.', '..'});

if prepend
  nfiles = length(filenames);
  if ispc()
    c = '\';
  else
    c = '/';
  end
  for fi=1:nfiles
    filenames{fi} = sprintf('%s%s%s', dirname, c, filenames{fi});
  end
end

