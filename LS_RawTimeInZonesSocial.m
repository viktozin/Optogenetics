function [DurationInScaryZone,DurationInSafeZone,BoutData,ScaryBoutsDuration,SafeBoutsDuration,ScaryZoneMatrix ]=LS_RawTimeInZonesSocial(TypeOfTest, RawData,ScaryZoneSubstring,SafeZoneSubstring,FilePath,mins, AnimalName, ControlOrNot, StimulationIn, BoutData, resdir, CurrentStimulatedChamber,root,MergeCentreAndScaryZone)

% counts the number of bouts in the "scary" zone and calculates their
% duration for one trial of one animal

    VarDir=fullfile(root,'Variables');
    st = dbstack;
    namestr = st.name; %to get name of current function
    VarFilename=fullfile(VarDir,strcat(TypeOfTest,'_',num2str(mins),'mins','_',char(datetime("today","Format","dd-MMM-uuuu")),'_',namestr,'Beginning','.mat'));
    if ~exist(VarDir, 'dir')
        mkdir(VarDir);
    end
    save(VarFilename);

dbstop if error


% Extract the 3rd column (likely a cell array), in this case XCenter -
% the X position of the centre point of the animal
colData = RawData{:,3};

% Convert cell array of strings/numbers to numeric vector
numericCol = NaN(size(colData));
for i = 1:numel(colData)
    elem = colData(i);
    if isnumeric(elem)
        numericCol(i) = elem;
    elseif ischar(elem) || isstring(elem)
        numericCol(i) = str2double(strtrim(string(elem)));
    elseif iscell(elem)
        numericCol(i)=str2double(strtrim(string(elem{1})));
    else
        numericCol(i) = NaN;
    end
end

% Now find valid (non-NaN) rows
validIdx = ~isnan(numericCol);

% Filter table
RawData = RawData(validIdx, :);

if numel(RawData)==0
    keyboard
end

% % deleting NaNs
% validIdx = ~isnan(RawData{:,3});
% RawData=RawData(validIdx,:);

% F=figure
% if FilePath(end-5)=='7'
%     keyboard
% end

TrialTime=RawData.TrialTime; %TrialTime=RawData.TrialTime;
TrialTime=array2table(TrialTime);

%for scary zone:
ScaryZoneMatrix=zeros(200,4); % 2 column: time stamp when entered, 3rd: when left, 4th: how long the bout was
ScaryZoneMatrix(:,1)=1:200;

%%%%%%%%%%%% histogram bout hossz %%%%%%%%%%%%%%%%%%%%% vonal

VariablesInFile=RawData.Properties.VariableNames;
InScary_inx=(contains(VariablesInFile,ScaryZoneSubstring,'IgnoreCase',true))&(~contains(VariablesInFile,strcat('Transit', ScaryZoneSubstring),'IgnoreCase',true))&(contains(VariablesInFile,'niff','IgnoreCase',true));

if nnz(InScary_inx)==0
    keyboard
end

% try
%     InScaryOrNotColumn = RawData(:,InScary_inx);
% catch ME
%     disp('Error Message:')
%     disp(ME.message)
%     keyboard
% end
% InScaryOrNotColumn = RawData(:,InScary_inx);
InScaryOrNotColumnCell = RawData{:, InScary_inx};
InScaryOrNotColumn = NaN(size(InScaryOrNotColumnCell));

for i = 1:numel(InScaryOrNotColumnCell)
    if isa(InScaryOrNotColumnCell,'double')
        val = InScaryOrNotColumnCell(i);  % safely extract from cell %(i) changed to {i} 10.06.2025.
    elseif isa(InScaryOrNotColumnCell,'cell')
        val = InScaryOrNotColumnCell{i};  % safely extract from cell %(i) changed to {i} 10.06.2025.
    end
    
    if isnumeric(val)
        InScaryOrNotColumn(i) = val;
    elseif ischar(val) || isstring(val)
        InScaryOrNotColumn(i) = str2double(strtrim(string(val)));
    else
        InScaryOrNotColumn(i) = NaN;
        keyboard
    end
