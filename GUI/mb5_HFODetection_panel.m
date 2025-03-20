function mb5_HFODetection_panel(iEEGPrepApp, GridLayout)
%
%
%
%% Initial setting
    Setting = getappdata(iEEGPrepApp.UiFig, 'Setting');
%% Running Button
    RunButton = ui_createRunButton(iEEGPrepApp, GridLayout, [2 3], [3 4]);  
    RunButton.ValueChangedFcn = @(src, event) runHFODetection(src, event);
    function runHFODetection(~, ~)
        if RunButton.Value
            disp('**********************************************************************************');
            disp('--------Running HFO Detection');
            f_HFOdetection_batchrun(Setting);
            RunButton.Value = false;
            disp('--------Finish HFO Detection');
            disp('**********************************************************************************');
        end
    end
%%
    uiLabel = cell(8, 1);
    uiLabelRow = {4, 6, 8, 10, 12, 14, 16, 18};
    uiLabelColumn = [2 length(GridLayout.ColumnWidth)-2];
        for ii_uilabel = 1:length(uiLabel)
        uiLabel{ii_uilabel} = uilabel(GridLayout);
        uiLabel{ii_uilabel}.Layout.Row = uiLabelRow{ii_uilabel};
        uiLabel{ii_uilabel}.Layout.Column = uiLabelColumn;
        end
    uiEditField = cell(6, 1);
    uiEditFieldStyle = {'text', 'text', 'text', 'numeric', 'numeric', 'numeric'};
    uiEditFieldRow = {5, 7, 9, 11, 13, 15};
    uiEditFieldColumn = [2 length(GridLayout.ColumnWidth)-2];
    for ii_uiEditField = 1:length(uiEditFieldRow)
        uiEditField{ii_uiEditField} = uieditfield(GridLayout, uiEditFieldStyle{ii_uiEditField});
        uiEditField{ii_uiEditField}.Layout.Row = uiEditFieldRow{ii_uiEditField};
        uiEditField{ii_uiEditField}.Layout.Column = uiEditFieldColumn;
    end
%% Set Derivatives Directory
    uiLabel{1}.Text = '  Derivatives Directory';
    uiEditField{1}.ValueChangedFcn = @(src, event) setDerivativesDir(src, event);
    function setDerivativesDir(src, ~)
        Setting.DerivativesDir = get(src, 'Value');
        [Setting.SubjectList, Setting.InputFiles] = ui_inputFiles_InfoPanel(iEEGPrepApp.State, Setting, GridLayout);
        [SubjectTree, SubjectTreeGroup, Setting] = ui_subjectList2Tree(SubjectTree, SubjectTreeGroup, Setting);
        setappdata(iEEGPrepApp.UiFig, 'Setting', Setting);
    end
%% Set task name
    uiLabel{2}.Text = '  Task';
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
    function setKeyWord(src, ~)
        Setting.KeyWord = get(src, 'Value');
        [Setting.SubjectList, Setting.InputFiles] = ui_inputFiles_InfoPanel(iEEGPrepApp.State, Setting, GridLayout);
        [SubjectTree, SubjectTreeGroup, Setting] = ui_subjectList2Tree(SubjectTree, SubjectTreeGroup, Setting);
        setappdata(iEEGPrepApp.UiFig, 'Setting', Setting);
    end
%% input the lower frequency for bandpass filtering
    uiLabel{4}.Text = '  HFO Lower Frequency (Hz)';
    uiEditField{4}.ValueChangedFcn = @(src, event) setHFOLowerFreq(src, event);
    function setHFOLowerFreq(src, ~)
        Setting.HFOLowerFreq = get(src, 'Value');
        setappdata(iEEGPrepApp.UiFig, 'Setting', Setting);
    end
%% input the upper frequency for bandpass filtering
    uiLabel{5}.Text = '  HFO Upper Frequency (Hz)';
    uiEditField{5}.ValueChangedFcn = @(src, event) setHFOUpperFreq(src, event);
    function setHFOUpperFreq(src, ~)
        Setting.HFOUpperFreq = get(src, 'Value');
        setappdata(iEEGPrepApp.UiFig, 'Setting', Setting);
    end
%% Set HFO threshold
    uiLabel{6}.Text = '  HFO Threshould (Default:2)';
    uiEditField{6}.ValueChangedFcn = @(src, event) setHFOThreshould(src, event);
    function setHFOThreshould(src, ~)
        Setting.HFOThreshould = get(src, 'Value');
        setappdata(iEEGPrepApp.UiFig, 'Setting', Setting);
    end
%% Set Reference Method
    uiLabel{7}.Text = '  Re-reference Method';
    RefMethod = uidropdown(GridLayout);
    RefMethod.Layout.Row = 17;
    RefMethod.Layout.Column = [2 length(GridLayout.ColumnWidth)-2];
    RefMethod.Items = {'CommonAverage', 'ChannelAverage', 'Bipolar', 'Laplace', 'NA'};
    RefMethod.ValueChangedFcn = @(src, event) selectRefMethod(src, event);
    function selectRefMethod(src, ~)
        Setting.SelectedRefMethod = get(src, 'Value');
        [Setting.SubjectList, Setting.InputFiles] = ui_inputFiles_InfoPanel(iEEGPrepApp.State, Setting, GridLayout);
        [SubjectTree, SubjectTreeGroup, Setting] = ui_subjectList2Tree(SubjectTree, SubjectTreeGroup, Setting);
        setappdata(iEEGPrepApp.UiFig, 'Setting', Setting);
    end
%% the subject tree check list
    uiLabel{8}.Text = '  Subject List';
    SubjectTree = uitree(GridLayout, 'checkbox');
    SubjectTree.Layout.Row = [19, length(GridLayout.RowHeight)-1];
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
    if isfield(Setting, 'HFOLowerFreq')
        uiEditField{4}.Value = Setting.HFOLowerFreq;
    else
        uiEditField{4}.Value = 200;
        Setting.HFOLowerFreq = uiEditField{4}.Value;
    end
    if isfield(Setting, 'HFOUpperFreq')
        uiEditField{5}.Value = Setting.HFOUpperFreq;
    else
        uiEditField{5}.Value = 400;
        Setting.HFOUpperFreq = uiEditField{5}.Value;
    end
    if isfield(Setting, 'HFOThreshould')
        uiEditField{6}.Value = Setting.HFOThreshould;
    else
        uiEditField{6}.Value = 2;
        Setting.HFOThreshould = uiEditField{6}.Value;
    end
    if ~isfield(Setting, 'SelectedRefMethod')
        Setting.SelectedRefMethod = 'CommonAverage';
    end
    [Setting.SubjectList, Setting.InputFiles] = ui_inputFiles_InfoPanel(iEEGPrepApp.State, Setting, GridLayout);
    [SubjectTree, SubjectTreeGroup, Setting] = ui_subjectList2Tree(SubjectTree, SubjectTreeGroup, Setting);
    setappdata(iEEGPrepApp.UiFig, 'Setting', Setting);
end



