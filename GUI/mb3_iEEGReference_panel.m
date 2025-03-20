function mb3_iEEGReference_panel(iEEGPrepApp, GridLayout)  
% mb3_iEEGReference_panel - Creates a panel for iEEG re-referencing within the iEEG preparation application.  
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
  
%% Run button of data inspection  
    % Creates a run button using a custom function f_createRunButton.  
    % The button is placed within the specified GridLayout at the specified position.  
    RunButton = ui_createRunButton(iEEGPrepApp, GridLayout, [2 3], [3 4]);  
  
    % Sets the ValueChangedFcn callback for the run button.  
    % When the button's value changes (e.g., from off to on), the callback function runiEEGReference is executed.  
    RunButton.ValueChangedFcn = @(src, event) runiEEGReference(src, event);  
  
    % Define the callback function that is called when the run button is pressed.  
    function runiEEGReference(~, ~)  
        % Checks if the run button is in the 'on' state.  
        if RunButton.Value  
            % Displays messages indicating the start of the re-referencing process.  
            disp('**********************************************************************************');  
            disp('******** Running iEEG Re-reference');  
              
            % Calls the function f_run_Rereference with the retrieved settings to perform the re-referencing.  
            f_run_Rereference(Setting);  
              
            % Turns the run button off after the process is complete.  
            RunButton.Value = false;  
              
            % Displays a message indicating the completion of the re-referencing process.  
            disp('******** Finish iEEG Re-reference');  
            disp('**********************************************************************************');  
        end  
    end  
%% Labels and Edit Fields for Directories 
    % Initialize a cell array to hold labels. This cell array will store references to three uilabel objects.  
    uiLabel = cell(5, 1);  
    uiEditField = cell(3, 1);

    % Define the layout positions for the labels. 
    % uiLabelRow specifies the row positions.
    % uiLabelColumn specifies the column positions.  
    uiLabelRow = {4, 6, 8, 10, 12};
    uiLabelColumn = [2 length(GridLayout.ColumnWidth)-2];

    % Loop through to create three labels and set their layout positions.  
    for ii_uilabel = 1:5
        uiLabel{ii_uilabel} = uilabel(GridLayout);
        uiLabel{ii_uilabel}.Layout.Row = uiLabelRow{ii_uilabel};
        uiLabel{ii_uilabel}.Layout.Column = uiLabelColumn;
    end

    % Define the styles for the edit fields.
    uiEditFieldStyle = {'text', 'text', 'text'};

    % Set the layout positions, styles, and create the edit fields.  
    uiEditFieldRow = {5, 7, 9};
    uiEditFieldColumn = [2 length(GridLayout.ColumnWidth)-2];
    for ii_uiEditField = 1:3
        uiEditField{ii_uiEditField} = uieditfield(GridLayout, uiEditFieldStyle{ii_uiEditField});
        uiEditField{ii_uiEditField}.Layout.Row = uiEditFieldRow{ii_uiEditField};
        uiEditField{ii_uiEditField}.Layout.Column = uiEditFieldColumn;
    end

%% Set Derivatives Directory  
    % This section sets up the user interface for specifying the derivatives directory.  
    % Update the label text to indicate the purpose of this field.  
    uiLabel{1}.Text = '  Derivatives Dir';  
  
    % Assign a callback function to the edit field.  
    % When the value in the edit field changes, the setDerivativesDir function will be called.  
    uiEditField{1}.ValueChangedFcn = @(src, event) setDerivativesDir(src, event);  
  
    % Callback function for when the derivatives directory is changed.  
    function setDerivativesDir(src, ~)  
        % Update the derivatives directory in the settings.  
        Setting.DerivativesDir = get(src, 'Value');  
      
        % Call a function to update the subject list and input files based on the new directory.  
        [Setting.SubjectList, Setting.InputFiles] = ui_inputFiles_InfoPanel(iEEGPrepApp.State, Setting, GridLayout);  
      
        % Update the subject list in the tree view.  
        [SubjectTree, SubjectTreeGroup, Setting] = ui_subjectList2Tree(SubjectTree, SubjectTreeGroup, Setting);
      
        % Store the updated settings in the application's data.  
        setappdata(iEEGPrepApp.UiFig, 'Setting', Setting);  
    end  

%% Set the Task Name  
    %This section sets up the user interface for specifying the task name.  
    % Update the label text to indicate the purpose of this field.  
    uiLabel{2}.Text = '  Task';  
  
    % Assign a callback function to the edit field.  
    % When the value in the edit field changes, the setTask function will be called.  
    uiEditField{2}.ValueChangedFcn = @(src, event) setTask(src, event);  
  
    % Callback function for when the task name is changed.  
    function setTask(src, ~)  
        % Update the task name in the settings.  
        Setting.Task = get(src, 'Value');  
      
        % Call a function to update the subject list and input files based on the new task name.  
        [Setting.SubjectList, Setting.InputFiles] = ui_inputFiles_InfoPanel(iEEGPrepApp.State, Setting, GridLayout);  
      
        % Store the updated settings in the application's data.  
        setappdata(iEEGPrepApp.UiFig, 'Setting', Setting);  
      
        % Update the subject list in the tree view.  
        [SubjectTree, SubjectTreeGroup, Setting] = ui_subjectList2Tree(SubjectTree, SubjectTreeGroup, Setting);
    end  

