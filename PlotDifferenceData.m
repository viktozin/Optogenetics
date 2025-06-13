function PlotDifferenceData(root, resdir, NoDupesSafeData,NoDupesScaryData, mins, TypeOfTest, ScaryZoneSubstring, SafeZoneSubstring, NoDuplicateTable, NoDuplicateTableAdjCol)

% Data=readtable("D:\LS\OFT_constab_forMITT.xlsx"','Sheet','10 mins');

dbstop if error

% NoDupesScaryData=NoDupesScaryData(1:20,:); %cuts off new blind cohort
% NoDupesSafeData=NoDupesSafeData(1:20,:); %cuts off new blind cohort
% % Data=Data(1:20,:);
% % % if NoDupesScaryData~=[];%in case the condition had not yet occured
    ScaryGFPIndex = cell2mat(cellfun(@(x) contains(x,'Control'), NoDuplicateTableAdjCol.ControlOrNot, 'UniformOutput', 0));;
    ScaryGFPData=NoDuplicateTableAdjCol(ScaryGFPIndex,:);

    ScaryChR2Index = cell2mat(cellfun(@(x) contains(x,'Treated'), NoDuplicateTableAdjCol.ControlOrNot, 'UniformOutput', 0));
    ScaryChR2Data=NoDuplicateTableAdjCol(ScaryChR2Index,:);
% % % end

%same for safe data, which is stimualation in safe zone condition:
% if NoDupesSafeData~=[];%in case the condition had not yet occured
    % % % SafeGFPIndex = cell2mat(cellfun(@(x) contains(x,'Control'), NoDupesSafeData.ControlOrNot, 'UniformOutput', 0));
    % % % SafeGFPData=NoDupesSafeData(SafeGFPIndex,:);
    % % % 
    % % % SafeChR2Index = cell2mat(cellfun(@(x) contains(x,'Treated'), NoDupesSafeData.ControlOrNot, 'UniformOutput', 0));
    % % % SafeChR2Data=NoDupesSafeData(SafeChR2Index,:);
% end

% if more variables needed: for i=8:length(NoDupesScaryData.Properties.VariableNames);

    % VarToAnalyse=NoDupesScaryData.Properties.VariableNames{i};

    ScaryGFP=ScaryGFPData; % ScaryGFP=ScaryGFPData{:,i};
    ScaryChR2=ScaryChR2Data;
    % SafeGFP=SafeGFPData;
    % SafeChR2=SafeChR2Data;


%if exist('ScaryGFP.DiffDurInScary','var');    
 DiffDurScaryGFP=ScaryGFP.DiffDurInScaryCondition;
 DiffDurScaryChR2=ScaryChR2.DiffDurInScaryCondition;
%end

 % DiffDurSafeGFP=SafeGFP.DiffDurInSafe;
 % DiffDurSafeChR2=SafeChR2.DiffDurInSafe;
      
    
    Q=figure();
    x = categorical(["GFP"]); %, "ChR2"]); %2;% how many groups
    y=[median(DiffDurScaryGFP)];%  mean(DiffDurScaryChR2)]; %);mean(SafeGFP) mean(SafeChR2)];
    b=barh(x,y);
    %plot(x,y,'orientation','horizontal')

    hold on 

    x = categorical(["ChR2"]); %2;% how many groups
    y=[median(DiffDurScaryChR2)]; %);mean(SafeGFP) mean(SafeChR2)];
    bb=barh(x,y);
   

    b.FaceColor=[0.4660, 0.9, 0.4880];% [0.3660, 0.9, 0.4880];
    bb.FaceColor=[0.3010 0.7450 0.9330];

    
    % % % hold on; % plot multiple things without clearing the axes
    % % % b=bar( x, y, 0.4 ); % bar of the means
    
    hold on

    %scatter(repmat(b(1).XEndPoints(1), length(DiffDurScaryGFP), 1),DiffDurScaryGFP,70,'MarkerFaceColor',[0.0, 0.6, 0.45],'MarkerEdgeColor','k','LineWidth',1, 'O');
    scatter(DiffDurScaryGFP,(repmat(b(1).XEndPoints(1), length(DiffDurScaryGFP), 1)),70,'MarkerFaceColor',[0.0, 0.6, 0.45],'MarkerEdgeColor','k','LineWidth',1);
    % scatter(repmat(b(1).XEndPoints(2), length(SafeGFP), 2),SafeGFP,70,'MarkerFaceColor',[0.0, 0.6, 0.45],'MarkerEdgeColor','k','LineWidth',1);
    %scatter(repmat(bb(1).XEndPoints(1), length(DiffDurScaryChR2), 1),DiffDurScaryChR2,70,'MarkerFaceColor','b','MarkerEdgeColor','k','LineWidth',1);
    % scatter(repmat(b(2).XEndPoints(2), length(SafeChR2), 2),SafeChR2,70,'MarkerFaceColor','b','MarkerEdgeColor','k','LineWidth',1);
    scatter(DiffDurScaryChR2,(repmat(bb(1).XEndPoints(1), length(DiffDurScaryChR2), 1)),70,"MarkerFaceColor",'b','MarkerEdgeColor','k','LineWidth',1);

    b.ShowBaseLine='on'
    b.BaseLine.Color=[0.6 0.6 0.6];
    b.BaseLine.LineWidth=3;
    b.BaseLine.LineStyle=":";


    