end % of for i = 1:numel(InScaryOrNotColumnCell)
%%%scary



% InScaryOrNotColumnnnn = 0.5 * (fillmissing(InScaryOrNotColumn, 'previous') + fillmissing(InScaryOrNotColumn, 'next')); %interpolates NaN values
%% ENTRY ZONE HANDLING for entry zone, which we call centre zone in LDB
    if contains(TypeOfTest,'Light', 'IgnoreCase',1) && MergeCentreAndScaryZone==0 % the second part gived permission to process CentreZone as a separate zone, not as part of Scary (light) zone
        CentreZoneSubstring= 'Entry';
        InCentre_inx=((contains(VariablesInFile,strcat('InZone_', CentreZoneSubstring),'IgnoreCase',true))&(~contains(VariablesInFile,strcat('Transit', CentreZoneSubstring),'IgnoreCase',true)));
        if nnz(InCentre_inx)==1; %so if such a column exists
            
         InCentreOrNotColumnCell = RawData{:, InScary_inx};
         InCentreOrNotColumn = NaN(size(InScaryOrNotColumnCell));

for i = 1:numel(InCentreOrNotColumnCell)
    if isa(InCentreOrNotColumnCell,'double')
        val = InCentreOrNotColumnCell(i);  % safely extract from cell %(i) changed to {i} 10.06.2025.
    elseif isa(InCentreOrNotColumnCell,'cell')
        val = InCentreOrNotColumnCell{i};  % safely extract from cell %(i) changed to {i} 10.06.2025.
    end
    
    if isnumeric(val)
        InCentreOrNotColumn(i) = val;
    elseif ischar(val) || isstring(val)
        InCentreOrNotColumn(i) = str2double(strtrim(string(val)));
    else
        InCentreOrNotColumn(i) = NaN;
    end
end % of for i = 1:numel(InScaryOrNotColumnCell)
        
        end
    end % of if contains(TypeOfTest,'Light', 'IgnoreCase',1) && MergeCentreAndScaryZone==0
%% END OF ENTRY ZONE HANDLING


%for safe zone:
SafeZoneMatrix=zeros(200,4);
SafeZoneMatrix(:,1)=1:200;

VariablesInFile=RawData.Properties.VariableNames;
InSafe_inx=((contains(VariablesInFile,strcat('InZone_', SafeZoneSubstring),'IgnoreCase',true))&(~contains(VariablesInFile,strcat('Transit', SafeZoneSubstring),'IgnoreCase',true)));

%InSafeOrNotColumn = RawData(:,InSafe_inx);
InSafeOrNotColumnCell = RawData{:,InSafe_inx};
InSafeOrNotColumn = NaN(size(InSafeOrNotColumnCell));  % Preallocate

for i = 1:numel(InSafeOrNotColumnCell)
    %val = InSafeOrNotColumnCell(i); %% safely extract from cell %(i) changed to {i} 10.06.2025.
    if isa(InSafeOrNotColumnCell,'double')
        val = InSafeOrNotColumnCell(i);  % safely extract from cell %(i) changed to {i} 10.06.2025.
    elseif isa(InSafeOrNotColumnCell,'cell')
        val = InSafeOrNotColumnCell{i};  % safely extract from cell %(i) changed to {i} 10.06.2025.
    end
        
    if isnumeric(val)
        InSafeOrNotColumn(i) = val;
    elseif ischar(val) || isstring(val)
        InSafeOrNotColumn(i) = str2double(strtrim(string(val)));
    else
        InSafeOrNotColumn(i) = NaN;  % For unexpected types
    end
end

%%%

% Step 1: Extract the original data column
TrialTime = RawData.TrialTime;

% Step 1: Fix first value if it cannot be converted to a number
firstElem = TrialTime(1);
if isnumeric(firstElem)
    firstVal = firstElem;
elseif ischar(firstElem) || isstring(firstElem)
    firstVal = str2double(strtrim(string(firstElem)));
else
    firstVal = NaN;
end

if isnan(firstVal)
    TrialTime{1} = 0;
end

