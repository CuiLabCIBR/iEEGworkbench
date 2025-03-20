function InputFiles = io_iEEGRereference_InputFiles(Setting)
% io_iEEGRereference_InputFiles - Retrieves iEEG input files for rereferencing based on the provided settings  
%  
% Input:  
%   - Setting: A structure containing settings information, including 'DerivativesDir' (directory to search for files)  
%              and other relevant fields such as 'KeyWord' and 'Task' for filtering the files.  
%  
% Output:  
%   - InputFiles: A structure array containing information about the located iEEG files that need to be rereferenced.  
%                 If no files are found or no 'DerivativesDir' is specified, it will be an empty array.  
%  
% Description:  
%       This function checks if the 'DerivativesDir' field exists in the provided Setting structure.  
%       If it does, the function searches for files with specific patterns based on the 'KeyWord' and 'Task' fields.  
%       It then filters out any files that have already been rereferenced (contain '_ref-' in their names).  
%       The remaining files are returned in the InputFiles output.  
%
%% main function
    if isfield(Setting, 'DerivativesDir')  
        % Check if 'KeyWord' is set to 'NA', in which case we search for files without using the keyword  
        if strcmp(Setting.KeyWord, 'NA')  
            InputFilesAll = dir(fullfile(Setting.DerivativesDir, '**', ['*task-', Setting.Task, '*_ieeg.mat']));  
        else  
            % Search for files using the specified 'KeyWord' and 'Task'  
            InputFileDir1 = dir(fullfile(Setting.DerivativesDir, '**', ['*', Setting.KeyWord, '*task-', Setting.Task, '*_ieeg.mat']));  
            InputFileDir2 = dir(fullfile(Setting.DerivativesDir, '**', ['*task-', Setting.Task, '*', Setting.KeyWord, '*_ieeg.mat']));  
            InputFilesAll = [InputFileDir1; InputFileDir2];  % Combine the results  
        end  
          
        % Remove rereferenced IEEG data (files containing '_ref-' in their names)  
        NN = 0;  
        for ii_InputFilesAll = 1:length(InputFilesAll)  
            FileName = InputFilesAll(ii_InputFilesAll).name;  
            if ~contains(FileName, '_ref-')  
                NN = NN + 1;  
                InputFiles(NN) = InputFilesAll(ii_InputFilesAll);  
            end  
        end  
    end  
      
    % If InputFiles variable does not exist (e.g., no 'DerivativesDir' was specified or no files were found),  
    % initialize it as an empty array to avoid undefined variable errors  
    if ~exist('InputFiles', 'var')  
        InputFiles = [];  
    end
end