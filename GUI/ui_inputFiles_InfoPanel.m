function [SubjectList, InputFiles] = ui_inputFiles_InfoPanel(State, Setting, GridLayout)
% ui_inputFiles_InfoPanel - Retrieves input file information based on the current state and updates the UI table.  
%  
% Input:  
%   - State: Current state of the application (string).  
%   - Setting: Settings specific to the current state (various types).  
%   - GridLayout: Layout information for the UI grid (structure).  
%  
% Output:  
%   - SubjectList: List of subjects extracted from the input file names (cell array of strings).  
%   - InputFiles: Table containing information about the input files (table).  
%  
% Description:  
%   This function retrieves input file information based on the provided state and settings.  
%   It then updates a UI table with the file details. Additionally, it generates a list of  
%   subjects from the input file names.  
%
%% main function
    switch State
        case 'iEEGPrep'
            % Retrieve input files for mini preparation 
            InputFiles = io_iEEGPrep_InputFiles(Setting);
        case 'QualityControl'
            % Retrieve input files for quality control of iEEG
            % Preprocessing
            InputFiles = io_iEEGQualityControl_InputFiles(Setting);
        case 'iEEGRereference'
            % Retrieve input files for rereferencing
            InputFiles = io_iEEGRereference_InputFiles(Setting);
        case 'IEDDetection'
            % Retrieve input files for interictal epileptiform discharge detection
            InputFiles = io_IEDDetection_InputFiles(Setting);
        case 'HFODetection'
            % Retrieve input files for high-frequency oscillation detection
            InputFiles = io_HFODetection_InputFiles(Setting);
        case 'iEEGVisualization'
            % Retrieve input files for data visualization
            InputFiles = io_iEEGVisualization_InputFiles(Setting);
    end
%%
    if isempty(InputFiles)
        % If no input files are found, set SubjectList to empty and create an empty UI table
        SubjectList = [];
        InputFileTable = uitable(GridLayout);
        InputFileTable.Layout.Row = [2 length(GridLayout.RowHeight)-1];
        InputFileTable.Layout.Column = [length(GridLayout.ColumnWidth)-1, length(GridLayout.ColumnWidth)];
    else
        % Remove unnecessary fields from InputFiles and convert it to a table
        InputFiles = rmfield(InputFiles, {'isdir', 'datenum', 'bytes'});
        
        % Create and populate the UI table with the input file information
        InputFileTable = uitable(GridLayout);
        InputFileTable.Data = struct2table(InputFiles);
        InputFileTable.Layout.Row = [2 length(GridLayout.RowHeight)-1];
        InputFileTable.Layout.Column = [length(GridLayout.ColumnWidth)-1, length(GridLayout.ColumnWidth)];
        
        % Generate the subject list by extracting the subject name from each file name  
        SubjectList = cell(length(InputFiles), 1);
        for fN = 1:length(InputFiles)
            TempSTR = f_strsplit(InputFiles(fN).name, '_');
            SubjectList{fN} = TempSTR{1};
        end
    end
end