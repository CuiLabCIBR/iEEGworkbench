function f_IED_qualityControlGUI(DerivativesDir, IEEGfilename, IEDfilename)
%
%
%
%% Load IED list
    IEDsDir = dir(fullfile(DerivativesDir, '**', IEDfilename));
    IEDs = load(fullfile(IEDsDir.folder, IEDsDir.name));
    cd(IEDsDir.folder);
    IEDs = IEDs.IEDs;

%% show figure
    SignalFig = f_IEEGVisualization(DerivativesDir, IEEGfilename);
    Plotcfg = getappdata(SignalFig, 'Plotcfg');
    Plotcfg.IEDs = IEDs;
    Plotcfg.currentIEDNum = 1;
    setappdata(SignalFig, 'Plotcfg', Plotcfg);
    f_plot_timeseries(SignalFig);

    %% change the number of IED
    GridLayout = SignalFig.Children;

    % Create the button 
    IEDMoveLabel = uilabel(GridLayout);
    IEDMoveLabel.Layout.Row = 12;
    IEDMoveLabel.Layout.Column = [1 6];
    IEDMoveLabel.Text = '  IED Number';
    IEDMoveLeftButton = uibutton(GridLayout, 'push');
    IEDMoveLeftButton.Text = '<';
    IEDMoveLeftButton.Layout.Row = 13;
    IEDMoveLeftButton.Layout.Column = [1 3];
    % Asign a callback function for pressing the button.
    IEDMoveLeftButton.ButtonPushedFcn = @(src, event) iedMoveLeft(src, event);
    
    IEDMoveRightButton = uibutton(GridLayout, 'push');
    IEDMoveRightButton.Text = '>';
    IEDMoveRightButton.Layout.Row = 13;
    IEDMoveRightButton.Layout.Column = [4 6];
    % Asign a callback function for pressing the button.
    IEDMoveRightButton.ButtonPushedFcn = @(src, event) iedMoveRight(src, event);

%% edit IED information
    % Create a button group and radio buttons:
    IEDTypeLabel = uilabel(GridLayout);
    IEDTypeLabel.Layout.Row = 14;
    IEDTypeLabel.Layout.Column = [1 6];
    IEDTypeLabel.Text = '  IED Type';
    BG = uibuttongroup(GridLayout);
    BG.Layout.Row = [15 18];
    BG.Layout.Column = [1 6];
    BG.SelectionChangedFcn = @(src, event) selectIEDtype(src, event);
    RB1 = uiradiobutton(BG, 'Position', [20 110 250 35]);
    RB1.Text = 'none-IED normal activity';
    RB2 = uiradiobutton(BG, 'Position', [20 75 250 35]);
    RB2.Text = 'spike slow wave';
    RB3 = uiradiobutton(BG, 'Position', [20 40 250 35]);
    RB3.Text = 'spike with HFOs';
    RB4 = uiradiobutton(BG, 'Position', [20 4 250 35]);
    RB4.Text = 'polyspike';

    function selectIEDtype(~, event)
        SelectedIEDtyle = event.NewValue.Text;
        Plotcfg = getappdata(SignalFig, 'Plotcfg');
        CurrentTrialNum = Plotcfg.currentTrialNum; % the number of current trial
        IEDs = Plotcfg.IEDs;
        IEDs_currentTrial = IEDs.trial(CurrentTrialNum).IEDs_allchannel;
        CurrentIEDNum = Plotcfg.currentIEDNum;
        switch SelectedIEDtyle
            case 'spike'
                disp(['Present sharp wave:', num2str(CurrentIEDNum), ' is spike.']);
                IEDs_currentTrial.manualRate{CurrentIEDNum} = SelectedIEDtyle;
            case 'spike slow wave'
                disp(['Present sharp wave:', num2str(CurrentIEDNum),  ' is spike slow wave.']);
                IEDs_currentTrial.manualRate{CurrentIEDNum} = SelectedIEDtyle;
            case 'spike with HFOs'
                disp(['Present sharp wave:', num2str(CurrentIEDNum),  ' is spike with HFOs.']);
                IEDs_currentTrial.manualRate{CurrentIEDNum} = SelectedIEDtyle;
            case 'polyspike'
                disp(['Present sharp wave:', num2str(CurrentIEDNum),  ' is polyspike.'])
                IEDs_currentTrial.manualRate{CurrentIEDNum} = SelectedIEDtyle;
            case 'none'
                disp(['Present sharp wave:', num2str(CurrentIEDNum),  ' is normal activity.'])
                IEDs_currentTrial.manualRate{CurrentIEDNum} = SelectedIEDtyle;
        end
        IEDs.trial(CurrentTrialNum).IEDs_allchannel = IEDs_currentTrial;
        Plotcfg.IEDs = IEDs;
        setappdata(SignalFig, 'plotcfg', Plotcfg);
    end

    SignalFig.CloseRequestFcn = @(src, event) closereq(src, event);
    function closereq(~, ~)
        selection = questdlg('Close the figure window and save the changes?', ...
            'save IED list', ...
            'Yes', 'No', 'No');
        switch selection
            case 'Yes'
                SaveFolder = IEDsDir.folder;
                SaveName = IEDsDir.name;
                save(fullfile(SaveFolder, SaveName), 'IEDs');
                delete( SignalFig);
            case 'No'
                return
        end
    end

    function iedMoveLeft(~, ~)
        Plotcfg = getappdata(SignalFig, 'Plotcfg');
        Plotcfg.currentIEDNum = Plotcfg.currentIEDNum - 1;
        setappdata(SignalFig, 'Plotcfg', Plotcfg);
        f_plot_timeseries(SignalFig)
    end

    function iedMoveRight(~, ~)
        Plotcfg = getappdata(SignalFig, 'Plotcfg');
        Plotcfg.currentIEDNum = Plotcfg.currentIEDNum + 1;
        setappdata(SignalFig, 'Plotcfg', Plotcfg);
        f_plot_timeseries(SignalFig)
    end
end






