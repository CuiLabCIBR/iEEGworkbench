function SignalFig = f_iEEGplot_Visualization(DerivativesDir, filename)

%% open figure and initial view pannel
    SignalFig = f_viewIEEG_initPanel;
%% Load Data
    IEEGDir = dir(fullfile(DerivativesDir, '**', filename));
    IEEGData = load(fullfile(IEEGDir.folder, IEEGDir.name));
    IEEGData = IEEGData.Data;
    setappdata(SignalFig, 'IEEGData', IEEGData);
%% Channel Information
    ChanFileDir = dir(fullfile(IEEGDir.folder, '*_channel.mat'));
    if ~isempty(ChanFileDir)
        ChannelTable = load(fullfile(ChanFileDir.folder, ChanFileDir.name));
        ChannelTable = ChannelTable.ChannelTable;
    else
        % create channel info table
        ChannelTable = table;
        ChannelTable.channel = IEEGData.label;
        for Nchan = 1:length(ChannelTable.channel)
            ChannelTable.type{Nchan} = 'SEEG';
            label = ChannelTable.channel{Nchan};
            ChannelTable.group(Nchan) = join(regexp(label, '[a-zA-Z]', 'match'), '');
            ChannelTable.good{Nchan} = {'false'};
            ChannelTable.good{Nchan} = categorical(ChannelTable.good{Nchan}, {'false', 'true'});
        end
    end
    setappdata(SignalFig, 'ChannelTable', ChannelTable);
    DataForPlot = f_Data2Plot(IEEGData, ChannelTable);
    setappdata(SignalFig, 'DataForPlot', DataForPlot);
%% Initial Setting for plotting the iEEG timeseries
    Plotcfg.currentTrialNum = 1; % initial setting of the trial number
    Plotcfg.currentSegamentNum = 1; % initial setting of the segment number
    Plotcfg.fsample = DataForPlot.fsample; % sample frequency
    Plotcfg.timeWinWidth = 1; % initial setting of the size of time window, unit is second
    Plotcfg.voltageScale = 2; % initial setting of the scale of voltage for plotting
    Plotcfg.outputdir = IEEGDir.folder;
    TempSTR = strsplit(IEEGDir.name, '_');
    Plotcfg.subjectID = TempSTR{1};
    setappdata(SignalFig, 'Plotcfg', Plotcfg);
%% PLOT SIGNALS
    f_plot_timeseries(SignalFig);
    SignalFig.Visible = 'on';
end






