netc = closeloop(net);
netc.name = [net.name ' - Closed Loop'];
% view(netc)

%NAR

N=24;
M=72;

T = tonndata( [Fort(end-(N-1):end) NaN(1,M)] , true, false);
[xc,xic,aic,tc] = preparets(netc,{},{},T);
yc = netc(xc,xic,aic);

f = figure('visible', 'off');
plot(1:174, Fort, 174:174+M, [Fort(end) cell2mat(yc)]);
print -djpeg future.jpg
close(f)

T = tonndata( Fort(end-(N-1)-M:end) , true, false);
[xc,xic,aic,tc] = preparets(netc,{},{},T);
yc = netc(xc,xic,aic);

f = figure('visible', 'off');
plot(1:174, Fort, 174-M+1:174, [cell2mat(yc)]);
print -djpeg retrospective.jpg
close(f)

mean(power(Fort(end-(M-1):end)-cell2mat(yc),2))

%NARX

N=24;
M=72;

T = tonndata( [Fort(end-(N-1):end) NaN(1,M)],true,false);
Xt = tonndata([xt(end-(N-1):end) NaN(1,M)],true,false);
[xc,xic,aic,tc] = preparets(netc,Xt,{},T);
yc = netc(xc,xic,aic);

f = figure('visible', 'off');
plot(1:174, Fort, 1:174, xt, 174:174+M+1, [Fort(end) xt(end) cell2mat(yc)]);
print -djpeg future.jpg
close(f)

T = tonndata( Fort(end-(N-1)-M:end), true, false);
Xt = tonndata(xt(end-(N-1)-M:end),true,false);
[xc,xic,aic,tc] = preparets(netc, Xt, {}, T);
yc = netc(xc,xic,aic);

f = figure('visible', 'off');
plot(1:174, Fort, 1:174, xt, 174-M+1:174, [cell2mat(yc)]);
print -djpeg retrospective.jpg
close(f)

mean(power(Fort(end-(M-1):end)-cell2mat(yc),2))


