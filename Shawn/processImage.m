% Import image
I = imread('../RawImages/Lenna.png');
% Display original
figure(1);
image(I);
% Convert to YIQ
yiq = rgb2ntsc(I);
yData = yiq(:,:,1);
% Calculate DCT
J = dct2(yData);
% Find most highest points in DCT
jWidth = size(J,2);
jHeight = size(J,1);
mostPercept = zeros(jWidth*jHeight,3);
for i = 1:jWidth
    for j = 1:jHeight
        mostPercept(i*jHeight+j,:) = [abs(J(i,j)),i,j];
    end
end
mostPercept = sortrows(mostPercept,-1);
% Generate watermark on the most perceptive
watermarkLength = 1000;
watermark = zeros(jHeight,jWidth);
watermarkX = randn(watermarkLength,1);
watermarkScale = 0.1;
for i=1:watermarkLength
    loc = mostPercept(i+1,:);
    watermark(loc(2),loc(3)) = watermarkX(i);
end
% Apply watermark
J = J.*exp(watermarkScale*watermark);
% Reconstruct
yiq2 = yiq;
yiq2(:,:,1)=idct2(J);
% Display diff
yDiff = yiq2(:,:,1) - yiq(:,:,1);
figure(2);
imagesc(yDiff);
colorbar;
% Display modified
figure(3);
imagesc(ntsc2rgb(yiq2));
