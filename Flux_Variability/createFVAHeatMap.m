function createFVAHeatMap()

% Read in the Excel file FVA values
cc_min = xlsread('table 2_11012016.xlsx','FVA_QMO','B3:B36');
cc_max = xlsread('table 2_11012016.xlsx','FVA_QMO','C3:C36');

ps_min = xlsread('table 2_11012016.xlsx','FVA_QMO','G3:G36');
ps_max = xlsread('table 2_11012016.xlsx','FVA_QMO','H3:H36');

ls_min = xlsread('table 2_11012016.xlsx','FVA_QMO','L3:L36');
ls_max = xlsread('table 2_11012016.xlsx','FVA_QMO','M3:M36');

hs_min = xlsread('table 2_11012016.xlsx','FVA_QMO','Q3:Q36');
hs_max = xlsread('table 2_11012016.xlsx','FVA_QMO','R3:R36');

% Read in labels
[~,rxns] = xlsread('table 2_11012016.xlsx','FVA_QMO','A3:A36');

% Create a difference matrix
diff_mat = zeros(length(cc_min),4);
diff_mat(:,1) = cc_max - cc_min;
diff_mat(:,2) = ps_max - ps_min;
diff_mat(:,3) = ls_max - ls_min;
diff_mat(:,4) = hs_max - hs_min;

% Take the log
diff_mat = log(diff_mat+1);

% Create a heat map
conditions = {'CC','PS','LS','HS'};
hmo = HeatMap(diff_mat,'RowLabels',rxns,'ColumnLabels',conditions);
set(hmo, 'DisplayRange', 5);
addTitle(hmo,'Flux Variation Across Media')
%set(hmo,'Colormap',redbluecmap(3))

% Create a max matrix
max_mat = [cc_max,ps_max,ls_max,hs_max];

% Do the heat map of it
hmo = HeatMap(max_mat,'RowLabels',rxns,'ColumnLabels',conditions);
addTitle(hmo,'Max Fluxes Across Media')
%set(hmo, 'DisplayRange', 5);
