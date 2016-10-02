f = imread('model-t.png');

sobel_kernel_x = [1 0 -1; 2 0 -2; 1 0 -1] * (1/8);
sobel_kernel_y = [1 2 1; 0 0 0; -1 -2 -1] * (1/8);

% check kernel, x direction
sum(sobel_kernel_x(:));

gx = imfilter(double(f), double(sobel_kernel_x)); % vertical edges
%imshow(gx, []); % smallest value to be black, and largest value to white
%colormap jet;

% check kernel, y direction
gy = imfilter(double(f), double(sobel_kernel_y)); % horizontal edges
%imshow(gy, []);
%colormap jet;

% compute gradient magnitude
gm = sqrt((gx .^2) + (gy .^2));
imshow(gm,[]);
%colormap jet;

gradient_angle = atan2(gy,gx); %angles in radian of each gx,gy. I think this shows the change
%imshow(angle,[]);
%colormap jet;

tresh = 10;
binary = zeros(size(f,1), size(f,2));
binary = gm >= tresh;
imshow(binary,[]);
%colormap jet;





