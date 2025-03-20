function f_run_QualityControl(derivativesDir, denoiseName)
%
%
%% Load iEEG data
    % Load Preprocessing pipeline setting and iEEG file infomation
    denoiseDir = dir(fullfile(derivativesDir, '**', denoiseName));
    prepFolder = denoiseDir.folder;
    tempstr = f_strsplit(denoiseName, '_');
    SubjectID = tempstr{1};
    tempstr(end-1) = [];
    tempstr{end} = 'setting.mat';
    SettingName = join(tempstr, '_');
    if iscell(SettingName)
        SettingName = SettingName{1};
    end
    Setting = load(fullfile(prepFolder, SettingName));
    iEEGFileInfo = Setting.Setting.iEEGFileInfo;
    % Load Channel Table, miniPrep data, denoise data and noise data
    ChannelTable = load(fullfile(prepFolder, [SubjectID, '_channel.mat']));
    ChannelTable = ChannelTable.ChannelTable;
    % Load miniPrep data
    miniPrepName = iEEGFileInfo.miniPrepName;
    miniPrepDir = dir(fullfile(prepFolder, '**', miniPrepName));
    miniPrepData = load(fullfile(miniPrepDir.folder, miniPrepDir.name));
    miniPrepData = miniPrepData.Data;
    miniPrepData = f_iEEGnomScale(miniPrepData);
    % Load denoise Data
    denoiseData = load(fullfile(denoiseDir.folder, denoiseDir.name));
    denoiseData = denoiseData.Data;
    denoiseData = f_iEEGnomScale(denoiseData);
    % Load noise data
    if isfield(iEEGFileInfo, 'IEDName')
        IEDName = iEEGFileInfo.IEDName;
        IEDs = load(fullfile(prepFolder, IEDName));
        IEDs = IEDs.IEDs;
    end
    if isfield(iEEGFileInfo, 'rHFOName')
        rHFOName = iEEGFileInfo.rHFOName;
        rHFOs = load(fullfile(prepFolder, rHFOName));
        rHFOs = rHFOs.rHFOs;
    end
    if isfield(iEEGFileInfo, 'frHFOName')
        frHFOName = iEEGFileInfo.frHFOName;
        frHFOs = load(fullfile(prepFolder, frHFOName));
        frHFOs = frHFOs.frHFOs;
    end
%% Create QC figure
    QCfigure = f_QCfigure_step1_initPanel;
    QCfigure.UserData.miniPrep.iEEGData = miniPrepData;
    QCfigure.UserData.denoise.iEEGData = denoiseData;
    if exist('IEDs', 'var')
        QCfigure.UserData.IEDs = IEDs;
    end
    if exist('rHFOs', 'var')
        QCfigure.UserData.rHFOs = rHFOs;
    end
    if exist('frHFOs', 'var')
        QCfigure.UserData.frHFOs = frHFOs;
    end
%% Initial setting for show QC figure
    QCfigure.UserData.figcfg.currentTrial = 1;
    QCfigure.UserData.figcfg.currentSegment = 1;
    QCfigure.UserData.figcfg.winWidth = 1;
    QCfigure.UserData.figcfg.voltageScale = 1;
    N = 0;
    for chanN = 1:length(ChannelTable.channel)
        if strcmp(ChannelTable.goodORbad{chanN}, 'good')
              N = N+1;
              QCfigure.UserData.figcfg.channel{N} = ChannelTable.channel{chanN};
        end
    end
