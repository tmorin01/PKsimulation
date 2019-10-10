% % Set up matrices for system of linear equations
% C_roi = roi_tac(2,:)';
% C_ref = reference_tac(2,:)';
% dC_roi = diff(C_roi);
% dC_ref = diff(C_ref);
% 
% % Integrate
% iC_roi = zeros(length(C_roi),1);
% for m=1:length(C_roi)
%     if m==1
%         iC_roi(1,1) = C_roi(1,1);
%     else
%         iC_roi(m,1) = 0.5.*C_roi(m,1) + iC_roi(m-1,1);
%     end
% end
% 
% % Integrate
% iC_ref = zeros(length(C_ref),1);
% for m=1:length(C_ref)
%     if m==1
%         iC_ref(1,1) = C_ref(1,1);
%     else
%         iC_ref(m,1) = 0.5.*C_ref(m,1) + iC_ref(m-1,1);
%     end
% end     
% 
% % Solution via integrated thing
% C = C_roi;
% D = cat(2, C_ref, iC_ref, iC_roi);
% Y = linsolve(C,D);
% 
% C_roi(end,:) = [];
% C_ref(end,:) = [];
% 
% % Solution via derived thing
% A = dC_roi;
% B = cat(2, dC_ref, C_ref, C_roi);
% 
% % Solve for the unknown parameters
% % X(1) = R1
% % X(2) = k2
% % X(3) = (k2/(1+BP)) = k2a
% X = linsolve(A,B);


BP(1) = X(2)./X(3) - 1;
BP(2) = Y(2)./Y(3) - 1;