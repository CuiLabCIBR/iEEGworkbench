function mb1_iEEGPrepPipeline_panel(iEEGApp, GridLayout)
% mb1_iEEGMiniPrep_panel - Creates a panel for minimal IEEG preprocessing.  
%  
% Parameters:  
%   - IEEGPrepApp: The main IEEG preprocessing application object.  
%   - GridLayout: The layout manager for positioning UI components.  
%  
% This function adds UI components to the GridLayout for minimal IEEG  
% preprocessing, including labels, edit fields, and a run button.  
%
%% Initial setting  
    % Retrieve the current settings from the application's figure.  
    Setting = getappdata(iEEGApp.UiFig, 'Setting');
    
%% Run Button  
    % Create a run button that triggers the minimal preprocessing pipeline.  
    RunButton= ui_createRunButton(iEEGApp, GridLayout, [2 3], [3 7]);
    RunButton.ValueChangedFcn = @(src, event) runMiniPrep(src, event);
    function runMiniPrep(~, ~)
        if RunButton.Value
            disp('**********************************************************************************');
            disp('--------Running Minimal IEEG Preprocessing Pipeline');
            f_iEEGPrep_batchrun(Setting);                % Execute the minimal preprocessing pipeline. 
            RunButton.Value = false;                % Reset the button state. 
            disp('--------Finish Minimal IEEG Preprocessing Pipeline');
            disp('**********************************************************************************');
        end
    end
%% Set the Directory of BIDS
    % Set the label text for the BIDS directory.
    uiRow = 4;
    bidsLabel = uilabel(GridLayout);
    bidsLabel.Layout.Row = uiRow;
    bidsLabel.Layout.Column = [2 length(GridLayout.ColumnWidth)-2];
    bidsLabel.Text = '  BIDS Directory:';
    % Define the callback function for the BIDS directory edit field.
    uiRow = uiRow + 1;
    bidsEditField = uieditfield(GridLayout, 'text');
    bidsEditField.Layout.Row = uiRow;
    bidsEditField.Layout.Column = [2 length(GridLayout.ColumnWidth)-2];
    bidsEditField.ValueChangedFcn = @(src, event) setBIDSDir(src, event);
    % Callback function to update the BIDS directory setting.  
    function setBIDSDir(src, ~)  
        Setting.BIDSDir = get(src, 'Value');                                                                                                                % Update the BIDS directory.  
        [Setting.SubjectList, Setting.InputFiles] = ui_inputFiles_InfoPanel(iEEGApp.State, Setting, GridLayout);   % Update subject list and input files.  
        setappdata(iEEGApp.UiFig, 'Setting', Setting);                                                                                       % Save the updated settings.  
        [SubjectTree, SubjectTreeGroup, Setting] = ui_subjectList2Tree(SubjectTree, SubjectTreeGroup, Setting);  % Update the subject list in the tree view.  
    end
    if isfield(Setting, 'BIDSDir')  
        bidsEditField.Value = Setting.BIDSDir;  
    end  
%% Set the Directory of Derivatives
    % Set the label text for the derivatives directory.
    uiRow = uiRow + 1;
    derivativesLabel = uilabel(GridLayout);
    derivativesLabel.Layout.Row = uiRow;
    derivativesLabel.Layout.Column = [2 length(GridLayout.ColumnWidth)-2];
    derivativesLabel.Text = '  Derivatives Directory:';
    % Define the callback function for the derivatives directory edit field.
    uiRow = uiRow + 1;
    derivativesEditField = uieditfield(GridLayout, 'text');
    derivativesEditField.Layout.Row = uiRow;
    derivativesEditField.Layout.Column = [2 length(GridLayout.ColumnWidth)-2];
    derivativesEditField.ValueChangedFcn = @(src, event) setDerivativesDir(src, event);
    % Callback function to update the derivatives directory setting.  
    function setDerivativesDir(src, ~)  
        Setting.DerivativesDir = get(src, 'Value');                         % Update the derivatives directory.  
        setappdata(iEEGApp.UiFig, 'Setting', Setting);          % Save the updated settings.  
    end
    % Similar check for 'DerivativesDir'.  
    if isfield(Setting, 'DerivativesDir')  
        derivativesEditField.Value = Setting.DerivativesDir;  
    end  
