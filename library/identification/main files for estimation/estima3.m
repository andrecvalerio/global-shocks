function estima3(m,c,cf)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cf is optional argument, intended to be used only to perform a 
% pseudo-conterfactual analisys. It is restricted to the configuration
% of model 1. First, I want to make sure that it will only be used for that
% purpose, therefore, I set a default value for cf = 0, meaning that it
% will only perform the counterfactual analysis if it is the user desire.
% for any other value different from zero, the function will estimate the
% model for the counterfactual analisys.
if nargin > 2
    cf = cf;
else
    cf = 0;
end

if cf ~= 0              % Perform the "pseudo-counterfactual" analisys
    if m == 1
        which_country = c;
        model = 'ftd_cholesky';

        msstart_setup
        msprob
        msprobg
        close all

        Bhat(3:5,6)   = 0;
        Bhat(11:13,6) = 0;
        Bhat(19:21,6) = 0;
        Bhat(27:29,6) = 0;

        A0hat(3:5,6)  = 0;

        fevd
    elseif m == 2
        which_country = c;
        model = 'ftd_cholesky2';
        
        msstart_setup
        msprob
        msprobg
        close all
        
        Bhat(3,4)  = 0;
        Bhat(9,4)  = 0;
        Bhat(15,4) = 0;
        Bhat(21,4) = 0;
        
        A0hat(3,4) = 0;
        
        fevd 
    elseif m == 3
        which_country = c;
        model = 'ftd_cholesky3';
        
        msstart_setup
        msprob
        msprobg
        close all
        
        Bhat(3,4)  = 0;
        Bhat(9,4)  = 0;
        Bhat(15,4) = 0;
        Bhat(21,4) = 0;
        
        A0hat(3,4) = 0;
        
        fevd
    elseif m == 4
        which_country = c;
        model = 'ftd_cholesky4';
        
        msstart_setup
        msprob
        msprobg
        close all
        
        Bhat(3,4)  = 0;
        Bhat(9,4)  = 0;
        Bhat(15,4) = 0;
        Bhat(21,4) = 0;
        
        A0hat(3,4) = 0;
        
        fevd
    elseif m == 5
        which_country = c;
        model = 'ftd_cholesky5';
        
        msstart_setup
        msprob
        msprobg
        close all
        
        Bhat(3:4,5)  = 0;
        Bhat(10:11,5)  = 0;
        Bhat(17:18,5) = 0;
        Bhat(24:25,5) = 0;
        
        A0hat(3:4,5) = 0;
        
        fevd
    elseif m == 6
        which_country = c;
        model = 'ftd_cholesky6';
        
        msstart_setup
        msprob
        msprobg
        close all
        
        Bhat(3:4,5)  = 0;
        Bhat(10:11,5)  = 0;
        Bhat(17:18,5) = 0;
        Bhat(24:25,5) = 0;
        
        A0hat(3:4,5) = 0;
        
        fevd
    elseif m == 7
        which_country = c;
        model = 'ftd_cholesky7';
        
        msstart_setup
        msprob
        msprobg
        close all
        
        Bhat(3:4,5)  = 0;
        Bhat(10:11,5)  = 0;
        Bhat(17:18,5) = 0;
        Bhat(24:25,5) = 0;
        
        A0hat(3:4,5) = 0;
        
        fevd
    elseif m == 8
        which_country = c;
        model = 'ftd_cholesky8';

        msstart_setup
        msprob
        msprobg
        close all

        Bhat(3:5,6)   = 0;
        Bhat(11:13,6) = 0;
        Bhat(19:21,6) = 0;
        Bhat(27:29,6) = 0;

        A0hat(3:5,6)  = 0;

        fevd
    end
else
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% this function automatize the estimation routine
% m determines which model will be estimated
% 1 = Benchmark, 2 = Only PCOM,3 = Only WGDP, 4 = Only VIX,
% 5 = WGDP + PCOM, 6 = VIX + PCOM, 7 = WGDP + VIX, 8 = No block recursion
% 9 = WGDP PCOM VIX
% c determines which country's data will be used
% 1 = Brazil, 2 = Chile, 3 = Colombia, 4 = Peru

% checking if function's argument is ok
if m > 9 || m < 0
    error('Error. The first argument of this function is only defined for values between 0 and 9, inclusive. See Readme.');
elseif c > 4 || c < 0
    error('Error! The second argument of this function is only defined for values between 0 and 4, inclusive. See Readme.');
end

% setting the apropriate model file for estimation
if m == 1
    model = 'ftd_cholesky';     % Function that imposes contemporaneous and
elseif m == 2                   % lag restrictions on each model
    model = 'ftd_cholesky2';
elseif m == 3
    model = 'ftd_cholesky3';
elseif m == 4
    model = 'ftd_cholesky4';
elseif m == 5
    model = 'ftd_cholesky5';
elseif m == 6
    model = 'ftd_cholesky6';
elseif m == 7
    model = 'ftd_cholesky7';
elseif m == 8
    model = 'ftd_cholesky8';
elseif m == 9
    model = 'ftd_cholesky9';
end

% routines needed to estimate the model
which_country = c; % this variable is used in msstart_setup
msstart_setup      % file that make all appropriate settings for estimation
msprob             % estimation 
msprobg            % obtain error bands
close all
  
% plotting the irfs according to which_model is being estimated
if m == 1  
    plot_irf
    plot_irf2
elseif m == 2
    plot_irfm2
    plot_irf2m2
elseif m == 3
    plot_irfm3
    plot_irf2m3     
elseif m == 4
    plot_irfm4
    plot_irf2m4
elseif m == 5
    plot_irfm5
    plot_irf2m5
elseif m == 6
    plot_irfm6
    plot_irf2m6
elseif m == 7
    plot_irfm7
    plot_irf2m7
elseif m == 8
    plot_irfm8
    plot_irf2m8
elseif m == 9
    plot_irfm9
    plot_irf2m9
end
close all



fevd % perform forecast error variance decomposition
end

