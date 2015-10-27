function [y] = getYComponent(I)
yiq = rgb2ntsc(I);
y = yiq(:,:,1);
end