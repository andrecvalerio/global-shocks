% Adding routines and data necessary to estimate the model
addpath('library')
addpath('data')

%%%%%% BEGIN OF PREAMBLE
%%% Sample information
month_quarter = 4;  % quarter or month; quarter = 4, month = 12 
y_bg   = 2000; % initial year 
qm_bg  = 1;    % initial quarter/month 
y_end  = 2017; % final year
qm_end = 2;    % final quarter/month
qm_lag = 4;    % number of lags                    

% loading the data according to which country
% 1 = Brazil; 2 = Chile; 3 = Colombia; 4 = Mexico; 5 = Peru

if which_country == 1
    load br.txt;
    dado = br;
    clear br;
    
    var_names = {'gdp', 'cpi', 'wgdp', 'vix', 'pcom', 'cr', 'exr', 'intr'}; %variable names
    gdp  = dado(:,1); %defining the variables according to the column order in the data file
    cpi  = dado(:,2);
    wgdp = dado(:,3);
    vix  = dado(:,4);
    pcom = dado(:,5);
    cr   = dado(:,6);
    exr  = dado(:,7);
    intr = dado(:,8);
            
elseif which_country == 2
    load ch.txt;
    dado = ch;
    clear ch;
    
    var_names = {'gdp', 'cpi', 'wgdp', 'vix', 'pcom', 'cr', 'exr', 'intr'}; %variable names
    gdp  = dado(:,1); %defining the variables
    cpi  = dado(:,2);
    wgdp = dado(:,3);
    vix  = dado(:,4);
    pcom = dado(:,5);
    cr   = dado(:,6);
    exr  = dado(:,7);
    intr = dado(:,8);
               
elseif which_country == 3
    load col.txt;
    dado = col;
    clear col;
    
    var_names = {'gdp', 'cpi', 'wgdp', 'vix', 'pcom', 'cr', 'exr', 'intr'}; %variable names
    gdp  = dado(:,1); %defining the variables
    cpi  = dado(:,2);
    wgdp = dado(:,3);
    vix  = dado(:,4);
    pcom = dado(:,5);
    cr   = dado(:,6);
    exr  = dado(:,7);
    intr = dado(:,8);
                
elseif which_country == 5
    load mex.txt;
    dado = mex;
    clear mex;
    
    var_names = {'gdp', 'cpi', 'wgdp', 'vix', 'pcom', 'cr', 'exr', 'intr'}; %variable names
    gdp  = dado(:,1); %defining the variables
    cpi  = dado(:,2);
    wgdp = dado(:,3);
    vix  = dado(:,4);
    pcom = dado(:,5);
    cr   = dado(:,6);
    exr  = dado(:,7);
    intr = dado(:,8);
                
elseif which_country == 4
    load peru.txt;
    dado = peru;
    clear peru;
    
    var_names = {'gdp', 'cpi', 'wgdp', 'vix', 'pcom', 'cr', 'exr', 'intr'}; %variable names
    gdp  = dado(:,1); %defining the variables
    cpi  = dado(:,2);
    wgdp = dado(:,3);
    vix  = dado(:,4);
    pcom = dado(:,5);
    cr   = dado(:,6);
    exr  = dado(:,7);
    intr = dado(:,8);
                
end

%%%% END OF LOADING DATA

% defining which VAR will be estimated
if m == 1 || m == 8
    var_reg      = [gdp, cpi, wgdp, vix, pcom, cr, exr, intr]; %defining the VAR to be estimated;
    %varlista = {namec(which_country, ' GDP'), namec(which_country, ' CPI'),'World GDP','VIX', 'Commodities', 'Country Risk', 'Exchange Rate', 'Interest Rate'}; %variables names
    varlista = {'GDP','CPI','WGDP','VIX','PCOM','CR','EXR','INTR'};
elseif m == 2
    var_reg      = [gdp, cpi, pcom, cr, exr, intr];
    %varlista = {namec(which_country, ' GDP'), namec(which_country, ' CPI'), 'Commodities', 'Country Risk', 'Exchange Rate', 'Interest Rate'};
    varlista = {'GDP','CPI','PCOM','CR','EXR','INTR'};
