%
%  Author: Tom Morin
%    Date: January, 2016
% Purpose: Implementation the Logan Reference Tissue Model

function plot_data = logan_sim(roi_tac, reference_tac, k2_prime, handles, chal_times, amplitude, noise)

%% Run the Logan Reference Model (Calculate Binding Potential)
t = [0:0.5:roi_tac(1,end)];

% Set up matrices for system of linear equations
Ct(1,:) = roi_tac(2,:);
Cr(1,:) = reference_tac(2,:);

% Integrate Ct
iCt = zeros(1,length(Ct));
for m=1:length(Ct)
    if m==1
        iCt(1,1) = Ct(1,1);
    else
        iCt(1,m) = 0.5.*Ct(1,m) + iCt(1,m-1);
    end
end

% Integrate Cr
iCr = zeros(1,length(Cr));
for m=1:length(Cr)
    if m==1
        iCr(1,1) = Cr(1,1);
    else
        iCr(1,m) = 0.5.*Cr(1,m) + iCr(1,m-1);
    end
end

% Find x and y coordinates of the Logan Plot
y = iCt(1,:)./Ct(1,:);
x = (iCr(1,:) + Cr(1,:)./k2_prime) ./ Ct(1,:);
x_orig = x;
y_orig = y;

assignin('base','x',x);
assignin('base','y',y);

% Delete initial NaN values
if isnan(y(1))
    y(1) = [];
end
if isnan(x(1))
    x(1) = [];

% Eliminate curve at beginning so that we're only left with linear portion
% 1. Find 2nd derivative of all points
% 2. Determine Z-scores for each f''(x) point
% 3. Eliminate any point before t=5 min
% 4. Eliminate any point after that that has a second derivative more than
%    2 standard deviations away from the mean second derivative

% Find 2nd derivateive of all points
for m=2:length(x)
    y_first_deriv(1,m-1) = ((y(1,m)-y(1,m-1))/(x(1,m)-x(1,m-1)));
end
for m=3:length(y_first_deriv)
   y_second_deriv(1,m-2) = ((y_first_deriv(1,m-1) - y_first_deriv(1,m-2))/...
                            (x(1,m) - x(1,m-1)));
end
mean_sec_deriv = mean(y_second_deriv);
std_sec_deriv = std(y_second_deriv);

% Determine Z-scores for each f''(x) point
for m=1:length(y_second_deriv)
    z_sec_deriv(1,m) = ((y_second_deriv(1,m) - mean_sec_deriv) ./ std_sec_deriv);
end
z_sec_deriv = cat(2,[3 3 3 3],z_sec_deriv);

% Eliminate all points before time t = 5min. & all points thereafter with a
% second derivative more than 2 standard deviations away from the mean
for m=1:length(z_sec_deriv)
   if m < 10
       x(1) = [];
       y(1) = [];
   elseif z_sec_deriv(1,m) > 1
       x(1) = -5;
       y(1) = -5;
   end      
end

m = 1;
while(m ~= length(x))
    if x(m) == -5 || y(m) == -5
        x(m) = [];
        y(m) = [];
    else
        m = m + 1;
    end
end

% Fit the data linearly and use slope to calculate BP
[xData, yData] = prepareCurveData(x,y);
ft = fittype('poly1');
[fitresult, gof] = fit(xData, yData, ft);
assignin('base','fitresult',fitresult);
params = coeffvalues(fitresult);
slope = params(1,1);
BP = slope - 1;

% Assign vectors to plot
plot_data.x(1,:) = xData; % Final Logan Plot X coordinates
plot_data.y(1,:) = yData; % Final Logan Plot Y coordinates
plot_data.fitresult = fitresult; % Final fitted curve of Logan Plot
plot_data.NT = zeros(1,length(xData));
plot_data.NT(1,:) = 0.2;
assignin('base','plot_data',plot_data);

% Display fitted parameters in a new figure
h = figure(1);
set(h,'Position',[50 300 250 300]); 
annotation('textbox',...
    [0.05 0.8 0.1 0.1],...
    'String',{'Logan Reference Plot','Fitted Parameters:','','k2^, =',k2_prime,'','BP =',BP(1,1),'','R^2 =',gof.rsquare},...
    'FontSize',20,...
    'EdgeColor',[0.0784313753247261 0.168627455830574 0.549019634723663],...
    'BackgroundColor',[1 1 1],...
    'FitBoxToText','on');

end