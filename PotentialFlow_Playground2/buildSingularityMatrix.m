function [A] = buildSingularityMatrix(A_source,B_vortex)
%BUILDSINGULARITYMATRIX constructs the RH matrix

A = zeros([size(A_source,2)+1,size(A_source,2)+1]);

A(1:end-1,1:end-1)=A_source;

A(1:end-1,end) = sum(B_vortex,2);

A(end,:) = kuttaCondition(A_source,B_vortex);

end

