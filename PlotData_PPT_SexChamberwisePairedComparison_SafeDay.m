function PlotData_PPT_SexChamberwisePairedComparison_SafeDay(root, resdir, NoDupesSafeData,NoDupesScaryData, mins, TypeOfTest, ScaryZoneSubstring, SafeZoneSubstring)

Sexes={'Male', 'Female'};

for i=1:length(Sexes);
    CurrentSex=Sexes{i}; %
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
%%%%%% for the single sex:
    ScarySexGFPIndex = cell2mat(cellfun(@(x) contains(x, CurrentSex), ScaryGFPData.Sex, 'UniformOutput', 0));
    ScarySexGFPData=ScaryGFPData(ScarySexGFPIndex,:);

    ScarySexChR2Index = cell2mat(cellfun(@(x) contains(x,CurrentSex), ScaryChR2Data.Sex, 'UniformOutput', 0));
    ScarySexChR2Data=ScaryChR2Data(ScarySexChR2Index,:);

    SafeSexGFPIndex = cell2mat(cellfun(@(x) contains(x,CurrentSex), SafeGFPData.Sex, 'UniformOutput', 0));
    SafeSexGFPData=SafeGFPData(SafeSexGFPIndex,:);

    SafeSexChR2Index = cell2mat(cellfun(@(x) contains(x,CurrentSex), SafeChR2Data.Sex, 'UniformOutput', 0));
    SafeSexChR2Data=SafeChR2Data(SafeSexChR2Index,:);


  %%%%%%%%%%%%%% now onto the chamberwise comparison:

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


%for i=8:9 %8:length(NoDupesScaryData.Properties.VariableNames);
    i=10;
    InScaryVarToAnalyse=NoDupesScaryData.Properties.VariableNames{i};
    
    if contains(InScaryVarToAnalyse,'Perc');
    %keyboard
    end


    InScaryScaryCondGFP=ScarySexGFPData{:,i};
    InScaryScaryCondChR2=ScarySexChR2Data{:,i};
    InScarySafeCondGFP=SafeSexGFPData{:,i};
    InScarySafeCondChR2=SafeSexChR2Data{:,i};
    
    

    i=11;
    InSafeVarToAnalyse=NoDupesScaryData.Properties.VariableNames{i};
    
    if contains(InSafeVarToAnalyse,'Perc');
    %keyboard
    end


    InSafeScaryCondGFP=ScarySexGFPData{:,i};
    InSafeScaryCondChR2=ScarySexChR2Data{:,i};
    InSafeSafeCondGFP=SafeSexGFPData{:,i};
    InSafeSafeCondChR2=SafeSexChR2Data{:,i};

 y=[mean(InSafeSafeCondChR2) mean(InScarySafeCondChR2); mean(InSafeSafeCondGFP) mean(InScarySafeCondGFP)];
    
   
   %NEW for overall movement
    x = categorical(["ChR2" ,"GFP"]); %2;% how many groups

  
% ORIGINAL %     y=[mean(ScaryGFP) mean(ScaryChR2);mean(SafeGFP) mean(SafeChR2)];

       
b=bar(y);


    hold on
    b(1).FaceColor=[0.8260, 0.85, 0.4280];% [0.3660, 0.9, 0.4880];
    b(2).FaceColor=[0.5010 0.7050 0.5730];

    if strcmp(CurrentSex,'Male');
    
        
        scatter(repmat(b(1).XEndPoints(1), length(InSafeSafeCondChR2), 1),InSafeSafeCondChR2,70,'MarkerFaceColor',[0.25, 0.55, 0.95],'MarkerEdgeColor','k','LineWidth',1);
        scatter(repmat(b(1).XEndPoints(2), length(InSafeSafeCondGFP), 1),InSafeSafeCondGFP,70,'MarkerFaceColor',[0.0, 0.6, 0.45],'MarkerEdgeColor','k','LineWidth',1);
        scatter(repmat(b(2).XEndPoints(1), length(InScarySafeCondChR2), 2),InScarySafeCondChR2,70,'MarkerFaceColor',[0.25, 0.55, 0.95],'MarkerEdgeColor','k','LineWidth',1);
        scatter(repmat(b(2).XEndPoints(2), length(InScarySafeCondGFP), 2),InScarySafeCondGFP,70,'MarkerFaceColor',[0.0, 0.6, 0.45],'MarkerEdgeColor','k','LineWidth',1);

        
    elseif contains(CurrentSex,'Female','IgnoreCase',true); %IF FEMALE

        
        scatter(repmat(b(1).XEndPoints(1), length(InSafeSafeCondChR2), 1),InSafeSafeCondChR2,70,'MarkerFaceColor','r','MarkerEdgeColor','k','LineWidth',1);
        scatter(repmat(b(1).XEndPoints(2), length(InSafeSafeCondGFP), 1),InSafeSafeCondGFP,70,'MarkerFaceColor',[0.0, 0.6, 0.45],'MarkerEdgeColor','k','LineWidth',1);
        scatter(repmat(b(2).XEndPoints(1), length(InScarySafeCondChR2), 2),InScarySafeCondChR2,70,'MarkerFaceColor','r','MarkerEdgeColor','k','LineWidth',1);
        scatter(repmat(b(2).XEndPoints(2), length(InScarySafeCondGFP), 2),InScarySafeCondGFP,70,'MarkerFaceColor',[0.0, 0.6, 0.45],'MarkerEdgeColor','k','LineWidth',1);

    else
        keyboard
    end

   

                MaxValues=[max(InSafeSafeCondChR2(:)),max(InSafeSafeCondGFP(:))];%,max(InScaryScaryCondChR2(:)),max(InScaryScaryCondGFP(:))];
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
    % a=gca;
    % a.XRuler.TickLabelGapOffset = 5;
   % xticklabels([strcat(ScaryZone," ") strcat(SafeZone," ")]);
    % 
    % set(gca(),'XTickLabel',{ScaryZone SafeZone sprintf('\\newlinecomposite')});
    % 
    % % a = get(gca,'XTickLabel');  
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

