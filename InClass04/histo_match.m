%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Histogram Equalization          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input_im = imread('input.jpg');

% Get histogram of input image
input_im_hist = imhist(input_im);

% Create probability density function by normalizing histogram (dividing by
% total # of pixels)
input_im_pdf = input_im_hist / numel(input_im);

% Create cumulative distribution function
input_im_cdf = cumsum(input_im_pdf);

% Use the computed CDF as a transformation function
output_im_after_equalization = input_im_cdf(input_im + 1);

% Get histogram of output image
output_im_after_equalization_hist = imhist(output_im_after_equalization);

% Create probability density function by normalizing histogram for output image
output_im_after_equalization_pdf = output_im_after_equalization_hist / numel(output_im_after_equalization);

% Create cumulative distribution function for output image
output_im_after_equalization_cdf = cumsum(output_im_after_equalization_pdf);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Histogram Matching              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ref_im = imread('ref.jpg');

% Get histogram of reference image
ref_hist = imhist(ref_im);

% Get pdf of histogram for reference image
ref_hist_pdf = ref_hist / numel(ref_im);

% Get cdf of reference image
ref_cdf = cumsum(ref_hist_pdf);

% Create transformation function based on input cdf and reference cdf
for i = 1:256
   ci = input_im_cdf(i);
   
   for j = 1:256
     if(ref_cdf(j) >= ci)
        T(i) = j;
        match_found = true;
        break;
     end
   end
   
   if(match_found == false)
       T(i) = 255;
   end
end

% Create matched image
matched = uint8(T(input_im + 1));
matched_hist = imhist(matched);
matched_pdf = matched_hist / numel(matched);
matched_cdf = cumsum(matched_pdf);