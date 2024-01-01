function proceed = error_check(force_data)
% error_check.m checks if the force data is corrupted or not

% error handling, if the force data is less than 0 N then the program 
% alerts the user that the data is corrupted 
corrupt_data = find(force_data<0); % creates a matrix which has linear 
% indexes where the force data is less than 0N
proceed = 'Yes'; % proceed variable is initialised
proceed = convertCharsToStrings(proceed); % converts its to a string for
% comparison to take place
if isempty(corrupt_data)==0
        % alert sound 
        [y, Fs] = audioread('alert.mp3');
        player = audioplayer(y, Fs);
        play(player);
     proceed = questdlg('The data is corrupted, do you want to continue?',...
'Alert','Yes','No','No'); 
     % gives the user a choice whether they want to proceed with the data 
% they have
     proceed = convertCharsToStrings(proceed); % converts the answer to a 
% string for comparison to take place
end

end 