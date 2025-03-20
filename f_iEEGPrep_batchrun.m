function f_iEEGPrep_batchrun(Setting)
%
%
%
%% Initial setting
    % File Filter
    DerivativesDir = Setting.DerivativesDir;
    Task = Setting.Task;
    CheckedSubjectList = Setting.CheckedSubjectList;
    CheckedFiles = Setting.CheckedFiles;
    
    % Preprocessing Parameter
    BandpassFreq = [Setting.LowerBPFreq, Setting.UpperBPFreq];
    PowerLineFreq = Setting.PowerLineFreq;
    ResampleFreq = Setting.ResampleFreq;
    RemoveBadChannels = Setting.RemoveBadChannels;
    SelectedRefMethod = Setting.SelectedRefMethod;
    
    % IED Detection and Regression Setting
    IEDDetection = Setting.IEDDetection;
    IEDRegression = Setting.IEDRegression;
    IEDThreshold = Setting.IEDThreshold;
    IEDBPFreq = [Setting.IEDLowerFreq, Setting.IEDUpperFreq];
    
    % ripple HFO Detection and Regression Setting
    rHFODetection = Setting.rHFODetection;
    rHFORegression = Setting.rHFORegression;
    rHFOThreshold = Setting.rHFOThreshold;
    rHFOBPFreq = [Setting.rHFOLowerFreq, Setting.rHFOUpperFreq];
    
    % fast ripple Detection and Regression Setting
    frHFODetection = Setting.frHFODetection;
    frHFORegression = Setting.frHFORegression;
    frHFOThreshold = Setting.frHFOThreshold;
    frHFOBPFreq = [Setting.frHFOLowerFreq, Setting.frHFOUpperFreq];
    
    miniPrepBPFreq(1) = min([1, IEDBPFreq(1), BandpassFreq(1)]);
    miniPrepBPFreq(2) = max([frHFOBPFreq(2), BandpassFreq(2)]);
    miniPrepResampleFreq = ceil(max([miniPrepBPFreq(2)*3, ResampleFreq]));

%% Prepare for batch run
    for ii_file = 1:length(CheckedFiles)
        %
        %
        %
        %
        %% Constructive the Preprocessed Folder and Name
        SubjectID = CheckedSubjectList{ii_file};
        iEEGFileInfo(ii_file).SubjectID = SubjectID;
        iEEGFileInfo(ii_file).RawFolder = CheckedFiles(ii_file).folder;
        iEEGFileInfo(ii_file).RawName = CheckedFiles(ii_file).name;
        % Constructive Derivative Folder
        disp('--------Construct the Preprocessed Folder and Name')
        disp(iEEGFileInfo(ii_file).RawName);
        TempA = f_strsplit(iEEGFileInfo(ii_file).RawName, '_');
        KeySTR = TempA(contains(TempA, '-'));
        SessionID = KeySTR(contains(KeySTR, 'ses-'));
        if isempty(SessionID)
            PrepFolder = fullfile(DerivativesDir, SubjectID, 'ieeg');
        else
            SessionID = SessionID{1};
            PrepFolder = fullfile(DerivativesDir, SubjectID, SessionID, 'ieeg');
        end
        if ~exist(PrepFolder, 'dir')
            mkdir(PrepFolder); 
        end
        iEEGFileInfo(ii_file).PrepFolder = PrepFolder;
        iEEGFileInfo(ii_file).KeySTR = KeySTR;

        %% Edit the channel table
        chanTableDir = dir(fullfile(iEEGFileInfo(ii_file).PrepFolder, '*_channel.mat'));% Load Exist Channel Table
        if isempty(chanTableDir)
            iEEGDataDir = fullfile(iEEGFileInfo(ii_file).RawFolder, iEEGFileInfo(ii_file).RawName);
            cfg = [];
            cfg.dataset = iEEGDataDir;
            Data = ft_preprocessing(cfg);
            disp(['--------Construct Channel Information Table:', iEEGFileInfo(ii_file).RawName]);
            ChannelTable = f_channelTable_create(Data);
            ChannelTable = f_channelTable_gui(ChannelTable);
            save(fullfile(iEEGFileInfo(ii_file).PrepFolder, [SubjectID, '_channel.mat']), 'ChannelTable');
        end    
    end

%% Perform iEEG Preprocessing
    for ii_file = 1:length(iEEGFileInfo)
        %
        %
        %
        %
% step 1: Import Channel Data
        SubjectID = iEEGFileInfo(ii_file).SubjectID;
        RawiEEGName = iEEGFileInfo(ii_file).RawName;
        RawFolder = iEEGFileInfo(ii_file).RawFolder;
        PrepFolder = iEEGFileInfo(ii_file).PrepFolder;
        chanTableDir = dir(fullfile(PrepFolder, '*_channel.mat'));% Load Exist Channel Table
        ChannelTable = load(fullfile(chanTableDir.folder, chanTableDir.name));
        ChannelTable = ChannelTable.ChannelTable;

