function QCfigure = f_QCfigure_step1_initPanel
%
%
%
%% Main function: Create Quality Control Uifigure
    oldQCfigure = findall(0, 'Type', 'figure', 'Tag', 'QCfigure');
    delete(oldQCfigure);% delete old QC figure
    % create new QC figure
    QCfigure = uifigure;
    QCfigure.Name = 'iEEG Quality Control';
    QCfigure.Pointer = 'hand';
    QCfigure.Visible = 'on';
    QCfigure.WindowState = 'maximized';
    QCfigure.Tag = 'QCfigure';
    GridLayout = uigridlayout(QCfigure);
    GridLayout.RowHeight = {25, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, '1x'};
    screenSize = get(0, 'ScreenSize');
    screenWidth = screenSize(3);
    screenWidth = screenWidth-200;
    GridLayout.ColumnWidth = {80, 80, screenWidth/4, screenWidth/4, screenWidth/6, screenWidth/6, screenWidth/6};
    GridLayout.ColumnSpacing = 0;
    GridLayout.RowSpacing = 0;
    % create Control panel in QC figure
    ControlPanel = uipanel(GridLayout);
    ControlPanel.Layout.Row = [1 length(GridLayout.RowHeight)];
    ControlPanel.Layout.Column = [1 2];
    ControlPanel.Title = 'Control Panel';
    ControlPanel.BackgroundColor = 'white';
    % Create channel info table in QC figure
    uiRow = 2;
    ChannelInfoButton = uibutton(GridLayout, 'push');
    ChannelInfoButton.Text = 'Channel Info';
    ChannelInfoButton.Layout.Row = uiRow;
    ChannelInfoButton.Layout.Column = [1, 2];
    ChannelInfoButton.ButtonPushedFcn = @(src, event) editChannelTable(src, event);
    % highlight the selected channel signal
    uiRow = uiRow + 1;
    HighlightChannelButton = uibutton(GridLayout, 'push');
    HighlightChannelButton.Text = 'Highlight';
    HighlightChannelButton.Layout.Row = uiRow;
    HighlightChannelButton.Layout.Column = [1, 2];
    HighlightChannelButton.ButtonPushedFcn = @(src, event) highlightChannel(src, event);
    %
    uiRow = uiRow + 1;
    VoltageScaleLabel = uilabel(GridLayout);
    VoltageScaleLabel.Layout.Row = uiRow;
    VoltageScaleLabel.Layout.Column = [1 2];
    VoltageScaleLabel.Text = '  Voltage Scale';
    uiRow = uiRow + 1;
    VoltageScalePlusButton = uibutton(GridLayout, 'push');
    VoltageScalePlusButton.Text = 'V +';
    VoltageScalePlusButton.Layout.Row = uiRow;
    VoltageScalePlusButton.Layout.Column = 1;
    VoltageScalePlusButton.ButtonPushedFcn = @(src, event) voltageScalePlus(src, event);
    VoltageScaleMinusButton = uibutton(GridLayout, 'push');
    VoltageScaleMinusButton.Text = 'V -';
    VoltageScaleMinusButton.Layout.Row = uiRow;
    VoltageScaleMinusButton.Layout.Column = 2;
    VoltageScaleMinusButton.ButtonPushedFcn = @(src, event) voltageScaleMinus(src, event);
    %
    uiRow = uiRow + 1;
    TimeResolutionLabel = uilabel(GridLayout);
    TimeResolutionLabel.Layout.Row = uiRow;
    TimeResolutionLabel.Layout.Column = [1 2];
    TimeResolutionLabel.Text = '  Time Resolution';
    uiRow = uiRow + 1;
    TimeResolutionPlusButton = uibutton(GridLayout, 'push');
    TimeResolutionPlusButton.Text = 'T +';
    TimeResolutionPlusButton.Layout.Row = uiRow;
    TimeResolutionPlusButton.Layout.Column = 1;
    TimeResolutionPlusButton.ButtonPushedFcn = @(src, event) timeResolutionPlus(src, event);
    TimeResolutionMinusButton = uibutton(GridLayout, 'push');
    TimeResolutionMinusButton.Text = 'T -';
    TimeResolutionMinusButton.Layout.Row = uiRow;
    TimeResolutionMinusButton.Layout.Column = 2;
    TimeResolutionMinusButton.ButtonPushedFcn = @(src, event) timeResolutionMinus(src, event);
    %
    uiRow = uiRow + 1;
    SegamentMoveLabel = uilabel(GridLayout);
    SegamentMoveLabel.Layout.Row = uiRow;
    SegamentMoveLabel.Layout.Column = [1 2];
    SegamentMoveLabel.Text = '  Segament';
    uiRow = uiRow + 1;
    SegamentMoveLeftButton = uibutton(GridLayout, 'push');
    SegamentMoveLeftButton.Text = '<';
    SegamentMoveLeftButton.Layout.Row = uiRow;
    SegamentMoveLeftButton.Layout.Column = 1;
    SegamentMoveLeftButton.ButtonPushedFcn = @(src, event) segmentMoveLeft(src, event);
    SegamentMoveRightButton = uibutton(GridLayout, 'push');
    SegamentMoveRightButton.Text = '>';
    SegamentMoveRightButton.Layout.Row = uiRow;
    SegamentMoveRightButton.Layout.Column = 2;
    SegamentMoveRightButton.ButtonPushedFcn = @(src, event) segmentMoveRight(src, event);
    %
    uiRow =uiRow + 1;
    TrialMoveLabel = uilabel(GridLayout);
    TrialMoveLabel.Layout.Row = uiRow;
    TrialMoveLabel.Layout.Column = [1 2];
    TrialMoveLabel.Text = '  Trial';
    uiRow = uiRow + 1;
    TrialMoveLeftButton = uibutton(GridLayout, 'push');
    TrialMoveLeftButton.Text = '<';
    TrialMoveLeftButton.Layout.Row = uiRow;
    TrialMoveLeftButton.Layout.Column = 1;
    TrialMoveLeftButton.ButtonPushedFcn = @(src, event) trialMoveLeft(src, event);
    TrialMoveRightButton = uibutton(GridLayout, 'push');
    TrialMoveRightButton.Text = '>';
    TrialMoveRightButton.Layout.Row = uiRow;
    TrialMoveRightButton.Layout.Column = 2;
    TrialMoveRightButton.ButtonPushedFcn = @(src, event) trialMoveRight(src, event);
    %
    uiRow = uiRow + 1;
    channelTreeLabel = uilabel(GridLayout);
    channelTreeLabel.Layout.Row = uiRow;
    channelTreeLabel.Layout.Column = [1 2];
    channelTreeLabel.Text = '  Channel List:';  
    uiRow = uiRow + 1;
    channelTree = uitree(GridLayout, 'checkbox');  
    channelTree.Layout.Row = [uiRow, length(GridLayout.RowHeight)];  
    channelTree.Layout.Column = [1 2];  
    channelTreeGroup = uitreenode(channelTree);  
    channelTreeGroup.Text = 'Channel Group'; 
    channelTree.CheckedNodesChangedFcn = @(src, event) checkChannels(src, event);
    channelLabel = ChannelTable.channel;
    goodchannel = cellfun(@char, ChannelTable.goodORbad, 'UniformOutput', false);
    N = 0;
    for ii_channel = 1:length(goodchannel)  
        if strcmp(goodchannel{ii_channel}, 'good')
            N = N + 1;
            channelTreeNode{N} = uitreenode(channelTreeGroup);                      % Create a new tree node  
            channelTreeNode{N}.Text = channelLabel{ii_channel};         % Set the node's text
            QCfigure.UserData.checkedChannels{N} = channelLabel{ii_channel};
        end
    end  
    % Create the uiaxes for plot miniprep iEEG signal
    miniPrepiEEGAxes = uiaxes(GridLayout);
    miniPrepiEEGAxes.Layout.Row = [1 length(GridLayout.RowHeight)];
    miniPrepiEEGAxes.Layout.Column = [3, 4];
    miniPrepiEEGAxes.Tag = 'miniPrep';
    % Create the uiaxes for plot IED/rHFO/frHFO signal
    IEDAxes = uiaxes(GridLayout);
    IEDAxes.Layout.Row = [1 8];
    IEDAxes.Layout.Column = 5;
    IEDAxes.Tag = 'IEDs';
    rHFOAxes = uiaxes(GridLayout);
    rHFOAxes.Layout.Row = [1 8];
    rHFOAxes.Layout.Column = 6;
    rHFOAxes.Tag = 'rHFOs';
    frHFOAxes = uiaxes(GridLayout);
    frHFOAxes.Layout.Row = [1 8];
    frHFOAxes.Layout.Column = 7;
    frHFOAxes.Tag = 'frHFOs';
    % Create the uiaxes for plot denoised iEEG signal
    denoisediEEGAxes = uiaxes(GridLayout);
    denoisediEEGAxes.Layout.Row = [9 length(GridLayout.RowHeight)];
    denoisediEEGAxes.Layout.Column = [5 7];
    denoisediEEGAxes.Tag = 'denoise';
