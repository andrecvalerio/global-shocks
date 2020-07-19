% To facilitate comparison, we standardize the shocks so each one implies
% an increase of 10% in commoditie prices at impact

if m == 1 || m == 2 || m == 9  % Those are the models with all international variables
    % Index position of PCOM
    id_p = find(varlist == "PCOM");
    
    % Obtaining factors that will imply a 10% increase in commodities prices
    f_wgdp = 0.1/imfhat(1,id_p);
    f_vix = 0.1/imfhat(1,id_p+nvar);
    f_pcom = 0.1/imfhat(1,id_p+nvar*2);
    
    % Obtaining the response and confidence intervals estimates
    % imfhat, imferrl1, imferrh1 are a [h x (nvar x nvar)] matrix, where h is
    % the forecast horizon and nvar is the number of variables in the system
    % imfhat -> contains the response to the shock
    % imferrl1 -> contains the lower estimate of the confidence interval
    % imferrh1 -> contains the upper estimate of the confidence interval
    imf_adj = imfhat;
    low_adj = imferrl1;
    up_adj = imferrh1;

    % Multiplying those matrix by the factors obtained before
    imf_adj(:,1:nvar) = imfhat(:,1:nvar).*f_wgdp;
    imf_adj(:,nvar+1:nvar*2) = imfhat(:,nvar+1:nvar*2).*f_vix;
    imf_adj(:,nvar*2+1:nvar*3) = imfhat(:,nvar*2+1:nvar*3).*f_pcom;

    low_adj(:,1:nvar) = imferrl1(:,1:nvar).*f_wgdp;
    low_adj(:,nvar*2+1:nvar*3) = imferrl1(:,nvar*2+1:nvar*3).*f_pcom;

    up_adj(:,1:nvar) = imferrh1(:,1:nvar).*f_wgdp;
    up_adj(:,nvar*2+1:nvar*3) = imferrh1(:,nvar*2+1:nvar*3).*f_pcom;

    % Sometimes, the VIX shock is negative. Here I make sure to invert the
    % upper and lower estimates of the CI in case the shock was negative
    if f_vix < 0 
       low_adj(:,nvar+1:nvar*2) = imferrh1(:,nvar+1:nvar*2).*f_vix; 
       up_adj(:,nvar+1:nvar*2) = imferrl1(:,nvar+1:nvar*2).*f_vix;
    else
        low_adj(:,nvar+1:nvar*2) = imferrl1(:,nvar+1:nvar*2).*f_vix;
        up_adj(:,nvar+1:nvar*2) = imferrh1(:,nvar+1:nvar*2).*f_vix;
    end

    % creating matrix with impulse response functions and lower and upper 
    % bounds for confidence interval of 68%
    irf_mat = [imf_adj, low_adj, up_adj]; 
    
elseif m == 3 % Model with only WGDP & PCOM in the international side
    % Index position of PCOM
    id_p = find(varlist == "PCOM");
    
    % Obtaining factors that will imply a 10% increase in commodities prices
    f_wgdp = 0.1/imfhat(1,id_p);
    f_pcom = 0.1/imfhat(1,id_p+nvar);
    
    % Obtaining the response and confidence intervals estimates
    % imfhat, imferrl1, imferrh1 are a [h x (nvar x nvar)] matrix, where h is
    % the forecast horizon and nvar is the number of variables in the system
    % imfhat -> contains the response to the shock
    % imferrl1 -> contains the lower estimate of the confidence interval
    % imferrh1 -> contains the upper estimate of the confidence interval
    imf_adj = imfhat;
    low_adj = imferrl1;
    up_adj = imferrh1;

    % Multiplying those matrix by the factors obtained before
    imf_adj(:,1:nvar) = imfhat(:,1:nvar).*f_wgdp;
    imf_adj(:,nvar+1:nvar*2) = imfhat(:,nvar+1:nvar*2).*f_pcom;
    
    low_adj(:,1:nvar) = imferrl1(:,1:nvar).*f_wgdp;
    low_adj(:,nvar+1:nvar*2) = imferrl1(:,nvar+1:nvar*2).*f_pcom;

    up_adj(:,1:nvar) = imferrh1(:,1:nvar).*f_wgdp;
    up_adj(:,nvar+1:nvar*2) = imferrh1(:,nvar+1:nvar*2).*f_pcom;
    
    % creating matrix with impulse response functions and lower and upper 
    % bounds for confidence interval of 68%
    irf_mat = [imf_adj, low_adj, up_adj]; 
    
