function [Ui,Vi,n0,np,ixmC0Pres] = ftd_cholesky9(lags,nvar,nexo,indxC0Pres,m)
%January 2016
% The model:
%   WGDP VIX PCOM CR EXR GDP CPI INTR
%   This identification does not impose block restriction but the
%   contemporaneous restrictions are the same as the benchmark model.
%   However, the country risk equation still has block restriction to
%   prevent the variable to respond to domestic variables.
%  
%   Identification structure: X means unrestricted and columns are
%   equations. For instance, column 1 says that only WGDP affects 
%   contemporaneously WGDP, while column 6 says that only WGDP and GDP
%   affects GDP contemporaneously.
%   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%   %        WGDP VIX PCOM CR EXR  GDP CPI INTR %
%   % WGDP	  X	  X   X    X   X    X   X   X   %
%   % VIX	  0   X   X    X   X    0   0   X   %
%   % PCOM    0   0   X    X   X    0   X   X   %
%   % CR      0   0   0    X   X    0   0   X   %
%   % EXR     0	  0   0    0   X    0   0   X   %
%   % GDP	  0	  0   0    0   0    X   X   X   %
%   % CPI     0	  0	  0    0   0    0   X   X   % 
%   % INTR    0   0	  0    0   0    0   0   X   %
%   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Lag restrictions only imposed on the international block - WGDP, VIX, PCOM and CR
%
%For restricted VARs in the form: y_t'*A0 = x_t'*Ap + e_t', where y_t is a vector of endogenous variables
%      and x_t is a vector of lagged endogenous variables and the constant term (last term).
%      Note that the columns of A0 and Ap correspnd to equations.
%
%    Exporting orthonormal matrices for the deterministic linear restrictions (equation by equation)
%    See Waggoner and Zha's Gibbs sampling paper.
%
% q_m:  quarter or month
% lags: the maximum length of lag
% nvar:  number of endogeous variables
% nexo:  number of exogenous variables.  If nexo is not supplied, nexo=1 as default for a constant
% indxC0Pres: index for cross-A0-A+ restrictions.  if 1: cross-A0-and-A+ restrictions; 0: idfile is all we have
%                Example for indxOres==1: restrictions of the form P(t) = P(t-1).
%                These restrictions have to be manually and carefully keyed in.
%-----------------
% Ui: nvar-by-1 cell.  In each cell, nvar-by-qi orthonormal basis for the null of the ith
%           equation contemporaneous restriction matrix where qi is the number of free parameters.
%           With this transformation, we have ai = Ui*bi or Ui'*ai = bi where ai is a vector
%           of total original parameters and bi is a vector of free parameters. When no
%           restrictions are imposed, we have Ui = I.  There must be at least one free
%           parameter left for the ith equation.
% Vi: nvar-by-1 cell.  In each cell, k-by-ri orthonormal basis for the null of the ith
%           equation lagged restriction matrix where k is a total of exogenous variables and
%           ri is the number of free parameters. With this transformation, we have fi = Vi*gi
%           or Vi'*fi = gi where fi is a vector of total original parameters and gi is a
%           vector of free parameters. There must be at least one free parameter left for
%           the ith equation.
% n0: nvar-by-1, ith element represents the number of free A0 parameters in ith equation
% np: nvar-by-1, ith element represents the number of free A+ parameters in ith equation
% ixmC0Pres:  neq_cres-by-1 cell.  Effective only if indxC0Pres=1, otherwise equals NaN.
%             neq_cres is the number of equations in which cross-A0-A+ restrictions occur.
%             In the jth cell representing equation, we have 4 columns:
%               1st: the jth column (equation) of A+ or A0: f_j or a_j
%               2nd: the ith element f_j(i) -- the ith element in the jth column of A+
%               3rd: the hth element a_j(h) -- the hth element in the jth column of A0
%               4th: the number s such that f_j(i) = s * a_j(h) holds.
%
% Tao Zha, May 2000

Ui = cell(nvar,1);  % initializing for contemporaneous endogenous variables
Vi = cell(nvar,1);  % initializing for lagged and exogenous variables
n0 = zeros(nvar,1); % ith element represents the number of free A0 parameters in ith equation
np = zeros(nvar,1); % ith element represents the number of free A+ parameters in ith equation

if (nargin==2)
   nexo = 1;  % 1: constant as default where nexo must be a nonnegative integer
elseif (nargin==3)
   indxC0Pres = 0;  % default is no cross-A0-and-A+ restrictions.
end

k = lags*nvar+nexo;  % maximum number of lagged and exogenous variables in each equation

Qi = zeros(nvar,nvar,nvar);   % for nvar contemporaneous equations
Ri = zeros(k,k,nvar);    % for nvar lagged and exogenous equations
  % Row corresponds to equation. 0 means no restriction.
  %                              1 means exclusion restriction such that the corresponding parameter is restricted to 0.

%nfvar = 6;   % number of foreign (Granger causing) variables
%nhvar = nvar-nfvar;  % number of home (affected) variables.


%-------------------------------------------------------------
%  Beginning the manual input of the restrictions one quation at a time
%-------------------------------------------------------------
  

