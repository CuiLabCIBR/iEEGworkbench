function [IEDs_brianWise, IEDs_channelWise] = f_IED_detection(Data, BPFreq, winSize, Threshold, timeLThd, intervalLThd)
%
%
% Edit by Longzhou Xu, 20250318
%%
    % Initial setting
    fsample = Data.fsample;
    chanLabel = Data.label;

    % Perform Bandpass filtering 
    disp(['****IED Detection Step 1: Bandpass Filtering ', num2str(BPFreq(1)), '-', num2str(BPFreq(2)), 'Hz', ' Using Fieldtrip Toolbox.']); 
    disp(['****', char(datetime('now'))]); % Display the current date and time 
    Data = f_filter_bandpass(Data, BPFreq);
    
    % Calculate Envelope and Threshold curver
    disp('****IED Detection Step 2: Calculate Envelope of iEEG Signal.'); 
    disp(['****', char(datetime('now'))]); % Display the current date and time  
    % Computes the envelope of the filtered iEEG signal.
    iEEGEnvelope = f_envelope(Data);
    iEEGTrial = Data.trial;
    iEEGtime = Data.time;
    clear Data;

    % 
    disp('****IED Detection Step 3: Calculate threshould curve and find Event above Threshold');
    disp(['****', char(datetime('now'))]); % Display the current date and time
    % Computes the threshold curve for IED detection and construct IED pointer.
    IEDsinfo = f_IED_sampleinfo(iEEGEnvelope, winSize, Threshold);
    clear iEEGEnvelope;
    
    % find wholw IEDs of each channe;
    disp('****IED Detection Step 4: Find whole IED wave.');
    disp(['****', char(datetime('now'))]); % Display the current date and time
    trialCount = size(IEDsinfo, 2);
    chanCount = size(chanLabel, 1);
    for nTrial = 1:trialCount
        N = 0;
        for nChan = 1:chanCount
            if size(IEDsinfo{nChan, nTrial})>0
                disp(['****Find whole IED wave of Trial - ', num2str(nTrial), ' of channel - ', num2str(nChan)]);
                disp(['****', char(datetime('now'))]); % Display the current date and time
                signalChan = iEEGTrial{nTrial}(nChan, :);
                tempIEDsinfo = f_wholeWave(signalChan, IEDsinfo{nChan, nTrial});
                IEDsinfo{nChan, nTrial} = tempIEDsinfo;
                for nIED = 1:size(tempIEDsinfo, 1)
                    IEDbegin = tempIEDsinfo(nIED, 1);
                    IEDend = tempIEDsinfo(nIED, 2);
                    IEDsignal = signalChan(IEDbegin:IEDend);
                    IEDpeak = f_IED_wavePeak(IEDsignal);
                    IEDpeak = IEDbegin + IEDpeak - 1;
                    % construct channel wise IED info
                    N = N + 1;
                    IEDs_channelWise{nTrial}(N).label = chanLabel{nChan};
                    IEDs_channelWise{nTrial}(N).signal = IEDsignal;
                    IEDs_channelWise{nTrial}(N).begin = IEDbegin;
                    IEDs_channelWise{nTrial}(N).peak = IEDpeak;
                    IEDs_channelWise{nTrial}(N).end = IEDend;
                end
            end
        end
    end  
    
    % find IED event of whole brain
    disp('****IED Detection Step 5: Find IEDs event across all channel.');
    disp(['****', char(datetime('now'))]); % Display the current date and time
    timeLThd = ceil(timeLThd*fsample);% convert second to sample
    intervalLThd = ceil(intervalLThd*fsample);
    IEDs_brianWise.time = iEEGtime;
    IEDs_brianWise.label = chanLabel;
    for nTrial = 1:trialCount
        pointer = zeros(chanCount, length(IEDs_brianWise.time{nTrial}));
        channelPointer = zeros(chanCount, 1);
        for nChan = 1:chanCount
            sinfo = IEDsinfo{nChan, nTrial};
            for nEvent = 1:size(sinfo, 1)
                pointer(nChan, sinfo(nEvent, 1):sinfo(nEvent, 2)) = 1;
            end
        end
        pointerSum = sum(pointer, 1)>1;
        [eventBegin, eventEnd, ~] = f_eventDetection(pointerSum, timeLThd, intervalLThd);
        for nEvent = 1:length(eventBegin)
            channelPointer(:, nEvent) = sum(pointer(:, eventBegin(nEvent):eventEnd(nEvent)), 2)>1;
        end
        IEDs_brianWise.sampleinfo{nTrial} = [eventBegin(:), eventEnd(:)];
        IEDs_brianWise.channelPointer{nTrial} = channelPointer;
    end

    %
    disp('****Finish IED Detection!');
    disp(['****', char(datetime('now'))]); % Display the current date and time
end