%% Set other Key Word  
    % This section sets up the user interface for specifying additional keywords.  
    % Update the label text to indicate the purpose of this field.  
    uiLabel{3}.Text = '  Key Word';  
  
    % Assign a callback function to the edit field.  
    % When the value in the edit field changes, the setKeyWord function will be called.  
    uiEditField{3}.ValueChangedFcn = @(src, event) setKeyWord(src, event);  
  
    % Callback function for when the keyword is changed.  
    function setKeyWord(src, ~)  
        % Update the keyword in the settings.  
        Setting.KeyWord = get(src, 'Value');  
      
        % Call a function to update the subject list and input files based on the new keyword.  
        [Setting.SubjectList, Setting.InputFiles] = ui_inputFiles_InfoPanel(iEEGPrepApp.State, Setting, GridLayout);  
      
        % Store the updated settings in the application's data.  
        setappdata(iEEGPrepApp.UiFig, 'Setting', Setting);  
      
        % Update the subject list in the tree view.  
        [SubjectTree, SubjectTreeGroup, Setting] = ui_subjectList2Tree(SubjectTree, SubjectTreeGroup, Setting);
    end

%% Set Reference Method  
    % Set the label text for the reference method section  
    uiLabel{4}.Text = '  Re-reference Method';  
  
    % Create a dropdown menu for selecting the reference method  
    RefMethod = uidropdown(GridLayout);  
    RefMethod.Layout.Row = 11;  
    RefMethod.Layout.Column = [2 length(GridLayout.ColumnWidth)-2];  
    % Populate the dropdown menu with available reference methods  
    RefMethod.Items = {'CommonAverage', 'ChannelAverage', 'Bipolar', 'Laplace'};  
  
    % Define a callback function for when the selected value in the dropdown changes  
    RefMethod.ValueChangedFcn = @(src, event) selectRefMethod(src, event);  
  
    % Callback function to update the selected reference method  
    function selectRefMethod(src, ~)  
        Setting.SelectedRefMethod = get(src, 'Value');  % Get the selected value from the dropdown  
        setappdata(iEEGPrepApp.UiFig, 'Setting', Setting);  % Store the updated setting  
        disp(['Select Re-reference Method:' Setting.SelectedRefMethod]);  % Display the selected method  
    end

%% the subject tree check list  
    % Set the label text for the subject list section  
    uiLabel{5}.Text = '  Subject List';  
  
    % Create a checkbox tree for selecting subjects  
    SubjectTree = uitree(GridLayout, 'checkbox');  
    SubjectTree.Layout.Row = [13, length(GridLayout.RowHeight)-1];  
    SubjectTree.Layout.Column = [2 length(GridLayout.ColumnWidth)-2];  
    SubjectTreeGroup = uitreenode(SubjectTree);  
    SubjectTreeGroup.Text = 'Subject Group';  
  
    % Assign a callback function for when checked nodes change in the tree  
    SubjectTree.CheckedNodesChangedFcn = @(src, event) checkedSubjects(src, event);  
  
    % Callback function to handle changes in checked subjects  
    function checkedSubjects(~, event)  
        Nodes = event.LeafCheckedNodes;  % Get the checked nodes  
        Setting.CheckedSubjects = {};  % Initialize an empty cell array for checked subjects  
        if ~isempty(Nodes)  % If there are checked nodes  
            for ii_sub = 1:length(Nodes)  % Iterate over the checked nodes  
                Setting.CheckedSubjects{ii_sub} = Nodes(ii_sub).Text;  % Store the text of the checked node  
                setappdata(iEEGPrepApp.UiFig, 'Setting', Setting);  % Update the setting with the checked subjects  
            end  
        end  
    end

%% Default Setting  
    % Set default values for various settings if they are not already set  
    if isfield(Setting, 'DerivativesDir')  
        uiEditField{1}.Value = Setting.DerivativesDir;  % Set the value of the derivatives directory edit field  
    end  
    if isfield(Setting, 'Task')  
        uiEditField{2}.Value = Setting.Task;  % Set the value of the task edit field  
    else  
        uiEditField{2}.Value = 'rest';  % Set the default task to 'rest'  
        Setting.Task = 'rest';  % Update the setting with the default task  
    end  
    if isfield(Setting, 'KeyWord')  
        uiEditField{3}.Value = Setting.KeyWord;  % Set the value of the keyword edit field  
    else    
        uiEditField{3}.Value = 'NA';  % Set the default keyword to 'NA'  
        Setting.KeyWord = 'NA';  % Update the setting with the default keyword  
    end  
    if ~isfield(Setting, 'SelectedRefMethod')  % If the selected reference method is not set  
        Setting.SelectedRefMethod = 'CommonAverage';  % Set the default reference method to 'CommonAverage'  
    end  
    % Call functions to update the subject list and input files based on the current state and settings  
    [Setting.SubjectList, Setting.InputFiles] = ui_inputFiles_InfoPanel(iEEGPrepApp.State, Setting, GridLayout);  
    [SubjectTree, SubjectTreeGroup, Setting] = ui_subjectList2Tree(SubjectTree, SubjectTreeGroup, Setting);  
    % Store the updated settings  
    setappdata(iEEGPrepApp.UiFig, 'Setting', Setting);

end

