function save_as_table(tumour_data,potential_tumour_data,file_name)
% save_as_table.m saves the tumour data in a table

headers1 = {'No of Tumours','x-coordinates (mm)','y-coordinates (mm)',...
'Tumour stiffness (N/m)','Approximate Size of Tumour (mm^2)'}; % cell 
% array for headers 
if isempty(potential_tumour_data) == 0
    % if there are any potential tumours in the sample then the data of
    % potential tumours will also be saved in the same file as that of 
    % actual tumours
    Empty = {' ',' ', ' ', ' ',' '}; % empty line
    headers2 = {'No of Potential Tumours','x-coordinates (mm)',...
        'y-coordinates (mm)','Tumour stiffness (N/m)',...
        'Default Size of Potential Tumour (mm^2)'};
    % concatenates the different information 
    final_data = vertcat(headers1,num2cell(round(tumour_data,2)),...
        Empty,headers2,num2cell(round(potential_tumour_data,2)));
    % concatenates all the data and the headers
else
    final_data = vertcat(headers1,num2cell(round(tumour_data,2))); 
    % concatenates all the data for headers and tumours
end 
file_name = strcat(file_name(1:(end-4)),'_result_table.csv'); % sets a 
% default filename based on the filename of the data inputted in
% the code
[file,path] = uiputfile(file_name,'Please save your file'); % opens a 
% dialog box allowing the user to name the file or to keep the default name 
% and save it in their chosen location
if file==0 % if the dialog box is canceled the program returns
    return
end 
filename = fullfile(path,file); % this code allows to save the file 
% outside of the defualt directory
writetable(cell2table(final_data),filename,'Filetype','text','Delimiter',...
',','WriteVariableNames',false); % write the data into a table and saves
% the file in CSV format

end 