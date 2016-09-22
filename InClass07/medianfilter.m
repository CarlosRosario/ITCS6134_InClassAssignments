input_im = imread('salt-pep.png');

windowSize = 3; % set window size
halfWidth = floor(windowSize/2);
[R,C] = size(input_im);
padded_input_im = padarray(input_im, [windowSize, windowSize]);
g = zeros(R,C, 'uint8');

for x = 1:R
    for y = 1:C
        window = padded_input_im(x+windowSize-halfWidth:x+windowSize+halfWidth, y+windowSize-halfWidth:y+windowSize+halfWidth);
        window = window(:);
        window = sort(window);
        median_val = window(ceil(end/2));
        g(x,y) = median_val;
    end
end

imshow(g);

% Create time plot - I commented out this code but, you can uncomment it,
% run it, and it will produce the time plot
% W = 3:21:101;
% d = zeros(1,5, 'double');
% for i=1:size(W,2)
%     
%     windowSize = W(i); % set window size
%     halfWidth = floor(windowSize/2);
%     padded_input_im = padarray(input_im, [windowSize, windowSize]);
%     g = zeros(R,C, 'uint8');
%     
%     tic;
%     for x = 1:R
%         for y = 1:C
%             tstart = tic;
%             window = padded_input_im(x+windowSize-halfWidth:x+windowSize+halfWidth, y+windowSize-halfWidth:y+windowSize+halfWidth);
%             window = window(:);
%             window = sort(window);
%             median_val = window(ceil(end/2));
%             g(x,y) = median_val;
%             
%             telapsed = toc(tstart);
%             d(i) = telapsed;
%         end
%     end
% end
% 
% plot(W,d,'-ro');






