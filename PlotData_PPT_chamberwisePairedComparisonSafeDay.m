function PlotData_PPT_chamberwisePairedComparisonSafeDay(root, resdir, NoDupesSafeData,NoDupesScaryData, mins, TypeOfTest, ScaryZoneSubstring, SafeZoneSubstring)

% Data=readtable("D:\LS\OFT_constab_forMITT.xlsx"','Sheet','10 mins');

dbstop if error

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
    F=figure();


for i=10; %:9 %8:length(NoDupesScaryData.Properties.VariableNames);
    i=10;
    InScaryVarToAnalyse=NoDupesScaryData.Properties.VariableNames{i};
    
    if contains(InScaryVarToAnalyse,'Perc');
    %keyboard
    end


    InScaryScaryCondGFP=ScaryGFPData{:,i};
    InScaryScaryCondChR2=ScaryChR2Data{:,i};
    InScarySafeCondGFP=SafeGFPData{:,i};
    InScarySafeCondChR2=SafeChR2Data{:,i};
    

     i=11;
    InSafeVarToAnalyse=NoDupesScaryData.Properties.VariableNames{i};
    
    if contains(InSafeVarToAnalyse,'Perc');
    %keyboard
    end


    InSafeScaryCondGFP=ScaryGFPData{:,i};
    InSafeScaryCondChR2=ScaryChR2Data{:,i};
    InSafeSafeCondGFP=SafeGFPData{:,i};
    InSafeSafeCondChR2=SafeChR2Data{:,i};

     y=[mean(InSafeSafeCondChR2) mean(InScarySafeCondChR2); mean(InSafeSafeCondGFP) mean(InScarySafeCondGFP)];
      
    %NEW for overall movement
    x = categorical(["ChR2","GFP"]); %2;% how many groups

 
% ORIGINAL %     y=[mean(ScaryGFP) mean(ScaryChR2);mean(SafeGFP) mean(SafeChR2)];

       
b=bar(y);


    hold on
    b(1).FaceColor=[0.8260, 0.85, 0.4280];% [0.3660, 0.9, 0.4880];
    b(2).FaceColor=[0.5010 0.7050 0.5730];

    % b(1,1).FaceColor=[0.1260, 0.85, 0.4280];% [0.3660, 0.9, 0.4880];
    % b(1,2).FaceColor=[0.5010 0.7050 0.5730];    
    % b(2,1).FaceColor=[0.8260, 0.85, 0.4280];;% [0.3660, 0.9, 0.4880];
    % b(2,2).FaceColor=[0.5010 0.7050 0.5730]; 



    scatter(repmat(b(1).XEndPoints(1), length(InSafeSafeCondChR2), 1),InSafeSafeCondChR2,70,'MarkerFaceColor',[0.25, 0.55, 0.95],'MarkerEdgeColor','k','LineWidth',1);
    scatter(repmat(b(1).XEndPoints(2), length(InSafeSafeCondGFP), 1),InSafeSafeCondGFP,70,'MarkerFaceColor',[0.0, 0.6, 0.45],'MarkerEdgeColor','k','LineWidth',1);
    scatter(repmat(b(2).XEndPoints(1), length(InScarySafeCondChR2), 2),InScarySafeCondChR2,70,'MarkerFaceColor',[0.25, 0.55, 0.95],'MarkerEdgeColor','k','LineWidth',1);
    scatter(repmat(b(2).XEndPoints(2), length(InScarySafeCondGFP), 2),InScarySafeCondGFP,70,'MarkerFaceColor',[0.0, 0.6, 0.45],'MarkerEdgeColor','k','LineWidth',1);


        MaxValues=[max(InSafeScaryCondChR2(:)),max(InSafeScaryCondGFP(:)),max(InScaryScaryCondChR2(:)),max(InScaryScaryCondGFP(:))];
    Max=max(MaxValues);
        MinValues=[-12,-12,-12,-12]; %MinValues=[min(ScaryGFP(:)),min(ScaryChR2(:)),min(SafeGFP(:)),min(SafeChR2(:))];
    Min=min(MinValues);
    
    hold off
    
    if contains(TypeOfTest,'levated','IgnoreCase',true);
        SafeZone = 'Closed Arms';
        ScaryZone = 'Open Arms';
        CentreZone = 'Centre Zone';
    elseif contains(TypeOfTest,'Open','IgnoreCase',true);
        SafeZone ='Border';
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
        SafeZone ='No';
        ScaryZone ='Right Chamber';

    end

       xticklabels(["ChR2" "GFP"]); %commented out 06.07.2024
    %%%%% HUN xticklabels(["Stimuláció nyílt karokban" "Stimuláció zárt karokban"]);
    if Min>0
        try ylim([-(Min*0.25) (Max*1.05)]);%%%ylim([-((Max*1.05)-Min) (Max*1.05)]);%(Max*1.05)]);
        catch ME
            keyboard
        end
    else 
        try ylim([-(Max*0.045) (Max*1.05)]);%%%ylim([-((Max*1.05)-Min) (Max*1.05)]);%(Max*1.05)]);
        catch ME
            keyboard
        end
    end

    a = get(gca,'XTickLabel');  
    set(gca,'XTickLabel',a,'fontsize',12,'FontWeight','bold');

           % % % % if contains(VarToAnalyse,'scar','IgnoreCase',true);
           % % % %      VarToAnalyse=replace(VarToAnalyse,'Scary','Right');
           % % % % elseif contains(VarToAnalyse,'safe','IgnoreCase',true);
           % % % %      VarToAnalyse=replace(VarToAnalyse,'Safe','left');
           % % % % end

