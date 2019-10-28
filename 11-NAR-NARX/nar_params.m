T = tonndata(Fort,true,false);

%trainFcns={'trainlm','trainbr','trainscg'};
trainFcns={'trainscg'};

delays={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50};

layers={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50};

for i=1:length(trainFcns)
    for j=1:length(delays)
        for k=1:length(layers)
            
            trainFcn = trainFcns{i};
            feedbackDelays = 1:delays{j};
            hiddenLayerSize = layers{k};

            net = narnet(feedbackDelays,hiddenLayerSize,'open',trainFcn);

            net.input.processFcns = {'removeconstantrows','mapminmax'};

            [x,xi,ai,t] = preparets(net,{},{},T);

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

%             view(net);

%             f = figure('visible', 'off');
%             plotperform(tr);
%             print -djpeg plotperform.jpg
%             close(f)
%                        
%             f = figure('visible', 'off');
%             plottrainstate(tr);
%             print -djpeg plottrainstate.jpg
%             close(f)
%             
%             f = figure('visible', 'off');
%             ploterrhist(e);
%             print -djpeg ploterrhist.jpg
%             close(f)
%             
%             f = figure('visible', 'off');
%             plotregression(t,y);
%             print -djpeg plotregression.jpg
%             close(f)
%             
%             f = figure('visible', 'off');
%             plotresponse(t,y);
%             print -djpeg plotresponse.jpg
%             close(f)
%             
%             f = figure('visible', 'off');
%             ploterrcorr(e);
%             print -djpeg ploterrcorr.jpg
%             close(f)
%             
%             f = figure('visible', 'off');
%             plotinerrcorr(x,e);
%             print -djpeg plotinerrcorr.jpg
%             close(f)

            save(strcat('nar_',trainFcn,'_',num2str(delays{j}),'_',num2str(layers{k})))

        end
    end
end