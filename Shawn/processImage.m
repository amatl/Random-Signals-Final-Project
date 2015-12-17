% Import image
I = imread('../RawImages/Lenna.png');
% Display original
figure(1);
imagesc(I);
title('Original Image');
% Find highest points in DCT
watermarkLength = 1000;
watermarkScale=0.10;
[watermarkedI, watermark]= genApplyWatermark(I,watermarkLength,watermarkScale);
predistortI = watermarkedI;
% Display diff of y
% Different test modes
% 1: adding noise
% 2: swaps corners (breaks, but expected)
% 3: cropped image to small fraction
%     (and reconstructed with unwatermarked image)
% 4: Jpeg compression test
% 5: Scaling down and back up
testMode = 1;
if testMode == 1
    watermarkedI = min(max(watermarkedI+0.05*randn(size(I)),0),1);
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
    imwrite(watermarkedI,'tmp.jpg','Quality',50);
    watermarkedI = imread('tmp.jpg');
elseif testMode == 5
    scalefac = 5.0;
    watermarkedI = min(max(imresize(watermarkedI,1/scalefac),0),1);
    size(watermarkedI)
    watermarkedI = min(max(imresize(watermarkedI,[size(I,1),size(I,2)]),0),1);
    size(watermarkedI)
elseif testMode == 6
    watermarkedI = watermarkedI * 0.5;
elseif testMode == 7
    % Convert to YIQ
    yData = getYComponent(watermarkedI);
    % Calculate DCT
    J = dct2(yData);
    % Generate watermark
    watermarkMal = [watermark(:,1),watermark(:,2),1*ones(size(watermark(:,3)))];
    % Apply watermark
    J = applyWatermark(J,watermarkMal,watermarkScale);
    % Reconstruct image
    watermarkedY = idct2(J);
    watermarkedI = replaceYComponent(watermarkedI,watermarkedY);
elseif testMode == 8
    G = fspecial('gaussian',[15 15],3);
    watermarkedI = imfilter(watermarkedI,G,'same');
elseif testMode == 9
    watermarkedI = replaceYComponent(watermarkedI,min(max(getYComponent(watermarkedI)+0.1*randn(size(I(:,:,1))),0),1));
elseif testMode == 10
    blah = im2bw(watermarkedI,0.5);
    watermarkedI(:,:,1) = blah;
    watermarkedI(:,:,2) = blah;
    watermarkedI(:,:,3) = blah;
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
extWatermarkNorm = extWatermark - mean(extWatermark);
fitnessChecks = 1000;
fitnessPlot = zeros(fitnessChecks,1);
randWatermark = watermark;
checkedWatermark = extWatermark;
for i=1:fitnessChecks
    if i==round(fitnessChecks/2);
        checkedWatermark = extWatermarkNorm;
    end
    if i == 100 || i == fitnessChecks/2 + 100
        randWatermark(:,3) = watermark(:,3);
    else
        randWatermark(:,3) = randn(size(watermark,1),1);
    end
    fitnessPlot(i) = checkWatermark(checkedWatermark,randWatermark);
end
figure(4);
plot(fitnessPlot);
title('Real Watermark (at 100) vs 999 Random Possible Watermarks');
ylabel('Standard Deviations of Confidence');
xlabel('Test Number');
figure(5);
imagesc(log10(abs(dct2(getYComponent(watermarkedI))))*20);
colorbar;
figure(7);
imagesc(abs(dct2(getYComponent(watermarkedI)))-abs(dct2(getYComponent(predistortI))));
colorbar;
figure(6);
%extWatermark = extractWatermark(watermarkedI,I,watermark);
x = 1:length(extWatermark);
plot(x,extWatermark,x,watermark(:,3)*watermarkScale)
ylabel('Signal Level')
xlabel('Sample Number')
title('Extracted Watermark (blue) vs Inserted Watermark (green)')
%blah = checkWatermark(extWatermark,[watermark(:,1) watermark(:,2) -watermark(:,3)])

