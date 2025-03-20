function QCfigure = f_QCfigure_step3_noiseMarker(QCfigure)
%
%
%
%%
    figcfg = QCfigure.UserData.figcfg;
    miniPrepData = QCfigure.UserData.miniPrep.iEEGData;
    selectedChannels = QCfigure.UserData.figcfg.channel;
    curTrial = figcfg.currentTrial;
    if isfield(QCfigure.UserData, 'IEDs')
        IEDs = QCfigure.UserData.IEDs{curTrial};
        IEDsChannel = IEDs.label;
        selectedChannelsIndex = zeros(length(IEDsChannel), 1);
        for ii_chan1 = 1:length(selectedChannels)
            for ii_chan2 = 1:length(IEDsChannel)
                if strcmp(selectedChannels{ii_chan1}, IEDsChannel{ii_chan2})
                    selectedChannelsIndex(ii_chan2) = 1;
                end
            end
        end
        IEDs.label = IEDs.label(selectedChannelsIndex==1);
        IEDs.Events = IEDs.Events(selectedChannelsIndex==1);
    end
    if isfield(QCfigure.UserData, 'rHFOs')
        rHFOs = QCfigure.UserData.rHFOs{curTrial};
        rHFOsChannel = rHFOs.label;
        selectedChannelsIndex = zeros(length(rHFOsChannel), 1);
        for ii_chan1 = 1:length(selectedChannels)
            for ii_chan2 = 1:length(rHFOsChannel)
                if strcmp(selectedChannels{ii_chan1}, rHFOsChannel{ii_chan2})
                    selectedChannelsIndex(ii_chan2) = 1;
                end
            end
        end
        rHFOs.label = rHFOs.label(selectedChannelsIndex==1);
        rHFOs.Events = rHFOs.Events(selectedChannelsIndex==1);
    end
    if isfield(QCfigure.UserData, 'frHFOs')
        frHFOs = QCfigure.UserData.frHFOs{curTrial};
        frHFOsChannel = frHFOs.label;
        selectedChannelsIndex = zeros(length(frHFOsChannel), 1);
        for ii_chan1 = 1:length(selectedChannels)
            for ii_chan2 = 1:length(frHFOsChannel)
                if strcmp(selectedChannels{ii_chan1}, frHFOsChannel{ii_chan2})
                    selectedChannelsIndex(ii_chan2) = 1;
                end
            end
        end
        frHFOs.label = frHFOs.label(selectedChannelsIndex==1);
        frHFOs.Events = frHFOs.Events(selectedChannelsIndex==1);
    end
    
    % Fuse different noise to create noise pointer, begin and end
    noisePointer = zeros(1, miniPrepData.sampleinfo(curTrial, 2));
    if exist('IEDs', 'var')
        for ii_chan = 1:length(IEDs.label)
            IEDs_BeginEnd = IEDs.Events{ii_chan}.sampleinfo;
            for ii_IED = 1:size(IEDs_BeginEnd, 1)
                noisePointer(IEDs_BeginEnd(ii_IED, 1):IEDs_BeginEnd(ii_IED, 2)) = 1;
            end
        end
    end
    if exist('rHFOs', 'var')
        for ii_chan = 1:length(rHFOs.label)
            rHFOs_BeginEnd = rHFOs.Events{ii_chan}.sampleinfo;
            for ii_rHFO = 1:size(rHFOs_BeginEnd, 1)
                noisePointer(rHFOs_BeginEnd(ii_rHFO, 1):rHFOs_BeginEnd(ii_rHFO, 2)) = 1;
            end
        end
    end
    if exist('frHFOs', 'var')
        for ii_chan = 1:length(IEDs.label)
            IEDs_BeginEnd = IEDs.Events{ii_chan}.sampleinfo;
            for ii_IED = 1:size(IEDs_BeginEnd, 1)
                noisePointer(IEDs_BeginEnd(ii_IED, 1):IEDs_BeginEnd(ii_IED, 2)) = 1;
            end
        end
    end
        noisePointerSum = sum(noisePointer, 1);
        noisePointerSum(noisePointerSum>=1) =1;
        [noiseBegin, noiseEnd, ~] = f_eventDetection(noisePointerSum, 0, 0);
        
        % Find the noise info of each type noise of current noise event
        if exist('IEDs', 'var')
            noiseCount = length(noiseBegin);
            noiseEventIndex = cell(noiseCount, 3);
            noiseChannel = cell(noiseCount, 3);
            noiseChannelLabel = cell(noiseCount, 3);
            for ii_noise = 1:noiseCount
                noiseBeginEnd = [noiseBegin(ii_noise), noiseEnd(ii_noise)];
                IEDsIndex = find(IEDs{ii_trial}.EventsBegin>=noiseBeginEnd(1) & IEDs{ii_trial}.EventsBegin<=noiseBeginEnd(2));
                if isempty(IEDsIndex)
                    noiseEventIndex{ii_noise, 1} = [];
                else
                    noiseEventIndex{ii_noise, 1} = IEDsIndex;
                    noiseChannelTemp = cell(length(IEDsIndex),1);
                    for ii_IEDindex = 1:length(IEDsIndex)
                        IEDsChannel = IEDs{ii_trial}.EventsRaster(:, 1);
                        noiseChannelTemp{ii_IEDindex} = IEDsChannel(IEDs{ii_trial}.EventsRaster(:, 2) == IEDsIndex(ii_IEDindex));
                    end
                    noiseChannelTemp = cell2mat(noiseChannelTemp);
                    noiseChannel{ii_noise, 1} = unique(noiseChannelTemp);
                    noiseChannelLabel{ii_noise, 1} = miniPrepData_channelLabel(noiseChannel{ii_noise, 1});
                end
            end
        end
        if exist('rHFOs', 'var')
            for ii_noise = 1:noiseCount
                sampleinfo = [noiseBegin(ii_noise), noiseEnd(ii_noise)];
                rHFOsIndex = find(rHFOs{ii_trial}.EventsBegin>=sampleinfo(1) & rHFOs{ii_trial}.EventsBegin<=sampleinfo(2));
                if isempty(rHFOsIndex)
                    noiseEventIndex{ii_noise, 2} = [];
                else
                    noiseEventIndex{ii_noise, 2} = rHFOsIndex;
                    noiseChannelTemp = cell(length(rHFOsIndex),1);
                    for ii_rHFOindex = 1:length(rHFOsIndex)
                        rHFOsChannel = rHFOs{ii_trial}.EventsRaster(:, 1);
                        noiseChannelTemp{ii_rHFOindex} = rHFOsChannel(rHFOs{ii_trial}.EventsRaster(:, 2) == rHFOsIndex(ii_rHFOindex));
                    end
                    noiseChannelTemp = cell2mat(noiseChannelTemp);
                    noiseChannel{ii_noise, 2} = unique(noiseChannelTemp);
                    noiseChannelLabel{ii_noise, 2} = miniPrepData_channelLabel(noiseChannel{ii_noise, 2});
                end
            end
        end
        if exist('frHFOs', 'var')
            for ii_noise = 1:noiseCount
                sampleinfo = [noiseBegin(ii_noise), noiseEnd(ii_noise)];
                frHFOsIndex = find(frHFOs{ii_trial}.EventsBegin>=sampleinfo(1) & frHFOs{ii_trial}.EventsBegin<=sampleinfo(2));
                 if isempty(frHFOsIndex)
                    noiseEventIndex{ii_noise, 3} = [];
                else
                    noiseEventIndex{ii_noise, 3} = frHFOsIndex;
                    noiseChannelTemp = cell(length(frHFOsIndex),1);
                    for ii_frHFOindex = 1:length(frHFOsIndex)
                        frHFOsChannel = frHFOs{ii_trial}.EventsRaster(:, 1);
                        noiseChannelTemp{ii_frHFOindex} = frHFOsChannel(frHFOs{ii_trial}.EventsRaster(:, 2) == frHFOsIndex(ii_frHFOindex));
                    end
                    noiseChannelTemp = cell2mat(noiseChannelTemp);
                    noiseChannel{ii_noise, 3} = unique(noiseChannelTemp);
                    noiseChannelLabel{ii_noise, 3} = miniPrepData_channelLabel(noiseChannel{ii_noise, 3});
                end
            end
        end
        noise{ii_trial}.BeginTime = miniPrepData.time{ii_trial}(noiseBegin);
        noise{ii_trial}.EndTime = miniPrepData.time{ii_trial}(noiseEnd);
        noise{ii_trial}.EventIndex = noiseEventIndex;
        noise{ii_trial}.EventChannel = noiseChannel;
        noise{ii_trial}.EventChannelLabel = noiseChannelLabel;
    end
end