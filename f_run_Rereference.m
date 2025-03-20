function f_run_Rereference(Setting)
%
%
%
%% Initialization
    SubjectList = Setting.SubjectList;
    InputFiles = Setting.InputFiles;
    SelectedRefMethod = Setting.SelectedRefMethod;
%% the minimal preprocessing data file
    disp('--------Constructive File Information');
    for ii_InputFiles = 1:length(InputFiles.name)
        SubjectID = SubjectList{ii_InputFiles};
        DataFile(ii_InputFiles).SubjectID = SubjectID;

        DataFile(ii_InputFiles).PrepFolder = InputFiles.folder{ii_InputFiles};
        DataFile(ii_InputFiles).PrepName = InputFiles.name{ii_InputFiles};

        ChannelTableDir = dir(fullfile(DataFile(ii_InputFiles).PrepFolder, '**', [DataFile(ii_InputFiles).SubjectID, '*_channel.mat']));
        DataFile(ii_InputFiles).ChannelTableName = ChannelTableDir.name;

        RefNamePrefix = f_strsplit(DataFile(ii_InputFiles).PrepName, '_ieeg.mat');
        RefName = [RefNamePrefix{1}, '_ref-', SelectedRefMethod, '_ieeg.mat'];
        DataFile(ii_InputFiles).RefName = RefName;
    end
%% perform Re-reference
    for ii_datafile = 1:length(DataFile)
        SubjectID  = DataFile(ii_datafile).SubjectID;
        disp(['--------Perform Re-reference Using ', SelectedRefMethod, ': ', SubjectID]);
        cd(DataFile(ii_datafile).PrepFolder);

        disp(['--------Loading minimal preprocessed IEEG Data from file: ', DataFile(ii_datafile).PrepName]);
        Data = load(DataFile(ii_datafile).PrepName);
        Data = Data.Data;
            
        disp(['--------Loading Channel Table from file: ', DataFile(ii_datafile).ChannelTableName]);
        ChannelTable = load(DataFile(ii_datafile).ChannelTableName);
        ChannelTable = ChannelTable.ChannelTable;
            
        disp('--------Running Re-reference');
        Data = f_IEEGPrep_reference(Data, SelectedRefMethod, ChannelTable);

        disp(['--------Save Re-reference data to file: ', DataFile(ii_datafile).RefName]);
        save(DataFile(ii_datafile).RefName, 'Data');
    end
end
