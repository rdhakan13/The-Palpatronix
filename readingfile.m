function [x_resolution,y_resolution,depth,force_data] = readingfile(file_name)
% readingfile.m reads a CSV file which contains the raw data for detecting the tumour

x_resolution = [];
y_resolution = [];
depth = [];
force_data = [];
[filepath,name,extension] = fileparts(file_name);% error measure, checks 
% whether the file is csv, if not then it prompts for the user to re-load 
% the file 
extension = convertCharsToStrings(extension); % converts the data held by 
% 'extension' into a string for comparison to take place
if extension ~= '.csv'
    % alert sound 
    [y, Fs] = audioread('alert.mp3');
    player = audioplayer(y, Fs);
    msgbox('Please select a csv file. Try again.','Error','error'); % opens
 % a windows alerting the user that the selected file is not a csv
    playblocking(player);
    return % gets back to the program
end

try 
    % the following code is tried, if at any point an error occurs then it
    % moves to catch and this is good way of easily identifying if the data
    % is not in an appropriate manner
    all_data = dlmread(file_name, ',', 1, 1); % reads the data from the 
    % file be excluding the first columns containing titles and the row 
    % containing the dates
    force_data = all_data(4:end, 1:end); % extracting force data(N)
    all_data_dim = size(all_data); % takes the dimensions of the all_data 
    % array because used to make zeros array
    comparison = zeros(3,all_data_dim(2)-1); % creates a zeros array which 
    % is a key distinguishing feature that will easily identify if data is
    % properly arranged in the file
    if (all_data(1:3,2:end)~=comparison)& isempty(force_data)==1
        % alert sound 
        [y, Fs] = audioread('alert.mp3');
        player = audioplayer(y, Fs);
        msgbox("The data in the file is arranged in the wrong format.",...\
            "Error",'error'); % creates an error box
        playblocking(player);
        return % goes back to the program
    end
catch
    % alert sound 
    [y, Fs] = audioread('alert.mp3');
    player = audioplayer(y, Fs);
    msgbox("The data in the file is arranged in the wrong format or there is an error in the data.",...\
            "Error",'error'); % creates an error box
    playblocking(player);
    return
end 

x_resolution = all_data(1,1); % extracting x resolution(mm)
y_resolution = all_data(2,1); % extracting y resolution(mm)
depth = all_data(3,1)/1000; % extracting depth of sensor(m)

end 