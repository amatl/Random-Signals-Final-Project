function [Iout] = replaceYComponent(I, y)
yiq = rgb2ntsc(I);
yiq(:,:,1) = y;
Iout = ntsc2rgb(yiq);
end