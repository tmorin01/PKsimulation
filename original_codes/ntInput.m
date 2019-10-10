function NT = ntInput(t, parameter,td)

%%
% Generate endogenous neurotransmitter pulse
%
% Example: DA^{EN}
% [Basal, gamma, alpha, beta] = [100, 7000, 1, 1.2] or [100, 1000, 2, 0.8];
%
% ref: Morris and Yoder, JCBFM, 2006;
%%

basal = parameter(1);
gamma = parameter(2);
A = parameter(3);
B = parameter(4);

NT = zeros(1,length(t)); %row vector

NT = NT + basal;    
idx = find(t >= td);
NT(idx) = basal + gamma.*(t(idx)-td).^A.*exp(-B.*(t(idx)-td));
%NT(idx) = basal + gamma.*(exp(-1.*(t(idx)-td).^2));

    
    
    %% PLOT results
    
%     figure; whitebg('w'); set(gcf,'color','w');
%     plot(t,NT,'k','Linewidth',2);  
% 
%     xlabel('Time (min.)','FontSize',14,'FontName','Arial');
%     ylabel('Dopamine (nM)','FontSize',14,'FontName','Arial')
%     hleg1 = legend('DA^{EN}');
%     set(hleg1,'Location','Best','FontSize',12,'FontName','Arial');
%     title('Endogenous NT','FontSize',16,'fontWeight','bold','FontName','Arial');
% 
%     hold all;
end

% hold off;
% 
% end