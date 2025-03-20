function InputFiles = io_iEEGPrep_InputFiles(Setting)
% io_iEEGMiniPrep_InputFiles - Retrieve input files for iEEG mini-preparation based on given settings  
%  
% Input:  
%   - Setting: A structure containing the necessary settings for file retrieval  
%       .BIDSDir: The directory path where BIDS-formatted iEEG data is stored  
%       .KeyWord: A keyword used to filter file names (can be 'NA' if no specific keyword is needed)  
%       .Task: The task label used to identify relevant files  
%  
% Output:  
%   - InputFiles: A structure array containing information about the retrieved input files  
%  
% Description:  
%   This function retrieves iEEG files from the specified BIDS directory based on the given settings.  
%   It uses wildcard patterns to search for files that match the specified task label and keyword (if provided).  
%   The retrieved files are returned as a structure array for further processing.  
%
%% Main function
    if isfield(Setting, 'BIDSDir')
        % Check if BIDSDir field exists in Setting
        if strcmp(Setting.KeyWord, 'NA')
            % If KeyWord is 'NA', retrieve files without a specific keyword  
            InputFiles = dir(fullfile(Setting.BIDSDir, '**', ['*task-', Setting.Task, '*_ieeg.*']));
        else
            % If KeyWord is provided, retrieve files with the specified keyword in two possible positions  
            InputFileDir1 = dir(fullfile(Setting.BIDSDir, '**', ['*', Setting.KeyWord, '*task-', Setting.Task, '*_ieeg.*']));
            InputFileDir2 = dir(fullfile(Setting.BIDSDir, '**', ['*task-', Setting.Task, '*', Setting.KeyWord, '*_ieeg.*']));
            InputFiles = [InputFileDir1; InputFileDir2];
        end
    end
    if ~exist('InputFiles', 'var')
        % If InputFiles variable does not exist, initialize it as an empty array  
        InputFiles = [];
    end
end