% b.ShowBaseLine='off'
% bb.ShowBaseLine='off'


    hold off
    
    %ENG%%%%    xticklabels(["Center Stimulation" "Border Stimulation"]);
    %%%%% HUN xticklabels(["Stimuláció nyílt karokban" "Stimuláció zárt karokban"]);

    if contains(TypeOfTest,'levated','IgnoreCase',true);
        SafeZone = 'Closed Arms';
        ScaryZone = 'Open Arms';
        CentreZone = 'Centre Zone';
    elseif contains(TypeOfTest,'Open','IgnoreCase',true);
        SafeZone ='Border Zone';
        ScaryZone ='Centre';
    elseif strcmp(TypeOfTest, 'Light Dark Box');
        SafeZone ='Dark Chamber';
        ScaryZone ='Light Chamber';
        CentreZone = 'Entry Zone';
    elseif contains(TypeOfTest,'Light','IgnoreCase',true);
        SafeZone ='Dark Chamber';
        ScaryZone ='Light Chamber';
        CentreZone = 'Entry Zone';
    elseif contains(TypeOfTest,'Pla','IgnoreCase',true);
        SafeZone ='Not stimulated chamber';
        ScaryZone ='Stimulated chamber';

    end


    a = get(gca,'XTickLabel');  
    set(gca,'XTickLabel',a,'fontsize',14,'FontWeight','bold');
    a=gca;
    %a.XRuler.TickLabelGapOffset = 5;
   % xticklabels([strcat(ScaryZone," ") strcat(SafeZone," ")]);

   hold on

    % b=gca;
    % b.XRuler.TickLabelGapOffset = 30;
    
    % set(gca(),'XTickLabel',{'Stimulation' 'Stimulation' sprintf('\\newlinecomposite')});


    % a = get(gca,'XTickLabel');  
    % set(gca,'XTickLabel',a,'fontsize',12,'FontWeight','bold');
    % a=gca;
    % a.XRuler.TickLabelGapOffset = 25;
    %  xticklabels([" Stimulation" " Stimulation"]);