elseif m == 4 % Model with only PCOM in the international side
    % Index position of PCOM
    id_p = find(varlist == "PCOM");
    
    % Obtaining factors that will imply a 10% increase in commodities prices
    f_pcom = 0.1/imfhat(1,id_p);
    
    % Obtaining the response and confidence intervals estimates
    % imfhat, imferrl1, imferrh1 are a [h x (nvar x nvar)] matrix, where h is
    % the forecast horizon and nvar is the number of variables in the system
    % imfhat -> contains the response to the shock
    % imferrl1 -> contains the lower estimate of the confidence interval
    % imferrh1 -> contains the upper estimate of the confidence interval
    imf_adj = imfhat;
    low_adj = imferrl1;
    up_adj = imferrh1;

    % Multiplying those matrix by the factors obtained before
    imf_adj(:,1:nvar) = imfhat(:,1:nvar).*f_pcom;
    low_adj(:,1:nvar) = imferrl1(:,1:nvar).*f_pcom;
    up_adj(:,1:nvar) = imferrh1(:,1:nvar).*f_pcom;
    
    % creating matrix with impulse response functions and lower and upper 
    % bounds for confidence interval of 68%
    irf_mat = [imf_adj, low_adj, up_adj]; 
    
elseif m == 6 % Model with only VIX + PCOM in the international side
    % Index position of PCOM
    id_p = find(varlist == "PCOM");
    
    % Obtaining factors that will imply a 10% increase in commodities prices
    f_vix  = 0.1/imfhat(1,id_p);
    f_pcom = 0.1/imfhat(1,id_p+nvar);
    
    % Obtaining the response and confidence intervals estimates
    % imfhat, imferrl1, imferrh1 are a [h x (nvar x nvar)] matrix, where h is
    % the forecast horizon and nvar is the number of variables in the system
    % imfhat -> contains the response to the shock
    % imferrl1 -> contains the lower estimate of the confidence interval
    % imferrh1 -> contains the upper estimate of the confidence interval
    imf_adj = imfhat;
    low_adj = imferrl1;
    up_adj = imferrh1;

    % Multiplying those matrix by the factors obtained before
    imf_adj(:,1:nvar) = imfhat(:,1:nvar).*f_vix;
    imf_adj(:,nvar+1:nvar*2) = imfhat(:,nvar+1:nvar*2).*f_pcom;
    low_adj(:,nvar+1:nvar*2) = imferrl1(:,nvar+1:nvar*2).*f_pcom;
    up_adj(:,nvar+1:nvar*2) = imferrh1(:,nvar+1:nvar*2).*f_pcom;
    
    % Sometimes, the VIX shock is negative. Here I make sure to invert the
    % upper and lower estimates of the CI in case the shock was negative
    if f_vix < 0 
       low_adj(:,1:nvar) = imferrh1(:,1:nvar).*f_vix; 
       up_adj(:,1:nvar) = imferrl1(:,1:nvar).*f_vix;
    else
        low_adj(:,1:nvar) = imferrl1(:,1:nvar).*f_vix;
        up_adj(:,1:nvar) = imferrh1(:,1:nvar).*f_vix;
    end
    
    % creating matrix with impulse response functions and lower and upper 
    % bounds for confidence interval of 68%
    irf_mat = [imf_adj, low_adj, up_adj]; 

else % For cases where PCOM is not part of the model, there is no need to adjust the shocks
    
    irf_mat = [imfhat, imferrl1, imferrh1];
    
end

% Column and row labels for the spreadsheet
col_header = ['Horizon',repmat(varlist,1,nvar),repmat(strcat(varlist,'_low'),1,nvar),repmat(strcat(varlist,'_up'),1,nvar)];
row_header = (1:16)';

% saving irfs according to which model and which country is being estimated
name = namec(which_country,'_IRF_m',string(m));

xlswrite(name,irf_mat,'Sheet 1','B2');
xlswrite(name,col_header,'Sheet 1','A1');
xlswrite(name,row_header,'Sheet 1','A2');

