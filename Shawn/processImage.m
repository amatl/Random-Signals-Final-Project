% Import image
I = imread('../RawImages/Lenna.png');
% Display original
figure(1);
image(I);
% Find most highest points in DCT
watermarkLength = 1000;
watermarkScale=0.05;
[watermarkedI watermark]= genApplyWatermark(I,watermarkLength,watermarkScale);
% Display diff of y
figure(2);
imagesc(getYComponent(watermarkedI) - getYComponent(I));
colorbar;
% Display modified
figure(3);
imagesc(watermarkedI);
