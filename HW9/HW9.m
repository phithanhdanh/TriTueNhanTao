%LOAD DATA
%load the new images as an image datastore
imds = imageDatastore('myData', ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');
%Divide the data into training and validation data sets
[imdsTrain,imdsValidation,imdsTest] = splitEachLabel(imds,0.7,0.15,'randomized');
%display some picture
numTrainImages = numel(imdsTrain.Labels);
idx = randperm(numTrainImages,16);
figure
for i = 1:16
    subplot(4,4,i)
    I = readimage(imdsTrain,idx(i));
    imshow(I)
end

%% 
%LOAD PRETRAINED NETWORK
net = alexnet;
analyzeNetwork(net);
inputSize = net.Layers(1).InputSize

%% 
%REPLACE FINAL LAYERS
layersTransfer = net.Layers(1:end-3);
numClasses = numel(categories(imdsTrain.Labels))
layers = [
    layersTransfer
    fullyConnectedLayer(numClasses,"WeightLearnRateFactor",20,"BiasLearnRateFactor",20)
    softmaxLayer
    classificationLayer];

%%
%TRAIN NETWORK
%Resize images and Augmentation
pixelRange = [-30 30];
imageAugmenter = imageDataAugmenter(...
    "RandXReflection",true,...
    "RandXTranslation",pixelRange,...
    "RandYTranslation",pixelRange);
augimdsTrain = augmentedImageDatastore(inputSize(1:2),imdsTrain,...
    "DataAugmentation",imageAugmenter);
augimdsValidation = augmentedImageDatastore(inputSize(1:2),imdsValidation);
augimdsTest = augmentedImageDatastore(inputSize(1:2),imdsTest);
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
netTransfer = trainNetwork(augimdsTrain,layers,options);

%%
%Classify Test Images
[YPred,scores] = classify(netTransfer,augimdsTest);
YTest = imdsTest.Labels; 
%Top 1 accuracy
Top1Accuracy = mean(YPred == YTest)
%Top 5 accuracy
[n,m] = size(scores);  
idx = zeros(m,n); 
for i=1:n  
    [~,idx(:,i)] = sort(scores(i,:),'descend');  
end  
idx = idx(1:5,:);  
top5Classes = netTransfer.Layers(end).ClassNames(idx);  
top5count = 0;  
for i = 1:n  
    top5count = top5count + sum(YTest(i,1) == top5Classes(:,i));  
end  
top5Accuracy = top5count/n 

%Display some top 1 predicted images
idx = randperm(numel(imdsTest.Files),4);
figure
for i = 1:4
    subplot(2,2,i)
    I = readimage(imdsTest,idx(i));
    imshow(I)
    label = YPred(idx(i));
    title(string(label));
end