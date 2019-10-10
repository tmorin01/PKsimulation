% Author: Tom Morin
% Date: July, 2015
% Create a periodic right triangle of specific height and width according
% to a series of time data

function data = make_triangle(time,width,height)
data(:,1) = time;
for m=1:length(time)
    if mod(time(m),width) == 0
        data(m,2) = height;
    else
        data(m,2) = height./width.*mod(time(m),width);
    end
end