%======== The first equation - WGDP  
    Qi(1:8,:,1) = [
     0 0 0 0 0 0 0 0 % WGDP
     0 1 0 0 0 0 0 0 % VIX
	 0 0 1 0 0 0 0 0 % PCOM
     0 0 0 1 0 0 0 0 % CR
	 0 0 0 0 1 0 0 0 % EXR
	 0 0 0 0 0 1 0 0 % GDP
	 0 0 0 0 0 0 1 0 % CPI
     0 0 0 0 0 0 0 1 % INTR
  	];

%======== The second equation - VIX
    Qi(1:8,:,2) = [
     0 0 0 0 0 0 0 0 % WGDP
     0 0 0 0 0 0 0 0 % VIX
	 0 0 1 0 0 0 0 0 % PCOM
     0 0 0 1 0 0 0 0 % CR
	 0 0 0 0 1 0 0 0 % EXR
	 0 0 0 0 0 1 0 0 % GDP
	 0 0 0 0 0 0 1 0 % CPI
     0 0 0 0 0 0 0 1 % INTR
  	];

%======== The third equation - PCOM
    Qi(1:8,:,3) = [
     0 0 0 0 0 0 0 0 % WGDP
     0 0 0 0 0 0 0 0 % VIX
	 0 0 0 0 0 0 0 0 % PCOM
     0 0 0 1 0 0 0 0 % CR
	 0 0 0 0 1 0 0 0 % EXR
	 0 0 0 0 0 1 0 0 % GDP
	 0 0 0 0 0 0 1 0 % CPI
     0 0 0 0 0 0 0 1 % INTR
  	];

    

%======== The fourth equation - CR
    Qi(1:8,:,4) = [
     0 0 0 0 0 0 0 0 % WGDP
     0 0 0 0 0 0 0 0 % VIX
	 0 0 0 0 0 0 0 0 % PCOM
     0 0 0 0 0 0 0 0 % CR
	 0 0 0 0 1 0 0 0 % EXR
	 0 0 0 0 0 1 0 0 % GDP
	 0 0 0 0 0 0 1 0 % CPI
     0 0 0 0 0 0 0 1 % INTR
  	];

    
    
%======== The fifth equation - EXR
    Qi(1:8,:,5) = [
     0 0 0 0 0 0 0 0 % WGDP
     0 0 0 0 0 0 0 0 % VIX
	 0 0 0 0 0 0 0 0 % PCOM
     0 0 0 0 0 0 0 0 % CR
	 0 0 0 0 0 0 0 0 % EXR
	 0 0 0 0 0 1 0 0 % GDP
	 0 0 0 0 0 0 1 0 % CPI
     0 0 0 0 0 0 0 1 % INTR
  	];

%======== The sixth equation - GDP
    Qi(1:8,:,6) = [
     0 0 0 0 0 0 0 0 % WGDP
     0 1 0 0 0 0 0 0 % VIX
	 0 0 1 0 0 0 0 0 % PCOM
     0 0 0 1 0 0 0 0 % CR
	 0 0 0 0 1 0 0 0 % EXR
	 0 0 0 0 0 0 0 0 % GDP
	 0 0 0 0 0 0 1 0 % CPI
     0 0 0 0 0 0 0 1 % INTR
  	];

%======== The seventh equation - CPI
    Qi(1:8,:,7) = [
     0 0 0 0 0 0 0 0 % WGDP
     0 1 0 0 0 0 0 0 % VIX
	 0 0 0 0 0 0 0 0 % PCOM
     0 0 0 1 0 0 0 0 % CR
	 0 0 0 0 1 0 0 0 % EXR
	 0 0 0 0 0 0 0 0 % GDP
	 0 0 0 0 0 0 0 0 % CPI
     0 0 0 0 0 0 0 1 % INTR
  	];

%======== The eigth equation - INTR
    %%% No change, everything affects interest rate (monetary policy rate)
    
 %end
