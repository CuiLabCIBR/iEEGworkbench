function f_plot_timeseries(SignalFig)


%% Initial setting
    set(0, 'CurrentFigure', SignalFig);
    DataForPlot = getappdata(SignalFig, 'DataForPlot');
    Plotcfg = getappdata(SignalFig, 'Plotcfg');
    AX = SignalFig.CurrentAxes;

%% plot iEEG signal
    % the number of current trial
    CurrentTrialNum = Plotcfg.currentTrialNum;
    if CurrentTrialNum < 1
        CurrentTrialNum = 1;
    elseif CurrentTrialNum > length(DataForPlot.trial)
        CurrentTrialNum = length(DataForPlot.trial);
    end
    Plotcfg.currentTrialNum = CurrentTrialNum;
    setappdata(SignalFig, 'Plotcfg', Plotcfg);
    
    % construct the time window
    Time_CurrentTrial = DataForPlot.time{CurrentTrialNum};
    TimeWinWidth = Plotcfg.timeWinWidth;
    TimeWinBegin_Series = Time_CurrentTrial(1):TimeWinWidth:Time_CurrentTrial(end);
    TimeWinEnd_Series = TimeWinBegin_Series + TimeWinWidth;
    
    % the number of current time-window/segment, if show the IED
    if isfield(Plotcfg, 'IEDs')
        IEDs = Plotcfg.IEDs;
        IEDs_allchannel = IEDs.trial(CurrentTrialNum).IEDs_allchannel;
        IEDs_count = size(IEDs_allchannel.sampleinfo, 1);

        CurrentIEDNum = Plotcfg.currentIEDNum;
        if CurrentIEDNum <= 0
            CurrentIEDNum = 1;
        elseif CurrentIEDNum >= IEDs_count
            CurrentIEDNum = IEDs_count;
        end
        Plotcfg.currentIEDNum = CurrentIEDNum;
        
        IEDbeginTimeIndex_currentIED = IEDs_allchannel.sampleinfo(CurrentIEDNum, 1);
        IEDbeginTime_currentIED = Time_CurrentTrial(IEDbeginTimeIndex_currentIED);
        for ii_timewin = 1:length(TimeWinBegin_Series)
            if IEDbeginTime_currentIED > TimeWinBegin_Series(ii_timewin) && IEDbeginTime_currentIED < TimeWinEnd_Series(ii_timewin)
                Plotcfg.currentSegamentNum = ii_timewin;
            end
        end
    end

    % the number of current time-window/segment, if show the HFOs
    if isfield(Plotcfg, 'HFOs')
        HFOs = Plotcfg.HFOs;
        HFOs_allchannel = HFOs.trial(CurrentTrialNum).HFOs_allchannel;
        HFOs_count = size(HFOs_allchannel.sampleinfo, 1);

        CurrentHFONum = Plotcfg.currentHFONum;
        if CurrentHFONum <= 0
            CurrentHFONum = 1;
        elseif CurrentHFONum >= HFOs_count
            CurrentHFONum = HFOs_count;
        end
        Plotcfg.currentHFONum = CurrentHFONum;
        
        HFObeginTimeIndex_currentHFO = HFOs_allchannel.sampleinfo(CurrentHFONum, 1);
        HFObeginTime_currentHFO = Time_CurrentTrial(HFObeginTimeIndex_currentHFO);
        for ii_timewin = 1:length(TimeWinBegin_Series)
            if HFObeginTime_currentHFO > TimeWinBegin_Series(ii_timewin) && HFObeginTime_currentHFO < TimeWinEnd_Series(ii_timewin)
                Plotcfg.currentSegamentNum = ii_timewin;
            end
        end
    end

    setappdata(SignalFig, 'Plotcfg', Plotcfg);
    CurrentSegamentNum = Plotcfg.currentSegamentNum;
    if CurrentSegamentNum > length(TimeWinBegin_Series)
        CurrentSegamentNum = length(TimeWinBegin_Series);
    elseif CurrentSegamentNum < 1
        CurrentSegamentNum = 1;
    end
    Plotcfg.currentSegamentNum = CurrentSegamentNum;

    % extract the time series in current time window
    TimeWinBegin = TimeWinBegin_Series(CurrentSegamentNum);
    TimeWinEnd = TimeWinEnd_Series(CurrentSegamentNum);
    Xindex = find(Time_CurrentTrial >= TimeWinBegin & Time_CurrentTrial <= TimeWinEnd);
    XData_CurrentWin(:, 1) = Time_CurrentTrial(Xindex);
    Signal_CurrentTrial = DataForPlot.trial{CurrentTrialNum};
    YData_CurrentWin = Signal_CurrentTrial(:, Xindex);

    % voltage scale
    VoltageScale = Plotcfg.voltageScale;
    YData_CurrentWin  = YData_CurrentWin .* VoltageScale;
    Ypos = 1:size(YData_CurrentWin, 1);
    YData_CurrentWin = YData_CurrentWin + Ypos';
    Plotcfg.xData_currentWin = XData_CurrentWin;
    Plotcfg.yData_currentWin = YData_CurrentWin;


    delete(findobj(AX, 'Type', 'line'));