%% Set the Task Name and other Key Word
    % Update the text of the third user interface label to 'Task'.
    uiRow = uiRow + 1;
    taskLabel = uilabel(GridLayout);
    taskLabel.Layout.Row = uiRow;
    taskLabel.Layout.Column = [2 5];
    taskLabel.Text = '  Task:';
    % Assign a callback function to the Task Name edit field.
    taskEditField = uieditfield(GridLayout, 'text');
    taskEditField.Layout.Row = uiRow;
    taskEditField.Layout.Column = [6 11];
    taskEditField.ValueChangedFcn = @(src, event) setTask(src, event);
    % Callback function for setting the task name.  
    function setTask(src, ~)
        Setting.Task = get(src, 'Value');
        [Setting.SubjectList, Setting.InputFiles] = ui_inputFiles_InfoPanel(iEEGApp.State, Setting, GridLayout);
        setappdata(iEEGApp.UiFig, 'Setting', Setting);
        [SubjectTree, SubjectTreeGroup, Setting] = ui_subjectList2Tree(SubjectTree, SubjectTreeGroup, Setting);
    end

    % Update the text of the fourth user interface label to 'Key Word'.
    keyLabel = uilabel(GridLayout);
    keyLabel.Layout.Row = uiRow;
    keyLabel.Layout.Column = [12 18];
    keyLabel.Text = '  Key Word:';
    % Assign a callback function to the fourth edit field for setting the keyword.
    keyEditField = uieditfield(GridLayout, 'text');
    keyEditField.Layout.Row = uiRow;
    keyEditField.Layout.Column = [19 24];
    keyEditField.ValueChangedFcn = @(src, event) setKeyWord(src, event);
    % Callback function for setting the keyword.  
    function setKeyWord(src, ~)
        Setting.KeyWord = get(src, 'Value');
        [Setting.SubjectList, Setting.InputFiles] = ui_inputFiles_InfoPanel(iEEGApp.State, Setting, GridLayout);
        setappdata(iEEGApp.UiFig, 'Setting', Setting);
        [SubjectTree, SubjectTreeGroup, Setting] = ui_subjectList2Tree(SubjectTree, SubjectTreeGroup, Setting);
    end
    % Check for 'Task' field. If not present, set it to 'rest' as default.  
    if isfield(Setting, 'Task')  
        taskEditField.Value = Setting.Task;  
    else  
        taskEditField.Value = 'rest';  Setting.Task = 'rest';  
    end
    % Check for 'KeyWord' field. If not present, set it to 'NA' as default.  
    if isfield(Setting, 'KeyWord')  
        keyEditField.Value = Setting.KeyWord;  
    else  
        keyEditField.Value = 'NA';  Setting.KeyWord = 'NA';  
    end
%% Set the Resample Frequency
    % Update the text of the fifth user interface label to 'Resample Frequency (Hz)'.
    uiRow = uiRow + 1;
    resampleFreqLabel = uilabel(GridLayout);
    resampleFreqLabel.Layout.Row = uiRow;
    resampleFreqLabel.Layout.Column = [2 16];
    resampleFreqLabel.Text = '  Resample Frequency(Hz):';
    % Assign a callback function to the fifth edit field for setting the resample frequency.
    resampleFreqEditField = uieditfield(GridLayout, 'numeric');
    resampleFreqEditField.Layout.Row = uiRow;
    resampleFreqEditField.Layout.Column = [17 20];
    resampleFreqEditField.ValueChangedFcn = @(src, event) setResampleFreq(src, event);
    % Callback function for setting the resample frequency.  
    function setResampleFreq(src, ~)
        Setting.ResampleFreq = get(src, 'Value');
        setappdata(iEEGApp.UiFig, 'Setting', Setting);
    end
    % Check for 'ResampleBPFreq' field. If not present, set it to 1000 as default.  
    if isfield(Setting, 'ResampleFreq')  
        resampleFreqEditField.Value = Setting.ResampleFreq;
    else  
        resampleFreqEditField.Value = 500;  
        Setting.ResampleFreq = 500;
    end
