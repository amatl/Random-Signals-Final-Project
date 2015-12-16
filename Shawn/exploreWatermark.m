% Import image
I = imread('../RawImages/Lenna.png');
% Find highest points in DCT
watermarkLength = 1000;
watermarkScale=0.3;
[watermarkedI, watermark]= genApplyWatermark(I,watermarkLength,watermarkScale);
dctVals = dct2(getYComponent(I));
dctWMVals = dct2(getYComponent(watermarkedI));
watermarkIn = zeros(watermarkLength,1);
watermarkOut = watermarkIn;
for i=1:watermarkLength
    watermarkIn(i) = dctVals(watermark(i,1),watermark(i,2));
    watermarkOut(i) = dctWMVals(watermark(i,1),watermark(i,2));
end
x = 1:watermarkLength;
figure(1)
plot(x,abs(watermarkIn),x,abs(watermarkOut),x,watermark(:,3));
title('Watermark signal (red), original carrier DCT values (blue), and output (green)');