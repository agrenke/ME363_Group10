function [A] = sourceContNormal(panels)
%SOURCECONTNORMAL builds source contribution matrix

A = zeros([size(panels,2),size(panels,2)]);

for i = 1:size(panels,2)
    disp(['source Panel = ',num2str(i)])
    for j = 1:size(panels,2)
        if(ne(i,j))
            A(i,j) = (0.5 / pi) * Integral(panels(i).xc,panels(i).yc,panels(j),cos(panels(i).beta),sin(panels(i).beta));
        end
        if(i == j)
           A(i,j) = 0.5; 
        end
    end
end

end

