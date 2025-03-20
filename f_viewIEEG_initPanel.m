function SignalFig = f_viewIEEG_initPanel


%% Create Uifigure and panel
    SignalFig = uifigure;
    SignalFig.Name = 'Signal Inspection';
    SignalFig.Position = [800, 100, 1500, 1200];
    SignalFig.Pointer = 'hand';
    SignalFig.Visible = 'off';

    GridLayout = uigridlayout(SignalFig);
    GridLayout.RowHeight = {25, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, '1x'};
    GridLayout.ColumnWidth = {50, 50, 50, 50, 50, 50, '1x'};
    GridLayout.ColumnSpacing = 0;
    GridLayout.RowSpacing = 0;

    % Create the panel 1 within the grid layout for setting control button.
    Panel1 = uipanel(GridLayout);
    Panel1.Layout.Row = [1 length(GridLayout.RowHeight)];
    Panel1.Layout.Column = [1 6];
    Panel1.Title = 'Control Panel';
    Panel1.BackgroundColor = 'white';

    % Create the uiaxes
    AX = uiaxes(GridLayout);
    AX.Layout.Row = [1 length(GridLayout.RowHeight)];
    AX.Layout.Column = length(GridLayout.ColumnWidth);
%% Set uibutton
    % Create the button 
    ChannelInfoButton = uibutton(GridLayout, 'push');
    ChannelInfoButton.Text = 'Channel Information';
    ChannelInfoButton.Layout.Row = 2;
    ChannelInfoButton.Layout.Column = [1 6];
    % Asign a callback function for pressing the button.
    ChannelInfoButton.ButtonPushedFcn = @(src, event) openChannelInfoTable(src, event);

    % Create the button 
    HighlightChannelButton = uibutton(GridLayout, 'push');
    HighlightChannelButton.Text = 'Highlight Channel';
    HighlightChannelButton.Layout.Row = 3;
    HighlightChannelButton.Layout.Column = [1 6];
    % Asign a callback function for pressing the button.
    HighlightChannelButton.ButtonPushedFcn = @(src, event) highlightChannel(src, event);

    % Create the button 
    VoltageScaleLabel = uilabel(GridLayout);
    VoltageScaleLabel.Layout.Row = 4;
    VoltageScaleLabel.Layout.Column = [1 6];
    VoltageScaleLabel.Text = '  Voltage Scale';
    VoltageScalePlusButton = uibutton(GridLayout, 'push');
    VoltageScalePlusButton.Text = 'V +';
    VoltageScalePlusButton.Layout.Row = 5;
    VoltageScalePlusButton.Layout.Column = [1 3];
    % Asign a callback function for pressing the button.
    VoltageScalePlusButton.ButtonPushedFcn = @(src, event) voltageScalePlus(src, event);
    VoltageScaleMinusButton = uibutton(GridLayout, 'push');
    VoltageScaleMinusButton.Text = 'V -';
    VoltageScaleMinusButton.Layout.Row = 5;
    VoltageScaleMinusButton.Layout.Column = [4 6];
    % Asign a callback function for pressing the button.
    VoltageScaleMinusButton.ButtonPushedFcn = @(src, event) voltageScaleMinus(src, event);

    % Create the button 
    TimeResolutionLabel = uilabel(GridLayout);
    TimeResolutionLabel.Layout.Row = 6;
    TimeResolutionLabel.Layout.Column = [1 6];
    TimeResolutionLabel.Text = '  Time Resolution';
    TimeResolutionPlusButton = uibutton(GridLayout, 'push');
    TimeResolutionPlusButton.Text = 'T +';
    TimeResolutionPlusButton.Layout.Row = 7;
    TimeResolutionPlusButton.Layout.Column = [1 3];
    % Asign a callback function for pressing the button.
    TimeResolutionPlusButton.ButtonPushedFcn = @(src, event) timeResolutionPlus(src, event);
    TimeResolutionMinusButton = uibutton(GridLayout, 'push');
    TimeResolutionMinusButton.Text = 'T -';
    TimeResolutionMinusButton.Layout.Row = 7;
    TimeResolutionMinusButton.Layout.Column = [4 6];
    % Asign a callback function for pressing the button.
    TimeResolutionMinusButton.ButtonPushedFcn = @(src, event) timeResolutionMinus(src, event);

    % Create the button 
    SegamentMoveLabel = uilabel(GridLayout);
    SegamentMoveLabel.Layout.Row = 8;
    SegamentMoveLabel.Layout.Column = [1 6];
    SegamentMoveLabel.Text = '  Segament';
    SegamentMoveLeftButton = uibutton(GridLayout, 'push');
    SegamentMoveLeftButton.Text = '<';
    SegamentMoveLeftButton.Layout.Row = 9;
    SegamentMoveLeftButton.Layout.Column = [1 3];
    % Asign a callback function for pressing the button.
    SegamentMoveLeftButton.ButtonPushedFcn = @(src, event) segamentMoveLeft(src, event);
    SegamentMoveRightButton = uibutton(GridLayout, 'push');
    SegamentMoveRightButton.Text = '>';
    SegamentMoveRightButton.Layout.Row = 9;
    SegamentMoveRightButton.Layout.Column = [4 6];
    % Asign a callback function for pressing the button.
    SegamentMoveRightButton.ButtonPushedFcn = @(src, event) segamentMoveRight(src, event);

    % Create the button 
    TrialMoveLabel = uilabel(GridLayout);
    TrialMoveLabel.Layout.Row = 10;
    TrialMoveLabel.Layout.Column = [1 6];
    TrialMoveLabel.Text = '  Trial';
    TrialMoveLeftButton = uibutton(GridLayout, 'push');
    TrialMoveLeftButton.Text = '<';
    TrialMoveLeftButton.Layout.Row = 11;
    TrialMoveLeftButton.Layout.Column = [1 3];
    % Asign a callback function for pressing the button.
    TrialMoveLeftButton.ButtonPushedFcn = @(src, event) trialMoveLeft(src, event);
    TrialMoveRightButton = uibutton(GridLayout, 'push');
    TrialMoveRightButton.Text = '>';
    TrialMoveRightButton.Layout.Row = 11;
    TrialMoveRightButton.Layout.Column = [4 6];
    % Asign a callback function for pressing the button.
    TrialMoveRightButton.ButtonPushedFcn = @(src, event) trialMoveRight(src, event);
