% Import image
I = imread('../RawImages/Lenna.png');
% Display original
figure(1);
image(I);
% Find most highest points in DCT
watermarkLength = 1000;
watermarkScale=0.05;
[watermarkedI, watermark]= genApplyWatermark(I,watermarkLength,watermarkScale);
% Display diff of y
testMode = 5;
if testMode == 1
    watermarkedI = min(max(watermarkedI+0.10*randn(size(I)),0),1);
elseif testMode == 2
    % Swap corners of image, distroys watermark if not fixed
    watermarkedI(:,:,1) = fftshift(watermarkedI(:,:,1));
    watermarkedI(:,:,2) = fftshift(watermarkedI(:,:,2));
    watermarkedI(:,:,3) = fftshift(watermarkedI(:,:,3));
elseif testMode == 3
    for i = 1:size(I,1)
        for j = 1:size(I,2)
            if i<400 && i>300 && j<400 && j>300
            else
                watermarkedI(i,j,:) = double(I(i,j,:))/255;
            end
        end
    end
elseif testMode == 4
    imwrite(watermarkedI,'tmp.jpg','Quality',7);
    watermarkedI = imread('tmp.jpg');
elseif testMode == 5
    scalefac = 4.1;
    watermarkedI = min(max(imresize(watermarkedI,1/scalefac),0),1);
    size(watermarkedI)
    watermarkedI = min(max(imresize(watermarkedI,[size(I,1),size(I,2)]),0),1);
    size(watermarkedI)
end
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
