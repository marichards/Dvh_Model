function [solution]=flux_and_plot25A(model, threshhold, plot)

%varargout{1}

%solution=inputname(2)
modelname=inputname(1);
solutionname=strcat('solution_', modelname,'.svg');



%solution2=solution;

solution=optimizeCbModel(model, [], 0 , false)

%save solution;


if (solution.stat==1) 
    dummy=1;
    



graph={'EX_cpd00047(e)','EX_cpd00159(e)','rxn14404','rxn00157','rxn00173','rxn00225','rxn05488','rxn05602','rxn05938','rxn08793A','rxn10904','rxn11934A','rxn14405', 'rxn08971', 'rxn14407','rxn14408','rxn14409','rxn14410','rxn14411','rxn14412','rxn14414','rxn14417A', 'rxn14403', 'rxn14415', 'EX_cpd00239(e)', 'EX_cpd00048(e)', 'rxn05651A', 'rxn00379', 'rxn14419', 'rxn14413A', 'rxn14416', 'rxn14418', 'EX_cpd00011(e)', 'rxn10042', 'rxn00371A',  'rxn14420', 'rxn14418A', 'rxn00175', 'rxn11934B', 'bio_DvH', 'rxn08793B', 'Ex_cpd00026[c]'};
fid=fopen('/Users/jasonflowers/Documents/ENIGMA/Research/Fluxbalance model/test_out.txt', 'wt')


list={};
str=solution.x;
for i=1:length(graph) %cycle through the list of reactions
    %rxn=graph{i};

  
    
        
    for j=1:length(model.rxns)
        rxn=model.rxns{j};
lb=model.lb(j);
ub=model.ub(j);

        %this is being done since qmo has two forms for it now.  QMO and
        %QMOa (with confurcation).
        huh='rxn11934B';
        m=strcmp(huh, rxn);
        
        if (m==1)
            
            rxn='rxn11934A';
            
        end
        
        
        test=strcmp(rxn,graph{i});
        
        
        if (test==1);
            
            
    
        
            if (abs(str(j))>=threshhold); %if particular reaction (i) has |flux| > 0.5 then  exists in the model
             list{end+1} =graph{i};
             
             %fprintf('%s \t %s  \t %f\n', rxn, model.rxnNames{j}, str(j));
             fprintf('%s \t %s  \t %f\t %f \t %f \n', rxn, model.rxnNames{j}, str(j), lb, ub);
             fprintf(fid, '%s \t %s  \t %f\t %f \t %f \n', rxn, model.rxnNames{j}, str(j), lb, ub);

            end
            
        end
       
    end

end


%out = evalc(['disp(solution)'])

if (plot==1);  %remove this is new addition does not work


perl('/Users/jasonflowers/Documents/ENIGMA/Research/Fluxbalance model/SVG_flux_adjust_test4.pl','drawing_moreW25A_CC.svg', 'test_out.txt', solutionname);
%system(['open //Applications/Inkscape.app/ -f' output '-echo']);
system(['open ' solutionname]);

end %remove this is new addition does not work
else
    fprint('This did not work');
    
end

end


%draw_by_rxn(model, list, 'true', 'struc', {''}, {''}, FBAsolution.x);

