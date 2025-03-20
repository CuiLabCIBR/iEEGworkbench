function f_HFO_qualityControlGUI(DerivativesDir, IEEGfilename, HFOfilename)
%
%
%
%% Load HFOs
    HFOsDir = dir(fullfile(DerivativesDir, '**', HFOfilename));
    HFOs = load(fullfile(HFOsDir.folder, HFOsDir.name));
    cd(HFOsDir.folder);
    HFOs = HFOs.HFOs;

%% show figure
    SignalFig = f_IEEGVisualization(DerivativesDir, IEEGfilename);
    Plotcfg = getappdata(SignalFig, 'Plotcfg');
    Plotcfg.HFOs = HFOs;
    Plotcfg.currentHFONum = 1;
    setappdata(SignalFig, 'Plotcfg', Plotcfg);
    f_plot_timeseries(SignalFig);
    GridLayout = SignalFig.Children;

%% Change the number of HFOs
    % Create the button 
    HFOMoveLabel = uilabel(GridLayout);
    HFOMoveLabel.Layout.Row = 12;
    HFOMoveLabel.Layout.Column = [1 6];
    HFOMoveLabel.Text = '  HFO Number';

    HFOMoveLeftButton = uibutton(GridLayout, 'push');
    HFOMoveLeftButton.Text = '<';
    HFOMoveLeftButton.Layout.Row = 13;
    HFOMoveLeftButton.Layout.Column = [1 3];
    % Asign a callback function for pressing the button.
    HFOMoveLeftButton.ButtonPushedFcn = @(src, event) HFOMoveLeft(src, event);
    function HFOMoveLeft(~, ~)
        Plotcfg = getappdata(SignalFig, 'Plotcfg');
        Plotcfg.currentHFONum = Plotcfg.currentHFONum - 1;
        setappdata(SignalFig, 'Plotcfg', Plotcfg);
        f_plot_timeseries(SignalFig)
    end
    
    HFOMoveRightButton = uibutton(GridLayout, 'push');
    HFOMoveRightButton.Text = '>';
    HFOMoveRightButton.Layout.Row = 13;
    HFOMoveRightButton.Layout.Column = [4 6];
    % Asign a callback function for pressing the button.
    HFOMoveRightButton.ButtonPushedFcn = @(src, event) HFOMoveRight(src, event);
    function HFOMoveRight(~, ~)
        Plotcfg = getappdata(SignalFig, 'Plotcfg');
        Plotcfg.currentHFONum = Plotcfg.currentHFONum + 1;
        setappdata(SignalFig, 'Plotcfg', Plotcfg);
        f_plot_timeseries(SignalFig)
    end
end






