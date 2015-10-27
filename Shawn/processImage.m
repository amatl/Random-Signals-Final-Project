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
watermarkVals = [getHighPoints(J,watermarkLength) randn(watermarkLength)];
% Generate watermark on the most perceptive
watermark = zeros(jHeight,jWidth);
for val = watermarkVals'
    watermark(val(1),val(2)) = val(3);
end
% Apply watermark
J = J.*exp(watermarkScale*watermark);
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
