%author: Carlos Rosario
N = 10;

pepperImage = imread('peppers.jpg');
imshow(pepperImage);

%convert from rgb to hsv and assign to a new variable
hsvPepperImage = rgb2hsv(pepperImage);

%get user input N times for each pepper color
userSelectedHueValues = zeros(4,N);
pepper_colors = {' red', ' green', ' yellow', ' orange'};
for colorIndex = 1:size(pepper_colors,2)
    title(strcat('Select', pepper_colors(colorIndex), ' color'));
    [x,y] = ginput(N);
    
    %get corresponding hue value given (x,y) coordinates and save in
    %'userSelectedHueValues' matrix
    for j = 1:N
        userSelectedHueValues(colorIndex,j) = hsvPepperImage(round(y(j)), round(x(j)), 1); 
    end
end

%compute mean hue value for each pepper color
meanHueValues = zeros(4,1);
meanHueValues(1) = mean(userSelectedHueValues(1,:));
meanHueValues(2) = mean(userSelectedHueValues(2,:));
meanHueValues(3) = mean(userSelectedHueValues(3,:));
meanHueValues(4) = mean(userSelectedHueValues(4,:));

%calculate hue range for each pepper color
meanHueValues = sort(meanHueValues); % after sorting, the order of color ranges will be red, orange, yellow, green.. just like how they would be on a hue sphere.
hueRanges = zeros(4,2);
hueRanges(1,2) = (meanHueValues(1) + meanHueValues(2))/2; %set the first range up manually, so that the for loop is simplified.
for index = 2:4
    hueRanges(index,1) = hueRanges(index-1,2);
    if index == 4
        hueRanges(index,2) = meanHueValues(index);
    else
        hueRanges(index,2) = (meanHueValues(index) + meanHueValues(index+1))/2.0;
    end
end

% Classify each pixel as one of the pepper colors using the hue range
% created above. Let 0 = red, 1 = orange, 2 = yellow, 3 = green
pixelToPepperColorMap = zeros(255, 725);

for row = 1:size(hsvPepperImage,1)
    for col = 1: size(hsvPepperImage,2)
        hueValue = hsvPepperImage(row,col,1);
        
        if hueValue >= hueRanges(1,1) && hueValue <= hueRanges(1,2)
            pixelToPepperColorMap(row,col) = 0;
        elseif hueValue > hueRanges(2,1) && hueValue <= hueRanges(2,2)
            pixelToPepperColorMap(row,col) = 1;
        elseif hueValue > hueRanges(3,1) && hueValue <= hueRanges(3,2)
            pixelToPepperColorMap(row,col) = 2;
        elseif hueValue > hueRanges(4,1)
            pixelToPepperColorMap(row,col) = 3;
%         else
%             hueValue
%             pixelToPepperColorMap(row,col) = -99;
        end
    end
end

%Create segmentation output

%Create classification map 'RGBValuesPerPixel' for each pixel. I.E. Pixel at (1,1) is red,
%Pixel at (120, 240) is yellow, etc, etc.
RGBValuesPerPixel = zeros(4,3,'uint32');
redCount = 0;
orangeCount = 0;
yellowCount = 0;
greenCount = 0;
for row = 1:size(pepperImage,1)
    for col = 1: size(pepperImage,2)
        
        if pixelToPepperColorMap(row,col) == 0 %"red" pixel
           redCount = redCount + 1;
           RGBValuesPerPixel(1,1) = RGBValuesPerPixel(1,1) + uint32(pepperImage(row,col,1));
           RGBValuesPerPixel(1,2) = RGBValuesPerPixel(1,2) + uint32(pepperImage(row,col,2));
           RGBValuesPerPixel(1,3) = RGBValuesPerPixel(1,3) + uint32(pepperImage(row,col,3));
           
        elseif pixelToPepperColorMap(row,col) == 1 %"orange" pixel
            orangeCount = orangeCount + 1;
            RGBValuesPerPixel(2,1) = RGBValuesPerPixel(2,1) + uint32(pepperImage(row,col,1));
            RGBValuesPerPixel(2,2) = RGBValuesPerPixel(2,2) + uint32(pepperImage(row,col,2));
            RGBValuesPerPixel(2,3) = RGBValuesPerPixel(2,3) + uint32(pepperImage(row,col,3));
    
        elseif pixelToPepperColorMap(row,col) == 2 %"yellow" pixel
            yellowCount = yellowCount + 1;
            RGBValuesPerPixel(3,1) = RGBValuesPerPixel(3,1) + uint32(pepperImage(row,col,1));
            RGBValuesPerPixel(3,2) = RGBValuesPerPixel(3,2) + uint32(pepperImage(row,col,2));
            RGBValuesPerPixel(3,3) = RGBValuesPerPixel(3,3) + uint32(pepperImage(row,col,3));
            
        elseif pixelToPepperColorMap(row,col) == 3 %"green" pixel
            greenCount = greenCount + 1;
            RGBValuesPerPixel(4,1) = RGBValuesPerPixel(4,1) + uint32(pepperImage(row,col,1));
            RGBValuesPerPixel(4,2) = RGBValuesPerPixel(4,2) + uint32(pepperImage(row,col,2));
            RGBValuesPerPixel(4,3) = RGBValuesPerPixel(4,3) + uint32(pepperImage(row,col,3));
        end
    end