elseif m == 3
    var_reg      = [gdp, cpi, wgdp, cr, exr, intr];
    %varlista = {namec(which_country, ' GDP'), namec(which_country, ' CPI'), 'World GDP', 'Country Risk', 'Exchange Rate', 'Interest Rate'};
    varlista = {'GDP','CPI','WGDP','CR','EXR','INTR'};
elseif m == 4
    var_reg      = [gdp, cpi, vix, cr, exr, intr];
    %varlista = {namec(which_country, ' GDP'), namec(which_country, ' CPI'), 'VIX', 'Country Risk', 'Exchange Rate', 'Interest Rate'};
    varlista = {'GDP','CPI','VIX','CR','EXR','INTR'};
elseif m == 5
    var_reg      = [gdp, cpi, wgdp, pcom, cr, exr, intr];
    %varlista = {namec(which_country, ' GDP'), namec(which_country, ' CPI'),'World GDP', 'Commodities', 'Country Risk', 'Exchange Rate', 'Interest Rate'};
    varlista = {'GDP','CPI','WGDP','PCOM','CR','EXR','INTR'};
elseif m == 6
    var_reg      = [gdp, cpi, vix, pcom, cr, exr, intr];
    %varlista = {namec(which_country, ' GDP'), namec(which_country, ' CPI'),'VIX', 'Commodities', 'Country Risk', 'Exchange Rate', 'Interest Rate'};
    varlista = {'GDP','CPI','VIX','PCOM','CR','EXR','INTR'};
elseif m == 7
    var_reg      = [gdp, cpi, wgdp, vix, cr, exr, intr];
    %varlista = {namec(which_country, ' GDP'), namec(which_country, ' CPI'),'World GDP', 'VIX', 'Country Risk', 'Exchange Rate', 'Interest Rate'};
    varlista = {'GDP','CPI','WGDP','VIX','CR','EXR','INTR'};
elseif m == 9
    var_reg      = [gdp, cpi, wgdp, pcom, vix, cr, exr, intr]; %defining the VAR to be estimated;
    varlista = {'GDP','CPI','WGDP','PCOM','VIX','CR','EXR','INTR'};
end
% namec is a function created to automatize the naming process for each
% country

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END OF PREAMBLE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%===========================================
% Exordium I
%===========================================
format short g     % format
%
q_m = month_quarter;   % quarters or months, defined in the preamble
yrBin=y_bg;            % starting year of the sample
qmBin=qm_bg;            % starting month (quarter) of the sample
yrFin=y_end;           % final year of the sample
qmFin=qm_end;           % final month (quarter) of the sample. All of the defined in the preamble
nData=(yrFin-yrBin)*q_m + (qmFin-qmBin+1);
%*** Load data and series

xdd = var_reg;
[nt,ndv]=size(xdd);
nvar=ndv
if nt~=nData
   disp(' ')
   warning(sprintf('nt=%d, Caution: not equal to the length in the data',nt));
   %disp(sprintf('nt=%d, Caution: not equal to the length in the data',nt));
   disp('Press ctrl-c to abort')
   return
end
%--------
vlist = [1:nvar]; 
varlist=varlista;
vlistper = [1:nvar];           % subset of "vlist"
vlistlog = [ ];   % subset of "vlist.  Variables in log level so that differences are in **monthly** growth, unlike R and U which are in annual percent (divided by 100 already).
idfile_const=model;   %Only used by msstart2.m.
ylab = varlist;
xlab = varlist;

%----------------
nvar = length(vlist);       % number of endogenous variables
nlogeno = length(vlistlog)  % number of endogenous variables in vlistlog
npereno = length(vlistper)  % number of endogenous variables in vlistper
if (nvar~=(nlogeno+npereno))
   disp(' ')
   warning('Check xlab, nlogeno or npereno to make sure of endogenous variables in vlist')
   disp('Press ctrl-c to abort')
   return
elseif (nvar==length(vlist))
   nexo=1;    % only constants as an exogenous variable.  The default setting.
elseif (nvar<length(vlist))
   nexo=length(vlist)-nvar+1;
else
   disp(' ')
   warning('Make sure there are only nvar endogenous variables in vlist')
   disp('Press ctrl-c to abort')
   return
end

