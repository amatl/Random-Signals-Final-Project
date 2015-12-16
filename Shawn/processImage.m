% Import image
I = imread('../RawImages/Lenna.png');
% Display original
figure(1);
imagesc(I);
title('Original Image');
% Find highest points in DCT
watermarkLength = 10000;
watermarkScale=0.05;
[watermarkedI, watermark]= genApplyWatermark(I,watermarkLength,watermarkScale);
% Display diff of y
% Different test modes
% 1: adding noise
% 2: swaps corners (breaks, but expected)
% 3: cropped image to small fraction
%     (and reconstructed with unwatermarked image)
% 4: Jpeg compression test
% 5: Scaling down and back up
testMode = 3;
if testMode == 1
    watermarkedI = min(max(watermarkedI+0.2*randn(size(I)),0),1);
elseif testMode == 2
    % Swap corners of image, distroys watermark if not fixed
    watermarkedI(:,:,1) = fftshift(watermarkedI(:,:,1));
    watermarkedI(:,:,2) = fftshift(watermarkedI(:,:,2));
    watermarkedI(:,:,3) = fftshift(watermarkedI(:,:,3));
elseif testMode == 3
    for i = 1:size(I,1)
        for j = 1:size(I,2)
            if i<400 && i>370 && j<400 && j>300
            else
                watermarkedI(i,j,:) = double(I(i,j,:))/255;
            end
        end
    end
elseif testMode == 4
    imwrite(watermarkedI,'tmp.jpg','Quality',4);
    watermarkedI = imread('tmp.jpg');
elseif testMode == 5
    scalefac = 4.5;
    watermarkedI = min(max(imresize(watermarkedI,1/scalefac),0),1);
    size(watermarkedI)
    watermarkedI = min(max(imresize(watermarkedI,[size(I,1),size(I,2)]),0),1);
    size(watermarkedI)
end
watermarkedI = uint8(round(watermarkedI*255));
% Display diff of y
figure(2);
imagesc(getYComponent(watermarkedI) - getYComponent(I));
title('Difference between grayscale watermarked and original images');
colorbar;
% Display modified
figure(3);
imagesc(watermarkedI);
title('Watermarked Image');

% Check watermark against a variety of generated ones
extWatermark = extractWatermark(I,watermarkedI,watermark);
%extWatermark = extWatermark - mean(extWatermark);
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
title('Real Watermark (at 100) vs 999 Random Possible Watermarks');
ylabel('Standard Deviations of Confidence');
xlabel('Test Number');
figure(5);
imagesc(log10(abs(dct2(getYComponent(watermarkedI))))*20);
colorbar;
figure(6);
%extWatermark = extractWatermark(watermarkedI,I,watermark);
x = 1:length(extWatermark);
plot(x,extWatermark,x,-watermark(:,3)*watermarkScale)
ylabel('Signal Level')
xlabel('Sample Number')
title('Extracted Watermark (blue) vs Inserted Watermark (green)')
%blah = checkWatermark(extWatermark,[watermark(:,1) watermark(:,2) -watermark(:,3)])

