function ToolboxPath = iEEGworkbench_initial
%% Set the environment
    % This section configures the MATLAB environment for the iEEGPrep application.  
    % It adds the necessary folders to the MATLAB path to access functions and GUI components.  
    ToolboxDir = dir([mfilename("fullpath"), '.m']);
    ToolboxPath = ToolboxDir.folder;
    addpath(ToolboxPath);
    addpath(fullfile(ToolboxPath, 'function'));
    addpath(fullfile(ToolboxPath, 'GUI'));
end