%% Plot miniPrep iEEG data
    

    miniPrep_figcfg = QCfigure.UserData.(iEEGName).figcfg;
    iEEGAxes = QCfigure.UserData.(iEEGName).iEEGAxes;
    % selected the checked channel
    chanLabel = iEEGAxes.channelLabel;
    checkedChan = QCfigure.UserData.checkedChannels;
    yesChan = zeros(size(chanLabel));
    for ii_channel = 1:length(chanLabel)
        tempcmp = sum(strcmp(checkedChan, chanLabel{ii_channel}));
        if tempcmp == 1
            yesChan(ii_channel) = 1;
        end
    end
    selectedChannel = chanLabel(yesChan==1);
    % set the x for plot
    x = iEEGAxes.x;
    % set the y for plot
    y = iEEGAxes.y(yesChan==1, :);
    voltageScale = miniPrep_figcfg.voltageScale;
    y  = y .* voltageScale;
    yPos(:, 1) = 1:size(y, 1);
    y = y + yPos;
    % plot the noise highlight
    YLim = [0, min([size(y, 1)+1, max(max(y))])];
    figAxes = findall(QCfigure, 'Type', 'axes', 'Tag', iEEGName);
    delete(findobj(figAxes, 'Type', 'line'));
    noiseHighlightBegin_x = miniPrep_figcfg.noiseHighlightBegin_x;
    noiseHighlightEnd_x = miniPrep_figcfg.noiseHighlightEnd_x;
    noiseCount = length(noiseHighlightBegin_x);
    for ii_noise = 1:noiseCount
        line(figAxes, [noiseHighlightBegin_x(ii_noise), noiseHighlightBegin_x(ii_noise)], YLim, 'Color', [0, 1, 0], 'LineStyle', '--', 'LineWidth', 0.5, 'Tag', 'noise');
        line(figAxes, [noiseHighlightEnd_x(ii_noise), noiseHighlightEnd_x(ii_noise)], YLim, 'Color', [0, 1, 0], 'LineStyle', '--', 'LineWidth', 0.5, 'Tag', 'noise');
        line(figAxes, [noiseHighlightBegin_x(ii_noise), noiseHighlightEnd_x(ii_noise)], [YLim(1), YLim(1)], 'Color', [0, 1, 0], 'LineStyle', '--', 'LineWidth', 0.5, 'Tag', 'noise');
        line(figAxes, [noiseHighlightBegin_x(ii_noise), noiseHighlightEnd_x(ii_noise)], [YLim(2), YLim(2)], 'Color', [0, 1, 0], 'LineStyle', '--', 'LineWidth', 0.5, 'Tag', 'noise');
    end
    curNoiseBegin_x = miniPrep_figcfg.curNoiseBegin_x;
    curNoiseEnd_x = miniPrep_figcfg.curNoiseEnd_x;
    line(figAxes, [curNoiseBegin_x, curNoiseBegin_x], YLim, 'Color', [1, 0, 0], 'LineStyle', '--', 'LineWidth', 0.5, 'Tag', 'noise');
    line(figAxes, [curNoiseEnd_x, curNoiseEnd_x], YLim, 'Color', [1, 0, 0], 'LineStyle', '--', 'LineWidth', 0.5, 'Tag', 'noise');
    line(figAxes, [curNoiseBegin_x, curNoiseEnd_x], [YLim(1), YLim(1)], 'Color', [1, 0, 0], 'LineStyle', '--', 'LineWidth', 0.5, 'Tag', 'noise');
    line(figAxes, [curNoiseBegin_x, curNoiseEnd_x], [YLim(2), YLim(2)], 'Color', [1, 0, 0], 'LineStyle', '--', 'LineWidth', 0.5, 'Tag', 'noise');
    % plot the signal
    for ii_line = 1:size(y, 1)
        line(figAxes, x, y(ii_line, :), 'Color', [0, 0, 0], 'LineStyle', '-', 'LineWidth', 0.5, 'Tag', selectedChannel{ii_line});
    end
    figAxes.YLim = YLim;
    figAxes.XLim = [x(1), x(end)];
    % plot the noise signal
    EventX_index = find(x>=curNoiseBegin_x & x<=curNoiseEnd_x);
    EventX = x(EventX_index);
    EventChannelLabel_curNoise = miniPrep_figcfg.EventChannelLabel_curNoise;
    EventChannelIndex = zeros(size(selectedChannel));
    for ii_channel = 1:length(selectedChannel)
        temcmp = sum(strcmp(EventChannelLabel_curNoise, selectedChannel{ii_channel}));
        if temcmp == 1
            EventChannelIndex(ii_channel) = 1;
        end
    end
    EventY = y(EventChannelIndex==1, EventX_index);
    for ii_line = 1:size(EventY, 1)
        line(figAxes, EventX, EventY(ii_line, :), 'Color', [1, 0, 0], 'LineStyle', '-', 'LineWidth', 0.5, 'Tag', 'noise');
    end
    % set the axes title
    curTrial = miniPrep_figcfg.currentTrial;
    trialTotal = miniPrep_figcfg.trialTotal;
    curSeg = miniPrep_figcfg.currentSegment;
    segTotal = miniPrep_figcfg.segmentTotal;
    figAxes.Title.String = ['trial:', num2str(curTrial), '/', num2str(length(trialTotal)), '   segment:', num2str(curSeg), '/', num2str(segTotal)];
    checkedChanLabel = chanLabel(yesChan==1);
    figAxes.YTick  = 1:2:length(checkedChanLabel);
    figAxes.YTickLabel = checkedChanLabel(1:2:length(checkedChanLabel));
    figAxes.XLabel.String = 'time(s)';
%% Marker noise
    QCfigure = f_QCfigure_markerNoise(QCfigure, 'miniPrep');
    QCfigure = f_QCfigure_plotSignals(QCfigure, 'miniPrep');
    QCfigure = f_QCfigure_denoise_winSeg(QCfigure);
    QCfigure = f_QCfigure_markerNoise(QCfigure, 'denoise');
    QCfigure = f_QCfigure_plotSignals(QCfigure, 'denoise');
    if exist('IEDs', 'var')
        QCfigure = f_QCfigure_plotNoise(QCfigure, 'IEDs');
    end
    if exist('rHFOs', 'var')
        QCfigure = f_QCfigure_plotNoise(QCfigure, 'rHFOs');
    end
    if exist('frHFOs', 'var')
        QCfigure = f_QCfigure_plotNoise(QCfigure, 'frHFOs');
    end
end



