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
% Manipulate value for demonstration
vertChange = 5;
horChange = 5;
J(vertChange,horChange) = J(vertChange,horChange)+50;
% Display DCT
figure(2);
imagesc(log(abs(J)));
colorbar;
% Reconstruct
yiq2 = yiq;
yiq = zeros(size(yiq));
yiq(:,:,1)=idct2(J);
% Display modified
figure(3);
imagesc(ntsc2rgb(yiq));
title(['Changed DCT coordinate (' num2str(vertChange) ', ' num2str(horChange) ') [vertical, horizontal]'])