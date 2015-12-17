
I = imread('../RawImages/Lenna.png');
% Find highest points in DCT
watermarkLength = 1000;
watermarkScale=0.05;
[watermarkedI, watermark]= genApplyWatermark(I,watermarkLength,watermarkScale);
noiseEffect = [];
noiseEffectMean = [];
x = 0:99;
for i=x
    noiseWMI = min(max(watermarkedI+0.01*i*randn(size(I)),0),1);
    extWatermark = extractWatermark(I,noiseWMI,watermark);
    extWatermarkNorm = extWatermark - mean(extWatermark);
    noiseEffect(i+1) = checkWatermark(extWatermark,watermark);
    noiseEffectMean(i+1) = checkWatermark(extWatermarkNorm,watermark);
end
figure(1);
plot(x*0.01,noiseEffect,x*0.01,noiseEffectMean);
xlabel('Noise Amplitude');
ylabel('Standard Deviations of Confidence');
title('Effect of noise on watermark integrity');
figure(2);
noiseWMI = min(max(watermarkedI+0.01*80*randn(size(I)),0),1);
extWatermark = extractWatermark(I,noiseWMI,watermark);
displayedConfidence = checkWatermark(extWatermark,watermark)
imagesc(noiseWMI)
title(['Image with 0.2 Amplitude Noise Added. Confidence of ' num2str(displayedConfidence)]);