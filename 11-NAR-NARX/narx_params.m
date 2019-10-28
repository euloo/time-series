X = tonndata(xt,true,false);
T = tonndata(Fort,true,false);

%trainFcns={'trainlm','trainbr','trainscg'};
trainFcns={'trainscg'};

delays={1,5,10,15,20,25,30,35,40,45,50};

layers={1,5,10,15,20,25,30,35,40,45,50};

for i=1:length(trainFcns)
    for j=1:length(delays)
        for k=1:length(layers)

            trainFcn = trainFcns{i};
            feedbackDelays = 1:delays{j};
            inputDelays = 1:delays{j};
            hiddenLayerSize = layers{k};

            net = narxnet(inputDelays,feedbackDelays,hiddenLayerSize,'open',trainFcn);

            net.inputs{1}.processFcns = {'removeconstantrows','mapminmax'};
            net.inputs{2}.processFcns = {'removeconstantrows','mapminmax'};

            [x,xi,ai,t] = preparets(net,X,{},T);

            net.divideFcn = 'dividerand';
            net.divideMode = 'time';
            net.divideParam.trainRatio = 80/100;
            net.divideParam.valRatio = 5/100;
            net.divideParam.testRatio = 15/100;

            net.performFcn = 'mse';

            net.plotFcns = {};

            [net,tr] = train(net,x,t,xi,ai);

            y = net(x,xi,ai);
            e = gsubtract(t,y);
            performance = perform(net,t,y);

            trainTargets = gmultiply(t,tr.trainMask);
            valTargets = gmultiply(t,tr.valMask);
            testTargets = gmultiply(t,tr.testMask);
            trainPerformance = perform(net,trainTargets,y);
            valPerformance = perform(net,valTargets,y);
            testPerformance = perform(net,testTargets,y);
            
            save(strcat('narx_',trainFcn,'_',num2str(delays{j}),'_',num2str(layers{k})))

        end
    end
end