%-------------------------- Lag restrictions. ------------------------------------------
if (1)
  %--- Lag restrictions.:
  	indxeqn = 1;   %Which equation: WGDP
    nrestrs = 1;  %Number of restrictions.
	blags = zeros(nrestrs,k);
	cnt = 0;
	%--- Keep constant zero.
	cnt = cnt+1;
	blags(cnt,end) = 1;  %Constant = 0.
	if cnt~=nrestrs
	   error('Check lagged restrictions in 1st equation!')
	end
	Ri(1:nrestrs,:,indxeqn) = blags;

  %--- Lag restrictions.
  	indxeqn = 2;   %Which equation: VIX
	nrestrs = 1;  %Number of restrictions.
	blags = zeros(nrestrs,k);
	cnt = 0;
	%--- Keep constant zero.
	cnt = cnt+1;
	blags(cnt,end) = 1;  %Constant = 0.
	if cnt~=nrestrs
	   error('Check lagged restrictions in 2nd equation!')
	end
	Ri(1:nrestrs,:,indxeqn) = blags;
    
 %--- Lag restrictions.
    indxeqn = 3; % Which equation: PCOM 
 	nrestrs = 1;  %Number of restrictions.
	blags = zeros(nrestrs,k);
	cnt = 0;
	%--- Keep constant zero.
	cnt = cnt+1;
	blags(cnt,end) = 1;  %Constant = 0.
	if cnt~=nrestrs
	   error('Check lagged restrictions in 3rd equation!')
	end
	Ri(1:nrestrs,:,indxeqn) = blags;

  %--- Lag restrictions.
	indxeqn = 4;   %Which equation: CR
	nrestrs = (nvar-4)*lags+1;  %Number of restrictions.
	vars_restr = [5 6 7 8];  %Variables that are restricted.
	blags = zeros(nrestrs,k);
	cnt = 0;
	for ki = 1:lags
	   for kj=vars_restr
	      cnt = cnt+1;
	      blags(cnt,nvar*(ki-1)+kj) = 1;
	   end
	end
	%--- Keep constant zero.
	cnt = cnt+1;
	blags(cnt,end) = 1;  %Constant = 0.
	if cnt~=nrestrs
	   error('Check lagged restrictions in 4th equation!')
	end
	Ri(1:nrestrs,:,indxeqn) = blags;
    
     %--- Lag restrictions.
	indxeqn = 5;   %Which equation: EXR
	nrestrs = 1;  %Number of restrictions.
	blags = zeros(nrestrs,k);
	cnt = 0;
	%--- Keep constant zero.
	cnt = cnt+1;
	blags(cnt,end) = 1;  %Constant = 0.
	if cnt~=nrestrs
	   error('Check lagged restrictions in 5th equation!')
	end
	Ri(1:nrestrs,:,indxeqn) = blags;
    
    %--- Lag restrictions.
	indxeqn = 6;   %Which equation: GDP
	nrestrs = 1;  %Number of restrictions.
	blags = zeros(nrestrs,k);
	cnt = 0;
	%--- Keep constant zero.
	cnt = cnt+1;
	blags(cnt,end) = 1;  %Constant = 0.
	if cnt~=nrestrs
	   error('Check lagged restrictions in 6th equation!')
	end
	Ri(1:nrestrs,:,indxeqn) = blags;
    
     %--- Lag restrictions.
	indxeqn = 7;   %Which equation: CPI
	nrestrs = 1;  %Number of restrictions.
	blags = zeros(nrestrs,k);
	cnt = 0;
	%--- Keep constant zero.
	cnt = cnt+1;
	blags(cnt,end) = 1;  %Constant = 0.
	if cnt~=nrestrs
	   error('Check lagged restrictions in 7th equation!')
	end
	Ri(1:nrestrs,:,indxeqn) = blags;
    
     %--- Lag restrictions.
	indxeqn = 8;   %Which equation: INTR
	nrestrs = 1;  %Number of restrictions.
	blags = zeros(nrestrs,k);
	cnt = 0;
	%--- Keep constant zero.
	cnt = cnt+1;
	blags(cnt,end) = 1;  %Constant = 0.
	if cnt~=nrestrs
	   error('Check lagged restrictions in 8th equation!')
	end
	Ri(1:nrestrs,:,indxeqn) = blags;
end


for n=1:nvar   %  initializing loop for each equation
   Ui{n} = null(Qi(:,:,n));
   Vi{n} = null(Ri(:,:,n));
   n0(n) = size(Ui{n},2);
   np(n) = size(Vi{n},2);
end


%(2)-------------------------------------------------------------
%  Cross-A0-and-A+ rerestrictions one equation at a time
%    i.e., the first, second, ..., kjth, ..., equation
%  This type of restriction is used for the New-Keysian model studied by Leeper and Zha
%    "Assessing Simple Policy Rules: A View from a Complete Macroeconomic Model" published
%    by St. Louis Fed Review.
%(2)-------------------------------------------------------------
%
if indxC0Pres
   neq_cres = 3;   % the number of equations in which cross-A0-A+ restrictions occur.
   ixmC0Pres = cell(neq_cres,1);  % in each cell representing equation, we have 4 columns:
           % 1st: the jth column (equation) of A+ or A0: f_j or a_j
           % 2nd: the ith element f_j(i) -- the ith element in the jth column of A+
           % 3rd: the hth element a_j(h) -- the hth element in the jth column of A0
           % 4th: the number s such that f_j(i) = s * a_j(h) holds.
   %** 1st equation
   ixmC0Pres{1} = [1 2 2 1
                   1 7 1 1];
   %** 2nd equation
   ixmC0Pres{2} = [2 2 2 2];
   %** 3rd equation
   ixmC0Pres{3} = [3 7 1 1
                   3 2 2 1];


%         % 4 columns.
%   ncres = 5;  % manually key in the number of cross-A0-A+ restrictions

%           % 1st: the jth column (equation) of A+ or A0: f_j or a_j
%           % 2nd: the ith element f_j(i) -- the ith element in the jth column of A+
%           % 3rd: the hth element a_j(h) -- the hth element in the jth column of A0
%           % 4th: the number s such that f_j(i) = s * a_j(h) holds.
else
   ixmC0Pres = NaN;
end

