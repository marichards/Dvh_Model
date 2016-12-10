function plotFVARanges(rxns,minFlux,maxFlux)

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
title({'Flux Variability of Central Metabolism'})
ylim([1000*min(minFlux)-100*abs(min(minFlux)), 1000*max(maxFlux)+100*max(maxFlux)])



Xt = linspace(1,length(rxns),length(rxns));
set(gca,'XTick',Xt)
set(gca,'Xlim',[0.5 length(rxns)+0.5])
set(gca,'XTickLabel',rxns)

xticklabel_rotate([],45,[])
% ax = axis;
% Y1 = ax(3:4);
% t = text(Xt,Y1(1)*ones(1,length(Xt)),rxns);
% set(t,'HorizontalAlignment','right','VerticalAlignment','top','Rotation',90);
% set(gca,'XTickLabel','')