%% Callback function
    function openChannelInfoTable(~, ~)
        ChannelTable = getappdata(SignalFig, 'ChannelTable');

        % Create UI table for display channel information
        ChannelTableFig = uifigure;
        ChannelTableFigGL = uigridlayout(ChannelTableFig, [1, 1]);
        Uitable = uitable(ChannelTableFigGL, "Data", ChannelTable);
        Uitable.ColumnEditable = [false true true true];

        % Cell Edit Call back
        Uitable.CellEditCallback = @(src, event) editChannelTable(src, event);
        
        function editChannelTable(~, event)
            EditedRow = event.Indices(1); 
            EditedColumn = event.Indices(2); 
            NewData = event.NewData;
            ChannelTable{EditedRow, EditedColumn} = {NewData};
            setappdata(SignalFig, 'ChannelTable', ChannelTable);

            IEEGData = getappdata(SignalFig, 'IEEGData');
            DataForPlot = f_Data2Plot(IEEGData, ChannelTable);
            setappdata(SignalFig, 'DataForPlot', DataForPlot);

            f_plot_timeseries(SignalFig);
        end
    
        % save the channel table
        ChannelTableFig.CloseRequestFcn = @(src, event) closereq(src, event);
        Plotcfg = getappdata(SignalFig, 'Plotcfg');
        SaveFolder = Plotcfg.outputdir;
        SaveName = [Plotcfg.subjectID, '_channel.mat'];
        function closereq(~, ~)
            selection = uiconfirm(ChannelTableFig, 'Close the table window and save the changes?' ,...
                'Confirmation');
            switch selection
                case 'OK'
                    save(fullfile(SaveFolder, SaveName), 'ChannelTable');
                    delete(ChannelTableFig)
                case 'Cancel'
                    return
            end
        end
    end
    
    % highlight the select channel
    function highlightChannel(~, ~)
        Plotcfg = getappdata(SignalFig, 'Plotcfg');
        DataForPlot = getappdata(SignalFig, 'DataForPlot');
        AX = SignalFig.CurrentAxes;
        % Find the selected line
        ROI = drawpoint(AX);
        XMouse = ROI.Position(1);
        YMouse = ROI.Position(2);
        delete(ROI);
        XData = Plotcfg.xData_currentWin;
        YData = Plotcfg.yData_currentWin;
        [~, TimeIndex] = min(abs(XData-XMouse));
        [~, LineIndex] = min(abs((YData(:, TimeIndex)-YMouse)));
        ChannelLabel = DataForPlot.label;
        AimLineTag = ChannelLabel{LineIndex};
        AimLine =  findobj(SignalFig, {'Type', 'line'}, '-and', {'Tag', AimLineTag});
    
        % set the line width after select the line
        LineWidth = get(AimLine, 'LineWidth');
        LineChannelLabel = get(AimLine, 'Tag');
        if LineWidth == 0.5
            LineWidth = 2;
        else
            LineWidth = 0.5;
        end
        set(AimLine, 'LineWidth', LineWidth);
        disp(['You select channel: ', LineChannelLabel]);
    end

    % Control the voltage scale
    function voltageScalePlus(~, ~) 
        Plotcfg = getappdata(SignalFig, 'Plotcfg');
        Plotcfg.voltageScale = Plotcfg.voltageScale * 2;
        setappdata(SignalFig, 'Plotcfg', Plotcfg);
        f_plot_timeseries(SignalFig);
    end
    function voltageScaleMinus(~, ~) 
        Plotcfg = getappdata(SignalFig, 'Plotcfg');
        Plotcfg.voltageScale = Plotcfg.voltageScale/2;
        setappdata(SignalFig, 'Plotcfg', Plotcfg);
        f_plot_timeseries(SignalFig);
    end

    % control temporal resolution  of current window
    function timeResolutionPlus(~, ~)
        Plotcfg = getappdata(SignalFig, 'Plotcfg');
        Plotcfg.timeWinWidth = Plotcfg.timeWinWidth/2;
        setappdata(SignalFig, 'Plotcfg', Plotcfg);
        f_plot_timeseries(SignalFig);
    end
    function timeResolutionMinus(~, ~)
        Plotcfg = getappdata(SignalFig, 'Plotcfg');
        Plotcfg.timeWinWidth = Plotcfg.timeWinWidth*2;
        setappdata(SignalFig, 'Plotcfg', Plotcfg);
        f_plot_timeseries(SignalFig);
    end
    
    % control the segment
    function segamentMoveLeft(~, ~)
        Plotcfg = getappdata(SignalFig, 'Plotcfg');
        Plotcfg.currentSegamentNum = Plotcfg.currentSegamentNum - 1;
        setappdata(SignalFig, 'Plotcfg', Plotcfg);
        f_plot_timeseries(SignalFig);
    end
    function segamentMoveRight(~, ~)
        Plotcfg = getappdata(SignalFig, 'Plotcfg');
        Plotcfg.currentSegamentNum = Plotcfg.currentSegamentNum + 1;
        setappdata(SignalFig, 'Plotcfg', Plotcfg);
        f_plot_timeseries(SignalFig);
    end

    % control the trial
    function trialMoveLeft(~, ~)
        Plotcfg = getappdata(SignalFig, 'Plotcfg');
        Plotcfg.currentTrialNum = Plotcfg.currentTrialNum - 1;
        setappdata(SignalFig, 'Plotcfg', Plotcfg);
        f_plot_timeseries(SignalFig);
    end
    function trialMoveRight(~, ~)
        Plotcfg = getappdata(SignalFig, 'Plotcfg');
        Plotcfg.currentTrialNum = Plotcfg.currentTrialNum + 1;
        setappdata(SignalFig, 'Plotcfg', Plotcfg);
        f_plot_timeseries(SignalFig);
    end
end