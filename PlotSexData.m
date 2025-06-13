function PlotSexData(root, resdir, NoDupesSafeData,NoDupesScaryData, mins, TypeOfTest, ScarySubstring, SafeSubstring)

% Data=readtable("D:\LS\OFT_constab_forMITT.xlsx"','Sheet','10 mins');



% NoDupesScaryData=NoDupesScaryData(1:20,:); %cuts off new blind cohort
% NoDupesSafeData=NoDupesSafeData(1:20,:); %cuts off new blind cohort
% % Data=Data(1:20,:);
% % % if NoDupesScaryData~=[];%in case the condition had not yet occured
    ScaryGFPIndex = cell2mat(cellfun(@(x) contains(x,'Control'), NoDupesScaryData.ControlOrNot, 'UniformOutput', 0));
    ScaryGFPData=NoDupesScaryData(ScaryGFPIndex,:);

    ScaryChR2Index = cell2mat(cellfun(@(x) contains(x,'Treated'), NoDupesScaryData.ControlOrNot, 'UniformOutput', 0));
    ScaryChR2Data=NoDupesScaryData(ScaryChR2Index,:);
% % % end

%same for safe data, which is stimualation in safe zone condition:
% if NoDupesSafeData~=[];%in case the condition had not yet occured
    SafeGFPIndex = cell2mat(cellfun(@(x) contains(x,'Control'), NoDupesSafeData.ControlOrNot, 'UniformOutput', 0));
    SafeGFPData=NoDupesSafeData(SafeGFPIndex,:);

    SafeChR2Index = cell2mat(cellfun(@(x) contains(x,'Treated'), NoDupesSafeData.ControlOrNot, 'UniformOutput', 0));
    SafeChR2Data=NoDupesSafeData(SafeChR2Index,:);
% end

%%for sexes:


    ScaryMaleChR2Index = cell2mat(cellfun(@(x) contains(x,'Male'), ScaryChR2Data.Sex, 'UniformOutput', 0));
    ScaryMaleChR2Data=ScaryChR2Data(ScaryMaleChR2Index,:);

    ScaryFemaleChR2Index = cell2mat(cellfun(@(x) contains(x,'Female'), ScaryChR2Data.Sex, 'UniformOutput', 0));
    ScaryFemaleChR2Data=ScaryChR2Data(ScaryFemaleChR2Index,:);

    %%%%%%%%%%

    SafeMaleChR2Index = cell2mat(cellfun(@(x) contains(x,'Male'), SafeChR2Data.Sex, 'UniformOutput', 0));
    SafeMaleChR2Data=SafeChR2Data(SafeMaleChR2Index,:);

    SafeFemaleChR2Index = cell2mat(cellfun(@(x) contains(x,'Female'), SafeChR2Data.Sex, 'UniformOutput', 0));
    SafeFemaleChR2Data=SafeChR2Data(SafeFemaleChR2Index,:);

for i=8:length(NoDupesScaryData.Properties.VariableNames);

    VarToAnalyse=NoDupesScaryData.Properties.VariableNames{i};
    
    ScaryFemale=ScaryFemaleChR2Data{:,i};
    ScaryMale=ScaryMaleChR2Data{:,i};
    SafeFemale=SafeFemaleChR2Data{:,i};
    SafeMale=SafeMaleChR2Data{:,i};
    
    % y = [mean(GFP) mean(ChR2)];%[NoDupesScaryData.DurationInScaryZone NoDupesSafeData.DurationInScaryZone];
    
    
      
    F=figure();
    x = categorical(["Female", "Male"]); %2;% how many groups
    y=[mean(ScaryFemale) mean(ScaryMale);mean(SafeFemale) mean(SafeMale)];
    b=bar(y);
    
    hold on
    b(1).FaceColor=[0.8, 0.5, 0.70];% [0.3660, 0.9, 0.4880]; %pink
    b(2).FaceColor=[0.3010 0.7450 0.9330]; %baby blue
    
    % % % hold on; % plot multiple things without clearing the axes
    % % % b=bar( x, y, 0.4 ); % bar of the means
    
    scatter(repmat(b(1).XEndPoints(1), length(ScaryFemale), 1),ScaryFemale,70,'MarkerFaceColor',[0.85, 0.0, 0.55],'MarkerEdgeColor','k','LineWidth',1);
    scatter(repmat(b(1).XEndPoints(2), length(SafeFemale), 2),SafeFemale,70,'MarkerFaceColor',[0.85, 0.0, 0.55],'MarkerEdgeColor','k','LineWidth',1);
    scatter(repmat(b(2).XEndPoints(1), length(ScaryMale), 1),ScaryMale,70,'MarkerFaceColor','b','MarkerEdgeColor','k','LineWidth',1);
    scatter(repmat(b(2).XEndPoints(2), length(SafeMale), 2),SafeMale,70,'MarkerFaceColor','b','MarkerEdgeColor','k','LineWidth',1);
    
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
        SafeZone ='Left Chamber';
        ScaryZone ='Right Chamber';

    end

     xticklabels([strcat(ScaryZone," Stimulation") strcat(SafeZone," Stimulation")]);


    a = get(gca,'XTickLabel');  
    set(gca,'XTickLabel',a,'fontsize',12,'FontWeight','bold');
    a=gca;
    a.XRuler.TickLabelGapOffset = 5;


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

    ylabel(VarToAnalyse, FontSize=15);
           % % % % VarToAnalyse=NoDupesScaryData.Properties.VariableNames{i}; %reset VarToAnalyse


    
    xtips1 = b(1).XEndPoints;
    ytips1 = b(1).YEndPoints;
    
    xtips2 = b(2).XEndPoints;
    ytips2 = b(2).YEndPoints;
    
    ax=gca;
    ax.FontSize = 12
    
    
    % xtips = 'BZ';
    % ytips = 'CZ';
    labels1 = string(round(b(1).YData,2)); %round to show only 2 digits after the point
    labels2 = string(round(b(2).YData,2)); %round to show only 2 digits after the point
    %b(1).FaceColor = [.3 0.9 .6]; %green
    text(xtips1,ytips1,labels1,'HorizontalAlignment','right',...
        'VerticalAlignment','bottom','FontSize',8, 'FontWeight','bold');
    text(xtips2,ytips2,labels2,'HorizontalAlignment','right',...
        'VerticalAlignment','bottom','FontSize',8, 'FontWeight','bold');
    %Legend=legend('Mean, Border Zone', 'Max, Border Zone', 'Mean, Centre', 'Max, Centre','Location','bestoutside');
    %if size(y,2)>1
        Legend=legend(strcat('Female N=',num2str(length(ScaryFemale))), strcat('Male N=',num2str(length(ScaryMale))), 'Location','bestoutside', 'FontSize',13); %'Max, Border Zone', 'Mean, Centre', 'Max, Centre','Location','bestoutside');
    %end
    % if size(y,2)>2
    %     Legend=legend(ScaryZone, CentreZone, SafeZone, 'Location','bestoutside')
    % end
    
    if exist('Legend','var') ==1;
        set(Legend,'Interpreter','latex');
        set(gca,'FontSize',10);
    end
    
    MaxValues=[max(ScaryFemale(:)),max(ScaryMale(:)),max(SafeFemale(:)),max(SafeMale(:))];
    Max=max(MaxValues);
    try ylim([0 (Max*1.05)]);%(Max*1.05)]);
    catch ME
        keyboard
    end
    minsStr=num2str(mins);

    fnm = strcat(fullfile(resdir,'Average plots'),'\',VarToAnalyse,'_',minsStr,'MinsSex.png');%fullfile(StatisticPlots, strcat(TypeOfTest,'_',ExperimentFolders{i},'_ZoneTransition_', nameFolds{h}, '.png'));
    fnm1 = strcat(fullfile(resdir,'Average plots'),'\',VarToAnalyse,'_',minsStr,'MinsSex.fig');%fullfile(StatisticPlots, strcat(TypeOfTest,'_',ExperimentFolders{i},'_ZoneTransition_', nameFolds{h}, '.png'));
    fnm2 = strcat(fullfile(resdir,'Average plots'),'\',VarToAnalyse,'_',minsStr,'MinsSex.svg');%fullfile(StatisticPlots, strcat(TypeOfTest,'_',ExperimentFolders{i},'_ZoneTransition_', nameFolds{h}, '.png'));
  


    saveas(F,fnm)
    saveas(F,fnm1)
    saveas(F,fnm2)
    
    close(F)

end %of looping though variables

end