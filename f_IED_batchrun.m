function f_IED_batchrun(Setting)
% f_IEDdetection_batchrun: Performs batch detection of Interictal Epileptic Discharges (IEDs) in intracranial EEG (iEEG) data.  
%  
% INPUT:  
%   - Setting: A structure containing the necessary settings and parameters for IED detection.  
%       Fields include:  
%           - SubjectList: A cell array of subject IDs.  
%           - InputFiles: A structure containing information about the input files.  
%                   Fields: 'name' (cell array of file names), 'folder' (cell array of file folders).  
%           - IEDWinSize: Window size for IED detection.  
%           - IEDThreshold: Threshold value for IED detection.  
%           - IEDinterval: Minimum interval between consecutive IEDs.  
%           - IEDLowerFreq: Lower frequency bound for band-pass filtering.  
%           - IEDUpperFreq: Upper frequency bound for band-pass filtering.  
%  
% OUTPUT:  
%   - The function saves the detected IEDs for each subject in separate .mat files.  
%  
%
% Edited by Longzhou Xu, 2024-3-27
%% Main function 
    SubjectList = Setting.SubjectList;
    InputFiles = Setting.InputFiles;
    IEDWinSize = Setting.IEDWinSize;
    IEDThreshold = Setting.IEDThreshold;
    IEDLowerFreq = Setting.IEDLowerFreq;
    IEDUpperFreq = Setting.IEDUpperFreq;

% Constructive minimal preprocessing data file
    disp('--------Constructive File Information');
    for ii_InputFiles = 1:length(InputFiles.name)
        SubjectID = SubjectList{ii_InputFiles};
        Files(ii_InputFiles).SubjectID = SubjectID;

        Files(ii_InputFiles).PrepFolder = InputFiles.folder{ii_InputFiles};
        Files(ii_InputFiles).PrepName = InputFiles.name{ii_InputFiles};

        ChannelTableDir = dir(fullfile(Files(ii_InputFiles).PrepFolder, '**', [Files(ii_InputFiles).SubjectID, '*_channel.mat']));
        Files(ii_InputFiles).ChannelTableName = ChannelTableDir.name;

        IEDNamePrefix = f_strsplit(Files(ii_InputFiles).PrepName, '_ieeg.mat');
        Files(ii_InputFiles).IEDNamePrefix = IEDNamePrefix{1};
    end

% Running IED Detection
    for ii_Files = 1:length(Files)
        SubjectID  = Files(ii_Files).SubjectID;
        disp(['--------Perform IED Detection: ', SubjectID]);
        cd(Files(ii_Files).PrepFolder);

        disp(['--------Loading IEEG Data from file: ', Files(ii_Files).PrepName]);
        Data = load(Files(ii_Files).PrepName);
        Data = Data.Data;
            
        disp(['--------Loading Channel Table from file: ', Files(ii_Files).ChannelTableName]);
        ChannelTable = load(Files(ii_Files).ChannelTableName);
        ChannelTable = ChannelTable.ChannelTable;

        % IED Detection Pipeline  
        Data = f_select_channel(Data, ChannelTable); % Selects relevant channels from the iEEG data based on the channel table.  
        BPFreq = [IEDLowerFreq, IEDUpperFreq];% Defines the frequency range for band-pass filtering.
        TimeLengthT = 0;
        IntervalLengthT = 0.15;%The minimum interval (in seconds) between events to be considered distinct                   
        IEDs = f_IEDdetection(Data, BPFreq, IEDWinSize, IEDThreshold, TimeLengthT, IntervalLengthT);

        % Save the file
        SaveFolder = Files(ii_Files).PrepFolder;
        SaveName = [Files(ii_Files).IEDNamePrefix,  ...
            '_win-', num2str(IEDWinSize), 's', ...
            '_Th-', num2str(IEDThreshold), ...
            '_IEDfreq-', [num2str(IEDLowerFreq), 'to', num2str(IEDUpperFreq), 'Hz'], '_IED.mat'];
        save(fullfile(SaveFolder, SaveName), 'IEDs');            
    end
end