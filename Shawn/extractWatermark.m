function [extWatermark] = extractWatermark(Iorig,Icandidate,watermark)
Jorig = dct2(getYComponent(Iorig));
Jcandidate = dct2(getYComponent(Icandidate));

%The following is a resize for a cropped image added by Aimee, may need to
%be modified to zero padding
if(~isequal(size(Jorig),size(Jcandidate)))
    Jcandidate = imresize(Jcandidate,size(Jorig));
end

Jdiff = real(log(Jcandidate))-real(log(Jorig));
watermarkLength = size(watermark,1);
extWatermark = zeros(watermarkLength,1);
for i=1:watermarkLength
    val = watermark(i,:);
    extWatermark(i) = Jdiff(val(1),val(2));
end
end