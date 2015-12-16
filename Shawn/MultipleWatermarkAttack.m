I = imread('../RawImages/Lenna.png');
% Find highest points in DCT
watermarkLength = 1000;
watermarkScale=0.05;

[watermarkedI, watermark]= genApplyWatermark(I,watermarkLength,watermarkScale);

numWatermarkings = 10;
watermarks = zeros([size(watermark) numWatermarkings]);
tmp = extractWatermark(I,watermarkedI,watermark);
insWatermarks = [checkWatermark(tmp,watermark)];
images = zeros([numWatermarkings size(I)]);
for i=1:numWatermarkings
    images(i,:,:,:) = watermarkedI;
    [watermarkedI, watermarks(:,:,i)]= genApplyWatermark(watermarkedI,watermarkLength,watermarkScale);
    tmp = extractWatermark(I,watermarkedI,watermark);
    insWatermarks(i+1) = [checkWatermark(tmp,watermark)];
end
figure(2)
plot(insWatermarks)
title('Original Watermark Strength After Multiple Watermarkings');
ylabel('Standard Deviations of Confidence');
xlabel('Number of Watermarks');
tmp = extractWatermark(I,watermarkedI,watermark);
extWatermark = [checkWatermark(tmp,watermark)];
for i=1:numWatermarkings
    locImage = permute(images(i,:,:,:),[2 3 4 1]);
    tmp = extractWatermark(locImage,watermarkedI,watermarks(:,:,i));
    extWatermark(i+1) = checkWatermark(tmp,watermarks(:,:,i));
end

figure(1)
plot(extWatermark);
title('Strength of Multiple Simultaneous Watermarks');
ylabel('Standard Deviations of Confidence');
xlabel('Watermark Number');
figure(3)
imagesc(watermarkedI)
title(['Image After ' num2str(numWatermarkings+1) ' Watermarkings'])