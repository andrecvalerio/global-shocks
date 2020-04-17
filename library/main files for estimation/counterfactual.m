for c = 1:4
        which_country = c;
        model = 'ftd_cholesky';
        %m=1;

        msstart_setup
        msprob
        msprobg
        close all

        Bhat(1:3,4)   = 0; % 33x8
        Bhat(9:11,4) = 0;
        Bhat(17:19,4) = 0;
        Bhat(25:27,4) = 0;

        A0hat(1:3,4)  = 0; % 8x8
        
        swish = inv(A0hat);
        nn = [nvar lags 16];
        imfhat2 = fn_impulse(Bhat,swish,nn);

        % Index position of PCOM
        id_p = find(varlist == "PCOM");

        % Obtaining factors that will imply a 10% increase in commodities prices
        f_wgdp = 0.1/imfhat2(1,id_p);
        f_vix = 0.1/imfhat2(1,id_p+nvar);
        f_pcom = 0.1/imfhat2(1,id_p+nvar*2);

        % Obtaining the response and confidence intervals estimates
        % imfhat, imferrl1, imferrh1 are a [h x (nvar x nvar)] matrix, where h is
        % the forecast horizon and nvar is the number of variables in the system
        % imfhat -> contains the response to the shock
        % imferrl1 -> contains the lower estimate of the confidence interval
        % imferrh1 -> contains the upper estimate of the confidence interval
        imf_adj = imfhat2;     

        % Multiplying those matrix by the factors obtained before
        imf_adj(:,1:nvar) = imfhat2(:,1:nvar).*f_wgdp;
        imf_adj(:,nvar+1:nvar*2) = imfhat2(:,nvar+1:nvar*2).*f_vix;
        imf_adj(:,nvar*2+1:nvar*3) = imfhat2(:,nvar*2+1:nvar*3).*f_pcom;

        % Column and row labels for the spreadsheet
        col_header = ['Horizon',repmat(varlist,1,nvar),repmat(strcat(varlist,'_low'),1,nvar),repmat(strcat(varlist,'_up'),1,nvar)];
        row_header = (1:16)';
        
        name = namec(which_country,'_IRF','_m0');
        
        xlswrite(name,imf_adj,'Sheet 1','B2');
        xlswrite(name,col_header,'Sheet 1','A1');
        xlswrite(name,row_header,'Sheet 1','A2');
        
        fevd
end