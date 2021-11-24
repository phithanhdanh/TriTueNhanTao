%LOAD DATA
%load the new images as an image datastore
imdsTrain = imageDatastore('data/train images', ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames'); 
imdsValidation = imageDatastore('data/validation images', ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames'); 

%% 
%LOAD PRETRAINED NETWORK
net = resnet18;
%analyzeNetwork(net);
inputSize = net.Layers(1).InputSize;

%% 
%REPLACE FINAL LAYERS
numClasses = numel(categories(imdsTrain.Labels));
layers = [
    fullyConnectedLayer(numClasses,"WeightLearnRateFactor",10,"BiasLearnRateFactor",10)
    softmaxLayer
    classificationLayer];

lgraph=layerGraph(net);
lgraph = removeLayers(lgraph,{'ClassificationLayer_predictions','prob','fc1000'}); 
lgraph = addLayers(lgraph,layers);
lgraph = connectLayers(lgraph,'pool5','fc');
%analyzeNetwork(lgraph)

%%
%TRAIN NETWORK
%Resize images and Augmentation
pixelRange = [-30 30];
scaleRange = [0.9 1.1];
imageAugmenter = imageDataAugmenter( ...
    'RandXReflection',true, ...
    'RandXTranslation',pixelRange, ...
    'RandYTranslation',pixelRange, ...
    'RandXScale',scaleRange, ...
    'RandYScale',scaleRange, ...
    'RandRotation',[-180 180]);
augimdsTrain = augmentedImageDatastore(inputSize(1:2),imdsTrain, ...
    'DataAugmentation',imageAugmenter,'ColorPreprocessing','gray2rgb');
augimdsValidation = augmentedImageDatastore(inputSize(1:2), ...
    imdsValidation,'ColorPreprocessing','gray2rgb');

%Training options
options = trainingOptions("sgdm",...
    'MiniBatchSize',10,...
    'MaxEpochs',6,...
    'InitialLearnRate',1e-4,...
    'Shuffle','every-epoch',...
    'ValidationData',augimdsValidation,...
    'ValidationFrequency',3,...
    'Verbose',false,...
    'Plots','training-progress');

%Train
net = trainNetwork(augimdsTrain,lgraph,options);

%%
%Classify Test Images
[YPred,scores] = classify(net,augimdsValidation);
YValidation = imdsValidation.Labels; 
%Top 1 accuracy
Top1Accuracy = mean(YPred == YValidation)
%Top 5 accuracy
[n,m] = size(scores);  
idx = zeros(m,n); 
for i=1:n  
    [~,idx(:,i)] = sort(scores(i,:),'descend');  
end  
idx = idx(1:5,:);  
top5Classes = net.Layers(end).ClassNames(idx);  
top5count = 0;  
for i = 1:n  
    top5count = top5count + sum(YValidation(i,1) == top5Classes(:,i));  
end  
top5Accuracy = top5count/n 

%Display some top 1 predicted images
idx = randperm(numel(imdsValidation.Files),4);
figure
for i = 1:4
    subplot(2,2,i)
    I = readimage(imdsValidation,idx(i));
    imshow(I)
    label = YPred(idx(i));
    title(string(label));
end