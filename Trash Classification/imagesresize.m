
%load the new images as an image datastore
imds = imageDatastore('images', ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');

%Divide the data into training and validation data sets
[imdsTrain,imdsValidation,imdsTest] = splitEachLabel(imds,0.7,0.15,'randomized');
%% 

%Export transformed data sets
location = fullfile(pwd,'transformeddata');
temp = transform(imdsTest,@(x) squarecrop(x));
writeall(temp,fullfile(location,'test images'),"FilenamePrefix",'aug_',OutputFormat='jpeg');
temp = transform(imdsTrain,@(x) squarecrop(x));
writeall(temp,fullfile(location,'train images'),"FilenamePrefix",'aug_',OutputFormat='jpeg');
temp = transform(imdsValidation,@(x) squarecrop(x));
writeall(temp,fullfile(location,'validation images'),"FilenamePrefix",'aug_',OutputFormat='jpeg');
%% 

%Export untransformed data sets
location = fullfile(pwd,'untransformeddata');
writeall(imdsTest,fullfile(location,'test images'),"OutputFormat","jpeg");
writeall(imdsValidation,fullfile(location,'validation images'),"OutputFormat","jpeg");
writeall(imdsTrain,fullfile(location,'train images'),"OutputFormat","jpeg");
%% 

function I = squarecrop(I)
minXY = min(size(I,1),size(I,2));
targetSize = [minXY minXY];
win1 = centerCropWindow2d(size(I),targetSize);
I = imcrop(I,win1);
end