%% Set the Frequency Band for Bandpass Filtering
    % Update the text of the seventh user interface label to 'Bandpass Frequency (Hz)'.
    uiRow = uiRow + 1;
    bpFreqLabel = uilabel(GridLayout);
    bpFreqLabel.Layout.Row = uiRow;
    bpFreqLabel.Layout.Column = [2 13];
    bpFreqLabel.Text = '  Bandpass Filter(Hz):';
    % Assign a callback function to the seventh edit field for setting the bandpass frequency. 
    bpLowerFreqEditField = uieditfield(GridLayout, 'numeric');
    bpLowerFreqEditField.Layout.Row = uiRow;
    bpLowerFreqEditField.Layout.Column = [14 17];
    bpLowerFreqEditField.ValueChangedFcn = @(src, event) setLowerBPFreq(src, event);
    hyphenLabel = uilabel(GridLayout);
    hyphenLabel.Layout.Row = uiRow;
    hyphenLabel.Layout.Column = 18;
    hyphenLabel.Text = ' -';
    % Assign a callback function to the seventh edit field for setting the bandpass frequency. 
    bpUpperFreqEditField = uieditfield(GridLayout, 'numeric');
    bpUpperFreqEditField.Layout.Row = uiRow;
    bpUpperFreqEditField.Layout.Column = [19 22];
    bpUpperFreqEditField.ValueChangedFcn = @(src, event) setUpperBPFreq(src, event);
    % Callback function for setting the bandpass frequency.  
    function setLowerBPFreq(src, ~)
        Setting.LowerBPFreq = get(src, 'Value');
        setappdata(iEEGApp.UiFig, 'Setting', Setting);
    end
    function setUpperBPFreq(src, ~)
        Setting.UpperBPFreq = get(src, 'Value');
        setappdata(iEEGApp.UiFig, 'Setting', Setting);
    end
    % Check for 'LowerBPFreq' and 'UpperBPFreq' fields, setting defaults if necessary.  
    if isfield(Setting, 'LowerBPFreq')  
        bpLowerFreqEditField.Value = Setting.LowerBPFreq;  
    else  
        bpLowerFreqEditField.Value = 1; Setting.LowerBPFreq = 1;  
    end    
    if isfield(Setting, 'UpperBPFreq')  
        bpUpperFreqEditField.Value = Setting.UpperBPFreq;  
    else  
        bpUpperFreqEditField.Value = 160;  Setting.UpperBPFreq = 160;  
    end  
%% Set the Power-Line Frequency
    % Update the text of the sixth user interface label to 'Power Line Frequency (Hz)'.
    uiRow = uiRow + 1;
    powerlineFreqLabel = uilabel(GridLayout);
    powerlineFreqLabel.Layout.Row = uiRow;
    powerlineFreqLabel.Layout.Column = [2 16];
    powerlineFreqLabel.Text = '  Powerline Frequency(Hz):';
    % Assign a callback function to the sixth edit field for setting the power-line frequency.
    powerlineFreqEditField = uieditfield(GridLayout, 'numeric');
    powerlineFreqEditField.Layout.Row = uiRow;
    powerlineFreqEditField.Layout.Column = [17 20];
    powerlineFreqEditField.ValueChangedFcn = @(src, event) setPowerLineFreq(src, event);
    % Callback function for setting the power-line frequency. 
    function setPowerLineFreq(src, ~)
        Setting.PowerLineFreq = get(src, 'Value');
        setappdata(iEEGApp.UiFig, 'Setting', Setting);
    end
    % Check for 'PowerLineFreq' field. If not present, set it to 50 as default (typically the frequency of power lines in Hz).  
    if isfield(Setting, 'PowerLineFreq')  
        powerlineFreqEditField.Value = Setting.PowerLineFreq;  
    else  
        powerlineFreqEditField.Value = 50;  
        Setting.PowerLineFreq = 50;  
    end
