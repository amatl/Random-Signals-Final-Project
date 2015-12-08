watermark = xlsread('watermark.xls');
[WatermarkedI,map] = imread('pictureOfWatermarkedImage.jpg');
OriginalI = imread('Image2.jpg');
x = size(OriginalI);
extWatermark = extractWatermark(OriginalI, WatermarkedI, watermark);
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