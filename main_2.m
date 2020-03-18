clear all;
format long;
% Main function to extra features from cell image
%
% | Version | Author | Date     | Commit
% | 0.1     | ZhouXY | 20.02.12 | The init version
% TODO: put the parameters outside function but main function
%test version is used for testing center fitting in time series
%Method Ref: Label-free tracking of single organelle transportation in cells with nanometer precision using a plasmonic imaging technique

tic;
% Parameters
%C:\Users\xzhou145\Desktop\spot
%C:\Users\xzhou145\Desktop\ASU\Lab\DivisionTrack\TestFigure4\
source_path = 'C:\Users\ZXY\Desktop\ASU\Lab\DivisionTrack\test2\TestFigure\';
result_path ='C:\Users\xzhou145\Desktop\ASU\Lab\DivisionTrack\TestResult\';
%200, 10, 600
thresh = 200;
small = 10;
big = 250;
%'Centroid' or '2DGaussian'
CenterType = '2DGaussian'; 

ROIside = 14;
%(220, 190) (350, 305) (100,160) (260, 230) (538,595), (669, 464) (541, 598)
ROIxs = 21;
ROIys = 21;

imges = dir([source_path '*.tif']);
imge_num = length(imges);
CenterLocations = cell(imge_num,1);
leng = imge_num;

%use parfor later
imgxy = [0 0];
CIs_x = [0 0];
CIs_y = [0 0];
mean_intensity = zeros(1,leng);
for i = 1:1
    i
    img = imread([imges(i).folder '/' imges(i).name]);
%     img = img(ROIys:ROIys + ROIside-1,ROIxs:ROIxs + ROIside-1);
%     mean_intensity(i) = mean(img(:));
% %     normalization
%     img = double(img);
%     img_max = max(img(:))
%     img_min = min(img(:))
%     img = (img-img_min)/(img_max-img_min)
    [imgx, imgy, Confidenece_Interval, imgbwthresh, imgremoved, test_para]...
        = IdentifySpots(img,thresh,small,big, CenterType);
    
    new_imgxy = cat(2,imgx',imgy');
    imgxy = cat(1,new_imgxy,imgxy);
    
%     CI_x = Confidenece_Interval(:,:,1);
%     CI_y = Confidenece_Interval(:,:,2);
%     CIs_x = cat(1, CIs_x, CI_x);
%     CIs_y = cat(1, CIs_y, CI_y);
%     imwrite(imgbwthresh, [result_path 'Thresh'  '.png']);
%     imwrite(imgremoved, [result_path 'Remove' '.png']);
    
%     figure(i)
%     mesh(img)
%     hold on
%     plot(imgx, imgy,'r*')
end

imgxy(end,:) = [];%remove [0 0] at the end
CIs_x(1,:) = [];
CIs_y(1,:) = [];
figure(3)
mesh(img)
hold on
plot(imgx, imgy,'g*')

% 
% 
% testx =Confidenece_Interval(:,:,1);
% testy = Confidenece_Interval(:,:,2);
% % img_sig = img(ROIys:ROIys + ROIside-1,ROIxs:ROIxs + ROIside-1);
% % figure(3)
% % surfc(img_sig)
% % hold on
% % plot(imgx, imgy,'r*')
% % figure(4)
% % mesh(img_sig)
% % hold on
% % plot(imgx, imgy,'r*')
% toc;











