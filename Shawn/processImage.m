% Import image
I = imread('../RawImages/Lenna.png');
% Display original
figure(1);
image(I);
% Find most highest points in DCT
watermarkLength = 1000;
watermarkScale=0.025;
[watermarkedI, watermark]= genApplyWatermark(I,watermarkLength,watermarkScale);
% Display diff of y
figure(2);
imagesc(getYComponent(watermarkedI) - getYComponent(I));
colorbar;
% Display modified
figure(3);
imagesc(watermarkedI);

% Check watermark against a variety of generated ones
extWatermark = extractWatermark(I,watermarkedI,watermark);
fitnessChecks = 1000;
fitnessPlot = zeros(fitnessChecks,1);
randWatermark = watermark;
for i=1:fitnessChecks
    if i == 100
        randWatermark(:,3) = watermark(:,3);
    else
        randWatermark(:,3) = randn(size(watermark,1),1);
    end
    fitnessPlot(i) = checkWatermark(extWatermark,randWatermark);
end
figure(4);
plot(fitnessPlot);
