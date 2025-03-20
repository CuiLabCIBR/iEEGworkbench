function InputFiles = io_IEDDetection_InputFiles(Setting)
% io_IEDDetection_InputFiles - Retrieves input files for Interictal Epileptic Discharge (IED) detection  
%  
% Input:  
%   - Setting: A structure containing various settings for file retrieval.  
%       - DerivativesDir: Directory to search for derivative files.  
%       - SelectedRefMethod: The selected reference method (e.g., 'bipolar', 'common', etc.).  
%                            If set to 'NA', files without re-referencing will be retrieved.  
%       - KeyWord: A keyword to filter the files. If set to 'NA', no keyword filtering will be applied.  
%       - Task: The task name to filter the files.  
%  
% Output:  
%   - InputFiles: A structure array containing information about the located IED detection input files.  
%  
% Description:  
%   This function retrieves input files for IED detection based on the provided settings.  
%   It searches the specified derivatives directory for files matching the given criteria,  
%   such as the selected reference method, keyword, and task name.  
%   Files are excluded if the SelectedRefMethod is set to 'NA'.  
%   If no files are found or the DerivativesDir is not specified, an empty array is returned.  
%
%% main function
    % Check if DerivativesDir is specified in the setting
    if isfield(Setting, 'DerivativesDir')
        % Retrieve files without re-referencing if SelectedRefMethod is 'NA'  
        if strcmp(Setting.SelectedRefMethod, 'NA')
            if strcmp(Setting.KeyWord, 'NA')
                % Retrieve files without keyword filtering
                InputFiles = dir(fullfile(Setting.DerivativesDir, '**', ['*_task-', Setting.Task, '*_ieeg.mat']));
            else
                % Retrieve files with keyword filtering  
                InputFile1 = dir(fullfile(Setting.DerivativesDir, '**', ['*', Setting.KeyWord, '*_task-', Setting.Task, '*_ieeg.mat']));
                InputFile2 = dir(fullfile(Setting.DerivativesDir, '**', ['*_task-', Setting.Task, '*', Setting.KeyWord, '*_ieeg.mat']));
                InputFiles = [InputFile1; InputFile2];
            end
            
            % Remove files that have already been re-referenced  
            NN = 0;
            for ii_InputFilesAll = 1:length(InputFiles)
                FileName = InputFiles(ii_InputFilesAll).name;
                if ~contains(FileName, '_ref-')
                    NN = NN + 1;
                    InputFilesTemp(NN) = InputFiles(ii_InputFilesAll);
                end
            end
            InputFiles = InputFilesTemp;

        else % Retrieve files with re-referencing
            if strcmp(Setting.KeyWord, 'NA')
                % Retrieve files without keyword filtering but with re-referencing  
                InputFiles = dir(fullfile(Setting.DerivativesDir, '**', ['*_task-', Setting.Task, '*_ref-', Setting.SelectedRefMethod, '*_ieeg.mat']));
            else
                % Retrieve files with keyword filtering and re-referencing
                InputFile1 = dir(fullfile(Setting.DerivativesDir, '**', ['*', Setting.KeyWord, '*_task-', Setting.Task, '*_ref-', Setting.SelectedRefMethod, '*_ieeg.mat']));
                InputFile2 = dir(fullfile(Setting.DerivativesDir, '**', ['*_task-', Setting.Task, '*', Setting.KeyWord, '*_ref-', Setting.SelectedRefMethod, '*_ieeg.mat']));
                InputFile3 = dir(fullfile(Setting.DerivativesDir, '**', ['*_task-', Setting.Task, '*_ref-', Setting.SelectedRefMethod, '*', Setting.KeyWord, '*_ieeg.mat']));
             InputFiles = [InputFile1; InputFile2; InputFile3];
            end
        end
    end

    % Initialize InputFiles as an empty array if it doesn't exist  
    if ~exist('InputFiles', 'var')
        InputFiles = [];
    end
end