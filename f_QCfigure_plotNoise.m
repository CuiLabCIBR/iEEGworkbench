function QCfigure = f_QCfigure_plotNoise(QCfigure, noiseName)
%
%
%
%
%%
    set(0, 'CurrentFigure', QCfigure);
    miniPrepfigcfg = QCfigure.UserData.miniPrep.figcfg;
    curTrial = miniPrepfigcfg.currentTrial;
    noisecfg = QCfigure.UserData.noise{curTrial};
    curNoise = miniPrepfigcfg.noiseIndex;
    noiseData = QCfigure.UserData.(noiseName).iEEGData{curTrial};
    figAxes = findall(QCfigure, 'Type', 'axes', 'Tag', noiseName);
    delete(findobj(figAxes, 'Type', 'line'));
    
    % plot max noise signal
    switch noiseName
        case 'IEDs'
            IEDIndex_curNoise = noisecfg.EventIndex{curNoise, 1};% the event index of IEDs
            if isempty(IEDIndex_curNoise)
                disp('Current Noise without IED.');
            else
                IEDs = noiseData.Events;
                IEDsBegin_curNoise = noiseData.EventsBegin(IEDIndex_curNoise);% the begin of IEDs
                IEDsEnd_curNoise = noiseData.EventsEnd(IEDIndex_curNoise); % the end of IEDs
                IEDsRaster = noiseData.EventsRaster; % the raster of IEDs
                for ii_event = 1:length(IEDsBegin_curNoise)
                    IEDChannels_curNoise = IEDsRaster(IEDsRaster(:, 2) == IEDIndex_curNoise(ii_event), 1);% find the channel of current noise
                    for ii_channel = 1:length(IEDChannels_curNoise)
                        IED = IEDs{IEDChannels_curNoise(ii_channel)};
                        sampleinfo = IED.sampleinfo;
                        eventTrialIndex = find(sampleinfo(:,1)>=IEDsBegin_curNoise(ii_event)&sampleinfo(:,1)<=IEDsEnd_curNoise(ii_event));
                        for ii_eventTrialIndex = 1:length(eventTrialIndex)
                            EventSignal_Y = zscore(IED.trial{eventTrialIndex});
                            EventSignal_X = noiseData.time(sampleinfo(eventTrialIndex, 1):sampleinfo(eventTrialIndex, 2));
                            EventSignal_label = noiseData.label{IEDChannels_curNoise(ii_channel)};
                        end
                    end
                    line(figAxes, EventSignal_X, EventSignal_Y, 'Color', [0, 0, 0], 'LineStyle', '-', 'LineWidth', 0.5, 'Tag', EventSignal_label);
                end
                figAxes.YTick  = 1:2:ii_channel;
                figAxes.YTickLabel = noiseData.label(IEDChannels_curNoise(1:2:ii_channel));
                figAxes.XLabel.String = 'time(s)';
            end
        case 'rHFOs'

        case 'frHFOs'

    end
end
