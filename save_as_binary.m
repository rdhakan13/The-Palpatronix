function save_as_binary(y_array,x_array,binary_array,file_name)
% save_as_binary.m save data as binary table with axes labels

headers3 = "x-coordinates (mm) ==> " + newline + "y-coordinates (mm)"; 
% creates two lines for headers the top one is for x-coordinate and arrow
% indicating that the column headers are the values 
binary_data = horzcat(y_array',binary_array); % concatenates the y_array
% to the binary_array
array = [cell2mat(headers3),string(x_array)]; % concatenates the headers to
% the x_array with the coordinates
binary_data = vertcat (array, num2cell(binary_data)); % concatenates all 
% the data
file_name = strcat(file_name(1:(end-4)),'_result_binary.xlsx'); % sets a 
% default filename based on the filename of the data inputted in
% the code
[file,path] = uiputfile(file_name,'Please save your file');% opens a 
% dialog box allowing the user to name the file or to keep the default name 
% and save it in their chosen location
if file==0 % if the dialog box is canceled the program returns
    return
end 
filename = fullfile(path,file);% this code allows to save the file 
% outside of the defualt directory
writetable(array2table(binary_data),filename,'Filetype','spreadsheet',...
    'WriteVariableNames',false,'UseExcel',true);% write the data into a 
% table and saves the file in XLSX format

end 