% step 2: Perform Minimal Preprocessing
        disp(['--------Perform iEEG Minimal Preprocessing: ', RawiEEGName]);
        % miniPrep: constract miniPrep data file name
        KeySTR = iEEGFileInfo(ii_file).KeySTR;
        KeySTR{end+1} = ['res-', num2str(miniPrepResampleFreq)];
        KeySTR{end+1} = ['bp-', num2str(miniPrepBPFreq(1)), 'to', num2str(miniPrepBPFreq(2))];
        miniPrepName = KeySTR;
        miniPrepName{end+1} = 'miniprep.mat';
        miniPrepName = join(miniPrepName, '_');
        if iscell(miniPrepName)
            miniPrepName = miniPrepName{1};
        end
        iEEGFileInfo(ii_file).miniPrepName = miniPrepName;

        % miniPrep: import iEEG raw data
        miniPrepDir = dir(fullfile(PrepFolder, miniPrepName));
        if isempty(miniPrepDir)
            disp(['--------Import iEEG Data: ', RawiEEGName]);
            iEEGDataDir = fullfile(RawFolder, RawiEEGName);
            cfg = [];
            cfg.dataset = iEEGDataDir;
            Data = ft_preprocessing(cfg);

            % miniPrep: Resample, Bandpass filtering, Remove line noise
            if Data.fsample < miniPrepResampleFreq
                miniPrepResampleFreq = Data.fsample;
                miniPrepBPFreq(2) = floor(miniPrepResampleFreq/2);
            end
            Data = f_iEEGPrep_resample(Data, miniPrepResampleFreq);
            Data = f_iEEGPrep_bandpass(Data, miniPrepBPFreq);
            Data = f_iEEGPrep_powerlinenoise(Data, PowerLineFreq, miniPrepBPFreq, 1);
            % miniPrep: Save miniPrep Data
            disp(['--------Save the minimal preprocessed iEEG Data: ', fullfile(PrepFolder, miniPrepName)]);
            save(fullfile(PrepFolder, miniPrepName), 'Data');
        else
            Data = load(fullfile(PrepFolder, miniPrepName));
            Data = Data.Data;
        end

% step 3: Remove none-used and zero channels 
        % Remova bad channels by channel table
        disp(['--------Remove non-used Channels:', RawiEEGName]);
        Data = f_rmBadChan_rmChanByChanTable(Data, ChannelTable);
        % Remove zero channels
        disp(['--------Remove Zero Channels:', RawiEEGName]);
        [Data, ChannelTable] = f_rmBadChan_rmZeroChannels(Data, ChannelTable);

% step 4: Perform Re-reference
        if strcmp(SelectedRefMethod, 'None')
            disp(['--------Not perform re-reference:', RawiEEGName]);
        else
            disp(['--------Perform Re-reference Using ', SelectedRefMethod, ': ', RawiEEGName]);
            Data = f_iEEGPrep_reference(Data, SelectedRefMethod, ChannelTable);
        end
        KeySTR{end+1} = ['ref-', SelectedRefMethod];
        
% step 5: Detection of IEDs
        if IEDDetection
            disp(['--------Running IED Detection: ', RawiEEGName]);
            % IED Detection: Construct IED File Name
            IEDinfo = ['IED-', num2str(IEDBPFreq(1)), 'to', num2str(IEDBPFreq(2)), 'd', num2str(IEDThreshold)];
            IEDName = KeySTR;
            IEDName{end+1} = IEDinfo;
            IEDName{end+1} = 'IEDs.mat';
            IEDName = join(IEDName, '_');
            if iscell(IEDName)
                IEDName = IEDName{1};
            end
            iEEGFileInfo(ii_file).IEDName = IEDName;

            % IED Detection: Perform IED Detection
            IEDDir = dir(fullfile(PrepFolder, IEDName));
            if isempty(IEDDir)
                IEDWinSize = 10;
                TimeLThd = 0;
                IntervalLThd = 0.15;
                IEDs = f_IED_detectionByEnvelope(Data, IEDBPFreq, IEDWinSize, IEDThreshold, TimeLThd, IntervalLThd);
                %IED Detection: Save IEDs
                disp(['--------Save the IEDs:', fullfile(PrepFolder, IEDName)]);
                save(fullfile(PrepFolder, IEDName), 'IEDs');
            else
                IEDs = load(fullfile(PrepFolder, IEDName));
                IEDs = IEDs.IEDs;
            end

            % IED Detection: Plot IEDs Distribution Figure
            state = plotNoiseDistribution(DerivativesDir, SubjectID, Task, [IEDinfo, '_IED']);
            if state == 1
                disp('Plot IED distribution figure successfully!');
            else
                disp('Plot IED distribution figure with error!')
            end
        end

