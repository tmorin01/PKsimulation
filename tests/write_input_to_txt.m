%  write_input_to_txt()
%
%  Author: Tom Morin
%    Date: September, 2015
%
% Purpose: Take an Arterial Input Function & write it to a .txt file for
% easy manipulation by other programs
%   INPUT: time --- the scan time in minutes
%          input -- an array of Cp or Ca values (values should be taken at an
%                   interval of 1-second)
%  RETURN: t ------ a 2D array of times & corresponding Ca or Cp values

function t = write_input_to_txt(time, input)

t(1,:) = (0:(1/2):time)

[height, ~] = size(input);
disp(height);
if height > 1
    t(2,:) = input';
else
    t(2,:) = input;
end

disp(t);

[filename, pathname] = uiputfile('*.txt');

fID = fopen([pathname filename],'w');
fprintf(fID, '%s %s\n', 'time [s]',	'Activity [arb units]');
fprintf(fID, '%.4f %.4f\n', t);
fclose(fID);
end
