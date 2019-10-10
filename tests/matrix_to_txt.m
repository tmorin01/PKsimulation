%% matrix_to_txt.m
% Author: Tom Morin
%   Date: Nov, 2015
% 
% Purpose: Write the contents of a matrix with dimensions width & height 
%          to a .txt file
%   INPUT: A matrix, mx
%  OUTPUT: A text file in the current directory with delimeter '\t'

function matrix_to_txt(mx)

[height, width] = size(mx);

% Always write data in columns
if height < width
    mx = mx';
    temp = height;
    height = width;
    width = temp;
end

% Get a filename from the UI
[filename, pathname] = uiputfile('*.txt');
fID = fopen([pathname filename],'w+');

% Write the data to the file
fprintf(fID, '%d %d\n', width, height);
for i = 1:height
    for j = 1:width
        fprintf(fID, '%.4f\t', mx(i, j));
    end
    fprintf(fID, '\n');
end

fclose(fID);
end