% Step 6: Detection of Ripple HFOs
        if rHFODetection
            disp(['--------Running ripple HFO Detection: ', RawiEEGName]);
            % rHFO Detection: constrct rHFO file name
            rHFOinfo = ['rHFO-', num2str(rHFOBPFreq(1)), 'to', num2str(rHFOBPFreq(2)),'d', num2str(rHFOThreshold)];
            rHFOName = KeySTR;
            rHFOName{end+1} = rHFOinfo;
            rHFOName{end+1} = 'rHFOs.mat';
            rHFOName = join(rHFOName, '_');
            if iscell(rHFOName)
                rHFOName = rHFOName{1};
            end
            iEEGFileInfo(ii_file).rHFOName = rHFOName;

            % rHFO Detection: perform ripple HFO Detection
            rHFODir = dir(fullfile(PrepFolder, rHFOName));
            if isempty(rHFODir)
                TimeLThd = 0;
                IntervalLThd = 0.15;
                rHFOs = f_HFO_detectionBySTE(Data, rHFOBPFreq, rHFOThreshold, TimeLThd, IntervalLThd);
                % Save Ripple HFOs
                disp(['--------Save the ripple HFOs:', fullfile(PrepFolder, rHFOName)]);
                save(fullfile(PrepFolder, rHFOName), 'rHFOs');
            else
                rHFOs = load(fullfile(PrepFolder, rHFOName));
                rHFOs = rHFOs.rHFOs;
            end

            % Plot Ripple HFOs Distribution Figure
            state = plotNoiseDistribution(DerivativesDir, SubjectID, Task, [rHFOinfo, '_rHFO']);
            if state == 1
                disp('Plot rHFO distribution figure successfully!');
            else
                disp('Plot rHFO distribution figure with error!')
            end
        end

% Step 7: Detection of Fast Ripple HFOs
        if frHFODetection
            % frHFO Detection: constrcut frHFO file name
            frHFOinfo = ['frHFO-', num2str(frHFOBPFreq(1)), 'to', num2str(frHFOBPFreq(2)), 'd', num2str(frHFOThreshold)];
            frHFOName = KeySTR;
            frHFOName{end+1} = frHFOinfo;
            frHFOName{end+1} = 'frHFOs.mat';
            frHFOName = join(frHFOName, '_');
            if iscell(frHFOName)
                frHFOName = frHFOName{1};
            end
            iEEGFileInfo(ii_file).frHFOName = frHFOName;
            frHFODir = dir(fullfile(PrepFolder, frHFOName));

            % frHFO Detection: Perform Fast Ripple HFOs Detection
            if isempty(frHFODir)
                disp(['--------Running fast ripple HFO Detection: ', RawiEEGName]);
                TimeLThd = 0;
                IntervalLThd = 0.15;
                frHFOs = f_HFO_detectionBySTE(Data, frHFOBPFreq, frHFOThreshold, TimeLThd, IntervalLThd);
                % Save Fast Ripple HFOs
                disp(['--------Save the fast ripple HFOs: ', fullfile(PrepFolder, frHFOName)]);
                save(fullfile(PrepFolder, frHFOName), 'frHFOs');
            else
                frHFOs = load(fullfile(PrepFolder, frHFOName));
                frHFOs = frHFOs.frHFOs;
            end

            % plot IED distribution fig
            state = plotNoiseDistribution(DerivativesDir, SubjectID, Task, [frHFOinfo, '_frHFO']);
            if state == 1
                disp('Plot frHFO distribution figure successfully!');
            else
                disp('Plot frHFO distribution figure with error!')
            end
        end
        
