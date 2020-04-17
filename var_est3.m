function var_est3(m,c,cf)
% this function generalize "estima" function, enabling the estimation of
% multiple models and countries simultaneously, speeding the process to
% obtain the results presented at the paper.
% m determines which model will be estimated
% c determines which country's data will be used
% cf determines if the "pseudo-counterfactual" analysis will be made
% m assumes values from 0 to 8
    % m = 0 -> estimate all eight models at once
    % m = 1 -> estimate the benchmark model
    % m = 2 -> full model with alternative identification
    % m = 3 -> WGDP + PCOM in the international side
    % m = 4 -> Only PCOM in the international side
    % m = 5 -> WGDP + VIX in the international side
    % m = 6 -> VIX + PCOM in the international side
    % m = 7 -> Only WGDP in the international side
    % m = 8 -> Only VIX in the international side
    % m = 9 -> benchmark without block recursion
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

if c == 0
    if cf~=0 && m == 0
        for j = 1:4
            for i = 1:9
                estima3(1,j,cf)
                estima3(i,j,0)
            end
        end
    elseif cf == 0 && m == 0
        for j = 1:4
            for i = 1:9
                estima3(i,j,cf)
            end
        end
    elseif cf == 0 && m ~=0
        for j = 1:4
            estima3(m,j,cf)
        end
    end
elseif m == 0
    for i = 1:9
        estima3(i,c,0)
    end
else
    estima3(m,c,cf)
end
  