S  = 'Duration';%VarToAnalyse;
 
Srepl=S;

if contains(S, 'cary');
    Srepl=replace(S, 'ScaryZone', ScaryZone);
elseif contains(S, 'afe');
    Srepl=replace(S, 'SafeZone', SafeZone);
elseif contains(S, 'Over');
    Srepl  = VarToAnalyse;
end


up = isstrprop(Srepl, 'upper');
VarStr  = blanks(length(Srepl) + sum(up));
VarStr(cumsum(up + 1)) = lower(Srepl);

VarStr=strcat(upper(VarStr(1)),lower(VarStr(2:end)));
VarStr=strcat(upper(VarStr(1)),lower(VarStr(2:end)));

if contains(VarStr, 'uration');
    VarStrUnit=' s';
elseif contains(VarStr, 'ove');
    VarStrUnit=' cm';
elseif contains(VarStr, 'elo');
    VarStrUnit=' cm/s';
elseif contains(VarStr, 'req');
    VarStrUnit=' #';
elseif contains(VarStr, 'cent')||contains(VarStr, 'atio');
    VarStrUnit=' %';
end


   
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

    %NumOfAnimals=size(NoDupesSafeData,2);
    Legend=legend('Not stimulated chamber','Stimulation-coupled chamber' , 'Location','northeastoutside', 'FontSize',13); %'Max, Border Zone', 'Mean, Centre', 'Max, Centre','Location','bestoutside');
       

    if exist('Legend','var') ==1;
        set(Legend,'Interpreter','latex');
        set(gca,'FontSize',10);
    end
    

% ylabel(horzcat(S,',',VarStrUnit), FontSize=12);
%               minsStr=num2str(mins);

ylabel(horzcat(S,', %'), FontSize=12);
%               minsStr=num2str(mins);
   title(horzcat(VarStr,' in chamber,',VarStrUnit), FontSize=17);
   subtitle("No stimulation condition");

    if ~exist(fullfile(resdir,'Average plots',horzcat(num2str(mins),' mins')), 'dir');
       mkdir(fullfile(resdir,'Average plots',horzcat(num2str(mins),' mins')));
    end

    l=yline(50); %line for chance value, 300 is half of 600, but should be made dznamic
    l.Color=[0.6 0.6 0.6];
    l.LineWidth=3;
    l.LineStyle=":";

setmyplot_balazs
    % % % fnm = fullfile(resdir,'Average plots',strcat(Srepl,'_Paired_NOStim_OverallMovement',num2str(mins),'Mins.png'));%fullfile(StatisticPlots, strcat(TypeOfTest,'_',ExperimentFolders{i},'_ZoneTransition_', nameFolds{h}, '.png'));
    % % % fnm1 = fullfile(resdir,'Average plots',strcat(Srepl,'_Paired_NOStim_OverallMovement',num2str(mins),'Mins.fig'));%fullfile(StatisticPlots, strcat(TypeOfTest,'_',ExperimentFolders{i},'_ZoneTransition_', nameFolds{h}, '.png'));
    % % % fnm2 = fullfile(resdir,'Average plots',strcat(Srepl,'_Paired_NOtStim_OverallMovement',num2str(mins),'Mins.svg'));%fullfile(StatisticPlots, strcat(TypeOfTest,'_',ExperimentFolders{i},'_ZoneTransition_', nameFolds{h}, '.png'));
    
    % fnm = fullfile(resdir,'Average plots',strcat(Srepl,'_Paired_RightStim_OverallMovement',num2str(mins),'Mins.png'));%fullfile(StatisticPlots, strcat(TypeOfTest,'_',ExperimentFolders{i},'_ZoneTransition_', nameFolds{h}, '.png'));
    % fnm1 = fullfile(resdir,'Average plots',strcat(Srepl,'_Paired_RightStim_OverallMovement',num2str(mins),'Mins.fig'));%fullfile(StatisticPlots, strcat(TypeOfTest,'_',ExperimentFolders{i},'_ZoneTransition_', nameFolds{h}, '.png'));
    % fnm2 = fullfile(resdir,'Average plots',strcat(Srepl,'_Paired_RightStim_OverallMovement',num2str(mins),'Mins.svg'));%fullfile(StatisticPlots, strcat(TypeOfTest,'_',ExperimentFolders{i},'_ZoneTransition_', nameFolds{h}, '.png'));

    
    fnm = fullfile(resdir,'Average plots',strcat(Srepl,'_Paired_NoStim_duration',num2str(mins),'Mins.png'));%fullfile(StatisticPlots, strcat(TypeOfTest,'_',ExperimentFolders{i},'_ZoneTransition_', nameFolds{h}, '.png'));
    fnm1 = fullfile(resdir,'Average plots',strcat(Srepl,'_Paired_NoStim_duration',num2str(mins),'Mins.fig'));%fullfile(StatisticPlots, strcat(TypeOfTest,'_',ExperimentFolders{i},'_ZoneTransition_', nameFolds{h}, '.png'));
    fnm2 = fullfile(resdir,'Average plots',strcat(Srepl,'_Paired_NoStim_duration',num2str(mins),'Mins.svg'));%fullfile(StatisticPlots, strcat(TypeOfTest,'_',ExperimentFolders{i},'_ZoneTransition_', nameFolds{h}, '.png'));




    saveas(F,fnm);
    saveas(F,fnm1);
    saveas(F,fnm2);
    
    close(F);

%end %of looping though variables

end