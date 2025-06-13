function PlotDataOptogenwAnimalNames(root, resdir, NoDupesSafeData, NoDupesScaryData, mins, TypeOfTest, ScaryZoneSubstring, SafeZoneSubstring, Table)
% Plots boxplots of animal data with animal names next to each dot.

dbstop if error

% Extract groups
ScaryGFPIndex = cell2mat(cellfun(@(x) contains(x,'Control'), NoDupesScaryData.ControlOrNot, 'UniformOutput', 0));
ScaryGFPData = NoDupesScaryData(ScaryGFPIndex,:);

ScaryChR2Index = cell2mat(cellfun(@(x) contains(x,'Treated'), NoDupesScaryData.ControlOrNot, 'UniformOutput', 0));
ScaryChR2Data = NoDupesScaryData(ScaryChR2Index,:);

SafeGFPIndex = cell2mat(cellfun(@(x) contains(x,'Control'), NoDupesSafeData.ControlOrNot, 'UniformOutput', 0));
SafeGFPData = NoDupesSafeData(SafeGFPIndex,:);

SafeChR2Index = cell2mat(cellfun(@(x) contains(x,'Treated'), NoDupesSafeData.ControlOrNot, 'UniformOutput', 0));
SafeChR2Data = NoDupesSafeData(SafeChR2Index,:);

% Column name for animal names (change if different in your table)
animal_col = 'AnimalName';

for i = 10:length(NoDupesScaryData.Properties.VariableNames)
    VarToAnalyse = NoDupesScaryData.Properties.VariableNames{i};

    ScaryGFP = ScaryGFPData{:,i};
    ScaryChR2 = ScaryChR2Data{:,i};
    SafeGFP = SafeGFPData{:,i};
    SafeChR2 = SafeChR2Data{:,i};

    % Use cell array of char (compatible with any table column type)
    ScaryGFP_names = ScaryGFPData.(animal_col);
    ScaryChR2_names = ScaryChR2Data.(animal_col);
    SafeGFP_names = SafeGFPData.(animal_col);
    SafeChR2_names = SafeChR2Data.(animal_col);

    % Stack data and group info for boxplot
    allData = [ScaryGFP(:); SafeGFP(:); ScaryChR2(:); SafeChR2(:)];
    group = [ones(size(ScaryGFP)); ...
         2*ones(size(SafeGFP)); ...
         3*ones(size(ScaryChR2)); ...
         4*ones(size(SafeChR2))];

    F = figure();
    boxplot(allData, group, 'Labels', {'ScarymCherry', 'SafemCherry', 'ScaryhM3Dq', 'SafehM3Dq'});
    hold on

    % lines for joining individual animals in each genotype
% Join paired GFP animals by animal name
for k = 1:length(ScaryGFP)
    this_name = ScaryGFP_names{k};
    idx = find(strcmp(this_name, SafeGFP_names));
    if ~isempty(idx)
        plot([1 2], [ScaryGFP(k) SafeGFP(idx)], 'Color', [0.5 0.8 0.5], 'LineStyle', '--', 'LineWidth', 1);
    end
end

% Join paired ChR2 animals by animal name
for k = 1:length(ScaryChR2)
    this_name = ScaryChR2_names{k};
    idx = find(strcmp(this_name, SafeChR2_names));
    if ~isempty(idx)
        plot([3 4], [ScaryChR2(k) SafeChR2(idx)], 'Color', [0.5 0.5 1], 'LineStyle', '--', 'LineWidth', 1);
    end
end

% Offset for animal names so they don't overlap points
dx = 0.08;

% --- ScaryGFP (x=1) ---
scatter(1*ones(size(ScaryGFP)), ScaryGFP, 70, ...
    'MarkerFaceColor', [0.0, 0.6, 0.45], ...
    'MarkerEdgeColor', 'k', ...
    'LineWidth', 1);
for k = 1:length(ScaryGFP)
    text(1+dx, ScaryGFP(k), ScaryGFP_names{k}, ...
        'FontSize', 8, ...
        'Color', [0 0.5 0], ...
        'HorizontalAlignment', 'left', ...
        'Interpreter', 'none');
