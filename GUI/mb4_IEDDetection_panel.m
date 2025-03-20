function mb4_IEDDetection_panel(iEEGPrepApp, GridLayout)
% mb4_IEDDetection_panel - Create a user interface panel for Interictal Epileptic Discharge (IED) detection. 
%  
% INPUT:  
%   - iEEGPrepApp: The main iEEG preparation application structure/object.  
%   - GridLayout: A grid layout object that defines the organization of UI components.  
%  
% OUTPUT:  
%   - None.
%  
%% Initial setting  
    % Retrieves the application settings stored in the appdata of the UI figure. 
    Setting = getappdata(iEEGPrepApp.UiFig, 'Setting');

%% Running Button
    % Creates a run button using a custom function f_createRunButton.  
    % The button is placed within the specified GridLayout at the specified position.  
    RunButton = ui_createRunButton(iEEGPrepApp, GridLayout, [2 3], [3 4]);  
  
    % Sets the ValueChangedFcn callback for the run button.  
    % When the button's value changes (e.g., from off to on), the callback function runiEEGReference is executed.  
    RunButton.ValueChangedFcn = @(src, event) runIEDDetection(src, event);  
  
    % Define the callback function that is called when the run button is pressed.  
    function runIEDDetection(~, ~)
        % Checks if the run button is in the 'on' state.  
        if RunButton.Value  
            % Displays messages indicating the start of the re-referencing process.  
            disp('**********************************************************************************');  
            disp('******** Running IED Detection');  
              
            % Calls the function with the retrieved settings to perform the re-referencing.  
            f_IEDdetection_batchrun(Setting);
              
            % Turns the run button off after the process is complete.  
            RunButton.Value = false;  
              
            % Displays a message indicating the completion of the re-referencing process.  
            disp('******** Finish IED Detection');  
            disp('**********************************************************************************');  
        end  
    end
%% Labels and Edit Fields for Directories 
    % Initialize a cell array to hold labels. This cell array will store references to three uilabel objects.  
    uiLabel = cell(9, 1);  

    % Define the layout positions for the labels. 
    % uiLabelRow specifies the row positions.
    % uiLabelColumn specifies the column positions.  
    uiLabelRow = {4, 6, 8, 10, 12, 14, 16, 18, 20};
    uiLabelColumn = [2 length(GridLayout.ColumnWidth)-2];

    % Loop through to create three labels and set their layout positions.  
    for ii_uilabel = 1:length(uiLabel)
        uiLabel{ii_uilabel} = uilabel(GridLayout);
        uiLabel{ii_uilabel}.Layout.Row = uiLabelRow{ii_uilabel};
        uiLabel{ii_uilabel}.Layout.Column = uiLabelColumn;
    end
    
    uiEditField = cell(7, 1);
    % Define the styles for the edit fields.
    uiEditFieldStyle = {'text', 'text', 'text', 'numeric', 'numeric', 'numeric', 'numeric'};

    % Set the layout positions, styles, and create the edit fields.  
    uiEditFieldRow = {5, 7, 9, 11, 13, 15, 17};
    uiEditFieldColumn = [2 length(GridLayout.ColumnWidth)-2];
    for ii_uiEditField = 1:length(uiEditFieldRow)
        uiEditField{ii_uiEditField} = uieditfield(GridLayout, uiEditFieldStyle{ii_uiEditField});
        uiEditField{ii_uiEditField}.Layout.Row = uiEditFieldRow{ii_uiEditField};
        uiEditField{ii_uiEditField}.Layout.Column = uiEditFieldColumn;
    end

%% Set Derivatives Directory
    uiLabel{1}.Text = '  Derivatives Directory';
    % Callback function
    uiEditField{1}.ValueChangedFcn = @(src, event) setDerivativesDir(src, event);
    function setDerivativesDir(src, ~)
        Setting.DerivativesDir = get(src, 'Value');
        [Setting.SubjectList, Setting.InputFiles] = ui_inputFiles_InfoPanel(iEEGPrepApp.State, Setting, GridLayout);  
        [SubjectTree, SubjectTreeGroup, Setting] = ui_subjectList2Tree(SubjectTree, SubjectTreeGroup, Setting);  
        setappdata(iEEGPrepApp.UiFig, 'Setting', Setting);
    end
%% Set task name
    uiLabel{2}.Text = '  Task';
    % Callback function
    uiEditField{2}.ValueChangedFcn = @(src, event) setTask(src, event);
    function setTask(src, ~)
        Setting.Task = get(src, 'Value');
        [Setting.SubjectList, Setting.InputFiles] = ui_inputFiles_InfoPanel(iEEGPrepApp.State, Setting, GridLayout);  
        [SubjectTree, SubjectTreeGroup, Setting] = ui_subjectList2Tree(SubjectTree, SubjectTreeGroup, Setting);
        setappdata(iEEGPrepApp.UiFig, 'Setting', Setting);
    end
%% Set other Key Word
    uiLabel{3}.Text = '  Key Word';
    uiEditField{3}.ValueChangedFcn = @(src, event) setKeyWord(src, event);
    % Callback function
    function setKeyWord(src, ~)
        Setting.KeyWord = get(src, 'Value');
        [Setting.SubjectList, Setting.InputFiles] = ui_inputFiles_InfoPanel(iEEGPrepApp.State, Setting, GridLayout);  
        [SubjectTree, SubjectTreeGroup, Setting] = ui_subjectList2Tree(SubjectTree, SubjectTreeGroup, Setting);
        setappdata(iEEGPrepApp.UiFig, 'Setting', Setting);
    end
