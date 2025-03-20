function f_HFO_batchrun(Setting)  
% f_HFOdetection_batchrun Performs batch High-Frequency Oscillation (HFO) detection on iEEG data.  
%  
% Inputs:  
%   - Setting: A structure containing the necessary settings for HFO detection.  
%       Fields include:  
%           - SubjectList: List of subject IDs.  
%           - InputFiles: Structure with fields 'name' and 'folder' specifying the iEEG files to process.  
%           - HFOThreshould: Threshold for HFO detection.  
%           - HFOTimeThreshould: Time threshold for HFO events.  
%           - HFOLowerFreq: Lower frequency bound for the HFO band.  
%           - HFOUpperFreq: Upper frequency bound for the HFO band.  
%  
% Outputs:  
%   - None. However, the function saves the detected HFOs and the band-pass filtered iEEG signals to files.  
%  
% Description:  
%   This function performs batch HFO detection on iEEG data. It iterates over a list of subjects and their  
%   corresponding iEEG files. For each file, it loads the data, selects the relevant channels, performs HFO  
%   detection using specified settings, and saves the detected HFOs and the band-pass filtered signals to files.  
%  
% Note:  
%   - The function assumes that the iEEG data and channel tables are stored in separate MAT-files.  
%   - The function saves the output files in the same folder as the input iEEG files.  
%   - The naming convention for the output files includes the subject ID, HFO frequency range, thresholds, and other  
%     relevant parameters.  
  
%% main function  
    % ======== Extract necessary settings from the input structure ===============  
    SubjectList = Setting.SubjectList;  
    InputFiles = Setting.InputFiles;
    HFOThreshould = Setting.HFOThreshould;  
    HFOLowerFreq = Setting.HFOLowerFreq;  
    HFOUpperFreq = Setting.HFOUpperFreq;  
  
    % ======== Construct minimal preprocessing data file information ============  
    disp('--------Constructive File List Information');  
    for ii_InputFiles = 1:length(InputFiles.name)  
        % Extract subject ID and file information  
        SubjectID = SubjectList{ii_InputFiles};  
        Files(ii_InputFiles).SubjectID = SubjectID;  
        Files(ii_InputFiles).PrepFolder = InputFiles.folder{ii_InputFiles};  
        Files(ii_InputFiles).PrepName = InputFiles.name{ii_InputFiles};  
      
        % Find the corresponding channel table file  
        ChannelTableDir = dir(fullfile(Files(ii_InputFiles).PrepFolder, '**', [Files(ii_InputFiles).SubjectID, '*_channel.mat']));  
        Files(ii_InputFiles).ChannelTableName = ChannelTableDir.name;  
      
        % Extract the IED name prefix for saving output files  
        IEDNamePrefix = f_strsplit(Files(ii_InputFiles).PrepName, '_ieeg.mat');  
        Files(ii_InputFiles).IEDNamePrefix = IEDNamePrefix{1};  
    end  
  
    % ======== Running HFO Detection ================================  
    for ii_Files = 1:length(Files)  
        % Extract subject ID and file information  
        SubjectID = Files(ii_Files).SubjectID;  
        disp(['--------Perform HFO Detection: ', SubjectID]);  
        cd(Files(ii_Files).PrepFolder);  
      
        % Load iEEG data  
        disp(['--------Loading IEEG Data from file: ', Files(ii_Files).PrepName]);  
        Data = load(Files(ii_Files).PrepName);  
        Data = Data.Data;  
      
        % Load channel table  
        disp(['--------Loading Channel Table from file: ', Files(ii_Files).ChannelTableName]);  
        ChannelTable = load(Files(ii_Files).ChannelTableName);  
        ChannelTable = ChannelTable.ChannelTable;  
      
        % Select relevant channels (assuming f_select_channel is a custom function)  
        Data = f_select_channel(Data, ChannelTable);  
      
        % Perform HFO detection  
        BPFreq = [HFOLowerFreq, HFOUpperFreq];
        TimeLThd = 1/HFOThreshould*4;
        IntervalLThd = 1/HFOThreshould*2;
        HFOs = f_HFO_detection(Data, BPFreq, HFOThreshould, TimeLThd, IntervalLThd);
      
        % Save the detected HFOs to a file  
        SaveFolder = Files(ii_Files).PrepFolder;  
        SaveName = [Files(ii_Files).IEDNamePrefix, ...  
                ['_HFOfreq-', num2str(HFOLowerFreq), 'to', num2str(HFOUpperFreq), 'Hz'], ...  
                '_Th-', num2str(HFOThreshould), ...  
                '_HFO.mat'];  
        save(fullfile(SaveFolder, SaveName), 'HFOs');  
    end  
end