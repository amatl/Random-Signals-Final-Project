function [yDataOut] = getJustWatermark(Iorig,watermark)
%GETJUSTWATERMARK Summary of this function goes here
%   Detailed explanation goes here

Jorig = dct2(getYComponent(Iorig));
watermarkLength = size(watermark,1);
extWatermark = zeros(size(Iorig,1),size(Iorig,2));
for i=1:watermarkLength
    val = watermark(i,:);
    extWatermark(val(1),val(2)) = Jorig(val(1),val(2));
end
yDataOut = idct2(extWatermark);

end

