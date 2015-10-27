% Import image
I = imread('../RawImages/Lenna.png');
% Display original
figure(1);
image(I);
% Convert to YIQ
yData = getYComponent(I);
% Calculate DCT
J = dct2(yData);
% Find most highest points in DCT
watermarkLength = 1000;
watermarkScale=0.05;
J = genApplyWatermark(J,watermarkLength,watermarkScale);
% Reconstruct
watermarkedY = idct2(J);
watermarkedI = replaceYComponent(I,watermarkedY);
% Display diff of y
figure(2);
imagesc(watermarkedY - yData);
colorbar;
% Display modified
figure(3);
imagesc(watermarkedI);
