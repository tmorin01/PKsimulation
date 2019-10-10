%  write_SRTM_txt()
%
%  Author: Tom Morin
%    Date: December, 2015
%
% Purpose: Take an Arterial Input Function & write it to a .txt file for
% easy manipulation by other programs
%   INPUT: time --- a vector of the time-series x-axis
%           ROI --- a vector of the Region of Interest TAC
%           REF --- a vector of the Reference Region TAC
%  RETURN: mx ----- a concatinated matrix made up of the three input
%                   vectors

% NOTE: Be sure that input vectors are verticle (i.e. dims 401 x 1)

function mx = write_SRTM_txt(time, ROI, REF)

start_time = time .* 60;
end_time = (time + 0.5) .* 60;
mx = cat(2,start_time,end_time,ROI,REF);

[filename, pathname] = uiputfile('*.txt');

fID = fopen([pathname filename],'w');
fprintf(fID, '%s\t%s\t%s\t%s\n', 'start[seconds]','end[kBq/cc]','striatum','cerebellum');
fprintf(fID, '%d\t%d\t%.4f\t%.4f\n',mx');
fclose(fID);
end
