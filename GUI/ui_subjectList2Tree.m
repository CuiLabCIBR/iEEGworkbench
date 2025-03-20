function [SubjectTree, SubjectTreeGroup, Setting] = ui_subjectList2Tree(SubjectTree, SubjectTreeGroup, Setting)  
% ui_subjectList2Tree: Convert subject list to a tree structure  
%  
% INPUT:  
%   - SubjectTree: The existing tree structure (possibly empty)  
%   - SubjectTreeGroup: The existing tree group (possibly empty)  
%   - Setting: A structure containing settings, including 'SubjectList' if available  
%  
% OUTPUT:  
%   - SubjectTree: The updated tree structure with new subject nodes  
%   - SubjectTreeGroup: The new or updated tree group containing subject nodes  
%   - Setting: The input setting structure (unchanged)  
%  
% Description:  
%       This function takes an existing tree structure and a setting structure as input.  
%       If the setting structure contains a 'SubjectList' field, the function creates  
%       a new tree group (or deletes and recreates if it already exists) and populates  
%       it with subject nodes based on the unique subject names in the 'SubjectList'.  
%       Finally, the function expands the subject tree in the UI.  
%
%% Main function  
    % Delete any existing subject tree group.  
    if ~isempty(SubjectTreeGroup)  
        SubjectTreeGroup.delete;  
    end  
  
    % If 'SubjectList' field exists in 'Setting', create a new tree group and populate it with subject nodes.  
    if isfield(Setting, 'SubjectList')  
        SubjectTreeGroup = uitreenode(SubjectTree);                                                  % Create a new tree group  
        SubjectTreeGroup.Text = 'Subject Group';                                                         % Set the group's text  
        SubjectTreeNodeName = unique(Setting.SubjectList);                                      % Get unique subject names  
  
        % Loop through subject names and create tree nodes for each.  
        for ii_subject = 1:length(SubjectTreeNodeName)  
            SubjectTreeNode{ii_subject} = uitreenode(SubjectTreeGroup);                      % Create a new tree node  
            SubjectTreeNode{ii_subject}.Text = SubjectTreeNodeName{ii_subject};         % Set the node's text  
        end  
    end  
  
    % Expand the subject tree in the UI.  
    expand(SubjectTree);  
end