%% Set Reference Method  
    % Set the label text for the reference method section
    uiRow = uiRow + 1;
    rereferenceMethodLabel = uilabel(GridLayout);
    rereferenceMethodLabel.Layout.Row = uiRow;
    rereferenceMethodLabel.Layout.Column = [2 length(GridLayout.ColumnWidth)-2];
    rereferenceMethodLabel.Text = '  Re-reference Method';  
  
    % Create a dropdown menu for selecting the reference method
    uiRow = uiRow + 1;
    rereferenceMethod = uidropdown(GridLayout);  
    rereferenceMethod.Layout.Row = uiRow;  
    rereferenceMethod.Layout.Column = [2 length(GridLayout.ColumnWidth)-2];  
    % Populate the dropdown menu with available reference methods  
    rereferenceMethod.Items = {'None', 'CommonAverage', 'ChannelAverage', 'Bipolar', 'Laplace'};  
  
    % Define a callback function for when the selected value in the dropdown changes  
    rereferenceMethod.ValueChangedFcn = @(src, event) selectRereferenceMethod(src, event); 
    if ~isfield(Setting, 'SelectedRefMethod')  % If the selected reference method is not set  
        Setting.SelectedRefMethod = 'None';  % Set the default reference method to 'CommonAverage'  
    end  
  
    % Callback function to update the selected reference method  
    function selectRereferenceMethod(src, ~)  
        Setting.SelectedRefMethod = get(src, 'Value');  % Get the selected value from the dropdown  
        setappdata(iEEGApp.UiFig, 'Setting', Setting);  % Store the updated setting  
        disp(['Select Re-reference Method:' Setting.SelectedRefMethod]);  % Display the selected method  
    end
%%
    uiRow = uiRow + 1;
    IEDCheckBox = uicheckbox(GridLayout);
    IEDCheckBox.Layout.Row = uiRow;
    IEDCheckBox.Layout.Column = [3, 12];
    IEDCheckBox.Text = 'IED Detection';
    IEDCheckBox.ValueChangedFcn = @(src, event) setIEDDetection(src, event);
    if isfield(Setting, 'IEDDetection')
        IEDCheckBox.Value = Setting.IEDDetection;
    else
        IEDCheckBox.Value = 1;
        Setting.IEDDetection = IEDCheckBox.Value;
    end
    function setIEDDetection(src, ~)
        Setting.IEDDetection = get(src, 'Value');
        setappdata(iEEGApp.UiFig, 'Setting', Setting);
    end

    IEDRegressionCheckBox = uicheckbox(GridLayout);
    IEDRegressionCheckBox.Layout.Row = uiRow;
    IEDRegressionCheckBox.Layout.Column = [13, 23];
    IEDRegressionCheckBox.Text = 'IED Regression';
    IEDRegressionCheckBox.ValueChangedFcn = @(src, event) setIEDRegression(src, event);
    if isfield(Setting, 'IEDRegression')
        IEDRegressionCheckBox.Value = Setting.IEDRegression;
    else
        IEDRegressionCheckBox.Value = 1;
        Setting.IEDRegression = IEDRegressionCheckBox.Value;
    end
    function setIEDRegression(src, ~)
        Setting.IEDRegression = get(src, 'Value');
        setappdata(iEEGApp.UiFig, 'Setting', Setting);
    end
    
    uiRow = uiRow + 1;
    IEDthdLabel = uilabel(GridLayout);
    IEDthdLabel.Layout.Row = uiRow;
    IEDthdLabel.Layout.Column = [2 10];
    IEDthdLabel.Text = '  IED Threshold:';
    IEDthdEditField = uieditfield(GridLayout, 'numeric');
    IEDthdEditField.Layout.Row = uiRow;
    IEDthdEditField.Layout.Column = [11 14];
    IEDthdEditField.ValueChangedFcn = @(src, event) setIEDThreshold(src, event);
    if isfield(Setting, 'IEDThreshold')
        IEDthdEditField.Value = Setting.IEDThreshold;
    else
        IEDthdEditField.Value = 3.65;
        Setting.IEDThreshold = IEDthdEditField.Value;
    end
    function setIEDThreshold(src, ~)
        Setting.IEDThreshold = get(src, 'Value');
        setappdata(iEEGApp.UiFig, 'Setting', Setting);
    end

    uiRow = uiRow + 1;
    IEDFreqLabel = uilabel(GridLayout);
    IEDFreqLabel.Layout.Row = uiRow;
    IEDFreqLabel.Layout.Column = [2 13];
    IEDFreqLabel.Text = '  IED Frequency(Hz):';
    IEDLowerFreqEditField = uieditfield(GridLayout, 'numeric');
    IEDLowerFreqEditField.Layout.Row = uiRow;
    IEDLowerFreqEditField.Layout.Column = [14 17];
    IEDLowerFreqEditField.ValueChangedFcn = @(src, event) setIEDLowerFreq(src, event);
    hyphenLabel = uilabel(GridLayout);
    hyphenLabel.Layout.Row = uiRow;
    hyphenLabel.Layout.Column = 18;
    hyphenLabel.Text = ' -';
    IEDUpperFreqEditField = uieditfield(GridLayout, 'numeric');
    IEDUpperFreqEditField.Layout.Row = uiRow;
    IEDUpperFreqEditField.Layout.Column = [19 22];
    IEDUpperFreqEditField.ValueChangedFcn = @(src, event) setIEDUpperFreq(src, event);
    if isfield(Setting, 'IEDLowerFreq')
        IEDLowerFreqEditField.Value = Setting.IEDLowerFreq;
    else
        IEDLowerFreqEditField.Value = 10;
        Setting.IEDLowerFreq = IEDLowerFreqEditField.Value;
    end
    if isfield(Setting, 'IEDUpperFreq')
        IEDUpperFreqEditField.Value = Setting.IEDUpperFreq;
    else
        IEDUpperFreqEditField.Value = 60;
        Setting.IEDUpperFreq = IEDUpperFreqEditField.Value;
    end
    function setIEDLowerFreq(src, ~)
        Setting.IEDLowerFreq = get(src, 'Value');
        setappdata(iEEGApp.UiFig, 'Setting', Setting);
    end
    function setIEDUpperFreq(src, ~)
        Setting.IEDUpperFreq = get(src, 'Value');
        setappdata(iEEGApp.UiFig, 'Setting', Setting);
    end
