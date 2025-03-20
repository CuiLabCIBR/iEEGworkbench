function mb5_IEDVisualization_panel(IEEGDenoiseApp, GridLayout)
%
%
%
%% Initial setting
    Setting = getappdata(IEEGDenoiseApp.UiFig, 'Setting');
%% Run Button of IED Visualization
    RunButton = uibutton(GridLayout, 'state');
    RunButton.Layout.Row = [2, 3];
    RunButton.Layout.Column = [3, 4];
    RunButton.Text = 'Run';
    RunButton.Icon = fullfile(IEEGDenoiseApp.ToolboxPath, 'data', 'run.png');
    RunButton.IconAlignment = "top";
     % Callback function
    RunButton.ValueChangedFcn = @(src, event) runIEDVisualization(src, event);
    function runIEDVisualization(~, ~)
        if RunButton.Value
            disp('********************************************************************************');
            disp('-------Visualization of IED');
            f_IEDVisualization(Setting.DerivativesDir, Setting.SelectedFile, Setting.SelectedIEDFile);
            RunButton.Value = false;
        end
    end
%% Set Derivatives Directory
    Label1 = uilabel(GridLayout);
    Label1.Layout.Row = 4;
    Label1.Layout.Column = [2 length(GridLayout.ColumnWidth)-2];
    Label1.Text = '  Derivatives Directory';
    DerivativesDir = uieditfield(GridLayout);
    DerivativesDir.Layout.Row = 5;
    DerivativesDir.Layout.Column = [2 length(GridLayout.ColumnWidth)-2];
    % Callback function
    DerivativesDir.ValueChangedFcn = @(src, event) setDerivativesDir(src, event);
    function setDerivativesDir(src, ~)
        Setting.DerivativesDir = get(src, 'Value');
        [Setting.SubjectList, Setting.InputFiles] = f_inputFiles_InfoPanel(IEEGDenoiseApp.State, Setting, GridLayout);
        if ~isempty(Setting.SubjectList)
            Setting.SelectedSubject = Setting.SubjectList{1};
        end
        inputFiles_SelectedSubject;
        inputIEDFile_SelectedSubject;
        setappdata(IEEGDenoiseApp.UiFig, 'Setting', Setting);
    end
%% Set Subject List
    Label2 = uilabel(GridLayout);
    Label2.Layout.Row = 6;
    Label2.Layout.Column = [2 length(GridLayout.ColumnWidth)-2];
    Label2.Text = '  Subject Name';
    SubjectList = uidropdown(GridLayout);
    SubjectList.Layout.Row = 7;
    SubjectList.Layout.Column = [2 length(GridLayout.ColumnWidth)-2];
    SubjectList.ValueChangedFcn = @(src, event) selectSubject(src, event);
    % Callback function
    function selectSubject(src, ~)
        Setting.SelectedSubject = get(src, 'Value');
        inputFiles_SelectedSubject;
        inputIEDFile_SelectedSubject;
        setappdata(IEEGDenoiseApp.UiFig, 'Setting', Setting);
    end
%% Set IEEG File List
    Label3 = uilabel(GridLayout);
    Label3.Layout.Row = 8;
    Label3.Layout.Column = [2 length(GridLayout.ColumnWidth)-2];
    Label3.Text = '  File Name';
    FileName = uidropdown(GridLayout);
    FileName.Layout.Row = 9;
    FileName.Layout.Column = [2 length(GridLayout.ColumnWidth)-2];
    FileName.ValueChangedFcn = @(src, event) selectFile(src, event);
    % Callback function
    function selectFile(src, ~)
        Setting.SelectedFile = get(src, 'Value');
        inputIEDFile_SelectedSubject;
        setappdata(IEEGDenoiseApp.UiFig, 'Setting', Setting);
    end
%% Set IED File List
    Label4 = uilabel(GridLayout);
    Label4.Layout.Row = 10;
    Label4.Layout.Column = [2 length(GridLayout.ColumnWidth)-2];
    Label4.Text = '  IED File Name';
    IEDFileName = uidropdown(GridLayout);
    IEDFileName.Layout.Row = 11;
    IEDFileName.Layout.Column = [2 length(GridLayout.ColumnWidth)-2];
    IEDFileName.ValueChangedFcn = @(src, event) selectIEDFile(src, event);
    % Callback function
    function selectIEDFile(src, ~)
        Setting.SelectedIEDFile = get(src, 'Value');
        setappdata(IEEGDenoiseApp.UiFig, 'Setting', Setting);
    end
%% Default setting
    if isfield(Setting, 'DerivativesDir')
        DerivativesDir.Value = Setting.DerivativesDir;
        [Setting.SubjectList, Setting.InputFiles] = f_inputFiles_InfoPanel(IEEGDenoiseApp.State, Setting, GridLayout);
        if ~isempty(Setting.SubjectList)
            Setting.SelectedSubject = Setting.SubjectList{1};
        end
        inputFiles_SelectedSubject;
        inputIEDFile_SelectedSubject;
    end
    setappdata(IEEGDenoiseApp.UiFig, 'Setting', Setting);
%% Other function
    function inputFiles_SelectedSubject
        if isempty(Setting.SubjectList)
            SubjectList.Items = {};
            Setting.SelectedSubject = {};
            FileName.Items = {};
            Setting.SelectedFile = {};
        else
            SubjectList.Items = unique(Setting.SubjectList);
            FileName.Items = {};
            NN = 0;
            for ii_file = 1:length(Setting.SubjectList)
                if strcmp(Setting.SelectedSubject, Setting.SubjectList{ii_file})
                    NN = NN + 1;
                    FileName.Items{NN} = Setting.InputFiles.name{ii_file};
                end
            end
            Setting.SelectedFile = FileName.Items{1};
        end
    end
    function inputIEDFile_SelectedSubject
        if isempty(Setting.SelectedFile)
            Setting.SelectedIEDFile = {};
            IEDFileName.Items = {};
        else
            IEDFileName.Items = {};
            IEDFilePrefix = f_strsplit(Setting.SelectedFile, '_ieeg.mat');
            IEDFilePrefix = IEDFilePrefix{1};
            IEDFileDir = dir(fullfile(Setting.DerivativesDir, '**', [IEDFilePrefix, '*_IED.mat']));
            for ii_IEDFileDir = 1:length(IEDFileDir)
                IEDFileName.Items{ii_IEDFileDir} = IEDFileDir(ii_IEDFileDir).name;
            end
            if isempty(IEDFileName.Items)
                Setting.SelectedIEDFile = [];
            else
                Setting.SelectedIEDFile = IEDFileName.Items{1};
            end
        end
    end
end

