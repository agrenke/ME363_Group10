function [B] = vortexContNormal(panels)
%VORTEXCONTNORMAL builds vortex contribution matrix

B = zeros([size(panels,2),size(panels,2)]);

for i = 1:size(panels,2)
    disp(['vortex Panel = ',num2str(i)])
    for j = 1:size(panels,2)
        if(ne(i,j))
            B(i,j) = (-0.5 / pi()) * Integral(panels(i).xc,panels(i).yc,panels(j),sin(panels(i).beta),-cos(panels(i).beta));
        end
        if(i==j)
           B(i,j) = 0; 
        end
    end
end

end