end

%Now that i have the classification map, go ahead and compute the RGB
%averages for each pepper color
RGBAveragesForEachPepperColor = zeros(4,3,'uint8');
RGBAveragesForEachPepperColor(1,1) = RGBValuesPerPixel(1,1)/redCount; %Red Average for Red Pepper
RGBAveragesForEachPepperColor(1,2) = RGBValuesPerPixel(1,2)/redCount; %Green Average for Red Pepper
RGBAveragesForEachPepperColor(1,3) = RGBValuesPerPixel(1,3)/redCount; %Blue Average for Red Pepper

RGBAveragesForEachPepperColor(2,1) = RGBValuesPerPixel(2,1)/orangeCount; %Red average for orange pepper
RGBAveragesForEachPepperColor(2,2) = RGBValuesPerPixel(2,2)/orangeCount; %Green Average for orange pepper
RGBAveragesForEachPepperColor(2,3) = RGBValuesPerPixel(2,3)/orangeCount; %Blue Average for orange pepper

RGBAveragesForEachPepperColor(3,1) = RGBValuesPerPixel(3,1)/yellowCount; %Red average for yellow pepper
RGBAveragesForEachPepperColor(3,2) = RGBValuesPerPixel(3,2)/yellowCount; %Green average for yellow pepper
RGBAveragesForEachPepperColor(3,3) = RGBValuesPerPixel(3,3)/yellowCount; %Blue average for yellow pepper

RGBAveragesForEachPepperColor(4,1) = RGBValuesPerPixel(4,1)/greenCount; %Red average for green pepper
RGBAveragesForEachPepperColor(4,2) = RGBValuesPerPixel(4,2)/greenCount; %Green average for green pepper
RGBAveragesForEachPepperColor(4,3) = RGBValuesPerPixel(4,3)/greenCount; %Blue average for green pepper

%Now 'flatten' the colors in the RGB image
for row = 1:size(pepperImage,1)
    for col = 1: size(pepperImage,2)
        
        if pixelToPepperColorMap(row,col) == 0 %"red" pixel
            pepperImage(row,col,1) = RGBAveragesForEachPepperColor(1,1);
            pepperImage(row,col,2) = RGBAveragesForEachPepperColor(1,2);
            pepperImage(row,col,3) = RGBAveragesForEachPepperColor(1,3);
        elseif pixelToPepperColorMap(row,col) == 1 %"orange" pixel
            pepperImage(row,col,1) = RGBAveragesForEachPepperColor(2,1);
            pepperImage(row,col,2) = RGBAveragesForEachPepperColor(2,2);
            pepperImage(row,col,3) = RGBAveragesForEachPepperColor(2,3);
        elseif pixelToPepperColorMap(row,col) == 2 %"yellow" pixel
            pepperImage(row,col,1) = RGBAveragesForEachPepperColor(3,1);
            pepperImage(row,col,2) = RGBAveragesForEachPepperColor(3,2);
            pepperImage(row,col,3) = RGBAveragesForEachPepperColor(3,3);      
        elseif pixelToPepperColorMap(row,col) == 3 %"green" pixel
           pepperImage(row,col,1) = RGBAveragesForEachPepperColor(4,1);
           pepperImage(row,col,2) = RGBAveragesForEachPepperColor(4,2);
           pepperImage(row,col,3) = RGBAveragesForEachPepperColor(4,3);
        end
    end
end

%Show segmented output
figure();
imshow(pepperImage);

