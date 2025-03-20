function mb2_QualityControl_panel(iEEGApp, GridLayout)
%
%
%
%% Initial setting
    Setting = getappdata(iEEGApp.UiFig, 'Setting');
%% Run Button of IED Visualization
    RunButton= ui_createRunButton(iEEGApp, GridLayout, [2 3], [3 7]);
     % Callback function
    RunButton.ValueChangedFcn = @(src, event) runQualityControl(src, event);
    function runQualityControl(~, ~)
        if RunButton.Value
            disp('********************************************************************************');
            disp('-------Quality control of Preprocessed iEEG data');
            f_run_QualityControl(Setting.DerivativesDir, Setting.SelectedFile);
            RunButton.Value = false;
            disp('********************************************************************************');
        end
    end
%% Set Derivatives Directory
    % Set the label text for the derivatives directory.
    uiRow = 4;
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
        [Setting.SubjectList, Setting.InputFiles] = ui_inputFiles_InfoPanel(iEEGApp.State, Setting, GridLayout);   % Update subject list and input files.
        Setting.SelectedSubject = Setting.SubjectList{1};
        denoisedIEEG_selectedSubject;
        setappdata(iEEGApp.UiFig, 'Setting', Setting);  % Save the updated settings.
    end
%% Set Subject List
    uiRow = uiRow + 1;
    subjectListLabel = uilabel(GridLayout);
    subjectListLabel.Layout.Row = uiRow;
    subjectListLabel.Layout.Column = [2 length(GridLayout.ColumnWidth)-2];
    subjectListLabel.Text = '  Subject Name';
    uiRow = uiRow + 1;
    subjectList = uidropdown(GridLayout);
    subjectList.Layout.Row = uiRow;
    subjectList.Layout.Column = [2 length(GridLayout.ColumnWidth)-2];
    subjectList.ValueChangedFcn = @(src, event) selectSubject(src, event);
    % Callback function
    function selectSubject(src, ~)
        Setting.SelectedSubject = get(src, 'Value');
        denoisedIEEG_selectedSubject;
        setappdata(iEEGApp.UiFig, 'Setting', Setting);
    end
%% Set the Denoised iEEG File List
    denoisediEEGLabel = uilabel(GridLayout);
    denoisediEEGLabel.Layout.Row = 8;
    denoisediEEGLabel.Layout.Column = [2 length(GridLayout.ColumnWidth)-2];
    denoisediEEGLabel.Text = '  Denoised iEEG Data';
    denoisediEEGList = uidropdown(GridLayout);
    denoisediEEGList.Layout.Row = 9;
    denoisediEEGList.Layout.Column = [2 length(GridLayout.ColumnWidth)-2];
    denoisediEEGList.ValueChangedFcn = @(src, event) selectFile(src, event);
    % Callback function
    function selectFile(src, ~)
        Setting.SelectedFile = get(src, 'Value');
        setappdata(iEEGApp.UiFig, 'Setting', Setting);
    end
%% Default Setting
    if isfield(Setting, 'DerivativesDir')
        derivativesEditField.Value = Setting.DerivativesDir;
        [Setting.SubjectList, Setting.InputFiles] = ui_inputFiles_InfoPanel(iEEGApp.State, Setting, GridLayout);
        Setting.SelectedSubject = Setting.SubjectList{1};
        denoisedIEEG_selectedSubject;
    end
    setappdata(iEEGApp.UiFig, 'Setting', Setting);
%% Other function
    function denoisedIEEG_selectedSubject
        if isempty(Setting.SubjectList)
            subjectList.Items = {};
            Setting.SelectedSubject = {};
            denoisediEEGList.Items = {};
            Setting.SelectedFile = {};
        else
            subjectList.Items = unique(Setting.SubjectList);
            denoisediEEGList.Items = {};
            NN = 0;
            for ii_file = 1:length(Setting.SubjectList)
                if strcmp(Setting.SelectedSubject, Setting.SubjectList{ii_file})
                    NN = NN + 1;
                    denoisediEEGList.Items{NN} = Setting.InputFiles.name{ii_file};
                end
            end
            Setting.SelectedFile = denoisediEEGList.Items{1};
        end
    end
end

