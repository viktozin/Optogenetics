function PlotSingleSexData(root, resdir, NoDupesSafeData,NoDupesScaryData, mins, TypeOfTest, ScaryZoneSubstring, SafeZoneSubstring)

% Data=readtable("D:\LS\OFT_constab_forMITT.xlsx"','Sheet','10 mins');
Sexes={'Male', 'Female'};

for i=1:length(Sexes);
    CurrentSex='Female' %Sexes{i}; %'Female';
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



for i=10:length(NoDupesScaryData.Properties.VariableNames);

    VarToAnalyse=NoDupesScaryData.Properties.VariableNames{i};
    
    ScarySexGFP=ScarySexGFPData{:,i};
    ScarySexChR2=ScarySexChR2Data{:,i};
    SafeSexGFP=SafeSexGFPData{:,i};
    SafeSexChR2=SafeSexChR2Data{:,i};
    
    % y = [mean(GFP) mean(ChR2)];%[NoDupesScaryData.DurationInScaryZone NoDupesSafeData.DurationInScaryZone];
    
    
      
    F=figure();
    x = categorical(["GFP", "ChR2"]); %2;% how many groups
    y=[median(ScarySexGFP) median(ScarySexChR2);median(SafeSexGFP) median(SafeSexChR2)];

        MaxValues=[max(ScarySexGFP(:)),max(ScarySexChR2(:)),max(SafeSexGFP(:)),max(SafeSexChR2(:))];
    Max=max(MaxValues);
        MinValues=[min(ScarySexGFP(:)),min(ScarySexChR2(:)),min(SafeSexGFP(:)),min(SafeSexChR2(:))];
    Min=min(MinValues);

    
    b=bar(y);
    
    hold on
    if strcmp(CurrentSex,'Male');
        b(1).FaceColor=[0.4660, 0.9, 0.4880];% [0.3660, 0.9, 0.4880]; %pink
        b(2).FaceColor=[0.3010 0.7450 0.9330];
    else %if female
        b(1).FaceColor=[0.4660, 0.9, 0.4880];% [0.3660, 0.9, 0.4880]; %pink
        b(2).FaceColor=[0.95 0.5 0.55];
           
    end
    
    % % % hold on; % plot multiple things without clearing the axes
    % % % b=bar( x, y, 0.4 ); % bar of the means
    if strcmp(CurrentSex,'Male');
    
        scatter(repmat(b(1).XEndPoints(1), length(ScarySexGFP), 1),ScarySexGFP,70,'MarkerFaceColor',[0.0, 0.6, 0.45],'MarkerEdgeColor','k','LineWidth',1);
        scatter(repmat(b(1).XEndPoints(2), length(SafeSexGFP), 2),SafeSexGFP,70,'MarkerFaceColor',[0.0, 0.6, 0.45],'MarkerEdgeColor','k','LineWidth',1);
        scatter(repmat(b(2).XEndPoints(1), length(ScarySexChR2), 1),ScarySexChR2,70,'MarkerFaceColor','b','MarkerEdgeColor','k','LineWidth',1);
        scatter(repmat(b(2).XEndPoints(2), length(SafeSexChR2), 2),SafeSexChR2,70,'MarkerFaceColor','b','MarkerEdgeColor','k','LineWidth',1);
        
    elseif contains(CurrentSex,'Female','IgnoreCase',true); %IF FEMALE

        scatter(repmat(b(1).XEndPoints(1), length(ScarySexGFP), 1),ScarySexGFP,70,'MarkerFaceColor',[0.0, 0.6, 0.45],'MarkerEdgeColor','k','LineWidth',1);
        scatter(repmat(b(1).XEndPoints(2), length(SafeSexGFP), 2),SafeSexGFP,70,'MarkerFaceColor',[0.0, 0.6, 0.45],'MarkerEdgeColor','k','LineWidth',1);
        scatter(repmat(b(2).XEndPoints(1), length(ScarySexChR2), 1),ScarySexChR2,70,'MarkerFaceColor','r','MarkerEdgeColor','k','LineWidth',1);
        scatter(repmat(b(2).XEndPoints(2), length(SafeSexChR2), 2),SafeSexChR2,70,'MarkerFaceColor','r','MarkerEdgeColor','k','LineWidth',1);
     
    else
        keyboard
    end 
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
        SafeZone ='No Stimulation';
        ScaryZone ='Stimulation';

    end


    %set(gca(),'XTickLabel',{ScaryZone SafeZone sprintf('\\newlinecomposite')});


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

  %%%%%%%%%%%%%%%  ylabel(VarToAnalyse, FontSize=15);
           % % % % VarToAnalyse=NoDupesScaryData.Properties.VariableNames{i}; %reset VarToAnalyse


    
    xtips1 = b(1).XEndPoints;
    ytips1 = b(1).YEndPoints;
    
    xtips2 = b(2).XEndPoints;
    ytips2 = b(2).YEndPoints;
    
    ax=gca;
    ax.FontSize = 12;
    
    
    % xtips = 'BZ';
    % ytips = 'CZ';
    labels1 = string(round(b(1).YData,2)); %round to show only 2 digits after the point
    labels2 = string(round(b(2).YData,2)); %round to show only 2 digits after the point
    b(1).FaceColor = [.3 0.9 .6]; %green
    text(xtips1,ytips1,labels1,'HorizontalAlignment','right',...
        'VerticalAlignment','bottom','FontSize',8, 'FontWeight','bold');
    text(xtips2,ytips2,labels2,'HorizontalAlignment','right',...
        'VerticalAlignment','bottom','FontSize',8, 'FontWeight','bold');
    %Legend=legend('Mean, Border Zone', 'Max, Border Zone', 'Mean, Centre', 'Max, Centre','Location','bestoutside');
    %if size(y,2)>1
   
   Legend=legend(strcat('GFP N=',num2str(length(ScarySexGFP))), strcat('ChR2 N=',num2str(length(ScarySexChR2))), 'Location','bestoutside', 'FontSize',13); %'Max, Border Zone', 'Mean, Centre', 'Max, Centre','Location','bestoutside');
   %Legend=legend('GFP' ,'ChR2', 'Location','bestoutside', 'FontSize',13); %'Max, Border Zone', 'Mean, Centre', 'Max, Centre','Location','bestoutside'); 
   
    try ylim([-3 Max*1.05]); %(Max*1.10)]);%(Max*1.05)]);
    catch ME
        keyboard
    end

   NumOfGFPAnimals=length(ScarySexGFP);
   NumOfChR2Animals=length(ScarySexChR2);
   
 %Legend=legend(strcat('GFP', ' N=',num2str(NumOfGFPAnimals)) ,strcat('ChR2', ' N=',num2str(NumOfChR2Animals)) , 'Location','bestoutside', 'FontSize',13); %'Max, Border Zone', 'Mean, Centre', 'Max, Centre','Location','bestoutside');
    %end
        
        %end

    % if size(y,2)>2
    %     Legend=legend(ScaryZone, CentreZone, SafeZone, 'Location','bestoutside')
    % end
    
    if exist('Legend','var') ==1;
        set(Legend,'Interpreter','latex');
        set(gca,'FontSize',10);
    end
    

    minsStr=num2str(mins);


       xticklabels([strcat(ScaryZone," Condition") strcat(SafeZone, " Condition")]);
    %%%%% HUN xticklabels(["Stimuláció nyílt karokban" "Stimuláció zárt karokban"]);


    a = get(gca,'XTickLabel');  
    set(gca,'XTickLabel',a,'fontsize',12,'FontWeight','bold');


