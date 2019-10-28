% view(net);

f = figure('visible', 'off');
plotperform(tr);
print -djpeg plotperform.jpg
close(f)

f = figure('visible', 'off');
plottrainstate(tr);
print -djpeg plottrainstate.jpg
close(f)

f = figure('visible', 'off');
ploterrhist(e);
print -djpeg ploterrhist.jpg
close(f)

f = figure('visible', 'off');
plotregression(t,y);
print -djpeg plotregression.jpg
close(f)

f = figure('visible', 'off');
plotresponse(t,y);
print -djpeg plotresponse.jpg
close(f)

f = figure('visible', 'off');
ploterrcorr(e);
print -djpeg ploterrcorr.jpg
close(f)

f = figure('visible', 'off');
plotinerrcorr(x,e);
print -djpeg plotinerrcorr.jpg
close(f)