%% Set slide window size
    uiLabel{4}.Text = '  Time Window Size (s)';
    % Callback function
    uiEditField{4}.ValueChangedFcn = @(src, event) setIEDWinSize(src, event);
    function setIEDWinSize(src, ~)
        Setting.IEDWinSize = get(src, 'Value');
        setappdata(iEEGPrepApp.UiFig, 'Setting', Setting);
    end
%% Set IED threshold k
    uiLabel{5}.Text = '  IED Threshold (Default:3.65)';
    % Callback function
    uiEditField{5}.ValueChangedFcn = @(src, event) setIEDThreshold(src, event);
    function setIEDThreshold(src, ~)
        Setting.IEDThreshold = get(src, 'Value');
        setappdata(iEEGPrepApp.UiFig, 'Setting', Setting);
    end
%% input the lower frequency for bandpass filtering
    uiLabel{6}.Text = '  IED Lower Frequency (Hz)';
    uiEditField{6}.ValueChangedFcn = @(src, event) setIEDLowerFreq(src, event);
    function setIEDLowerFreq(src, ~)
        Setting.IEDLowerFreq = get(src, 'Value');
        setappdata(iEEGPrepApp.UiFig, 'Setting', Setting);
    end
%% input the upper frequency for bandpass filtering
    uiLabel{7}.Text = '  IED Upper Frequency (Hz)';
    uiEditField{7}.ValueChangedFcn = @(src, event) setIEDUpperFreq(src, event);
    function setIEDUpperFreq(src, ~)
        Setting.IEDUpperFreq = get(src, 'Value');
        setappdata(iEEGPrepApp.UiFig, 'Setting', Setting);
    end
%% Set Reference Method
    uiLabel{8}.Text = '  Re-reference Method';
    RefMethod = uidropdown(GridLayout);
    RefMethod.Layout.Row = 19;
    RefMethod.Layout.Column = [2 length(GridLayout.ColumnWidth)-2];
    RefMethod.Items = {'CommonAverage', 'ChannelAverage', 'Bipolar', 'Laplace', 'NA'};
    % Callback function
    RefMethod.ValueChangedFcn = @(src, event) selectRefMethod(src, event);
    function selectRefMethod(src, ~)
        Setting.SelectedRefMethod = get(src, 'Value');
        [Setting.SubjectList, Setting.InputFiles] = ui_inputFiles_InfoPanel(iEEGPrepApp.State, Setting, GridLayout);  
        [SubjectTree, SubjectTreeGroup, Setting] = ui_subjectList2Tree(SubjectTree, SubjectTreeGroup, Setting);
        setappdata(iEEGPrepApp.UiFig, 'Setting', Setting);
    end
%% the subject tree check list
    uiLabel{9}.Text = '  Subject List';
    SubjectTree = uitree(GridLayout, 'checkbox');
    SubjectTree.Layout.Row = [21, length(GridLayout.RowHeight)-1];
    SubjectTree.Layout.Column = [2 length(GridLayout.ColumnWidth)-2];
    SubjectTreeGroup = uitreenode(SubjectTree);
    SubjectTreeGroup.Text = 'Subject Group';
    % Assign callbacks in response to node check and selection
    SubjectTree.CheckedNodesChangedFcn = @(src, event) checkedSubjects(src, event);
    function checkedSubjects(~, event)
        Nodes = event.LeafCheckedNodes;
        Setting.CheckedSubjects = {};
        if ~isempty(Nodes)
            for ii_sub = 1:length(Nodes)
                Setting.CheckedSubjects{ii_sub} = Nodes(ii_sub).Text;
                setappdata(iEEGPrepApp.UiFig, 'Setting', Setting);
            end
        end
    end
%% Default setting
    if isfield(Setting, 'DerivativesDir')
        uiEditField{1}.Value = Setting.DerivativesDir;
    end
    if isfield(Setting, 'Task')
        uiEditField{2}.Value = Setting.Task;
    else
        uiEditField{2}.Value = 'rest';
        Setting.Task = uiEditField{2}.Value;
    end
    if isfield(Setting, 'KeyWord')
        uiEditField{3}.Value = Setting.KeyWord;
    else
        uiEditField{3}.Value = 'NA';
        Setting.KeyWord = uiEditField{3}.Value;
    end
    if isfield(Setting, 'IEDWinSize')
        uiEditField{4}.Value = Setting.IEDWinSize;
    else
        uiEditField{4}.Value = 5;
        Setting.IEDWinSize = uiEditField{4}.Value;
    end
    if isfield(Setting, 'IEDThreshold')
        uiEditField{5}.Value = Setting.IEDThreshold;
    else
        uiEditField{5}.Value = 3.65;
        Setting.IEDThreshold = uiEditField{5}.Value;
    end
    if isfield(Setting, 'IEDLowerFreq')
        uiEditField{6}.Value = Setting.IEDLowerFreq;
    else
        uiEditField{6}.Value = 10;
        Setting.IEDLowerFreq = uiEditField{6}.Value;
    end
    if isfield(Setting, 'IEDUpperFreq')
        uiEditField{7}.Value = Setting.IEDUpperFreq;
    else
        uiEditField{7}.Value = 60;
        Setting.IEDUpperFreq = uiEditField{7}.Value;
    end
    if ~isfield(Setting, 'SelectedRefMethod')
        Setting.SelectedRefMethod = 'CommonAverage';
    end
    % Call functions to update the subject list and input files based on the current state and settings  
    [Setting.SubjectList, Setting.InputFiles] = ui_inputFiles_InfoPanel(iEEGPrepApp.State, Setting, GridLayout);  
    [SubjectTree, SubjectTreeGroup, Setting] = ui_subjectList2Tree(SubjectTree, SubjectTreeGroup, Setting);  
    % Store the updated settings  
    setappdata(iEEGPrepApp.UiFig, 'Setting', Setting);
end

