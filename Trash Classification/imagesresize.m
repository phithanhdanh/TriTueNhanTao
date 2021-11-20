
%load the new images as an image datastore
imds = imageDatastore('data/images', ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');

%Divide the data into training and validation data sets
[imdsTrain,imdsTest] = splitEachLabel(imds,0.85,'randomized');

%Export data sets
location = fullfile(pwd,'data');
temp = transform(imdsTest,@(x) squarecrop(x));
writeall(temp,fullfile(location,'test images'),"FilenamePrefix",'aug_',OutputFormat='jpeg');
temp = transform(imdsTrain,@(x) squarecrop(x));
writeall(temp,fullfile(location,'train images'),"FilenamePrefix",'aug_',OutputFormat='jpeg');

function I = squarecrop(I)
minXY = min(size(I,1),size(I,2));
targetSize = [minXY minXY];
win1 = centerCropWindow2d(size(I),targetSize);
I = imcrop(I,win1);
end