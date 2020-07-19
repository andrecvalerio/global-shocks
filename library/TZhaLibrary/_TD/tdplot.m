function [] = tdplot(res);
% PURPOSE: Graphic output of temporal disaggregation methods
% ------------------------------------------------------------
% SYNTAX: tdlot(res) 
% ------------------------------------------------------------
% OUTPUT: Graphic output
% ------------------------------------------------------------
% INPUT: res: structure generated by td programs
% ------------------------------------------------------------
% LIBRARY: tduni_plot, td_plot, mtd_plot
% ------------------------------------------------------------
% SEE ALSO: 

% written by:
%  Enrique M. Quilis
%  Macroeconomic Research Department
%  Ministry of Economy and Finance
%  Paseo de la Castellana, 162. Office 2.5-1.
%  28046 - Madrid (SPAIN)
%  <enrique.quilis@meh.es>

% Version 1.1 [August 2006]

if (nargin == 1)
    switch res.meth
        case {'Boot-Feibes-Lisman','Denton','Stram-Wei'}
            tduni_plot(res);
        case {'Fernandez','Chow-Lin','Litterman','Santos Silva-Cardoso'}
            td_plot(res);
        case {'Multivariate Denton','Proportional Multivariate Denton', ...
                'Multivariate Di Fonzo','Multivariate Rossi'}
            mtd_plot(res);
    end
else
    switch res.meth
        case {'Boot-Feibes-Lisman','Denton','Stram-Wei'}
            tduni_plot(res,file_sal);
        case {'Fernandez','Chow-Lin','Litterman','Santos Silva-Cardoso'}
            td_plot(res,file_sal);
        case {'Multivariate Denton','Proportional Multivariate Denton', ...
                'Multivariate Di Fonzo','Multivariate Rossi'}
            mtd_plot(res,file_sal);
    end
end
