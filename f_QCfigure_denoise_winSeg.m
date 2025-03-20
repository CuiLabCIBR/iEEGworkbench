function QCfigure = f_QCfigure_denoise_winSeg(QCfigure)
%
%
%
%
%%
    set(0, 'CurrentFigure', QCfigure);
    miniPrepfigcfg = QCfigure.UserData.miniPrep.figcfg;
    denoiseData = QCfigure.UserData.denoise.iEEGData;

    % Set the trial number of the current plot
    curTrial = miniPrepfigcfg.currentTrial;
    trialTotal = miniPrepfigcfg.trialTotal;
    denoiseTrialTotal = length(denoiseData.trial);
    if trialTotal ~= denoiseTrialTotal
        error('The miniPrep data show different trial with denoise data.')
    end

    % Set the x of current plot
    timeLimit = miniPrepfigcfg.timeLimit;
    denoiseTime = denoiseData.time{curTrial};
    index_time = find(denoiseTime>=timeLimit(1) & denoiseTime<=timeLimit(2));
    iEEGAxes.x = denoiseTime(index_time);
    iEEGAxes.y = denoiseData.trial{curTrial}(:, index_time);
    iEEGAxes.channelLabel = denoiseData.label;

    figcfg.currentTrial = curTrial;
    figcfg.trialTotal = trialTotal;
    figcfg.currentSegment = miniPrepfigcfg.currentSegment;
    figcfg.segmentTotal = miniPrepfigcfg.segmentTotal;
    figcfg.timeLimit = timeLimit;
    figcfg.voltageScale = miniPrepfigcfg.voltageScale;
    figcfg.winBeginTime = miniPrepfigcfg.winBeginTime;
    figcfg.winEndTime = miniPrepfigcfg.winEndTime;
    figcfg.noiseIndex = miniPrepfigcfg.noiseIndex;
    
    QCfigure.UserData.denoise.iEEGAxes = iEEGAxes;
    QCfigure.UserData.denoise.figcfg = figcfg;
end
