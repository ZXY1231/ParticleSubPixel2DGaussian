
function [imgx, imgy, Confidence_Interval, img_thresh, img_removed,test_para] = IdentifySpots(img_soure, thresh, small, big, CenterType)
format long;
% Extract worm location from normalized image
% | Version | Author | Date     | Commit
% | 0.1     | ZhouXY | 18.07.19 | The init version
% | 0.2     | H.F.   | 18.09.05 |
% To Do: Binarize image with locally adaptive thresholding or only take
% threshold but keep graydrade

% Choose the threshold of image

img_thresh = imbinarize(img_soure,thresh);%previous use 0.2

img_thresh = ones(size(img_soure));
% Choose the reasonable area to find out worm
img_removed = bwareaopen(img_thresh,small);   %remove regions < small# pixels
% img_removed = RemoveBigArea(imgremovesmall,big);%remove regions >big# pixels

% Find connected components in binary image
CC = bwconncomp(img_removed,6); % should use 8 connected for 2d image
test_para = CC;

% Due to cellfun limit, size of img must be a cell form, all inout arguments must be cell form  
s = size(img_removed);
SizeCell = cell(1,numel(CC.PixelIdxList));
SizeCell(1:end) = {s};
CenterTypeCell = cell(1,numel(CC.PixelIdxList));
CenterTypeCell(1:end) = {CenterType};
ImgCell = cell(1,numel(CC.PixelIdxList));
ImgCell(1:end) = {img_soure};

% Find out the centre of worm
center = cellfun(@LocateSpotCentre, CC.PixelIdxList, SizeCell, CenterTypeCell, ImgCell);

% need to be shortened
center = cell2mat(center);
center = real(center);
test_para = center;
size(center)
x = center(1:6:end);
y = center(2:6:end);

CI_x1 = center(3:6:end);
CI_x2 = center(4:6:end);
CI_y1 = center(5:6:end);
CI_y2 = center(6:6:end);
notnan = ~isnan(CI_x1);
x = x(notnan);
y = y(notnan);
CI_x1 = CI_x1(notnan);
CI_x2 = CI_x2(notnan);
CI_y1 = CI_y1(notnan);
CI_y2 = CI_y2(notnan);

Confidence_Interval = zeros(length(CI_x1),2,2);
Confidence_Interval(:,:,1) = cat(2,CI_x1',CI_x2');
Confidence_Interval(:,:,2) = cat(2,CI_y1',CI_y2');

imgx = y;
imgy = x;
%imgy = s(2)-imgy; % What is mean? invert the image 