% step 8: performing iEEG denoise
        % Denoise: construct denoised iEEG file name
        iEEGDenoiseName = iEEGFileInfo(ii_file).KeySTR;
        iEEGDenoiseName{end+1} = ['res-', num2str(ResampleFreq)];
        iEEGDenoiseName{end+1} = ['bp-', num2str(BandpassFreq(1)), 'to', num2str(BandpassFreq(2))];
        iEEGDenoiseName{end+1} = ['ref-', SelectedRefMethod];
        if IEDRegression
            iEEGDenoiseName{end+1} = IEDinfo;
        end
        if rHFORegression
            iEEGDenoiseName{end+1} = rHFOinfo;
        end
        if frHFORegression
            iEEGDenoiseName{end+1} = frHFOinfo;
        end
        SettingName = iEEGDenoiseName;
        iEEGDenoiseName{end+1} = 'denoise.mat';
        iEEGDenoiseName = join(iEEGDenoiseName, '_');
        if iscell(iEEGDenoiseName)
            iEEGDenoiseName = iEEGDenoiseName{1};
        end
        iEEGFileInfo(ii_file).iEEGDenoiseName = iEEGDenoiseName;
        
        % Denoise: performing iEEG Denoise
        iEEGDenoiseDir = dir(fullfile(PrepFolder, iEEGDenoiseName));
        if isempty(iEEGDenoiseDir)
            % Denoise: Regress IED/rHFO/frHFO from iEEG data
            if IEDRegression
                disp(['--------Regression IED noise: ', RawiEEGName]);
                Data = f_IED_regression(Data, IEDs);
            end
            if rHFORegression
                disp(['--------Regression ripple noise: ', RawiEEGName]);
                Data = f_HFO_regression(Data, rHFOs);
            end
            if frHFORegression
                disp(['--------Regression fast ripple noise: ', RawiEEGName]);
                Data = f_HFO_regression(Data, frHFOs);
            end

            % Denoise: Perform Resample and Filtering after cleaning noise
            disp('--------Check Nyquist-Shannon Sampling Theorem--------');
            disp(['The Resample Frequency is ', num2str(ResampleFreq)]);
            disp(['The Upper Bandpaa Frequency is ', num2str(BandpassFreq(2))]);
            if ResampleFreq < 2*BandpassFreq(2)
                error('The resampling frequency is lower than twice the frequency of the high-frequency components.')
            end
            Data = f_iEEGPrep_resample(Data, ResampleFreq);
            Data = f_iEEGPrep_bandpass(Data, BandpassFreq);

            % Denoise: Remove Bad Channels using IEDs/rHFOs/frHFOs
            if RemoveBadChannels
            end
            
            % Denoise: Save Denoised iEEG Data
            save(fullfile(PrepFolder, iEEGDenoiseName), 'Data');
        end

% step 9: save the setting infomation of this Preprocessing pipeline
        SettingName{end+1} = 'setting.mat';
        SettingName = join(SettingName, '_');
        if iscell(SettingName)
            SettingName = SettingName{1};
        end
        Setting.iEEGFileInfo = iEEGFileInfo(ii_file);
        save(fullfile(iEEGFileInfo(ii_file).PrepFolder, SettingName), "Setting");
        
% step 10: save the new channel table
        save(fullfile(iEEGFileInfo(ii_file).PrepFolder, [SubjectID, '_channel.mat']), 'ChannelTable');
    end
end
function state = plotNoiseDistribution(IEEGPrepFolder, subjID, taskName, NoiseName)
%
%
%% main function
    try
        % find noise data
            NoiseDir  = dir(fullfile(IEEGPrepFolder, subjID, '**', [subjID, '*_task-', taskName, '*_', NoiseName, 's.mat']));
        % noise distribution
            N = 0;
            distribution_count = zeros(1, 1);
            for ii_noise = 1:length(NoiseDir)
                Noise = load(fullfile(NoiseDir(ii_noise).folder, NoiseDir(ii_noise).name));
                dataName = fieldnames(Noise);
                data = Noise.(dataName{1});
                distribution_label = data{1}.label;
                for ii_trial = 1:length(data)
                    N = N + 1;
                    for ii_channel = 1:length(distribution_label)
                        NoiseNum_eachdata = length(data{ii_trial}.Events{ii_channel}.trial);
                        distribution_count(ii_channel, N) = NoiseNum_eachdata;
                    end
                end
            end
            distribution_count = sum(distribution_count, 2);

            % distribution data
            distributionData = table;
            distributionData.channel = distribution_label;
            distributionData.count = distribution_count;
            mkdir(fullfile(IEEGPrepFolder, subjID, 'report'));
            distributionName = [subjID, '_', NoiseName, '_distributionData.csv'];
            writetable(distributionData, fullfile(IEEGPrepFolder, subjID, 'report', distributionName))

            % plot the figure
            noiseBar = figure;
            noiseAxes = axes(noiseBar);
            bar(noiseAxes, 1:length(distribution_label), distribution_count);
            noiseAxes.XTick = 1:length(distribution_label);
            noiseAxes.XTickLabel = distribution_label;
            splitNoiseName = f_strsplit(NoiseName, '_');
            splitNoiseName = splitNoiseName{end};
            noiseAxes.Title.String = [splitNoiseName, ' Distribution'];
            noiseAxes.XLabel.String = 'Channel Label';
            noiseAxes.YLabel.String = [splitNoiseName, 'Count'];
            distributionName = [subjID, '_', NoiseName, '_distributionFig.fig'];
            
            saveas(noiseBar, fullfile(IEEGPrepFolder, subjID, 'report', distributionName));
            delete(noiseBar);
            delete(noiseAxes);
            state = 1;
    catch
        state = 0;
    end
end
