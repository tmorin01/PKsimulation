function print_list(hdr,M,ffile,sf)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SCRIPT TO PRINT PMOD READABLE TEXT-FILES 
%% Written by Daniel Chonde
%% Req: dynamic pet data (*.i files)
%% Output: Patlak i file (brain.i)
%% Written: 03/16/2012 Updated:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script prints out data to a pmod readable tab delimited file.  It is
% called by gammareader, the function used to automatically convert blood
% data to single files.
% hdr = the headings on the final output file
% M = a matrix of data
% ffile = the desired name of the output file
% sf = the desired significant figures for data in output file
%
% example:
% print_list({'sample-time[seconds]';plasma[kBq/cc]},data,'sampledata.bld')
%
%

%% Set output number format
if nargin<4, sf=1;end
pformat=['%.' num2str(sf) 'f'];

%% Load Row Data
if iscolumn(hdr),hdr=hdr';end
if size(M,2)~=size(hdr,2), error('data and data header are different lengths.');end

%% Sort rows to make sure they are in ascending order
M=sortrows(M,1);

%% Write Format Strings
hdr_str='';
mat_str='';
for m=1:size(hdr,2)
hdr_str=[hdr_str '%s'];
mat_str=[mat_str pformat];
if m~=size(hdr,2), 
    hdr_str=[hdr_str '\t'];
    mat_str=[mat_str '\t'];
else
    hdr_str=[hdr_str '\n'];
    mat_str=[mat_str '\n'];
end
end

%% Print Data to file
fid=fopen(ffile,'w');
fprintf(fid,hdr_str,hdr{:});
fprintf(fid,mat_str,M');
fclose(fid);


end