% Step 2: Convert to numeric vector safely
numericTrialTime = NaN(size(TrialTime));
for i = 1:numel(TrialTime)
    elem = TrialTime(i);
    if isnumeric(elem)
        numericTrialTime(i) = elem;
    elseif ischar(elem) || isstring(elem);
        numericTrialTime(i) = str2double(strtrim(string(elem)));
    elseif iscell(elem)
        numericCol(i)=str2double(strtrim(string(elem{1})));
    else
        % For other types (empty cells, etc.), leave as NaN
        numericTrialTime(i) = NaN;
    end
end

% Step 3: Interpolate NaNs
nanIdx = isnan(numericTrialTime);
validIdx = ~nanIdx;
if any(validIdx)
    numericTrialTime(nanIdx) = interp1(find(validIdx), numericTrialTime(validIdx), find(nanIdx), 'linear', 'extrap');
end

% Final step: assign numeric vector back as double
TrialTime = num2cell(numericTrialTime);


%for debugging:
% plot(InSafeOrNotColumn, 1.5);
% bar(InSafeOrNotColumn, 1, 'grouped')
% histogram(InSafeOrNotColumn), 1, 'grouped'));
% InSafeOrNotColumnArray = table2array(InSafeOrNotColumn);
% bar(InSafeOrNotColumnArray, 1, 'FaceAlpha',0.5);
% set(gca,'ylim',[0 1.25]);
% set(gca,'xlim',[0 max(xlim)*1.1]);

%turn doubles back to cells:
% KELL????? 04.06.2025. %24.06.2025: needed to due syntaxis
% InScaryOrNotColumn{j,1}, otherwise {j,1} should be changed to (j)
if ~iscell(InScaryOrNotColumn);
    InScaryOrNotColumn = num2cell(InScaryOrNotColumn);
end

if ~iscell(InSafeOrNotColumn);
    InSafeOrNotColumn = num2cell(InSafeOrNotColumn);
end

if exist('InCentreOrNotColumn','var')==1
    if ~iscell(InCentreOrNotColumn);
        InCentreOrNotColumn = num2cell(InCentreOrNotColumn);
    end
end % of if exist('InCentreOrNotColumn','var')==1 &&


%%%  merging entry zone and light box was here, but was moved as a separate
%%%  function to LS_RawDataAnalysisMaster as [RawData] = MergeCentreAndScaryZoneFunction(RawData,CentreZoneSubstring,ScaryZoneSubstring)


%% the row-by-row analysis:
%%% SCARY ZONE: 
for j=1:size(RawData,1);
    if (j==305) || (j==13951);
        %keyboard originallz for debugging
    end
%for dealing with 0-0s before going on
if exist('InCentreOrNotColumn','var')==1;

    if InScaryOrNotColumn{j,1}==0 && InSafeOrNotColumn{j,1}==0 && InCentreOrNotColumn{j,1}==0;
        if j~=1
            if InScaryOrNotColumn{j-1,1}==1; 
                InScaryOrNotColumn{j,1}=1;
            elseif InSafeOrNotColumn{j-1,1}==1;
                InSafeOrNotColumn{j,1}=1;
            elseif InCentreOrNotColumn{j-1,1}==1;
                InCentreOrNotColumn{j,1}=1;
            end% 
        elseif j==1;
            keyboard
            if contains(TypeOfTest,'Light', 'IgnoreCase',1)

            end % of it 
        end
        disp(strcat('0 corrected in RawData row number__',string(j),'_in_InScaryOrNotColumn','__file:',FilePath));
    end
    
elseif exist('InCentreOrNotColumn','var')==0;
    
    if InScaryOrNotColumn{j,1}==0 && InSafeOrNotColumn{j,1}==0;
        if j~=1
            if InScaryOrNotColumn{j-1,1}==1; 
                InScaryOrNotColumn{j,1}=1;
            elseif InSafeOrNotColumn{j-1,1}==1;
                InSafeOrNotColumn{j,1}=1;
            end% 
        elseif j==1;
            keyboard % for debugging. This means the detection is wrong, animal is not detedted in any of the zones
            if contains(TypeOfTest,'Light', 'IgnoreCase',1)

            end % of it 
        end
        disp(strcat('0 corrected in RawData row number__',string(j),'_in_InScaryOrNotColumn','__file:',FilePath));
    end