% if m == 1
%     if which_country == 1
%         xlswrite('IRF_br',irf_mat,'Sheet 1','B2');
%         xlswrite('IRF_br',col_header,'Sheet 1','A1');
%         xlswrite('IRF_br',row_header,'Sheet 1','A2');
%     elseif which_country == 2
%         xlswrite('IRF_ch',irf_mat,'Sheet 1','B2');
%         xlswrite('IRF_ch',col_header,'Sheet 1','A1');
%         xlswrite('IRF_ch',row_header,'Sheet 1','A2');
%     elseif which_country == 3
%         xlswrite('IRF_col',irf_mat,'Sheet 1','B2');
%         xlswrite('IRF_col',col_header,'Sheet 1','A1');
%         xlswrite('IRF_col',row_header,'Sheet 1','A2');
%     else 
%         xlswrite('IRF_per',irf_mat,'Sheet 1','B2');
%         xlswrite('IRF_per',col_header,'Sheet 1','A1');
%         xlswrite('IRF_per',row_header,'Sheet 1','A2');
%     end
% elseif m == 2
%     if which_country == 1
%         xlswrite('IRF_m2_br',irf_mat,'Sheet 1','B2');
%         xlswrite('IRF_m2_br',col_header,'Sheet 1','A1');
%         xlswrite('IRF_m2_br',row_header,'Sheet 1','A2');
%     elseif which_country == 2
%         xlswrite('IRF_m2_ch',irf_mat,'Sheet 1','B2');
%         xlswrite('IRF_m2_ch',col_header,'Sheet 1','A1');
%         xlswrite('IRF_m2_ch',row_header,'Sheet 1','A2');
%     elseif which_country == 3
%         xlswrite('IRF_m2_col',irf_mat,'Sheet 1','B2');
%         xlswrite('IRF_m2_col',col_header,'Sheet 1','A1');
%         xlswrite('IRF_m2_col',row_header,'Sheet 1','A2');
%     else 
%         xlswrite('IRF_m2_per',irf_mat,'Sheet 1','B2');
%         xlswrite('IRF_m2_per',col_header,'Sheet 1','A1');
%         xlswrite('IRF_m2_per',row_header,'Sheet 1','A2');
%     end
% elseif m == 3
%     if which_country == 1
%         xlswrite('IRF_m3_br',irf_mat,'Sheet 1','B2');
%         xlswrite('IRF_m3_br',col_header,'Sheet 1','A1');
%         xlswrite('IRF_m3_br',row_header,'Sheet 1','A2');
%     elseif which_country == 2
%         xlswrite('IRF_m3_ch',irf_mat,'Sheet 1','B2');
%         xlswrite('IRF_m3_ch',col_header,'Sheet 1','A1');
%         xlswrite('IRF_m3_ch',row_header,'Sheet 1','A2');
%     elseif which_country == 3
%         xlswrite('IRF_m3_col',irf_mat,'Sheet 1','B2');
%         xlswrite('IRF_m3_col',col_header,'Sheet 1','A1');
%         xlswrite('IRF_m3_col',row_header,'Sheet 1','A2');
%     else 
%         xlswrite('IRF_m3_per',irf_mat,'Sheet 1','B2');
%         xlswrite('IRF_m3_per',col_header,'Sheet 1','A1');
%         xlswrite('IRF_m3_per',row_header,'Sheet 1','A2');
%     end
% elseif m == 4
%     if which_country == 1
%         xlswrite('IRF_m4_br',irf_mat,'Sheet 1','B2');
%         xlswrite('IRF_m4_br',col_header,'Sheet 1','A1');
%         xlswrite('IRF_m4_br',row_header,'Sheet 1','A2');
%     elseif which_country == 2
%         xlswrite('IRF_m4_ch',irf_mat,'Sheet 1','B2');
%         xlswrite('IRF_m4_ch',col_header,'Sheet 1','A1');
%         xlswrite('IRF_m4_ch',row_header,'Sheet 1','A2');
%     elseif which_country == 3
%         xlswrite('IRF_m4_col',irf_mat,'Sheet 1','B2');
%         xlswrite('IRF_m4_col',col_header,'Sheet 1','A1');
%         xlswrite('IRF_m4_col',row_header,'Sheet 1','A2');
%     else 
%         xlswrite('IRF_m4_per',irf_mat,'Sheet 1','B2');
%         xlswrite('IRF_m4_per',col_header,'Sheet 1','A1');
%         xlswrite('IRF_m4_per',row_header,'Sheet 1','A2');
%     end
% elseif m == 5
%     if which_country == 1
%         xlswrite('IRF_m5_br',irf_mat,'Sheet 1','B2');
%         xlswrite('IRF_m5_br',col_header,'Sheet 1','A1');
%         xlswrite('IRF_m5_br',row_header,'Sheet 1','A2');
%     elseif which_country == 2
%         xlswrite('IRF_m5_ch',irf_mat,'Sheet 1','B2');
%         xlswrite('IRF_m5_ch',col_header,'Sheet 1','A1');
%         xlswrite('IRF_m5_ch',row_header,'Sheet 1','A2');
%     elseif which_country == 3
%         xlswrite('IRF_m5_col',irf_mat,'Sheet 1','B2');
%         xlswrite('IRF_m5_col',col_header,'Sheet 1','A1');
%         xlswrite('IRF_m5_col',row_header,'Sheet 1','A2');
%     else 
%         xlswrite('IRF_m5_per',irf_mat,'Sheet 1','B2');
%         xlswrite('IRF_m5_per',col_header,'Sheet 1','A1');
%         xlswrite('IRF_m5_per',row_header,'Sheet 1','A2');
%     end
% elseif m == 6
%     if which_country == 1
%         xlswrite('IRF_m6_br',irf_mat,'Sheet 1','B2');
%         xlswrite('IRF_m6_br',col_header,'Sheet 1','A1');
%         xlswrite('IRF_m6_br',row_header,'Sheet 1','A2');
%     elseif which_country == 2
%         xlswrite('IRF_m6_ch',irf_mat,'Sheet 1','B2');
%         xlswrite('IRF_m6_ch',col_header,'Sheet 1','A1');
%         xlswrite('IRF_m6_ch',row_header,'Sheet 1','A2');
%     elseif which_country == 3
%         xlswrite('IRF_m6_col',irf_mat,'Sheet 1','B2');
%         xlswrite('IRF_m6_col',col_header,'Sheet 1','A1');
%         xlswrite('IRF_m6_col',row_header,'Sheet 1','A2');
%     else 
%         xlswrite('IRF_m6_per',irf_mat,'Sheet 1','B2');
%         xlswrite('IRF_m6_per',col_header,'Sheet 1','A1');
%         xlswrite('IRF_m6_per',row_header,'Sheet 1','A2');
%     end
% elseif m == 7
%     if which_country == 1
%         xlswrite('IRF_m7_br',irf_mat,'Sheet 1','B2');
%         xlswrite('IRF_m7_br',col_header,'Sheet 1','A1');
%         xlswrite('IRF_m7_br',row_header,'Sheet 1','A2');
%     elseif which_country == 2
%         xlswrite('IRF_m7_ch',irf_mat,'Sheet 1','B2');
%         xlswrite('IRF_m7_ch',col_header,'Sheet 1','A1');
%         xlswrite('IRF_m7_ch',row_header,'Sheet 1','A2');
%     elseif which_country == 3
%         xlswrite('IRF_m7_col',irf_mat,'Sheet 1','B2');
%         xlswrite('IRF_m7_col',col_header,'Sheet 1','A1');
%         xlswrite('IRF_m7_col',row_header,'Sheet 1','A2');
%     else 
%         xlswrite('IRF_m7_per',irf_mat,'Sheet 1','B2');
%         xlswrite('IRF_m7_per',col_header,'Sheet 1','A1');
%         xlswrite('IRF_m7_per',row_header,'Sheet 1','A2');
%     end
% elseif m == 8
%     if which_country == 1
%         xlswrite('IRF_m8_br',irf_mat,'Sheet 1','B2');
%         xlswrite('IRF_m8_br',col_header,'Sheet 1','A1');
%         xlswrite('IRF_m8_br',row_header,'Sheet 1','A2');
%     elseif which_country == 2
%         xlswrite('IRF_m8_ch',irf_mat,'Sheet 1','B2');
%         xlswrite('IRF_m8_ch',col_header,'Sheet 1','A1');
%         xlswrite('IRF_m8_ch',row_header,'Sheet 1','A2');
%     elseif which_country == 3
%         xlswrite('IRF_m8_col',irf_mat,'Sheet 1','B2');
%         xlswrite('IRF_m8_col',col_header,'Sheet 1','A1');
%         xlswrite('IRF_m8_col',row_header,'Sheet 1','A2');
%     else 
%         xlswrite('IRF_m8_per',irf_mat,'Sheet 1','B2');
%         xlswrite('IRF_m8_per',col_header,'Sheet 1','A1');
%         xlswrite('IRF_m8_per',row_header,'Sheet 1','A2');
%     end
% elseif m == 9
%     if which_country == 1
%         xlswrite('IRF_m9_br',irf_mat,'Sheet 1','B2');
%         xlswrite('IRF_m9_br',col_header,'Sheet 1','A1');
%         xlswrite('IRF_m9_br',row_header,'Sheet 1','A2');
%     elseif which_country == 2
%         xlswrite('IRF_m9_ch',irf_mat,'Sheet 1','B2');
%         xlswrite('IRF_m9_ch',col_header,'Sheet 1','A1');
%         xlswrite('IRF_m9_ch',row_header,'Sheet 1','A2');
%     elseif which_country == 3
%         xlswrite('IRF_m9_col',irf_mat,'Sheet 1','B2');
%         xlswrite('IRF_m9_col',col_header,'Sheet 1','A1');
%         xlswrite('IRF_m9_col',row_header,'Sheet 1','A2');
%     else 
%         xlswrite('IRF_m9_per',irf_mat,'Sheet 1','B2');
%         xlswrite('IRF_m9_per',col_header,'Sheet 1','A1');
%         xlswrite('IRF_m9_per',row_header,'Sheet 1','A2');
%     end
% end
