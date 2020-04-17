function x = namec(which_country, w, z) 
% this function facilitates the labelling process
% which_country is defined by the user in var_est
% w means word, it is the word that we want to paste, in this context, the
% word is already defined in msstart_setup. z is another word you want to
% use
if which_country == 1                
    y = 'Brazil';
elseif which_country == 2
    y = 'Chile';
elseif which_country == 3
    y = 'Colombia';
elseif which_country == 5
    y = 'Mexico';
elseif which_country == 4
    y = 'Peru';
end
x = strcat(y, w, z);

