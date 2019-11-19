function [numIntegrand] = integral_num(x,y,beta,X_raw,Y_raw,dxdk,dydk,S)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
        
    fun =@(x,y,beta,X_raw,Y_raw,dxdk,dydk,s)...
        ((x-(X_raw - sin(beta) * s)) * dxdk +...
        (y - (Y_raw + cos(beta) * s)) * dydk)./...
        ((x - (X_raw - sin(beta) * s)).^2 +...
        (y - (Y_raw + cos(beta) * s)).^2);
    
    numIntegrand = integral(@(s)fun(x,y,beta,X_raw,Y_raw,dxdk,dydk,s),0,S);
    
end

