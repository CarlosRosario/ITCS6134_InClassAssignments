input_im = imread('valve.png');

input_im_gray = rgb2gray(input_im);
input_im_graydb = double(input_im_gray);

sobel_kernel_x = [1 0 -1; 2 0 -2; 1 0 -1] * (1/8);
sobel_kernel_y = [1 2 1; 0 0 0; -1 -2 -1] * (1/8); % can transpose kernel_x i think if you want.

gx = imfilter(input_im_graydb, double(sobel_kernel_x), 'conv');
gy = imfilter(input_im_graydb, double(sobel_kernel_y), 'conv');
gm = sqrt((gx .^2) + (gy .^2));
gradient_angle = atan2(gy,gx);

imshow(gm, []);
figure; imshow(gradient_angle,[]); colormap jet;

%%%%%%%%%%%%NON-MAX SUPRESSION%%%%%%%%%%%%%%%
gmlocal = gm;

[R,C] = size(input_im_gray); 
for r = 2:(R-1)
   for c = 2:(C-1)
       v = gm(r,c);
       angle = gradient_angle(r,c);

       if( (pi/8 <= angle && (3*pi)/8 > angle))
           
           if(v < gm(r-1,c-1) || v < gm(r+1,c+1))
                gmlocal(r,c) = 0;  
           end
           
       elseif( ((3*pi)/8 <= angle && (5*pi)/8 > angle))
           
           if(v < gm(r-1,c) || v < gm(r+1,c))
               gmlocal(r,c) = 0;
           end
           
       elseif( ((5*pi)/8 <= angle && (7*pi)/8 > angle))
           
           if(v < gm(r+1,c-1) || v < gm(r-1,c+1))
               gmlocal(r,c) = 0;
           end
      
       elseif( -pi/8 < angle && angle <= pi/8 )
           
           if(v < gm(r,c-1) || v < gm(r,c+1))
                gmlocal(r,c) = 0;
           end
           
       elseif( (-7*pi)/8 < angle && angle <= -pi/8 )
           
           if(v < gm(r-1,c-1) || v < gm(r+1,c+1))
                gmlocal(r,c) = 0;
           end
           
       elseif( abs(angle) > 7*pi/8 )
           
           if(v < gm(r-1,c) || v < gm(r+1,c))
                gmlocal(r,c) = 0; 
           end
           
       elseif( -pi/8 < angle && angle <= pi/8 )
           
           if(v < gm(r-1,c+1) || v < gm(r,c-1))
                gmlocal(r,c) = 0; 
           end
       end
   end
end

% gx = imfilter(gmlocal, double(sobel_kernel_x), 'conv');
% gy = imfilter(gmlocal, double(sobel_kernel_y), 'conv');
% gm = sqrt((gx .^2) + (gy .^2));
% gradient_angle = atan2(gy,gx);
% 
% figure; imshow(gradient_angle,[]); colormap jet;
% return;
%%%%%%%% Calculate treshold values
input_im_hist = imhist(input_im_gray);

% Create probability density function by normalizing histogram (dividing by
% total # of pixels)
input_im_pdf = input_im_hist / numel(input_im_gray);

% Create cumulative distribution function
input_im_cdf = cumsum(input_im_pdf);

%%%%%%%%%%%%%%HYSTERISIS FUNCTION*************
S_edges = zeros(size(gmlocal,1), size(gmlocal,2));
W_edges = zeros(size(gmlocal,1), size(gmlocal,2));
B_edges = zeros(size(gmlocal,1), size(gmlocal,2));
frontier = java.util.Stack(); % was able to figure this out from stackoverflow.com/questions/4163920/matlab-stack-data-structure
alpha = .09;
beta = .5;

alpha_prime = alpha * .01;

t_high = find(input_im_cdf > alpha_prime,1);
t_low = ceil(t_high * beta);
[R,C] = size(gmlocal);

% strong edge map
% for r = 1:R
%    for c = 1:C
%        g = gmlocal(r,c);
%        if(g >= t_high)
%           S_edges(r,c) = 1;
%        end
%    end
% end

% % % weak edge map
% for r = 1:R
%    for c = 1:C
%        g = gmlocal(r,c);
%        if(g >= t_low)
%           B_edges(r,c) = 1;
%        end
%    end
% end
% 
% figure; imshow(B_edges);


for r = 2:(R-1)
   for c = 2:(C-1)
      g = gmlocal(r,c);
      if(g >= t_high)
          frontier.push([r, c]); % be careful when you pop, i think the answer comes out transposed.
          B_edges(r,c) = 1;
      end
   end
end

figure; imshow(B_edges);

temp_edges = zeros(size(gmlocal,1), size(gmlocal,2));
while ~frontier.isEmpty()
    p = frontier.pop()';
    p_x = p(1,2);
    p_y = p(1,1);
    
    q_x = [p_x - 1, p_x, p_x + 1, p_x - 1, p_x + 1, p_x - 1, p_x, p_x+1];
    q_y = [p_y - 1, p_y - 1, p_y - 1, p_y, p_y, p_y + 1, p_y + 1, p_y+1];
    
    for q = 1:8
        if(q_x(q) > size(gmlocal,1) || q_y(q) > size(gmlocal,2) || q_x(q) <= 1 || q_y(q) <=1)
           continue; 
        end
        g = gmlocal(q_x(q), q_y(q));
         if(g >= t_low)
%              if(B_edges(q_x(q) - 1, q_y(q) - 1) == 1 && ...
%                 B_edges(q_x(q), q_y(q) - 1) == 1 && ...
%                 B_edges(q_x(q) + 1, q_y(q) - 1) == 1 && ...
%                 B_edges(q_x(q) - 1, q_y(q)) == 1 && ...
%                 B_edges(q_x(q) + 1, q_y(q)) == 1 && ...
%                 B_edges(q_x(q) - 1, q_y(q) + 1) == 1 && ...
%                 B_edges(q_x(q), q_y(q) + 1) == 1 && ...
%                 B_edges(q_x(q) + 1, q_y(q) + 1) == 1 ...
%                 )
%                 continue; 
%              else
              
              if(temp_edges(q_x(q), q_y(q)) == 1)
                    continue;
              else    
                frontier.push([q_x(q), q_y(q)]);
                temp_edges(q_x(q), q_y(q)) = 1;
                B_edges(q_x(q),q_y(q)) = 1;  
             end
             %end
         end
    end
end

figure; imshow(B_edges);
%figure; imshow(temp_edges);






