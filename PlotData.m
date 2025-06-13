function PlotData(root, resdir, NoDupesSafeData,NoDupesScaryData, mins, TypeOfTest, ScaryZoneSubstring, SafeZoneSubstring, Table)

% Data=readtable("D:\LS\OFT_constab_forMITT.xlsx"','Sheet','10 mins');

dbstop if error
% ScarySubstring=ScaryZoneSubstring;
% SafeSubstring=SafeZoneSubstring;

% ScaryZoneSubstring=ScarySubstring;
% SafeZoneSubstring=SafeSubstring;

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

for i=10:length(NoDupesScaryData.Properties.VariableNames);

    VarToAnalyse=NoDupesScaryData.Properties.VariableNames{i};
    
    if contains(VarToAnalyse,'Perc');
    %keyboard
    end
    
    ScaryGFP=ScaryGFPData{:,i};
    ScaryChR2=ScaryChR2Data{:,i};
    SafeGFP=SafeGFPData{:,i};
    SafeChR2=SafeChR2Data{:,i};
    
    % y = [mean(GFP) mean(ChR2)];%[NoDupesScaryData.DurationInScaryZone NoDupesSafeData.DurationInScaryZone];
    
    
      
    F=figure();
    x = categorical(["GFP", "ChR2"]); %2;% how many groups
    y=[median(ScaryGFP) median(ScaryChR2);median(SafeGFP) median(SafeChR2)];
    


            MaxValues=[max(ScaryGFP(:)),max(ScaryChR2(:)),max(SafeGFP(:)),max(SafeChR2(:))];
    Max=max(MaxValues);
            MinValues=[min(ScaryGFP(:)),min(ScaryChR2(:)),min(SafeGFP(:)),min(SafeChR2(:))];
    Min=min(MinValues);

    

    
b=bar(y);

    hold on
    b(1).FaceColor=[0.4660, 0.9, 0.4880];% [0.3660, 0.9, 0.4880];
    b(2).FaceColor=[0.3010 0.7450 0.9330];
    
    % % % hold on; % plot multiple things without clearing the axes
    % % % b=bar( x, y, 0.4 ); % bar of the means
    
    scatter(repmat(b(1).XEndPoints(1), length(ScaryGFP), 1),ScaryGFP,70,'MarkerFaceColor',[0.0, 0.6, 0.45],'MarkerEdgeColor','k','LineWidth',1);
    scatter(repmat(b(1).XEndPoints(2), length(SafeGFP), 2),SafeGFP,70,'MarkerFaceColor',[0.0, 0.6, 0.45],'MarkerEdgeColor','k','LineWidth',1);
    scatter(repmat(b(2).XEndPoints(1), length(ScaryChR2), 1),ScaryChR2,70,'MarkerFaceColor','b','MarkerEdgeColor','k','LineWidth',1);
    scatter(repmat(b(2).XEndPoints(2), length(SafeChR2), 2),SafeChR2,70,'MarkerFaceColor','b','MarkerEdgeColor','k','LineWidth',1);
    
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

       xticklabels([strcat(ScaryZone," Condition") strcat(SafeZone, " Condition")]); %commented out 06.07.2024
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

S  = VarToAnalyse;
 

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


   % ylabel(strcat(VarStr,',  ',VarStrUnit), FontSize=15);
           % % % % VarToAnalyse=NoDupesScaryData.Properties.VariableNames{i}; %reset VarToAnalyse


    
    xtips1 = b(1).XEndPoints;
    ytips1 = b(1).YEndPoints;
    
    xtips2 = b(2).XEndPoints;
    ytips2 = b(2).YEndPoints;

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


    
    ax=gca;
    ax.FontSize = 12;
    
    
    %NumOfAnimals=size(NoDupesSafeData,2);
    Legend=legend(strcat('GFP N=',num2str(length(ScaryGFP))) ,strcat('ChR2 N=',num2str(length(ScaryChR2))) , 'Location','bestoutside', 'FontSize',13); %'Max, Border Zone', 'Mean, Centre', 'Max, Centre','Location','bestoutside');
       
    %Legend=legend(horzcat('GFP ',' ') ,horzcat('ChR2 ',' '), 'Location','bestoutside', 'FontSize',13); %'Max, Border Zone', 'Mean, Centre', 'Max, Centre','Location','bestoutside');
        %end
    % if size(y,2)>2
    %     Legend=legend(ScaryZone, CentreZone, SafeZone, 'Location','bestoutside')
    % end
    
    if exist('Legend','var') ==1;
        set(Legend,'Interpreter','latex');
        set(gca,'FontSize',10);
    end
    


ylabel(horzcat(VarStr,',',VarStrUnit), 'FontSize', '12');
           % % % % VarToAnalyse=NoDupesScaryData.Properties.VariableNames{i}; %reset VarToAnalyse
              minsStr=num2str(mins);
              %%%%xlabel('Stimulation', 'Position', 1.5);
              %xlabel({'Population','(in thousands)'})

   title(horzcat(VarStr,',',VarStrUnit), 'FontSize','17');
   
   subtitle(strcat('Duration of trial: ',minsStr,' mins'), 'FontSize',13);

   setmyplot_balazs;

    if ~exist(fullfile(resdir,'Average plots',horzcat(num2str(mins),' mins')), 'dir');
       mkdir(fullfile(resdir,'Average plots',horzcat(num2str(mins),' mins')));
    end

    fnm = fullfile(resdir,'Average plots',strcat(Srepl,'_',num2str(mins),'Mins.png'));%fullfile(StatisticPlots, strcat(TypeOfTest,'_',ExperimentFolders{i},'_ZoneTransition_', nameFolds{h}, '.png'));
    fnm1 = fullfile(resdir,'Average plots',strcat(Srepl,'_',num2str(mins),'Mins.fig'));%fullfile(StatisticPlots, strcat(TypeOfTest,'_',ExperimentFolders{i},'_ZoneTransition_', nameFolds{h}, '.png'));
    fnm2 = fullfile(resdir,'Average plots',strcat(Srepl,'_',num2str(mins),'Mins.svg'));%fullfile(StatisticPlots, strcat(TypeOfTest,'_',ExperimentFolders{i},'_ZoneTransition_', nameFolds{h}, '.png'));

    saveas(F,fnm);
    saveas(F,fnm1);
    saveas(F,fnm2);
    
    close(F);

end %of looping though variables

end