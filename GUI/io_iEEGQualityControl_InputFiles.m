function InputFiles = io_iEEGQualityControl_InputFiles(Setting)
% io_iEEGVisualization_InputFiles - Retrieves iEEG input files based on the provided settings  
%  
% Input:  
%   - Setting: A structure containing settings information, including the 'DerivativesDir' if available.  
%  
% Output:  
%   - InputFiles: A structure array returned by the dir function, containing information about the located iEEG files.  
%               If no files are found, it will be an empty array.  
%  
% Description:  
%   This function checks if the 'DerivativesDir' field exists in the provided Setting structure.  
%   If it does, the function searches for files with the '_ieeg.mat' pattern in all subdirectories of 'DerivativesDir'.  
%   The located files are then returned in the InputFiles output.  
%   If no 'DerivativesDir' is specified or no files are found, an empty array is returned.  
%
%% main function
    if isfield(Setting, 'DerivativesDir')  
        % If 'DerivativesDir' field exists in Setting, search for '_ieeg.mat' files in all subdirectories
        InputFiles = dir(fullfile(Setting.DerivativesDir, '**', '*_denoise_ieeg.mat'));
    end  
      
    % If InputFiles variable does not exist (e.g., no 'DerivativesDir' was specified or no files were found),  
    % initialize it as an empty array to avoid undefined variable errors  
    if ~exist('InputFiles', 'var')  
        InputFiles = [];  
    end  
end

