input_im = imread('rice.png');
imshow(input_im);
input_im_bw = imbinarize(input_im);
figure; imshow(input_im_bw);

[R, C] = size(input_im_bw);
label_matrix = zeros(R, C, 'uint16');
L = 1;
e = (1:(R*C));

count = 1;
minAndMaxLabels = zeros((R*C),2);
for r = 1:R
   for c = 1:C
        pixel = input_im_bw(r,c);
        
        if( pixel == true )
            
            if(r == 1)
                topLabel = label_matrix(r+1,c);
                topPixel = 0;
            else
                topLabel = label_matrix(r-1,c);
                topPixel = input_im_bw(r-1,c);
            end
            if(c == 1)
                leftLabel = label_matrix(r,c+1);
                leftPixel = 0;
            else
                leftLabel = label_matrix(r,c-1);
                leftPixel = input_im_bw(r,c-1);
            end

            if(topPixel == true && leftPixel == true)
                
                if(topLabel ~= leftLabel)
                    minLabel = min(topLabel, leftLabel);
                    maxLabel = max(topLabel, leftLabel);
                    label_matrix(r,c) = minLabel;
                    
                    minAndMaxLabels(count,1) = minLabel;
                    minAndMaxLabels(count,2) = maxLabel;
                    count = count + 1;
                else
                    label_matrix(r,c) = topLabel; % top and left are the same so just choose one
                end
                
            elseif(topPixel == true || leftPixel == true)
            
                if(topPixel == true)
                    label_matrix(r,c) = topLabel;
                else
                    label_matrix(r,c) = leftLabel;
                end
            elseif(topPixel == false && leftPixel == false)
                label_matrix(r,c) = L;
                L = L + 1;
            end
        end
    end
 end

%% apply equivalence-ness
for r = 1:R
    for c = 1:C
       pixel = label_matrix(r,c);
       if(pixel ~= 0)
         
            newLabel = pixel;
            while(~isempty(newLabel))
                indices = find(minAndMaxLabels(:,2) == newLabel);
                prevNewLabel = newLabel;
                newLabel = min(minAndMaxLabels(indices,1));
                
            end
            
            if(~isempty(prevNewLabel))
               label_matrix(r,c) = prevNewLabel; 
            end
       end
    end
end

figure; imshow(label_matrix, []);
cmap = rand(660,3);
figure;
RGB = label2rgb(label_matrix, cmap, 'k', 'shuffle'); % i couldn't get professor shins example for showing colored grains of rice, so i use this instead
imshow(RGB);


%% apply tresholding
size_treshold = 5;
different_labels = unique(label_matrix);
for i=1:size(different_labels,1) 
   sizeOfRice = sum(label_matrix == different_labels(i) );
   if(sizeOfRice < size_treshold)
       label_matrix( label_matrix == different_labels(i) ) = 0;
   end
end

figure;
RGB = label2rgb(label_matrix, cmap, 'k', 'shuffle');
imshow(RGB);

%% Get total count of rice grains
grainsOfRice = unique(label_matrix);
totalGrains = size(grainsOfRice,1);