% A specific sample is considered for estimation. Here is the full sample,
% so the values is the same as above. NOTE: this define the period of
% estimation, so beware of changes in here.
yrStart=y_bg;
qmStart=qm_bg; 
yrEnd=y_end;
qmEnd=qm_end;
nfyr = 4;   % number of years for forecasting

if nfyr<1
   error('To be safe, the number of forecast years should be at least 1')
end
ystr=num2str(yrEnd);
forelabel = [ ystr(3:4) ':' num2str(qmEnd) ' Forecast'];

nSample=(yrEnd-yrStart)*q_m + (qmEnd-qmStart+1);
if qmEnd==q_m
   E1yrqm = [yrEnd+1 1];  % first year and quarter (month) after the sample
else
   E1yrqm = [yrEnd qmEnd+1];  % first year and quarter (month) after the sample
end
E2yrqm = [yrEnd+nfyr qmEnd];   % end at the last month (quarter) of a calendar year after the sample
[fdates,nfqm]=fn_calyrqm(q_m,E1yrqm,E2yrqm);   % forecast dates and number of forecast dates
[sdates,nsqm] = fn_calyrqm(q_m,[yrStart qmStart],[yrEnd qmEnd]);
   % sdates: dates for the whole sample (including lags)
if nSample~=nsqm
   warning('Make sure that nSample is consistent with the size of sdates')
   disp('Hit any key to continue, or ctrl-c to abort')
   pause
end
imstp = 4*q_m;    % <<>>  impulse responses (4 years)
nayr = 4; %nfyr;  % number of years before forecasting for plotting.

%------- Prior, etc. -------
lags = qm_lag;        % number of lags
indxC0Pres = 0;   % 1: cross-A0-and-A+ restrictions; 0: idfile_const is all we have
            % Example for indxOres==1: restrictions of the form P(t) = P(t-1).
Rform = 0;  % 1: contemporaneous recursive reduced form; 0: restricted (non-recursive) form
Pseudo = 0;  % 1: Pseudo forecasts; 0: real time forecasts
indxPrior = 1;  % 1: Standard Sims-Zha Bayesian prior; 0: no prior
indxDummy = indxPrior;  % 1: add dummy observations to the data; 0: no dummy added.
ndobs = 0;  % No dummy observations for xtx, phi, fss, xdatae, etc.  Dummy observations are used as an explicit prior in fn_rnrprior_covres_dobs.m.
%if indxDummy
%   ndobs=nvar+1;         % number of dummy observations
%else
%   ndobs=0;    % no dummy observations
%end
%=== The following mu is effective only if indxPrior==1.
mu = zeros(6,1);   % hyperparameters
mu(1) = 1;
mu(2) = 0.5;
mu(3) = 0.1;
mu(4) = 1.0;
mu(5) = 1.0;
mu(6) = 0;%1.0;
%--- Default value.
%mu(1) = 1;
%mu(2) = 0.5;
%mu(3) = 0.1;
%mu(4) = 1.0;
%mu(5) = 1.0;
%mu(6) = 1.0;
%   mu(1): overall tightness and also for A0;
%   mu(2): relative tightness for A+;
%   mu(3): relative tightness for the constant term;
%   mu(4): tightness on lag decay;  (1)
%   mu(5): weight on nvar sums of coeffs dummy observations (unit roots);
%   mu(6): weight on single dummy initial observation including constant
%           (cointegration, unit roots, and stationarity);
%
%
hpmsmd = [0.0; 0.0];
indxmsmdeqn = [1; 2; 1; 2];

tdf = 3;          % degrees of freedom for t-dist for initial draw of the MC loop
nbuffer = 100;        % a block or buffer of draws (buffer) that is saved to the disk (not memory)
ndraws1=1*nbuffer;         % 1st part of Monte Carlo draws
ndraws2=10*ndraws1         % 2nd part of Monte Carlo draws
seednumber = 4; %7910;    %472534;   % if 0, random state at each clock time
           % good one 420 for [29 45], [29 54]
if seednumber
   randn('state',seednumber);
   rand('state',seednumber);
else
   randn('state',fix(100*sum(clock)));
   rand('state',fix(100*sum(clock)));
end
%  nstarts=1         % number of starting points
%  imndraws = nstarts*ndraws2;   % total draws for impulse responses or forecasts
%<<<<<<<<<<<<<<<<<<<