%% plot signal with IEDs
    if isfield(Plotcfg, 'IEDs')
        % find the IED in this time window
        IEDbeginTime = zeros(IEDs_count, 1);
        for ii_IED = 1:IEDs_count
            IEDbeginTimeIndex = IEDs_allchannel.sampleinfo(ii_IED, 1);
            IEDbeginTime(ii_IED) = Time_CurrentTrial(IEDbeginTimeIndex);
        end
        IEDbeginTime_currentWin = IEDbeginTime(IEDbeginTime >= TimeWinBegin & IEDbeginTime <= TimeWinEnd);

        % plot the line of begin of the IED in current time window
        for ii_IED_CurrTimeWin = 1:length(IEDbeginTime_currentWin)
            IEDLine_X = IEDbeginTime_currentWin(ii_IED_CurrTimeWin);
            IEDLine_Y = min([size(YData_CurrentWin, 1)+1, max(max(YData_CurrentWin))]);
            line(AX, [IEDLine_X, IEDLine_X], [0, IEDLine_Y], 'Color', [0, 1, 0], 'LineStyle', '--', 'Tag', 'IEDline');
        end

        % high-light the current IED
        line(AX, [IEDbeginTime_currentIED, IEDbeginTime_currentIED], [0, IEDLine_Y], ...
            'Color', [0, 1, 1], 'LineStyle', '-', 'LineWidth', 2, 'Tag', 'currentIEDline');
        IEDendTimeIndex_currentIED = IEDs_allchannel.sampleinfo(CurrentIEDNum, 2);
        IEDendTime_currentIED = Time_CurrentTrial(IEDendTimeIndex_currentIED);
        line(AX, [IEDendTime_currentIED, IEDendTime_currentIED], [0, IEDLine_Y], ...
            'Color', [0, 1, 1], 'LineStyle', '-', 'LineWidth', 2, 'Tag', 'currentIEDline');
        line(AX, [IEDbeginTime_currentIED, IEDendTime_currentIED], [0, 0], ...
            'Color', [0, 1, 1], 'LineStyle', '-', 'LineWidth', 2, 'Tag', 'currentIEDline');
        line(AX, [IEDbeginTime_currentIED, IEDendTime_currentIED], [IEDLine_Y, IEDLine_Y], ...
            'Color', [0, 1, 1], 'LineStyle', '-', 'LineWidth', 2, 'Tag', 'currentIEDline');
    end
