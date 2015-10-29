function [y] = getYComponent(I)
% Gets Y component from YIQ color space from RGB input
yiq = rgb2ntsc(I);
y = yiq(:,:,1);
end