end % of exist('InCentreOrNotColumn','var')==1;

    if InScaryOrNotColumn{j,1}==1 && j==1; %first row, and animal is in scary/right zone (=1 in column)
        ScaryZoneMatrix(j,2)=TrialTime{j,1}; %TimeOfEntry
        %continue
        %break %exists for
    elseif InScaryOrNotColumn{j,1}==1  && j~=1 && InScaryOrNotColumn{j-1,1}==0; %animal's position in zones changed
        Old_j=nnz(ScaryZoneMatrix(:,2));
        if Old_j==0;%new addition: 18042027 
            ScaryZoneMatrix(Old_j+1,2)=TrialTime{j,1}; %TimeOfEntry
            % if Old_j<1;
            %     disp('Error Message:') %...
            %     keyboard
            % end
        else
            ScaryZoneMatrix(Old_j+1,2)=TrialTime{j,1}; %TimeOfEntry
        end

        %continue
    end %of if InScaryOrNotColumn{1,i}==1...
    
   
    %case when the animal starts off NOT in Scary zone:
        %%% 19042024:
    if InScaryOrNotColumn{j,1}==0 && j==1; %animal is not in scary zone at beginning of trial
        %do nothing
        %ScaryZoneMatrix(j,2)=TrialTime{j,1}; %TimeOfEntry
        %keyboard
        %%%
    elseif InScaryOrNotColumn{j,1}==0  && j~=1 && InScaryOrNotColumn{j-1,1}==1; %used to be in scary/right zone, but now the animal left it (=0 in column)
        Old_j=nnz(ScaryZoneMatrix(:,2)); %to check how many rows have been populated
        %same as nnz: find(BoutMatrix(:,2),1,'last')
        if Old_j==0;%new addition: 18042024 
            %keyboard %ScaryZoneMatrix(Old_j,3)=TrialTime{j,1}; %TimeOfExit
            % if Old_j<1;
            %     disp('Error Message:') %220518 trial 3 - first 3 rows were NaN
            %     keyboard
            % end
        else
            ScaryZoneMatrix(Old_j,3)=TrialTime{j,1}; %TimeOfExit
        end
        %LengthOfStay=TimeOfExit-TimeOfEntry
    end % of if InScaryOrNotColumn{1,i}==0....
        %y=[y; value{i,:}];
end %of looping through rows of excel searching for 1 in scary zone (j loop)


%%% SAFE ZONE:  
for j=1:size(RawData,1); %looping through rows of excel searching for 1 in safe zone, resetting j
% if j==51765
%     keyboard
% end
if InScaryOrNotColumn{j,1}==0 && InSafeOrNotColumn{j,1}==0;
    if j~=1;
        if InScaryOrNotColumn{j-1,1}==1; 
            InScaryOrNotColumn{j,1}=1;
        elseif InSafeOrNotColumn{j-1,1}==1;
            InSafeOrNotColumn{j,1}=1;
        end% 
    elseif j==1;
        keyboard
    end
    disp(strcat('0 corrected in RawData row number__',string(j), '___',FilePath));
end

    if InSafeOrNotColumn{j,1}==1 && j==1 ;
        SafeZoneMatrix(j,2)=TrialTime{j,1}; %TimeOfEntry
        %continue
        %break %exists for
    elseif InSafeOrNotColumn{j,1}==1  && j~=1 && InSafeOrNotColumn{j-1,1}==0;
        Old_j=nnz(SafeZoneMatrix(:,2));
        if Old_j==0;%new addition: 18042024 
            SafeZoneMatrix(Old_j+1,2)=TrialTime{j,1}; %TimeOfEntry
            % % % if Old_j<1;
            % % %     disp('Error Message:') %220518 trial 3 - first 3 rows were NaN
            % % %     keyboard
            % % % end
        else
            SafeZoneMatrix(Old_j+1,2)=TrialTime{j,1}; %TimeOfEntry
        %continue
        end
    end %of if InScaryOrNotColumn{1,i}==1...
    
    if InSafeOrNotColumn{j,1}==0  && j~=1 && InSafeOrNotColumn{j-1,1}==1; %animal now left the safe zone

        Old_j=nnz(SafeZoneMatrix(:,2)); %to check how many rows have been populated
        %same as nnz: find(BoutMatrix(:,2),1,'last')
        if Old_j==0;%new addition: 18042024 
            % do nothiing? 240430 :
            % if Old_j<1;
            %     disp('Error Message:') %220518 trial 3 - first 3 rows were NaN
            %     keyboard
            % end
        else
            SafeZoneMatrix(Old_j,3)=TrialTime{j,1}; %TimeOfExit
        end

        %LengthOfStay=TimeOfExit-TimeOfEntry
    end % of if InScaryOrNotColumn{1,i}==0....
        %y=[y; value{i,:}];