%%
    uiRow = uiRow + 1;
    rHFOCheckBox = uicheckbox(GridLayout);
    rHFOCheckBox.Layout.Row = uiRow;
    rHFOCheckBox.Layout.Column = [3, 13];
    rHFOCheckBox.Text = 'rHFO Detection';
    rHFOCheckBox.ValueChangedFcn = @(src, event) setrHFODetection(src, event);
    if isfield(Setting, 'rHFODetection')
        rHFOCheckBox.Value = Setting.rHFODetection;
    else
        rHFOCheckBox.Value = 1;
        Setting.rHFODetection = rHFOCheckBox.Value;
    end
    function setrHFODetection(src, ~)
        Setting.rHFODetection = get(src, 'Value');
        setappdata(iEEGApp.UiFig, 'Setting', Setting);
    end

    rHFORegressionCheckBox = uicheckbox(GridLayout);
    rHFORegressionCheckBox.Layout.Row = uiRow;
    rHFORegressionCheckBox.Layout.Column = [14, 25];
    rHFORegressionCheckBox.Text = 'rHFO Regression';
    rHFORegressionCheckBox.ValueChangedFcn = @(src, event) setrHFORegression(src, event);
    if isfield(Setting, 'rHFORegression')
        rHFORegressionCheckBox.Value = Setting.rHFORegression;
    else
        rHFORegressionCheckBox.Value = 1;
        Setting.rHFORegression = rHFORegressionCheckBox.Value;
    end
    function setrHFORegression(src, ~)
        Setting.rHFORegression = get(src, 'Value');
        setappdata(iEEGApp.UiFig, 'Setting', Setting);
    end

    uiRow = uiRow + 1;
    rHFOthdLabel = uilabel(GridLayout);
    rHFOthdLabel.Layout.Row = uiRow;
    rHFOthdLabel.Layout.Column = [2 11];
    rHFOthdLabel.Text = '  rHFO Threshold:';
    rHFOthdEditField = uieditfield(GridLayout, 'numeric');
    rHFOthdEditField.Layout.Row = uiRow;
    rHFOthdEditField.Layout.Column = [12 15];
    rHFOthdEditField.ValueChangedFcn = @(src, event) setrHFOThreshold(src, event);
     if isfield(Setting, 'rHFOThreshold')
        rHFOthdEditField.Value = Setting.rHFOThreshold;
    else
        rHFOthdEditField.Value = 5;
        Setting.rHFOThreshold = rHFOthdEditField.Value;
     end
     function setrHFOThreshold(src, ~)
        Setting.rHFOThreshold = get(src, 'Value');
        setappdata(iEEGApp.UiFig, 'Setting', Setting);
    end

    uiRow = uiRow + 1;
    rHFOFreqLabel = uilabel(GridLayout);
    rHFOFreqLabel.Layout.Row = uiRow;
    rHFOFreqLabel.Layout.Column = [2 14];
    rHFOFreqLabel.Text = '  rHFO Frequency(Hz):';
    rHFOLowerFreqEditField = uieditfield(GridLayout, 'numeric');
    rHFOLowerFreqEditField.Layout.Row = uiRow;
    rHFOLowerFreqEditField.Layout.Column = [15 18];
    rHFOLowerFreqEditField.ValueChangedFcn = @(src, event) setrHFOLowerFreq(src, event);
    hyphenLabel = uilabel(GridLayout);
    hyphenLabel.Layout.Row = uiRow;
    hyphenLabel.Layout.Column = 19;
    hyphenLabel.Text = ' -';
    rHFOUpperFreqEditField = uieditfield(GridLayout, 'numeric');
    rHFOUpperFreqEditField.Layout.Row = uiRow;
    rHFOUpperFreqEditField.Layout.Column = [20 23];
    rHFOUpperFreqEditField.ValueChangedFcn = @(src, event) setrHFOUpperFreq(src, event);
    if isfield(Setting, 'rHFOLowerFreq')
        rHFOLowerFreqEditField.Value = Setting.rHFOLowerFreq;
    else
        rHFOLowerFreqEditField.Value = 80;
        Setting.rHFOLowerFreq = rHFOLowerFreqEditField.Value;
    end
    if isfield(Setting, 'rHFOUpperFreq')
        rHFOUpperFreqEditField.Value = Setting.rHFOUpperFreq;
    else
        rHFOUpperFreqEditField.Value = 160;
        Setting.rHFOUpperFreq = rHFOUpperFreqEditField.Value;
    end
    function setrHFOLowerFreq(src, ~)
        Setting.rHFOLowerFreq = get(src, 'Value');
        setappdata(iEEGApp.UiFig, 'Setting', Setting);
    end
    function setrHFOUpperFreq(src, ~)
        Setting.rHFOUpperFreq = get(src, 'Value');
        setappdata(iEEGApp.UiFig, 'Setting', Setting);
    end
