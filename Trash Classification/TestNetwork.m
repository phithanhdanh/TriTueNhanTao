%%
%To use this script: define your network as "net"

inputSize = net.Layers(1).InputSize;
augimdsTest = augmentedImageDatastore(inputSize(1:2), ...
    imdsTest,'ColorPreprocessing','gray2rgb');

%Classify Test Images
[YPred,scores] = classify(net,augimdsTest);
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
top5Classes = net.Layers(end).ClassNames(idx);  
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