end

% --- SafeGFP (x=2) ---
scatter(2*ones(size(SafeGFP)), SafeGFP, 70, ...
    'MarkerFaceColor', [0.0, 0.6, 0.45], ...
    'MarkerEdgeColor', 'k', ...
    'LineWidth', 1);
for k = 1:length(SafeGFP)
    text(2+dx, SafeGFP(k), SafeGFP_names{k}, ...
        'FontSize', 8, ...
        'Color', [0 0.5 0], ...
        'HorizontalAlignment', 'left', ...
        'Interpreter', 'none');
end

% --- ScaryChR2 (x=3) ---
scatter(3*ones(size(ScaryChR2)), ScaryChR2, 70, ...
    'MarkerFaceColor', 'b', ...
    'MarkerEdgeColor', 'k', ...
    'LineWidth', 1);
for k = 1:length(ScaryChR2)
    text(3+dx, ScaryChR2(k), ScaryChR2_names{k}, ...
        'FontSize', 8, ...
        'Color', 'b', ...
        'HorizontalAlignment', 'left', ...
        'Interpreter', 'none');
end

% --- SafeChR2 (x=4) ---
scatter(4*ones(size(SafeChR2)), SafeChR2, 70, ...
    'MarkerFaceColor', 'b', ...
    'MarkerEdgeColor', 'k', ...
    'LineWidth', 1);
for k = 1:length(SafeChR2)
    text(4+dx, SafeChR2(k), SafeChR2_names{k}, ...
        'FontSize', 8, ...
        'Color', 'b', ...
        'HorizontalAlignment', 'left', ...
        'Interpreter', 'none');
end


    hold off

    % Set y-axis label based on variable name
    S = VarToAnalyse;
    if contains(S, 'cary')
        Srepl = strrep(S, 'ScaryZone', 'Scary');
    elseif contains(S, 'afe')
        Srepl = strrep(S, 'SafeZone', 'Safe');
    else
        Srepl = VarToAnalyse;
    end

    up = isstrprop(Srepl, 'upper');
    VarStr = blanks(length(Srepl) + sum(up));
    VarStr(cumsum(up + 1)) = lower(Srepl);

    VarStr = [upper(VarStr(1)), lower(VarStr(2:end))];

    if ~isempty(strfind(VarStr, 'uration'))
        VarStrUnit = ' s';
    elseif ~isempty(strfind(VarStr, 'ove'))
        VarStrUnit = ' cm';
    elseif ~isempty(strfind(VarStr, 'elo'))
        VarStrUnit = ' cm/s';
    elseif ~isempty(strfind(VarStr, 'req'))
        VarStrUnit = ' #';
    elseif ~isempty(strfind(VarStr, 'cent')) || ~isempty(strfind(VarStr, 'atio'))
        VarStrUnit = ' %';
    else
        VarStrUnit = '';
    end

    ylabel([VarStr, ', ', VarStrUnit], 'FontSize', 12);

title([VarStr, ', ', VarStrUnit], 'FontSize', 22, 'Units', 'normalized', 'Position', [0.5, 1.08, 0]);

minsStr = num2str(mins);
    ax = gca;
    ax.FontSize = 12;

text(0.5, 1.14, ['Duration of trial: ', minsStr, ' mins'], ...
    'Units', 'normalized', 'HorizontalAlignment', 'center', 'FontSize', 13, 'Parent', ax);


    % Save
    avgPlotDir = fullfile(resdir, 'Average plots', [num2str(mins), ' mins']);
    if ~exist(avgPlotDir, 'dir')
        mkdir(avgPlotDir);
    end
    fnm = fullfile(avgPlotDir, [Srepl, '_', num2str(mins), 'Mins.png']);
    fnm1 = fullfile(avgPlotDir, [Srepl, '_', num2str(mins), 'Mins.fig']);
    fnm2 = fullfile(avgPlotDir, [Srepl, '_', num2str(mins), 'Mins.svg']);

    saveas(F, fnm);
    saveas(F, fnm1);
    saveas(F, fnm2);

    close(F);
end

end