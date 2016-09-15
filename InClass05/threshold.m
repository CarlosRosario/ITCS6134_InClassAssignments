%Otsu's method
input1_im = imread('input2.png');
%input1_im = imread('input2.png');

variance = zeros(256,1);
for T = 0:255
   input1_im_treshold = input1_im>= T; %applies treshold and creates binary image
   
   w2 = sum(input1_im_treshold(:)); % # of pixels in > T
   w1 = numel(input1_im) - w2; % # of pixels in < T
   
   mu2 = mean(input1_im(input1_im_treshold));
   mu1 = mean(input1_im(~input1_im_treshold));
   
   %mu1 = sum( w2(:) ) / numel(w2);
   %mu2 = sum( w1(:) ) / numel(w1);
   
   difference_averages = (mu1 - mu2)^2;
   variance(T+1) = w1*w2*difference_averages;
end

% Get treshold value and create treshold image
[~, treshold] = max(variance);
input1_im_treshold = input1_im >= treshold;
%plot(variance);
%title("some title");

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Local T method
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

input2_im = imread('input2.png');
input2_im = input2_im(1:3:end, 1:3:end);
window = 11; 
window_half = floor(window/2);
[R,C] = size(input2_im);

meanIm = zeros(R,C, 'uint8');
for r = window_half + 1 : (R-window_half-1)
    for c = window_half + 1 : (C - window_half -1) 
        meanIm(r,c) = mean (mean(input2_im(r-window_half:r+window_half, c-window_half:c+window_half)));
    end
end

input2_im_local_tresh_K1 = input2_im >= 1*meanIm;
input2_im_local_tresh_Kdot6 = input2_im >= .6*meanIm;
input2_im_local_tresh_K1dot2 = input2_im >= 1.2*meanIm;
