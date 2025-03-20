function QCfigure = f_QCfigure_step2_iEEGData(QCfigure)
%
%
%
%%
    figcfg = QCfigure.UserData.figcfg;
    miniPrepData = QCfigure.UserData.miniPrep.iEEGData;
    denoiseData = QCfigure.UserData.denoise.iEEGData;
    selectedChannels = QCfigure.UserData.figcfg.channel;

    % Set the trial number of the current plot
    trialTotal = length(miniPrepData.trial);
    curTrial = figcfg.currentTrial;
    if curTrial < 1; curTrial = 1; end
    if curTrial > trialTotal; curTrial = trialTotal; end
    figcfg.currentTrial = curTrial;
    figcfg.trialTotal = trialTotal;

    % Set the window begin of each segment
    sampleinfo = miniPrepData.sampleinfo(curTrial, :);
    fsample = miniPrepData.fsample;
    winWidth = figcfg.winWidth;
    winWidth = ceil(winWidth*fsample);
    winBeginSeries = sampleinfo(1):winWidth:sampleinfo(2);
    % Set the segment number of current plot
    segTotal = length(winBeginSeries);
    curSeg = figcfg.currentSegment;
    if curSeg < 1; curSeg = 1; end
    if curSeg > segTotal; curSeg = segTotal; end
    figcfg.currentSegment = curSeg;
    figcfg.segmentTotal = segTotal;
    % Set the time window of current plot
    winBegin = winBeginSeries(curSeg);
    winEnd = winBegin + winWidth;
    winEnd(winEnd>sampleinfo(2)) = sampleinfo(2);
    t = miniPrepData.time{curTrial};
    winBeginTime = t(winBegin);
    winEndTime = t(winEnd);
    figcfg.winBeginTime = winBeginTime;
    figcfg.winEndTime = winEndTime;

    % Set the x and y of current plot of miniPrep data
    miniPrepData_t = miniPrepData.time{curTrial};
    Xindex = find(miniPrepData_t > winBeginTime & miniPrepData_t< winEndTime);
    miniPrep_xCurrentWin = miniPrepData_t(Xindex);
    miniPrep_yCurrentWin = miniPrepData.trial{curTrial}(:, Xindex);
    miniPrep_channelLabel = miniPrepData.label;
    selectedChannelsIndex = zeros(length(miniPrep_channelLabel), 1);
    for ii_chan1 = 1:length(selectedChannels)
        for ii_chan2 = 1:length(miniPrep_channelLabel)
            if strcmp(selectedChannels{ii_chan1}, miniPrep_channelLabel{ii_chan2})
                selectedChannelsIndex(ii_chan2) = 1;
            end
        end
    end
    miniPrep_yCurrentWin = miniPrep_yCurrentWin(selectedChannelsIndex==1, :);
    miniPrep_channelLabel = miniPrep_channelLabel(selectedChannelsIndex==1);
    
    % Set the x and y of current plot of denoise data
    denoiseData_t = denoiseData.time{curTrial};
    Xindex = find(denoiseData_t > winBeginTime & denoiseData_t < winEndTime);
    denoise_xCurrentWin = denoiseData_t(Xindex);
    denoise_yCurrentWin = denoiseData.trial{curTrial}(:, Xindex);
    denoise_channelLabel = denoiseData.label;
    selectedChannelsIndex = zeros(length(denoise_channelLabel), 1);
    for ii_chan1 = 1:length(selectedChannels)
        for ii_chan2 = 1:length(denoise_channelLabel)
            if strcmp(selectedChannels{ii_chan1}, denoise_channelLabel{ii_chan2})
                selectedChannelsIndex(ii_chan2) = 1;
            end
        end
    end
    denoise_yCurrentWin = denoise_yCurrentWin(selectedChannelsIndex==1, :);
    denoise_channelLabel = denoise_channelLabel(selectedChannelsIndex==1);

    % Find the noise Begin and End of current window
    noise = QCfigure.UserData.noise;
    noiseBeginTime = noise{curTrial}.BeginTime;
    noiseEndTime = noise{curTrial}.EndTime;
    nB = noiseBeginTime>=winBeginTime & noiseBeginTime<=winEndTime;
    nE = noiseEndTime>=winBeginTime & noiseEndTime<=winEndTime;
    nBE = nB+nE;
    nBE = find(nBE == 2);
    firstNoise = nBE(1);
    if sum(nBE == figcfg.noiseIndex) ~= 1
        figcfg.noiseIndex = firstNoise;
    end
    figcfg.noiseHighlightBegin_x = noiseBeginTime(nBE);
    figcfg.noiseHighlightEnd_x = noiseEndTime(nBE);
    figcfg.curNoiseBegin_x = noiseBeginTime(figcfg.noiseIndex);
    figcfg.curNoiseEnd_x = noiseEndTime(figcfg.noiseIndex);

    % Find the noise channel of current noise
    EventChannelLabel = noise{curTrial}.EventChannelLabel(figcfg.noiseIndex, :);
    EventChannelLabelAll = cell(1, 1);
    ncell = 0;
    for ii_cell = 1:length(EventChannelLabel)
        for ii_label = 1:length(EventChannelLabel{ii_cell})
            ncell = ncell + 1;
            EventChannelLabelAll{ncell} = EventChannelLabel{ii_cell}{ii_label};
        end
    end
    figcfg.EventChannelLabel_curNoise = unique(EventChannelLabelAll);

    % save the figcfg
    QCfigure.UserData.(iEEGName).figcfg = figcfg;
end