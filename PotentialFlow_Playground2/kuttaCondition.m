function [b] = kuttaCondition(A_source,B_vortex)
%KUTTACONDITION Builds the Kutta condition array

b = zeros([size(A_source,1)+1,1]);
b(1:end-1) = B_vortex(1,:) + B_vortex(end,:);
b(end) = -sum(A_source(1,:)+A_source(end,:));

% b = zeros([size(A_source,1)+1,1]);
% b(1:end-1) = B_vortex(1,:) + B_vortex(end,:);
% b(end) = -sum(A_source(1,:)+A_source(end,:));

%     b = numpy.empty(A_source.shape[0] + 1, dtype=float)
%     # matrix of source contribution on tangential velocity
%     # is the same than
%     # matrix of vortex contribution on normal velocity
%     b[:-1] = B_vortex[0, :] + B_vortex[-1, :]
%     # matrix of vortex contribution on tangential velocity
%     # is the opposite of
%     # matrix of source contribution on normal velocity
%     b[-1] = - numpy.sum(A_source[0, :] + A_source[-1, :])

end
