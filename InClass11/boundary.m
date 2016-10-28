im = imread('rice.png');
imshow(im);

% otsu thresholding
thresh = graythresh(im);
imbw = imbinarize(im, thresh);
figure; imshow(imbw);

% do ccl
L = bwlabel(imbw,4);

% filter out small regions
stats = regionprops(L, 'Area', 'PixelIdxList');
cleaned = imbw;
for region = 1 : length(stats)
    if stats(region).Area < 50
        cleaned(stats(region).PixelIdxList) = 0;
    end
end
figure; imshow(cleaned);

% erode image
B = [1 1 1; 1 1 1; 1 1 1];
eroded_im = imerode(cleaned, B);
figure; imshow(eroded_im);

% compute edge image
final_im = cleaned - eroded_im;
figure; imshow(final_im);
 

