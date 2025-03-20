function HFOs = f_HFO_detection(Data, HFOBPFreq, HFOThreshold, TimeLThd, IntervalLThd)  
%% main function
    % Initial setting
    HFOBPFreq = [160, 450];
    HFOThreshold = 5;
    TimeLThd = 1/HFOBPFreq(1)*4;
    IntervalLThd = 1/HFOBPFreq(1)*4;

    % Bandpass filtering
    disp(['****HFO Detection Step 1: Bandpass Filtering ', num2str(HFOBPFreq(1)), '-', num2str(HFOBPFreq(2)), 'Hz', ' Using Fieldtrip Toolbox.']); 
    disp(['****', char(datetime('now'))]); % Display the current date and time  
    cfg = [];  % Initialize the configuration structure  
    cfg.demean = 'yes';  % Remove the mean from the data  
    cfg.bpfilter = 'yes';  % Apply bandpass filtering  
    cfg.bpfreq = HFOBPFreq;  % Specify the bandpass frequency range  
    cfg.bpfiltord = 3;  % Set the filter order  
    Data = ft_preprocessing(cfg, Data);
%     cfg = [];
%     ft_databrowser(cfg, Data);
    
    disp('****HFO Detection Step 2: Calculating short time energy of iEEG signal.');
    disp(['****', char(datetime('now'))]); % Display the current date and time  
    fsample = Data.fsample; 
    ChannelCount = length(Data.label);
    WinSize = ceil(fsample/HFOBPFreq(1));
    TimeLThd = ceil(TimeLThd*fsample);
    IntervalLThd = ceil(IntervalLThd*fsample);
    [ShortTEnergy, shortTEnergySta]= f_HFO_shortTEnergy(Data, WinSize);
    ShortTEnergyThd = shortTEnergySta.mean + HFOThreshold * shortTEnergySta.std;
%     cfg = [];
%     ft_databrowser(cfg, ShortTEnergy);

    disp('****HFO Detection Step 3: Find HFOs.');
    disp(['****', char(datetime('now'))]); % Display the current date and time  
    TrialCount = length(Data.trial);
    HFOs = cell(1, TrialCount);
    for ii_trial = 1:TrialCount
        Events_trial = [];
        Events_trial.cfg = Data.cfg;
        Events_trial.label = Data.label;
        Events_trial.fsample = fsample;
        Events_trial.sampleinfo = Data.sampleinfo(ii_trial, :);
        Events_trial.time = Data.time{ii_trial};
        ShortTEnergy_trial = ShortTEnergy.trial{ii_trial};
        pointerTrial = ShortTEnergy_trial > ShortTEnergyThd;
        for ii_channel = 1:ChannelCount

            %
            disp(['****Find HFOs of Trial - ', num2str(ii_trial), ' of channel - ', num2str(ii_channel)]);
            ShortTEnergy_channel = ShortTEnergy_trial(ii_channel, :);
            Signal = Data.trial{ii_trial}(ii_channel, :);
            pointerChannel = pointerTrial(ii_channel, :);
            [EventsBegin, EventsEnd, ~] = f_eventDetection(pointerChannel, TimeLThd, IntervalLThd);
            pointerChannel = f_WholeWave(ShortTEnergy_channel, pointerChannel, EventsBegin, EventsEnd);
            [EventsBegin, EventsEnd, ~] = f_eventDetection(pointerChannel, TimeLThd, IntervalLThd);
            
            %
            disp(['****Construct HFOs Data of Trial - ', num2str(ii_trial), ' of channel - ', num2str(ii_channel)]);
            Events_count = length(EventsBegin);
            Events_channel = [];
            Events_channel.sampleinfo(:, 1) = EventsBegin;
            Events_channel.sampleinfo(:, 2) = EventsEnd;
            Events_channel_trial = cell(1, Events_count);
            Events_channel_Peak = zeros(1, Events_count);
            for ii_event = 1:Events_count
                sampleinfo = [EventsBegin(ii_event), EventsEnd(ii_event)];
                sampleList = sampleinfo(1):sampleinfo(2);
                Events_channel_trial{ii_event} = Signal(sampleList);
                EventShortEnergy = ShortTEnergy_channel(sampleList);
                [~, Peak] = max(EventShortEnergy);
                Peak = Peak + sampleinfo(1) - 1;
                Events_channel_Peak(ii_event) = Peak;
            end
            Events_channel.trial = Events_channel_trial;
            Events_channel.Peak = Events_channel_Peak;
            Events_trial.Events{ii_channel, 1} = Events_channel;

            %
            pointerTrial(ii_channel, :) = pointerChannel;
        end
        pointerSum = sum(pointerTrial, 1);
        pointerSum(pointerSum>=1) = 1;
        [EventsBegin, EventsEnd, ~] = f_eventDetection(pointerSum, TimeLThd, IntervalLThd);
        EventsCount = length(EventsBegin);
        Eventchannel = zeros(ChannelCount, EventsCount);
        for ii_event = 1:length(EventsBegin)
            pointerEvent = pointerTrial(:, EventsBegin(ii_event):EventsEnd(ii_event));
            pointerEvent = sum(pointerEvent, 2);
            Eventchannel(:, ii_event) = pointerEvent>=1;
        end
        [EventsRaster(:,1), EventsRaster(:, 2)] = find(Eventchannel==1);
        Events_trial.EventsBegin = EventsBegin;
        Events_trial.EventsEnd = EventsEnd;
        Events_trial.EventsRaster = EventsRaster;
        %
        HFOs{ii_trial} = Events_trial;
    end  
end