%     xticklabels([strcat('N=',num2str(length(ScaryGFP))); strcat('N=',num2str(length(ScaryChR2))); strcat('N=',num2str(length(SafeGFP))); strcat('N=',num2str(length(SafeChR2)))]);
%     a = get(gca,'XTickLabel');  
%     set(gca,'XTickLabel',a,'fontsize',8,'FontWeight','bold');
%     a=gca;
%     a.XRuler.TickLabelGapOffset = 15;

           % % % % if contains(VarToAnalyse,'scar','IgnoreCase',true);
           % % % %      VarToAnalyse=replace(VarToAnalyse,'Scary','Right');
           % % % % elseif contains(VarToAnalyse,'safe','IgnoreCase',true);
           % % % %      VarToAnalyse=replace(VarToAnalyse,'Safe','left');
           % % % % end

    % if contains(TypeOfTest,'levated','IgnoreCase',true);
    %     SafeZone = 'Open Arms';
    %     ScaryZone = 'Closed Arms';
    %     CentreZone = 'Centre Zone';
    % elseif contains(TypeOfTest,'Open','IgnoreCase',true);
    %     SafeZone ='Border Zone';
    %     ScaryZone ='Centre';
    % elseif strcmp(TypeOfTest, 'Light Dark Box');
    %     SafeZone ='Dark Chamber';
    %     ScaryZone ='Light Chamber';
    %     CentreZone = 'Entry Zone';
    % elseif contains(TypeOfTest,'Light','IgnoreCase',true);
    %     SafeZone ='Dark Chamber';
    %     ScaryZone ='Light Chamber';
    %     CentreZone = 'Entry Zone';
    % elseif contains(TypeOfTest,'Pla','IgnoreCase',true);
    %     SafeZone ='Left Chamber';
    %     ScaryZone ='Right Chamber';
    % end
    
    VarStrUnit=' s';
    %VarStr=(horzcat('Difference in duration  '),horzcat('between ', ScaryZone, ' and ', SafeZone, 's'));

   % ylabel(strcat(VarStr,',  ',VarStrUnit), FontSize=15);
           % % % % VarToAnalyse=NoDupesScaryData.Properties.VariableNames{i}; %reset VarToAnalyse
    
    xtips1 = b.XEndPoints;
    ytips1 = b.YEndPoints;
    
    xtips2 = bb.XEndPoints;
    ytips2 = bb.YEndPoints;
    
    ax=gca;
    ax.FontSize = 16;
    
    % xtips = 'BZ';
    % ytips = 'CZ';
    labels1 = string(round(b.YData,2)); %round to show only 2 digits after the point
    labels2 = string(round(bb.YData,2)); %round to show only 2 digits after the point
    b.FaceColor = [.3 0.9 .6]; %green
    text(ytips1,xtips1,labels1,'HorizontalAlignment','left',...
        'VerticalAlignment','bottom','FontSize',8, 'FontWeight','bold');
    text(ytips2, xtips2,labels2,'HorizontalAlignment','left',...
        'VerticalAlignment','bottom','FontSize',8, 'FontWeight','bold');
    %Legend=legend('Mean, Border Zone', 'Max, Border Zone', 'Mean, Centre', 'Max, Centre','Location','bestoutside');
    %if size(y,2)>1
    
    Legend=legend(strcat('GFP', ' N=',num2str(length(DiffDurScaryGFP))) ,strcat('ChR2', ' N=',num2str(length(DiffDurScaryChR2))), 'Location','northeast', 'FontSize',13); %'Max, Border Zone', 'Mean, Centre', 'Max, Centre','Location','bestoutside');
       
    %Legend=legend(strcat('GFP', ' N=',num2str(length(ScaryGFP))) ,strcat('ChR2', ' N=',num2str(length(ScaryGFP))) , 'Location','bestoutside', 'FontSize',13); %'Max, Border Zone', 'Mean, Centre', 'Max, Centre','Location','bestoutside');
        %end
    % if size(y,2)>2
    %     Legend=legend(ScaryZone, CentreZone, SafeZone, 'Location','bestoutside')
    % end
    
    if exist('Legend','var') ==1;
        set(Legend,'Interpreter','latex');
        set(gca,'FontSize',10);
    end

title(horzcat('Difference in duration  '),horzcat('between ', ScaryZone, ' and ', SafeZone, 's. ', 'Trial: ',num2str(mins),' mins'), FontSize=13);
hold on
%subtitle(horzcat('Duration of trial:',num2str(mins),' mins'), 'FontSize',11);
           % % % % VarToAnalyse=NoDupesScaryData.Properties.VariableNames{i}; %reset VarToAnalyse
              minsStr=num2str(mins);
              %%%%xlabel('Stimulation', 'Position', 1.5);

   ylabel(horzcat('Δ time in ',ScaryZone, ' and ', SafeZone), FontSize=10);



   DiffResdir=fullfile(resdir,'Average plots');

    if ~exist(DiffResdir, 'dir');
       mkdir(DiffResdir);
    end

    setmyplot_balazs;

    fnm = strcat(DiffResdir,'\','DiffInDur_',num2str(mins),'Mins.png'); %fullfile(StatisticPlots, strcat(TypeOfTest,'_',ExperimentFolders{i},'_ZoneTransition_', nameFolds{h}, '.png'));
    fnm1 = strcat(DiffResdir,'\','DiffInDur_',num2str(mins),'Mins.fig');%fullfile(StatisticPlots, strcat(TypeOfTest,'_',ExperimentFolders{i},'_ZoneTransition_', nameFolds{h}, '.png'));
    fnm2 = strcat(DiffResdir,'\','DiffInDur_',num2str(mins),'Mins.svg');%fullfile(StatisticPlots, strcat(TypeOfTest,'_',ExperimentFolders{i},'_ZoneTransition_', nameFolds{h}, '.png'));

    saveas(Q,fnm);
    saveas(Q,fnm1);
    saveas(Q,fnm2);
    
    close(Q);

% end %of looping though variables
save(strcat(TypeOfTest,'_',char(today("datetime")),'_PlotDifferenceData'));
end