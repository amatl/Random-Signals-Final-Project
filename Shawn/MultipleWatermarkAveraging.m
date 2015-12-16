I = imread('../RawImages/Lenna.png');
% Find highest points in DCT
watermarkLength = 1000;
watermarkScale=0.05;

[watermarkedI, watermark]= genApplyWatermark(I,watermarkLength,watermarkScale);

numWatermarkings = 20;
watermarks = zeros([size(watermark) numWatermarkings]);
insWatermarks = [];
imageSum = zeros(size(I));
sequentialStr = [];
for i=1:numWatermarkings
    [imageLoc, watermarks(:,:,i)]= genApplyWatermark(I,watermarkLength,watermarkScale);
    imageLoc = double(uint8(round(imageLoc*255)));
    imageSum = imageSum + imageLoc;
    imageMixed =  uint8(round(double(imageSum/i)));
    tmp = extractWatermark(I,imageMixed,watermarks(:,:,1));
    sequentialStr(i) = checkWatermark(tmp,watermarks(:,:,1));
end
figure(3)
plot(sequentialStr)
imageMixed =  uint8(round(double(imageSum/numWatermarkings)));
wmStrength = [];
for i=1:numWatermarkings
    tmp = extractWatermark(I,imageMixed,watermarks(:,:,i));
    wmStrength(i) = checkWatermark(tmp,watermarks(:,:,i));
end
figure(1)
plot(wmStrength)
title('Strength of Multiple Simultaneous Watermarks');
ylabel('Standard Deviations of Confidence');
xlabel('Watermark Number');
figure(2)
imagesc(imageMixed)