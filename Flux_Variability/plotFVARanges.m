function plotFVARanges(minFlux,maxFlux)

i = 1:length(maxFlux);

Ys = 1000*[minFlux';minFlux';maxFlux';maxFlux'];

barwidth=.2;
X=[[1:size(i,2)]-barwidth/2
    [1:size(i,2)]+barwidth/2
    [1:size(i,2)]+barwidth/2
    [1:size(i,2)]-barwidth/2];

figure
patch('xdata',X,'ydata',Ys,'facecolor','b');
ylabel('Flux (mmol/gDCW \cdot h)')
xlabel('Reaction')
title({'Min/Max Flux Bounds (Test Plot)'})
%ylim([-50 50])