end %of j, looping through rows of excel


        HowManyRowsPopulated=find(ScaryZoneMatrix(:,2),1,'last');
        ScaryZoneMatrix=ScaryZoneMatrix(1:HowManyRowsPopulated,:);


        if nnz(ScaryZoneMatrix(:,2))==0; %was not populated
            %do nothing ScaryZoneMatrix(1,3)=TrialTime{end,1};
        elseif nnz(ScaryZoneMatrix(:,2))>0; %was populated;
            if ScaryZoneMatrix(end,3)==0 ;
                %if exist('CentreZoneSubstring',' var') && CentreZoneMatrix(end,3)==0 && nnz(CentreZoneMatrix(:,2))>0;
                %ScaryZoneMatrix
                ScaryZoneMatrix(end,3)=TrialTime{end,1};
            end
        end % of checking if the matrix is empty


        ScaryZoneMatrix(:,4)=ScaryZoneMatrix(:,3)-ScaryZoneMatrix(:,2);  %TimeOfExit-TimeOfEntry %LengthOfStay; 
        if isempty(ScaryZoneMatrix)==0;
            if ScaryZoneMatrix(1,4)<=0; %#ok<VUNUS>
                disp('Negative time oops:')
                disp(ME.message)
                keyboard
            end
        end

        ScaryBoutsDuration=ScaryZoneMatrix(:,4)';;

        try DurationInScaryZone=sum(ScaryBoutsDuration);;
        catch (DurationInScaryZone>(mins*60))==1;
            disp('ScaryTime longer than trial time oops:')
            disp(ME.message)
            keyboard
        end

        if (DurationInScaryZone==0) && (contains(StimulationIn, ScaryZoneSubstring));
            DurationInSafeZone=0;
            SafeBoutsDuration=0;
    return %skip this animal
        end

        %safe
        HowManyRowsPopulated=find(SafeZoneMatrix(:,2),1,'last');
        SafeZoneMatrix=SafeZoneMatrix(1:HowManyRowsPopulated,:);

        if nnz(SafeZoneMatrix(:,2))==0; %was not populated
            %SafeZoneMatrix(1,3)=TrialTime{end,1};
        elseif nnz(SafeZoneMatrix(:,2))>0; %was populated;
            if SafeZoneMatrix(end,3)==0;
                %SafeZoneMatrix
                SafeZoneMatrix(end,3)=TrialTime{end,1};
            end
        end % of checking if the matrix is empty
        

        
        SafeZoneMatrix(:,4)=SafeZoneMatrix(:,3)-SafeZoneMatrix(:,2);  %TimeOfExit-TimeOfEntry %LengthOfStay; 
           
        if isempty(SafeZoneMatrix)==0;
            if SafeZoneMatrix(1,4)<0 ;
                disp('Negative time oops:') % this can happen due to a NaN
                keyboard
            end
        end


        SafeBoutsDuration=SafeZoneMatrix(:,4)';

        DurationInSafeZone=sum(SafeBoutsDuration);
        if DurationInSafeZone>(mins*60)+0.081;
            disp('SafeTime longer than trial time oops:')
            keyboard
        elseif (DurationInSafeZone==0) && (contains(StimulationIn, SafeZoneSubstring));
            DurationInScaryZone=0;
            return %skip this animal
        end

        
        %         break