S  = 'Overall Movement';%VarToAnalyse;
 
Srepl=S;

if contains(S, 'cary');
    Srepl=replace(S, 'ScaryZone', ScaryZone);
elseif contains(S, 'afe');
    Srepl=replace(S, 'SafeZone', SafeZone);
elseif contains(S, 'Over');
    Srepl  = S;
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


   % ylabel(strcat(VarStr,',  ',VarStrUnit), FontSize=15);
           % % % % VarToAnalyse=NoDupesScaryData.Properties.VariableNames{i}; %reset VarToAnalyse


    
    xtips1 = b(1).XEndPoints;
    ytips1 = b(1).YEndPoints;
    
     xtips2 = b(2).XEndPoints;
     ytips2 = b(2).YEndPoints;
    % 
    ax=gca;
    ax.FontSize = 12
    
    
    % xtips = 'BZ';
    % ytips = 'CZ';
    labels1 = string(round(b(1).YData,2)); %round to show only 2 digits after the point
    labels2 = string(round(b(2).YData,2)); %round to show only 2 digits after the point
    %b(1).FaceColor = [.3 0.9 .6]; %green
    text(xtips1,ytips1,labels1,'HorizontalAlignment','right',...
        'VerticalAlignment','bottom','FontSize',8, 'FontWeight','bold');
    text(xtips2,ytips2,labels2,'HorizontalAlignment','right','VerticalAlignment','bottom','FontSize',8, 'FontWeight','bold');

    Legend=legend('Not stimulated chamber','Stimulation-coupled chamber' , 'Location','bestoutside', 'FontSize',13); %'Max, Border Zone', 'Mean, Centre', 'Max, Centre','Location','bestoutside');

    
    if exist('Legend','var') ==1;
        set(Legend,'Interpreter','latex');
        set(gca,'FontSize',10);
    end
    


%ylabel(horzcat(S,',',VarStrUnit), FontSize=12);
%ylabel('Overall movement, cm', FontSize=12);
ylabel('Duration, s', FontSize=12);
           % % % % VarToAnalyse=NoDupesScaryData.Properties.VariableNames{i}; %reset VarToAnalyse
              minsStr=num2str(mins);
              %%%%xlabel('Stimulation', 'Position', 1.5);
              %xlabel({'Population','(in thousands)'})

   title(horzcat(VarStr,' in chamber,',VarStrUnit), FontSize=17);
   subtitle("No stimulation condition");

   %subtitle(horzcat('Duration of trial: ',minsStr,' mins'),'FontSize',13);

    if ~exist(fullfile(resdir,'Average plots',horzcat(num2str(mins),' mins')), 'dir');
       mkdir(fullfile(resdir,'Average plots',horzcat(num2str(mins),' mins')));
    end

    l=yline(50);
    l.Color=[0.6 0.6 0.6];
    l.LineWidth=3;
    l.LineStyle=":";

    setmyplot_balazs

Srepl='Duration',

    fnm = fullfile(resdir,'Average plots',CurrentSex,strcat(Srepl,'_Paired_NOStim_Duration',CurrentSex,num2str(mins),'Mins.png'));%fullfile(StatisticPlots, strcat(TypeOfTest,'_',ExperimentFolders{i},'_ZoneTransition_', nameFolds{h}, '.png'));
    fnm1 = fullfile(resdir,'Average plots',CurrentSex,strcat(Srepl,'_Paired_NOStim_Duration',CurrentSex,num2str(mins),'Mins.fig'));%fullfile(StatisticPlots, strcat(TypeOfTest,'_',ExperimentFolders{i},'_ZoneTransition_', nameFolds{h}, '.png'));
    fnm2 = fullfile(resdir,'Average plots',CurrentSex,strcat(Srepl,'_Paired_NOStim_Duration',CurrentSex,num2str(mins),'Mins.svg'));%fullfile(StatisticPlots, strcat(TypeOfTest,'_',ExperimentFolders{i},'_ZoneTransition_', nameFolds{h}, '.png'));

    saveas(F,fnm);
    saveas(F,fnm1);
    saveas(F,fnm2);
    
    close(F);

%end %of looping though variables

end %of looping through sexes

end 