%%
    uiRow = uiRow + 1;
    frHFOCheckBox = uicheckbox(GridLayout);
    frHFOCheckBox.Layout.Row = uiRow;
    frHFOCheckBox.Layout.Column = [3, 13];
    frHFOCheckBox.Text = 'frHFO Detection';
    frHFOCheckBox.ValueChangedFcn = @(src, event) setfrHFODetection(src, event);
    if isfield(Setting, 'frHFODetection')
        frHFOCheckBox.Value = Setting.frHFODetection;
    else
        frHFOCheckBox.Value = 1;
        Setting.frHFODetection = frHFOCheckBox.Value;
    end
    function setfrHFODetection(src, ~)
        Setting.frHFODetection = get(src, 'Value');
        setappdata(iEEGApp.UiFig, 'Setting', Setting);
    end

    frHFORegressionCheckBox = uicheckbox(GridLayout);
    frHFORegressionCheckBox.Layout.Row = uiRow;
    frHFORegressionCheckBox.Layout.Column = [14, 25];
    frHFORegressionCheckBox.Text = 'frHFO Regression';
    frHFORegressionCheckBox.ValueChangedFcn = @(src, event) setfrHFORegression(src, event);
    if isfield(Setting, 'frHFORegression')
        frHFORegressionCheckBox.Value = Setting.frHFORegression;
    else
        frHFORegressionCheckBox.Value = 1;
        Setting.frHFORegression = frHFORegressionCheckBox.Value;
    end
    function setfrHFORegression(src, ~)
        Setting.frHFORegression = get(src, 'Value');
        setappdata(iEEGApp.UiFig, 'Setting', Setting);
    end

    uiRow = uiRow + 1;
    frHFOthdLabel = uilabel(GridLayout);
    frHFOthdLabel.Layout.Row = uiRow;
    frHFOthdLabel.Layout.Column = [2 11];
    frHFOthdLabel.Text = '  frHFO Threshold:';
    frHFOthdEditField = uieditfield(GridLayout, 'numeric');
    frHFOthdEditField.Layout.Row = uiRow;
    frHFOthdEditField.Layout.Column = [12 15];
    frHFOthdEditField.ValueChangedFcn = @(src, event) setfrHFOthreshold(src, event);
    if isfield(Setting, 'frHFOThreshold')
        frHFOthdEditField.Value = Setting.frHFOThreshold;
    else
        frHFOthdEditField.Value = 5;
        Setting.frHFOThreshold = frHFOthdEditField.Value;
    end
    function setfrHFOthreshold(src, ~)
        Setting.frHFOThreshold = get(src, 'Value');
        setappdata(iEEGApp.UiFig, 'Setting', Setting);
    end

    uiRow = uiRow + 1;
    frHFOFreqLabel = uilabel(GridLayout);
    frHFOFreqLabel.Layout.Row = uiRow;
    frHFOFreqLabel.Layout.Column = [2 14];
    frHFOFreqLabel.Text = '  frHFO Frequency(Hz):';
    frHFOLowerFreqEditField = uieditfield(GridLayout, 'numeric');
    frHFOLowerFreqEditField.Layout.Row = uiRow;
    frHFOLowerFreqEditField.Layout.Column = [15 18];
    frHFOLowerFreqEditField.ValueChangedFcn = @(src, event) setfrHFOLowerFreq(src, event);
    hyphenLabel = uilabel(GridLayout);
    hyphenLabel.Layout.Row = uiRow;
    hyphenLabel.Layout.Column = 19;
    hyphenLabel.Text = ' -';
    frHFOUpperFreqEditField = uieditfield(GridLayout, 'numeric');
    frHFOUpperFreqEditField.Layout.Row = uiRow;
    frHFOUpperFreqEditField.Layout.Column = [20 23];
    frHFOUpperFreqEditField.ValueChangedFcn = @(src, event) setfrHFOUpperFreq(src, event);
    if isfield(Setting, 'frHFOLowerFreq')
        frHFOLowerFreqEditField.Value = Setting.frHFOLowerFreq;
    else
        frHFOLowerFreqEditField.Value = 160;
        Setting.frHFOLowerFreq = frHFOLowerFreqEditField.Value;
    end
    if isfield(Setting, 'frHFOUpperFreq')
        frHFOUpperFreqEditField.Value = Setting.frHFOUpperFreq;
    else
        frHFOUpperFreqEditField.Value = 450;
        Setting.frHFOUpperFreq = frHFOUpperFreqEditField.Value;
    end
    function setfrHFOLowerFreq(src, ~)
        Setting.frHFOLowerFreq = get(src, 'Value');
        setappdata(iEEGApp.UiFig, 'Setting', Setting);
    end
    function setfrHFOUpperFreq(src, ~)
        Setting.frHFOUpperFreq = get(src, 'Value');
        setappdata(iEEGApp.UiFig, 'Setting', Setting);
    end