%         continue %i=i+1;


%MetaBoutMatrix=[MetaBoutMatrix ; BoutMatrix]
% BoutMatrix(:,2)=[]
% BoutMatrix(:,2)=[]; %not redundant, needed for deleting the 3rd column which was shifted to second


% % % % % % % % % 
% % % % % % % % % %%%%centre
% % % % % % % % % if isempty(varargin)==0; %if centre exists
% % % % % % % % %     if strcmp('Zen',varargin{1});
% % % % % % % % %     CentreZoneSubstring=varargin{1};
% % % % % % % % %     else
% % % % % % % % %     end
% % % % % % % % %                
% % % % % % % % %         HowManyRowsPopulated=find(CentreZoneMatrix(:,2),1,'last');
% % % % % % % % %         CentreZoneMatrix=CentreZoneMatrix(1:HowManyRowsPopulated,:);
% % % % % % % % % 
% % % % % % % % % 
% % % % % % % % %         if nnz(CentreZoneMatrix(:,3))>0; %was populated;
% % % % % % % % %             if CentreZoneMatrix(end,3)==0 && SafeZoneMatrix(end,3)==0 && ScaryZoneMatrix(end,3)==0;
% % % % % % % % %                 %CentreZoneMatrix
% % % % % % % % %                 CentreZoneMatrix(end,3)=TrialTime{end,1};
% % % % % % % % %             end
% % % % % % % % %         elseif nnz(CentreZoneMatrix(:,3))==0 && SafeZoneMatrix(end,3)==0 && ScaryZoneMatrix(end,3)==0; %was not populated
% % % % % % % % %             CentreZoneMatrix(1,3)=TrialTime{end,1};
% % % % % % % % %         end % of checking if the matrix is empty
% % % % % % % % %         
% % % % % % % % %         try
% % % % % % % % %         CentreZoneMatrix(:,4)=CentreZoneMatrix(:,3)-CentreZoneMatrix(:,2);  %TimeOfExit-TimeOfEntry %LengthOfStay; 
% % % % % % % % %         catch CentreZoneMatrix(:,4)<=	0 ;
% % % % % % % % %             disp('Negtive time oops:')
% % % % % % % % %             disp(ME.message)
% % % % % % % % %             keyboard
% % % % % % % % %         end
% % % % % % % % %         %         break
% % % % % % % % % %         continue %i=i+1;
% % % % % % % % % 
% % % % % % % % % 
% % % % % % % % % %MetaBoutMatrix=[MetaBoutMatrix ; BoutMatrix]
% % % % % % % % % % BoutMatrix(:,2)=[]
% % % % % % % % % % BoutMatrix(:,2)=[]; %not redundant, needed for deleting the 3rd column which was shifted to second
% % % % % % % % % 
% % % % % % % % % CentreBoutsDuration=CentreZoneMatrix(:,4)';
% % % % % % % % % 
% % % % % % % % % DurationInCentreZone=sum(CentreBoutsDuration);
% % % % % % % % %         if DurationInCentreZone>(mins*60)+0.08;
% % % % % % % % %             disp('CentreTime longer than trial time oops:')
% % % % % % % % %             keyboard
% % % % % % % % %         end
% % % % % % % % % else
% % % % % % % % %         DurationInCentreZone=[];
% % % % % % % % % end %of processing in case of centre zone


%keyboard

if exist('DurationInScaryZone','var')==0;
    keyboard
end

if exist('DurationInSafeZone','var')==0;
    keyboard
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BOUTS

ScaryBoutsDuration=ScaryZoneMatrix(:,4)';;
SafeBoutsDuration=SafeZoneMatrix(:,4)';
col=size(BoutData,2); %how many columns are already filled
InScaryOrNotColumnArray = table2array(InScaryOrNotColumn);
BoutData(:,col+1)={char(AnimalName); CurrentStimulatedChamber{:}; StimulationIn; ControlOrNot; [ScaryBoutsDuration]; [SafeBoutsDuration]; [ScaryZoneMatrix]; [InScaryOrNotColumnArray]}'; %ITT


end % of function