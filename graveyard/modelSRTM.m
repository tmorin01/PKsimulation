function plot_data = modelSRTM(handles,t)

global TAC;
assignin('base','TAC',TAC);
fitted_TAC.reference = pchip(TAC.reference(1,:),TAC.reference(2,:),t);
fitted_TAC.roi = pchip(TAC.roi(1,:),TAC.roi(2,:),t);

% Get lambda value for radioligand
contents = cellstr(get(handles.active_comp,'String'));
isotope = contents{get(handles.active_comp,'Value')};
if strcmp(isotope,'C-11')
    T_half = 20.4;
elseif strcmp(isotope, 'F-18')
    T_half = 110;
end
lambda = log(2)/T_half;

[k2, BP, R1] = find_SRTM_parameters(TAC,lambda);

%% BELOW HERE:  OLD (Attempt at using PMOD equation for SRTM model)
% K1 = str2num(get(handles.k1,'String'));
% K2 = str2num(get(handles.k2,'String'));
% K1_ref = str2num(get(handles.kr1,'String'));
% K2_ref = str2num(get(handles.kr2,'String'));
% k3 = str2num(get(handles.k3,'String'));
% k4 = str2num(get(handles.k4,'String'));
% 
% assignin('base','K2',K2);
% assignin('base','K1',K1);
% assignin('base','K1_ref',K1_ref);
% assignin('base','K2_ref',K2_ref);
% assignin('base','k3',k3);
% assignin('base','k4',k4);
% 
% 
% R1 = K1./K1_ref;
% BP = k3./k4;
% 
% %[T,Ct] = ode23s(@(t,c) ode_srtm(t,c,time,fitted_REF_TAC,R1,BP),t,[0]);
% 
% Ct = R1.*fitted_REF_TAC + (K2 - ((R1.*K2)./(1+BP)));
% %Ct = (exp((-K2.*t)./(1+BP)));
% %Ct = conv((R1.*fitted_REF_TAC + (K2 - ((R1.*K2)./(1+BP)) ).*fitted_REF_TAC),(exp((-K2.*t)./(1+BP))),'same');

plot_data.x(1,:) = t;
plot_data.y(1,:) = fitted_TAC.reference;
plot_data.x(2,:) = t;
plot_data.y(2,:) = fitted_TAC.roi;

end

function [k2, BP, R1] = find_SRTM_parameters(TAC,lambda)
% 100 discrete values of theta(3).i that range from theta(3).min to theta(3).max will
% be tested.  In each iteration, values of theta(1).i and theta(2).i will
% be calculated.  The iteration with the best linear fit for the three
% theta values will be used to calculated k2, BP, and R1.  (Gunn et al.
% 1997, Parametric Imaging of Ligand-Receptor Binding in PET Using a SRTM)

% % theta(3).i = (k2/(1+BP))+lambda;
% theta(3).min = lambda;
% theta(3).max = lambda*10;
% 
% for m=1:100
%     theta(3).i(m,1) = theta(3).min + (m*((theta(3).max - theta(3).min)/100));
% end
% assignin('base','theta', theta);
% 
% Bt = conv(TAC.reference(2,:),theta(3).i(:,1)','same');
% 
% for m=1:100
%     theta(2).i(m,1) = 
% % assignin('base','Bt',Bt);
% figure
% plot(TAC.reference(1,:),Bt(1,:));


% 
% theta(1) = R1;
% theta(2) = k2 - (R1*k2*(1+BP));
end