%% Remove bad channel and time point
    uiRow = uiRow + 1;
    RemoveBadChannelsCheckBox = uicheckbox(GridLayout);
    RemoveBadChannelsCheckBox.Layout.Row = uiRow;
    RemoveBadChannelsCheckBox.Layout.Column = [3, 16];
    RemoveBadChannelsCheckBox.Text = 'Remove bad channels';
    RemoveBadChannelsCheckBox.ValueChangedFcn = @(src, event) setRemoveBadChannels(src, event);
    if isfield(Setting, 'RemoveBadChannels')
        RemoveBadChannelsCheckBox.Value = Setting.RemoveBadChannels;
    else
        RemoveBadChannelsCheckBox.Value = 1;
        Setting.RemoveBadChannels = RemoveBadChannelsCheckBox.Value;
    end
    function setRemoveBadChannels(src, ~)
        Setting.RemoveBadChannels = get(src, 'Value');
        setappdata(iEEGApp.UiFig, 'Setting', Setting);
    end
    uiRow = uiRow + 1;
    scrubbingCheckBox = uicheckbox(GridLayout);
    scrubbingCheckBox.Layout.Row = uiRow;
    scrubbingCheckBox.Layout.Column = [3, 10];
    scrubbingCheckBox.Text = 'scrubbing';
    scrubbingCheckBox.ValueChangedFcn = @(src, event) setScrubbing(src, event);
    if isfield(Setting, 'scrubbing')
        scrubbingCheckBox.Value = Setting.scrubbing;
    else
        scrubbingCheckBox.Value = 1;
        Setting.scrubbing = scrubbingCheckBox.Value;
    end
    function setScrubbing(src, ~)
        Setting.scrubbing = get(src, 'Value');
        setappdata(IEEGPrepApp.UiFig, 'Setting', Setting);
    end
