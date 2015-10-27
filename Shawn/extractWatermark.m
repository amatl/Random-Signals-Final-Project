function [extWatermark] = extractWatermark(Iorig,Icandidate,watermark)
Jorig = dct2(getYComponent(Iorig));
Jcandidate = dct2(getYComponent(Icandidate));
Jdiff = real(log(Jcandidate))-real(log(Jorig));
watermarkLength = size(watermark,1);
extWatermark = zeros(watermarkLength,1);
for i=1:watermarkLength
    val = watermark(i,:);
    extWatermark(i) = Jdiff(val(1),val(2));
end
end