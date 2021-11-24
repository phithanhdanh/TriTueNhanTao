%% 
%LOAD PRETRAINED NETWORK
net = resnet50;
%analyzeNetwork(net);
inputSize = net.Layers(1).InputSize;

%% 
%REPLACE FINAL LAYERS
numClasses = numel(categories(imdsTrain.Labels));
layers = [
    fullyConnectedLayer(numClasses,"WeightLearnRateFactor",10,"BiasLearnRateFactor",10,"Name",'fc')
    softmaxLayer("Name",'softmax')
    classificationLayer("Name",'classoutput')];

lgraph = layerGraph(net);
lgraph = removeLayers(lgraph,{'ClassificationLayer_fc1000','fc1000_softmax','fc1000'}); 
lgraph = addLayers(lgraph,layers);
lgraph = connectLayers(lgraph,'avg_pool','fc');
%analyzeNetwork(lgraph)