%% Set the Subject Tree for Select Subject
    % Set the text of the 9th user interface label to indicate the subject list.
    uiRow = uiRow + 1;
    subjTreeLabel = uilabel(GridLayout);
    subjTreeLabel.Layout.Row = uiRow;
    subjTreeLabel.Layout.Column = [2 10];
    subjTreeLabel.Text = '  Subject List:';  
    % Create a user interface tree control with checkboxes in the specified grid layout position.
    uiRow = uiRow + 1;
    SubjectTree = uitree(GridLayout, 'checkbox');  
    SubjectTree.Layout.Row = [uiRow, length(GridLayout.RowHeight)-1];  
    SubjectTree.Layout.Column = [2 length(GridLayout.ColumnWidth)-2];  
    % Add a root node to the subject tree with the text 'Subject Group'.  
    SubjectTreeGroup = uitreenode(SubjectTree);  
    SubjectTreeGroup.Text = 'Subject Group'; 
    % Assign callback function in response to node check and selection
    SubjectTree.CheckedNodesChangedFcn = @(src, event) checkSubjects(src, event); 
    % Callback function for handling changes in the checked nodes of the subject tree  
    function checkSubjects(~, event)  
        % Retrieve the list of checked nodes from the event data.  
        Nodes = event.LeafCheckedNodes;
        % If there are checked nodes, loop through them and store their texts in the CheckedSubjects cell array.  
        if ~isempty(Nodes)
            CheckedSubjects = cell(length(Nodes), 1);
            for ii_sub = 1:length(Nodes)  
                CheckedSubjects{ii_sub} = Nodes(ii_sub).Text;  
            end
            InputFiles = Setting.InputFiles;
            N = 0;
            for ii_file = 1:length(InputFiles)
                fileName = InputFiles(ii_file).name;
                for ii_sub = 1:length(CheckedSubjects)
                    subjID = CheckedSubjects{ii_sub};
                    if contains(fileName, subjID)
                        N = N + 1;
                        CheckedFiles(N) = InputFiles(ii_file);
                        CheckedSubjectList{N} = subjID;
                    end
                end
            end
            Setting.CheckedSubjectList = CheckedSubjectList;
            Setting.CheckedFiles = CheckedFiles;
        else
            Setting.CheckedSubjectList= {};
            Setting.CheckedFiles = [];
        end
        % After each addition, save the updated Setting structure to the application's figure.  
        setappdata(iEEGApp.UiFig, 'Setting', Setting);  
    end
    % Get subject list and input file information, updating the 'Setting' structure.  
    [Setting.SubjectList, Setting.InputFiles] = ui_inputFiles_InfoPanel(iEEGApp.State, Setting, GridLayout);
    % Update the subject tree in the UI.  
    [SubjectTree, SubjectTreeGroup, Setting] = ui_subjectList2Tree(SubjectTree, SubjectTreeGroup, Setting);
    % Store the updated 'Setting' structure in the application's data.  
    setappdata(iEEGApp.UiFig, 'Setting', Setting);
end