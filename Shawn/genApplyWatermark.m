function [Iwatermarked, watermark] = genApplyWatermark(I, watermarkLength, watermarkPower)
% Convert to YIQ
yData = getYComponent(I);
% Calculate DCT
J = dct2(yData);
% Generate watermark
watermark = genWatermark(J,watermarkLength);
% Apply watermark
J = applyWatermark(J,watermark,watermarkPower);
% Reconstruct image
watermarkedY = idct2(J);
Iwatermarked = replaceYComponent(I,watermarkedY);
end