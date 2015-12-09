function [points] = getHighPoints(vals, num)
valWidth = size(vals,2);
valHeight = size(vals,1);
mostPercept = zeros(valWidth*valHeight-1,3);
for i = 1:valHeight
    for j = 1:valWidth
        if i==1 && j==1
            continue
        end
        mostPercept(i*valWidth+j,:) = [abs(vals(i,j)),i,j];
    end
end
points = sortrows(mostPercept,-1);
points = points(1:num,2:3);
end