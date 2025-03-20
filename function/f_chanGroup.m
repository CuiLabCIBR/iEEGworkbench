function chanGroups = f_chanGroup(chanLabels)
%
%
%%
    for nChan = 1:length(chanLabels)
        chanGroups(nChan) = join(regexp(chanLabels{nChan}, '\D', 'match'), '');
    end
end