function InputFiles = io_HFODetection_InputFiles(Setting)
% io_HFODetection_InputFiles - Retrieve iEEG files for High-Frequency Oscillation (HFO) detection  
%  
% Input:  
%   - Setting: A structure containing various settings information, including:  
%       - DerivativesDir: Directory where derivative files are stored.  
%       - SelectedRefMethod: The selected reference method (e.g., 'bipolar', 'common', 'NA' for no re-reference).  
%       - KeyWord: A keyword to filter the file search (can be 'NA' if no specific keyword is required).  
%       - Task: The task name or identifier to filter the file search.  
%  
% Output:  
%   - InputFiles: A structure array returned by the dir function, containing information  
%                 about the located iEEG files that match the specified criteria.  
%  
% Description:  
%   This function retrieves iEEG files based on the provided settings. It searches for files  
%   in the DerivativesDir that match specific patterns based on whether re-referencing is  
%   required, the presence of a keyword, and the task name. The function returns an array  
%   of structures containing information about the located files.  
%  
%% main function
    % Check if 'DerivativesDir' field exists in Setting  
    if isfield(Setting, 'DerivativesDir')
        % No re-reference selected
        if strcmp(Setting.SelectedRefMethod, 'NA')
            % No keyword specified, search based on task only
            if strcmp(Setting.KeyWord, 'NA')
                InputFiles = dir(fullfile(Setting.DerivativesDir, '**', ['*_task-', Setting.Task, '*_ieeg.mat']));

            % Keyword specified, search based on keyword and task 
            else
                InputFile1 = dir(fullfile(Setting.DerivativesDir, '**', ['*', Setting.KeyWord, '*_task-', Setting.Task, '*_ieeg.mat']));
                InputFile2 = dir(fullfile(Setting.DerivativesDir, '**', ['*_task-', Setting.Task, '*', Setting.KeyWord, '*_ieeg.mat']));
                InputFiles = [InputFile1; InputFile2];
            end

            % Remove files that contain '_ref-' in their names (indicating re-referencing)  
            NN = 0;
            for ii_InputFilesAll = 1:length(InputFiles)
                FileName = InputFiles(ii_InputFilesAll).name;
                if ~contains(FileName, '_ref-')
                    NN = NN + 1;
                    InputFilesTemp(NN) = InputFiles(ii_InputFilesAll);
                end
            end
            InputFiles = InputFilesTemp;

        % Re-reference selected
        else
            % No keyword specified, search based on task and reference method
            if strcmp(Setting.KeyWord, 'NA')
                InputFiles = dir(fullfile(Setting.DerivativesDir, '**', ['*_task-', Setting.Task, '*_ref-', Setting.SelectedRefMethod, '*_ieeg.mat']));
            
            % Keyword specified, search based on keyword, task, and reference method
            else
                InputFile1 = dir(fullfile(Setting.DerivativesDir, '**', ['*', Setting.KeyWord, '*_task-', Setting.Task, '*_ref-', Setting.SelectedRefMethod, '*_ieeg.mat']));
                InputFile2 = dir(fullfile(Setting.DerivativesDir, '**', ['*_task-', Setting.Task, '*', Setting.KeyWord, '*_ref-', Setting.SelectedRefMethod, '*_ieeg.mat']));
                InputFile3 = dir(fullfile(Setting.DerivativesDir, '**', ['*_task-', Setting.Task, '*_ref-', Setting.SelectedRefMethod, '*', Setting.KeyWord, '*_ieeg.mat']));
             InputFiles = [InputFile1; InputFile2; InputFile3];
            end
        end
    end

    % If InputFiles variable does not exist (e.g., no 'DerivativesDir' or no files found), initialize it as an empty array  
    if ~exist('InputFiles', 'var')
        InputFiles = [];
    end
end