%% plot the HFOs
    if isfield(Plotcfg, 'HFOs')
        % find the HFOs in this time window
        HFObeginTime = zeros(HFOs_count, 1);
        for ii_HFO = 1:HFOs_count
            HFObeginTimeIndex = HFOs_allchannel.sampleinfo(ii_HFO, 1);
            HFObeginTime(ii_HFO) = Time_CurrentTrial(HFObeginTimeIndex);
        end
        HFObeginTime_currentWin = HFObeginTime(HFObeginTime >= TimeWinBegin & HFObeginTime <= TimeWinEnd);

        % plot the line of begin of the HFO in current time window
        for ii_HFO_CurrTimeWin = 1:length(HFObeginTime_currentWin)
            HFOLine_X = HFObeginTime_currentWin(ii_HFO_CurrTimeWin);
            HFOLine_Y = min([size(YData_CurrentWin, 1)+1, max(max(YData_CurrentWin))]);
            line(AX, [HFOLine_X, HFOLine_X], [0, HFOLine_Y], 'Color', [0, 1, 0], 'LineStyle', '--', 'Tag', 'IEDline');
        end

        % high-light the current HFO
        line(AX, [HFObeginTime_currentHFO, HFObeginTime_currentHFO], [0, HFOLine_Y], ...
            'Color', [0, 1, 1], 'LineStyle', '-', 'LineWidth', 2, 'Tag', 'currentHFOline');
        HFOendTimeIndex_currentHFO = HFOs_allchannel.sampleinfo(CurrentHFONum, 2);
        HFOendTime_currentHFO = Time_CurrentTrial(HFOendTimeIndex_currentHFO);
        line(AX, [HFOendTime_currentHFO, HFOendTime_currentHFO], [0, HFOLine_Y], ...
            'Color', [0, 1, 1], 'LineStyle', '-', 'LineWidth', 2, 'Tag', 'currentHFOline');
        line(AX, [HFObeginTime_currentHFO, HFOendTime_currentHFO], [0, 0], ...
            'Color', [0, 1, 1], 'LineStyle', '-', 'LineWidth', 2, 'Tag', 'currentHFOline');
        line(AX, [HFObeginTime_currentHFO, HFOendTime_currentHFO], [HFOLine_Y, HFOLine_Y], ...
            'Color', [0, 1, 1], 'LineStyle', '-', 'LineWidth', 2, 'Tag', 'currentHFOline');
    end

    ChannelLabels = DataForPlot.label;
    for LineN = 1:size(YData_CurrentWin, 1)
        line(AX, XData_CurrentWin, YData_CurrentWin(LineN, :), 'Color', [0, 0, 0], 'LineStyle', '-', 'LineWidth', 0.5, 'Tag', ChannelLabels{LineN});
    end
    AX.YLim = [0, min([size(YData_CurrentWin, 1)+1, max(max(YData_CurrentWin))])];
    setappdata(SignalFig, 'Plotcfg', Plotcfg);
    AX.XLim = [TimeWinBegin, TimeWinEnd] ;
    % show title
    AX.Title.String = ['trial:', num2str(CurrentTrialNum), '/', num2str(length(DataForPlot.trial)), '   ', ...
        'segement:', num2str(CurrentSegamentNum), '/', num2str(length(TimeWinBegin_Series))];

    % show channel label
    AX.YTick  = 1:2:length(ChannelLabels);
    AX.YTickLabel = ChannelLabels(1:2:length(ChannelLabels));
    AX.XLabel.String = 'time(s)';

    %% marker the IED 
    if isfield(Plotcfg, 'IEDs')
        % high-light the current IED
        IED_ChannelLabels = IEDs_allchannel.ChannelLabels{CurrentIEDNum};
        for ii_channel = 1:length(IED_ChannelLabels)
            IEDchannelLineObj = findobj(AX, {'Type', 'Line'}, '-and', {'Tag', IED_ChannelLabels{ii_channel}});
            IEDline_X = get(IEDchannelLineObj, 'XData');
            IEDline_Y = get(IEDchannelLineObj, 'YData');

            IED_X_currentIED = IEDline_X(IEDline_X >= IEDbeginTime_currentIED & IEDline_X <= IEDendTime_currentIED);
            IED_Y_currentIED = IEDline_Y(IEDline_X >= IEDbeginTime_currentIED & IEDline_X <= IEDendTime_currentIED);
            
            line(AX, IED_X_currentIED, IED_Y_currentIED, 'Color', [1, 0, 0], 'LineStyle', '-', 'LineWidth', 0.5, 'Tag', 'IEDline');
        end
    end
end