S  = VarToAnalyse;

if contains(S, 'cary');
    Srepl=replace(S, 'ScaryZone', ScaryZone);
elseif contains(S, 'afe');
    Srepl=replace(S, 'SafeZone', SafeZone);
elseif contains(S, 'ver');
    Srepl=S;
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


ylabel(horzcat(VarStr,', ',VarStrUnit), FontSize=12);
           % % % % VarToAnalyse=NoDupesScaryData.Properties.VariableNames{i}; %reset VarToAnalyse
          %  xlabel('Stimulation', 'Position', 0.5);

              minsStr=horzcat(' ',num2str(mins));

   title(horzcat(VarStr,',',VarStrUnit), FontSize=17);
   subtitle(horzcat('Duration of trial:',num2str(mins),' mins. ', CurrentSex,'s'), 'FontSize',13);

setmyplot_balazs;

    fnm = strcat(fullfile(resdir,'Average plots',CurrentSex),'\',VarToAnalyse,'_',minsStr,CurrentSex,'Mins.png');%fullfile(StatisticPlots, strcat(TypeOfTest,'_',ExperimentFolders{i},'_ZoneTransition_', nameFolds{h}, '.png'));
    fnm1 = strcat(fullfile(resdir,'Average plots',CurrentSex),'\',VarToAnalyse,'_',minsStr,CurrentSex,'Mins.fig');%fullfile(StatisticPlots, strcat(TypeOfTest,'_',ExperimentFolders{i},'_ZoneTransition_', nameFolds{h}, '.png'));
    fnm2 = strcat(fullfile(resdir,'Average plots',CurrentSex),'\',VarToAnalyse,'_',minsStr,CurrentSex,'Mins.svg');%fullfile(StatisticPlots, strcat(TypeOfTest,'_',ExperimentFolders{i},'_ZoneTransition_', nameFolds{h}, '.png'));
  
    if ~exist((fullfile(resdir,'Average plots',CurrentSex)), 'dir');
       mkdir(fullfile(resdir,'Average plots',CurrentSex));
    end

    saveas(F,fnm);
    saveas(F,fnm1);
    saveas(F,fnm2);
    
    close(F);

end %of looping though variables

end %of looping through Sexes
end