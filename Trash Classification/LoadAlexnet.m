%% 
%LOAD PRETRAINED NETWORK
net = alexnet;
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
lgraph = removeLayers(lgraph,{'output','prob','fc8'}); 
lgraph = addLayers(lgraph,layers);
lgraph = connectLayers(lgraph,'drop7','fc');
%analyzeNetwork(lgraph)