input_im = imread('input.png');

% set sigma
sig = 5.0;
Wh = floor( 2.5 * sig - 0.5);

% create kernel
w = zeros(2*Wh+1, 2*Wh+1);
w = rand(2*Wh+1, 2*Wh+1);

% after gaussian, we should see red in the center and blue as it goes
% outward

%-12,-12 -> 1,1
%6,6 - > 12,12
%12,12 -> 25,25
% need to do + Wh + 1

% Creates Gaussian Kernel
for y = -Wh:Wh
    for x = -Wh:Wh
        w(x+Wh+1, y+Wh+1) = exp(-1 * (x^2 + y^2) / (2*sig^2)); 
    end
end


w = w / sum(w(:)); % normalization step

%imagesc(w); colormap jet;

% perform convolution
kernelSize = size(w,1);
[R,C] = size(input_im);
padded_input_im = padarray(input_im, [kernelSize, kernelSize]);
g = zeros(R,C, 'uint8');
runningSum = 0;
for x = 1:R
    for y = 1:C
        for r0 = -Wh:1:Wh
            for c0 = -Wh:1:Wh
                s = r0+Wh+1;
                t = c0+Wh+1;
                runningSum = runningSum + w(s, t) * double(padded_input_im((x+kernelSize) - (s), (y+kernelSize) - (t)));
            end 
        end
        g(x,y) = ceil(runningSum);
        runningSum = 0;
    end
end

imshow(input_im); figure(); imshow(g);