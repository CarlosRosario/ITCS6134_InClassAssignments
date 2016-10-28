f = imread('rice.png');
%imshow(f);

f_bw = imbinarize(f);
figure; imshow(f_bw); title('original image');

%erosion
%s = [0 1 0; 0 1 0; 0 1 0];
s = ones(7,7);
[sr, sc] = size(s);
sr = floor(sr/2);
sc = floor(sc/2);

[R, C] = size(f);

eroded_im = zeros(R,C);
for r = sr+1:(R-sr)
    for c = sc+1:(C-sc)
       
        A = f_bw(r-sr:r+sr, c-sc:c+sc);
        
        % if s is completely inside of A then output 1
        temp = A & s;
        
        if(sum(temp(:)) >= sum(s(:)))
            eroded_im(r,c) = 1;
        end
        
    end
end
figure; imshow(eroded_im); title('eroded image');

% %dilation
%s = [0 1 0; 0 1 0; 0 1 0];
s = ones(7,7);
[sr, sc] = size(s);
sr = floor(sr/2);
sc = floor(sc/2);
dilate_im = zeros(R,C);
for r = sr+1:(R-sr)
    for c = sc+1:(C-sc)
       
       A = f_bw(r-sr:r+sr, c-sc:c+sc);
       
       % if s has any overlap with A, then output 1
       temp = A & s;
       if(sum(temp(:)) >= 1)
          dilate_im(r,c) = 1; 
       end
   end
end
figure; imshow(dilate_im); title('dilated image');