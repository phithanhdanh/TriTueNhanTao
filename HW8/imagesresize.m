% Get list of all BMP files in this directory
% DIR returns as a structure array.  You will need to use () and . to get
% the file names.
ratio = 0.1;
OutputSize = [227 227];
CompressSize = [OutputSize(1) floor(OutputSize(2)*ratio)];
PatchSize = [OutputSize(1) OutputSize(2)-CompressSize(2)];
imagefiles = [dir('*.jpg') dir('*.webp')];      
nfiles = length(imagefiles);    % Number of files found
for ii=1:nfiles
   currentfilename = imagefiles(ii).name;
   currentimage = imread(currentfilename);
   %images{ii} = currentimage;
   
   minXY = min(size(currentimage,1),size(currentimage,2));
   targetSize = [minXY minXY];
   win1 = centerCropWindow2d(size(currentimage),targetSize);
   currentimage = imcrop(currentimage,win1);
   currentimage = imresize(currentimage,CompressSize);
   temp = zeros(PatchSize(1),PatchSize(2),3);
   currentimage = [currentimage temp];
   imwrite(currentimage,currentfilename);
end