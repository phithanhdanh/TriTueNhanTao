%% 
%LOAD PRETRAINED NETWORK
net = resnet101;
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
lgraph = removeLayers(lgraph,{'ClassificationLayer_predictions','prob','fc1000'}); 
lgraph = addLayers(lgraph,layers);
lgraph = connectLayers(lgraph,'pool5','fc');
%analyzeNetwork(lgraph)