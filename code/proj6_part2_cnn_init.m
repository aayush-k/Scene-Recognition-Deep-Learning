function net = proj6_part2_cnn_init()
%code for Computer Vision, Georgia Tech by James Hays

%edit this network and preserve the learned weights (except for the layers
%we will replace)
net = load('./matconvnet-1.0-beta25/imagenet-vgg-f.mat') ;

%{
The final two layers, fc8 and the softmax layer, should be removed and specified again using the same syntax seen in Part 1.
The original fc8 had an input data depth of 4096 and an output data depth of 1000 (for 1000 ImageNet categories).
We need the output depth to be 15, instead. The weights can be randomly initialized just like in Part 1.
The dropout layers used to train VGG-F are missing from the pretrained model (probably because they're not used at test time).
 It's probably a good idea to add one or both of them back in between fc6 and fc7 and between fc7 and fc8.
%}
f=1/100;

% remove last two fc8 and the softmax layers
net.layers{end}={};
net.layers{end-1}={};

% shift network down
net.layers{end-1} = net.layers{end-2};
net.layers{end-2} = net.layers{end-3};

% dropout rates
net.layers{end-3} = struct('type','dropout','rate',0.3);
net.layers{end} = struct('type','dropout','rate',0.3);

% specify fc8 and softmax
net.layers{end+1} = struct('type', 'conv', ...
                           'weights', {{f*randn(3, 3, 4096, 15, 'single'), zeros(1, 15, 'single')}}, ... % depth of 4096
                           'stride', 1, ...
                           'pad', 1, ...
                           'name', 'my-fc8') ;

net.layers{end+1} = struct('type', 'softmaxloss') ;


%Do your network surgery before calling vl_simplenn_tidy()
net = vl_simplenn_tidy(net);

vl_simplenn_display(net, 'inputSize', [224 224 3 50])

% [copied from the project webpage]
% proj6_part2_cnn_init.m will start with net = load('imagenet-vgg-f.mat');
% and then edit the network rather than specifying the structure from
% scratch.

% You need to make the following edits to the network: The final two
% layers, fc8 and the softmax layer, should be removed and specified again
% using the same syntax seen in Part 1. The original fc8 had an input data
% depth of 4096 and an output data depth of 1000 (for 1000 ImageNet
% categories). We need the output depth to be 15, instead. The weights can
% be randomly initialized just like in Part 1.

% The dropout layers used to train VGG-F are missing from the pretrained
% model (probably because they're not used at test time). It's probably a
% good idea to add one or both of them back in between fc6 and fc7 and
% between fc7 and fc8.

