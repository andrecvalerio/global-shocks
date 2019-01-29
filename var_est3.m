function var_est3(m,c,cf)
% this function generalize "estima" function, enabling the estimation of
% multiple models and countries simultaneously, speeding the process to
% obtain the results presented at the paper.
% m determines which model will be estimated
% c determines which country's data will be used
% cf determines if the "pseudo-counterfactual" analysis will be made
% m assumes values from 0 to 8
    % m = 0 -> estimate all eight models at once
    % m = 1 -> estimate the baseline model
    % m = 2 -> estimate the model with only PCOM in the international block
    % m = 3 -> estimate the model with only WGDP in international block
    % m = 4 -> estimate the model with only VIX in international block
    % m = 5 -> estimate the model with WGDP + PCOM in international block
    % m = 6 -> estimate the model with VIX + PCOM in international block
    % m = 7 -> estimate the model with WGDP + VIX in international block
    % m = 8 -> estimate the baseline model without block recursion
    % m = 9 -> benchmark model with alternative ordering in the
    % international block: WGDP PCOM VIX
% c assumes values from 0 to 4
    % c = 0 -> estimate the model for all countries
    % c = 1 -> Brazil
    % c = 2 -> Chile
    % c = 3 -> Colombia
    % c = 4 -> Peru
% cf has a default value of 0. The counterfactual analysis is performed
% when cf is explicited setted to be different from zero, any value will
% do the trick.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Making sure that all files needed for the estimation are added to the path
p = genpath('library');
addpath(p)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin > 2
    cf = cf;
else
    cf = 0;
end

if m == 0 && c == 0
    for i = 1:9
        for j = 1:4
            estima3(i,j,cf)
        end
    end
elseif m == 0
    for i = 1:9
        estima3(i,c,cf)
    end
elseif c == 0
    for j = 1:4
        estima3(m,j,cf)
    end
else
    estima3(m,c,cf)
end
  
