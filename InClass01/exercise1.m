% Author: Carlos Rosario
I = imread('mountain.png');
%imshow(I)
%size(I)

% part 1
meanMountainColumn = mean(I);
meanMountainColumn = meanMountainColumn'; % transpose vector

% part 2
darkestCol = find(meanMountainColumn == min(meanMountainColumn));
darkestCol = int16(darkestCol);

% part 3 
flipImage = uint8(I(end: -1: 1,:));

% part 4
halfImage = uint8(I(1:2:end, 1:2:end));

% part 5
myHist = zeros(256,1,'int16'); % Initialize histogram vector with zero's

for row = 1:size(I,1)
    for col = 1: size(I,2)
        pixel = I(row,col);
        myHist(pixel+1) = myHist(pixel+1) + 1; % I had to do pixel+1 to avoid 0 indexing issue.
    end
end