end

%% Subfunction: callback function of control button
function editChannelTable(~, ~)
    QCfigure = findall(0, 'Type', 'figure', 'Tag', 'QCfigure');
    ChannelTable = getappdata(QCfigure, 'ChannelTable');
    ChannelTableFig = uifigure;
    ChannelTableFig.Tag = 'ChannelTable';
    ChannelTableFigGL = uigridlayout(ChannelTableFig, [1, 1]);
    Uitable = uitable(ChannelTableFigGL, "Data", ChannelTable);
    Uitable.ColumnEditable = [false true true true];
    Uitable.CellEditCallback = @(src, event) changeChannelTable(src, event);
    ChannelTableFig.CloseRequestFcn = @(src, event) closereq(src, event);
    function changeChannelTable(~, event)
        EditedRow = event.Indices(1); 
        EditedColumn = event.Indices(2); 
        NewData = event.NewData;
        ChannelTable{EditedRow, EditedColumn} = {NewData};
        setappdata(QCFigure, 'ChannelTable', ChannelTable);
    end
    function closereq(~, ~)
        selection = uiconfirm(ChannelTableFig, 'Close the table window and save the changes?', 'Confirmation');
        switch selection
            case 'OK'
                delete(ChannelTableFig);
            case 'Cancel'
                return
        end
    end
