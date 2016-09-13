% Author: Carlos Rosario
original = imread('cameraman.png');
% imshow(original);

%1st corrupt image - inverse
corrupt1 = imread('corrupt1.png');
corrupt1test = 255 - corrupt1;
%imshow(corrupt1test);
sumofsquaredifference1 = sum(sum((corrupt1test-original).^2));

%2nd corrupt image - add +100
corrupt2 = imread('corrupt2.png');
%imshow(corrupt2);
corrupt2test = corrupt2 - 100;
%figure; imshow(corrupt2test);
sumofsquaredifference2 = sum(sum((corrupt2test-original).^2));

%3rd corrupt image - contrast stretch
corrupt3 = imread('corrupt3.png');
%imshow(corrupt3);
gmin = double(min(original(:)));
gmax = double(max(original(:)));
factor = 255/(gmax-gmin);
corrupt3test = factor .* (original - gmin);
% imshow(corrupt3test);
sumofsquaredifference3 = sum(sum((corrupt3test-corrupt3).^2));

%4th corrupt image - log
corrupt4 = imread('corrupt4.png');
c256 = log(256);
corrupt4test = uint8 (255 / c256 * log ( double(original) + 1));
sumofsquaredifference4 = sum(sum((corrupt4test-corrupt4).^2));







