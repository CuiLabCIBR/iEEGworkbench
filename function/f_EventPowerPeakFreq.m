function Events = f_EventPowerPeakFreq(Data, Events, WinSize, FreqRange,  FOI)
%
%
%
%% Main function
    disp('****Calculate the Power Spectrum of Event-Related iEEG Data.');
    disp(['****', char(datetime('now'))]); % Display the current date and time
    % Initial Setting
    fsample = Data.fsample;
    trialCount = length(Data.trial);
    WinSize = ceil(WinSize*fsample);
    for ii_trial = 1:trialCount
        iEEGsignal = Data.trial{ii_trial};
        iEEGlength = Data.sampleinfo(ii_trial, 2);
        iEEGcfg = Data.cfg;
        iEEGtime = Data.time{ii_trial};
        iEEGLabel = Data.label;
        EventLabelIndex = Events{ii_trial}.EventLabel;
        EventSampleinfo = Events{ii_trial}.sampleinfo;
        EventCount = length(Events{ii_trial}.trial);
        EventPeak = Events{ii_trial}.EventPeak;
        Events{ii_trial}.FOI = FOI;
        PeakFOILabel = cell(1, EventCount);

        % Prepare Event Related iEEG Data
        parfor ii_IED = 1:EventCount
            sampleinfo = EventSampleinfo(ii_IED, :);
            peakinfo = EventPeak(ii_IED);
            if diff(sampleinfo) < WinSize
                sampleinfo(1) = ceil(peakinfo - WinSize/2);
                if sampleinfo(1) <= 0; sampleinfo(1) = 1; end
                sampleinfo(2) = sampleinfo(1) + WinSize - 1;
                if sampleinfo(2) > iEEGlength; sampleinfo(2) = iEEGlength; end
                sampleinfo(1) = sampleinfo(2) - WinSize + 1;
            end
            eventLabelIndex = EventLabelIndex{ii_IED};
            ieegLabel = iEEGLabel;
            signal = iEEGsignal;
            time = iEEGtime;
            NewData = [];
            NewData.cfg = iEEGcfg;
            NewData.fsample = fsample;
            NewData.sampleinfo = sampleinfo;
            NewData.label = ieegLabel(eventLabelIndex);
            NewData.time{1} = time(sampleinfo(1):sampleinfo(2));
            NewData.trial{1} = signal(eventLabelIndex, sampleinfo(1):sampleinfo(2));
            
            % Calculate the PSD of Event Related iEEG Data
            freqRange = FreqRange;
            cfg = [];
            cfg.output = 'pow';
            cfg.channel = 'all';
            cfg.method = 'mtmfft';
            cfg.width = 7;
            cfg.foi = freqRange(1):1:freqRange(2);
            cfg.pad='nextpow2';
            cfg.tapsmofrq = 4;%4Hz smooth
            PSD = ft_freqanalysis(cfg, NewData);
            
            % Find the Peak Frequency in Frequency Range of Interesting
            foi = FOI
            freq = PSD.freq;
            PSD = PSD.powspctrm;
            PSD = PSD(:, freq >= foi(1) & freq<= foi(2));
            dfPSD = diff(PSD, 1, 2);
            dfPSD(dfPSD>=0) = 1;
            dfPSD(dfPSD<0) = -1;
            ddfPSD = diff(dfPSD);
            [row, ~] = find(ddfPSD==2);
            PeakFOILabel{ii_IED} = eventLabelIndex(unique(row));
        end
        Events{ii_trial}.PeakFOILabel = PeakFOILabel;
    end
end