end
function highlightChannel(~, ~)
        XMouse = ROI.Position(1);
        YMouse = ROI.Position(2);
        delete(ROI);
        QCfigure = findall(0, 'Type', 'figure', 'Tag', 'QCfigure');
        XData = plotcfg.xData_currentWin;
        YData = plotcfg.yData_currentWin;
        [~, TimeIndex] = min(abs(XData-XMouse));
        [~, LineIndex] = min(abs((YData(:, TimeIndex)-YMouse)));
        ChannelLabel = DataForPlot.label;
        AimLineTag = ChannelLabel{LineIndex};
        AimLine =  findobj(QCfigure, {'Type', 'line'}, '-and', {'Tag', AimLineTag});
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
function voltageScalePlus(~, ~) 
    QCfigure = findall(0, 'Type', 'figure', 'Tag', 'QCfigure');
    voltageScale = QCfigure.UserData.miniPrep.figcfg.voltageScale;
    QCfigure.UserData.miniPrep.figcfg.voltageScale = voltageScale*2;
end
function voltageScaleMinus(~, ~) 
    QCfigure = findall(0, 'Type', 'figure', 'Tag', 'QCfigure');
    voltageScale = QCfigure.UserData.miniPrep.figcfg.voltageScale;
    QCfigure.UserData.miniPrep.figcfg.voltageScale = voltageScale/2;
end
function timeResolutionPlus(~, ~)
    QCfigure = findall(0, 'Type', 'figure', 'Tag', 'QCfigure');
    winWidth = QCfigure.UserData.miniPrep.figcfg.winWidth;
    QCfigure.UserData.miniPrep.figcfg.winWidth = winWidth*2;
end
function timeResolutionMinus(~, ~)
    QCfigure = findall(0, 'Type', 'figure', 'Tag', 'QCfigure');
    winWidth = QCfigure.UserData.miniPrep.figcfg.winWidth;
    QCfigure.UserData.miniPrep.figcfg.winWidth = winWidth/2;
end
function segmentMoveLeft(~, ~)
    QCfigure = findall(0, 'Type', 'figure', 'Tag', 'QCfigure');
    currentSegment = QCfigure.UserData.miniPrep.figcfg.currentSegment;
    QCfigure.UserData.miniPrep.figcfg.currentSegment = currentSegment - 1;
end
function segmentMoveRight(~, ~)
    QCfigure = findall(0, 'Type', 'figure', 'Tag', 'QCfigure');
    currentSegment = QCfigure.UserData.miniPrep.figcfg.currentSegment;
    QCfigure.UserData.miniPrep.figcfg.currentSegment = currentSegment + 1;
end
function trialMoveLeft(~, ~)
    QCfigure = findall(0, 'Type', 'figure', 'Tag', 'QCfigure');
    currentTrial = QCfigure.UserData.miniPrep.figcfg.currentTrial;
    QCfigure.UserData.miniPrep.figcfg.currentTrial = currentTrial - 1;
end
function trialMoveRight(~, ~)
    QCfigure = findall(0, 'Type', 'figure', 'Tag', 'QCfigure');
    currentTrial = QCfigure.UserData.miniPrep.figcfg.currentTrial;
    QCfigure.UserData.miniPrep.figcfg.currentTrial = currentTrial + 1;
end
function checkChannels(~, event)  
    Nodes = event.LeafCheckedNodes;
    Setting.CheckedChannels = {};  
    if ~isempty(Nodes)  
        for ii_channel2 = 1:length(Nodes)  
            Setting.CheckedChannels{ii_channel2} = Nodes(ii_channel2).Text;  
        end
    end
end