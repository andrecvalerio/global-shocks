imfhat;      %matrix with IRFs
nlinha=ndv;  %number of variables;
nshock=3;    %how many shocks;

%imfhat is matriz of T X (nvar x nvar) dimension
%  - T = number of periods
%  - nvar x nvar - the default is to consider every variable in the system,
%  therefore each variable receive a shock and we observe the response of
%  all variables, hence nvar x nvar.
%  - The first nvar columns of imfhat shows the IRF of each variable in
%  response to a shock in the variable stored in the first column

% Organizing IRFs and CIs to plot
%IRF for shocks 3,4- WGDP, PCOM
which_shock=[3,4,5];  %variables that receive the shock - WGDP, PCOM
name_shock=varlist(which_shock);
new_nvar3=2;

[t,numvar]=size(imfhat);
irf=zeros(t,nvar,nshock);
for n=1:length(which_shock)
irf(:,:,n)=imfhat(:,(nvar*(which_shock(n)-1)+1):(nvar*which_shock(n)));
end

irf(:,:,1) = irf(:,:,1).*(2.21);
irf(:,:,2) = irf(:,:,2).*(1.16);

%Lower CI for shocks 1 and 2 and at 68% and 90%
irf_low68=zeros(t,nvar,nshock);
for n=1:length(which_shock)
irf_low68(:,:,n)=imferrl1(:,(nvar*(which_shock(n)-1)+1):(nvar*which_shock(n)));
end

irf_low90=zeros(t,nvar,nshock);
for n=1:length(which_shock)
irf_low90(:,:,n)=imferrl1(:,(nvar*(which_shock(n)-1)+1):(nvar*which_shock(n)));
end

irf_up68=zeros(t,nvar,nshock);
for n=1:length(which_shock)
irf_up68(:,:,n)=imferrh1(:,(nvar*(which_shock(n)-1)+1):(nvar*which_shock(n)));
end

irf_up90=zeros(t,nvar,nshock);
for n=1:length(which_shock)
irf_up90(:,:,n)=imferrh(:,(nvar*(which_shock(n)-1)+1):(nvar*which_shock(n)));
end

irf_low68(:,:,1) = irf_low68(:,:,1).*(2.21);
irf_low68(:,:,2) = irf_low68(:,:,2).*(1.16);

irf_up68(:,:,1) = irf_up68(:,:,1).*(2.21);
irf_up68(:,:,2) = irf_up68(:,:,2).*(1.16);
 
zero=0*(1:imstp);
ncoluna=nshock;
figure('Name','Impulse Response Function and 68% C.Interval');
 %subplot(nvar,ncoluna,1);
I=1:nshock;
 for j=3:4;     % Ploting variables -> WGDP and Commodidites
     for n=1:nshock
         subplot(new_nvar3,ncoluna,I(n));
         plot (1:imstp,zero,'k-',1:imstp,irf(:,j,n),'k-',1:imstp,irf_low68(:,j,n),'k:',1:imstp,irf_up68(:,j,n),'k:');
         ymax=max(0,1.20*max(irf_up68(:,j,n)));
         ymin=min(0,1.20*min(irf_low68(:,j,n)));
         if ymax==0;
             ymax=0.005;
         end
         if ymin==0;
             ymin=-0.005;
         end
         axis([-inf,imstp,ymin,ymax]);
         if n==1
             ylabel(ylab(j));
         end
         if j==3
             title(name_shock(n));
         end
         set(gca,'FontSize',7);
     end
     I=I+nshock;
 end

if which_country == 1       % saving for Brazil
    saveas(gcf,'irf_intl_br_m5','jpg');
elseif which_country == 2   %saving for Chile
    saveas(gcf,'irf_intl_ch_m5','jpg');
elseif which_country == 3   %saving for Colombia
    saveas(gcf,'irf_intl_col_m5','jpg');
elseif which_country == 5   %saving for Mexico
    saveas(gcf,'irf_intl_mex_m5','jpg');
elseif which_country == 4   %saving for Peru
    saveas(gcf,'irf_intl_per_m5','jpg');
end

wgdp_shock = irf(:,:,1);
pcom_shock = irf(:,:,2);
cr_shock   = irf(:,:,3);

wgdp_low68 = irf_low68(:,:,1);
pcom_low68 = irf_low68(:,:,2);
cr_low68   = irf_low68(:,:,3);

wgdp_up68 = irf_up68(:,:,1);
pcom_up68 = irf_up68(:,:,2);
cr_up68   = irf_up68(:,:,3);

col_header = ['Horizon', varlist];
row_header = (1:16)';

if which_country == 1
    
    xlswrite('IRF_br_wgdp_m5',wgdp_shock,'Sheet 1','B2');
    xlswrite('IRF_br_wgdp_m5',col_header,'Sheet 1','A1');
    xlswrite('IRF_br_wgdp_m5',row_header,'Sheet 1','A2');
    xlswrite('IRF_br_wgdp_low_m5',wgdp_low68,'Sheet 1','B2');
    xlswrite('IRF_br_wgdp_low_m5',col_header,'Sheet 1','A1');
    xlswrite('IRF_br_wgdp_low_m5',row_header,'Sheet 1','A2');
    xlswrite('IRF_br_wgdp_up_m5',wgdp_up68,'Sheet 1','B2');
    xlswrite('IRF_br_wgdp_up_m5',col_header,'Sheet 1','A1');
    xlswrite('IRF_br_wgdp_up_m5',row_header,'Sheet 1','A2');

    xlswrite('IRF_br_pcom_m5',pcom_shock,'Sheet 1','B2');
    xlswrite('IRF_br_pcom_m5',col_header,'Sheet 1','A1');
    xlswrite('IRF_br_pcom_m5',row_header,'Sheet 1','A2');
    xlswrite('IRF_br_pcom_low_m5',pcom_low68,'Sheet 1','B2');
    xlswrite('IRF_br_pcom_low_m5',col_header,'Sheet 1','A1');
    xlswrite('IRF_br_pcom_low_m5',row_header,'Sheet 1','A2');
    xlswrite('IRF_br_pcom_up_m5',pcom_up68,'Sheet 1','B2');
    xlswrite('IRF_br_pcom_up_m5',col_header,'Sheet 1','A1');
    xlswrite('IRF_br_pcom_up_m5',row_header,'Sheet 1','A2');

    xlswrite('IRF_br_cr_m5',cr_shock,'Sheet 1','B2');
    xlswrite('IRF_br_cr_m5',col_header,'Sheet 1','A1');
    xlswrite('IRF_br_cr_m5',row_header,'Sheet 1','A2');
    xlswrite('IRF_br_cr_low_m5',cr_low68,'Sheet 1','B2');
    xlswrite('IRF_br_cr_low_m5',col_header,'Sheet 1','A1');
    xlswrite('IRF_br_cr_low_m5',row_header,'Sheet 1','A2');
    xlswrite('IRF_br_cr_up_m5',cr_up68,'Sheet 1','B2');
    xlswrite('IRF_br_cr_up_m5',col_header,'Sheet 1','A1');
    xlswrite('IRF_br_cr_up_m5',row_header,'Sheet 1','A2');
    
elseif which_country == 2
    
    xlswrite('IRF_ch_wgdp_m5',wgdp_shock,'Sheet 1','B2');
    xlswrite('IRF_ch_wgdp_m5',col_header,'Sheet 1','A1');
    xlswrite('IRF_ch_wgdp_m5',row_header,'Sheet 1','A2');
    xlswrite('IRF_ch_wgdp_low_m5',wgdp_low68,'Sheet 1','B2');
    xlswrite('IRF_ch_wgdp_low_m5',col_header,'Sheet 1','A1');
    xlswrite('IRF_ch_wgdp_low_m5',row_header,'Sheet 1','A2');
    xlswrite('IRF_ch_wgdp_up_m5',wgdp_up68,'Sheet 1','B2');
    xlswrite('IRF_ch_wgdp_up_m5',col_header,'Sheet 1','A1');
    xlswrite('IRF_ch_wgdp_up_m5',row_header,'Sheet 1','A2');

    xlswrite('IRF_ch_pcom_m5',pcom_shock,'Sheet 1','B2');
    xlswrite('IRF_ch_pcom_m5',col_header,'Sheet 1','A1');
    xlswrite('IRF_ch_pcom_m5',row_header,'Sheet 1','A2');
    xlswrite('IRF_ch_pcom_low_m5',pcom_low68,'Sheet 1','B2');
    xlswrite('IRF_ch_pcom_low_m5',col_header,'Sheet 1','A1');
    xlswrite('IRF_ch_pcom_low_m5',row_header,'Sheet 1','A2');
    xlswrite('IRF_ch_pcom_up_m5',pcom_up68,'Sheet 1','B2');
    xlswrite('IRF_ch_pcom_up_m5',col_header,'Sheet 1','A1');
    xlswrite('IRF_ch_pcom_up_m5',row_header,'Sheet 1','A2');

    xlswrite('IRF_ch_cr_m5',cr_shock,'Sheet 1','B2');
    xlswrite('IRF_ch_cr_m5',col_header,'Sheet 1','A1');
    xlswrite('IRF_ch_cr_m5',row_header,'Sheet 1','A2');
    xlswrite('IRF_ch_cr_low_m5',cr_low68,'Sheet 1','B2');
    xlswrite('IRF_ch_cr_low_m5',col_header,'Sheet 1','A1');
    xlswrite('IRF_ch_cr_low_m5',row_header,'Sheet 1','A2');
    xlswrite('IRF_ch_cr_up_m5',cr_up68,'Sheet 1','B2');
    xlswrite('IRF_ch_cr_up_m5',col_header,'Sheet 1','A1');
    xlswrite('IRF_ch_cr_up_m5',row_header,'Sheet 1','A2');
    
elseif which_country == 3
    
    xlswrite('IRF_col_wgdp_m5',wgdp_shock,'Sheet 1','B2');
    xlswrite('IRF_col_wgdp_m5',col_header,'Sheet 1','A1');
    xlswrite('IRF_col_wgdp_m5',row_header,'Sheet 1','A2');
    xlswrite('IRF_col_wgdp_low_m5',wgdp_low68,'Sheet 1','B2');
    xlswrite('IRF_col_wgdp_low_m5',col_header,'Sheet 1','A1');
    xlswrite('IRF_col_wgdp_low_m5',row_header,'Sheet 1','A2');
    xlswrite('IRF_col_wgdp_up_m5',wgdp_up68,'Sheet 1','B2');
    xlswrite('IRF_col_wgdp_up_m5',col_header,'Sheet 1','A1');
    xlswrite('IRF_col_wgdp_up_m5',row_header,'Sheet 1','A2');

    xlswrite('IRF_col_pcom_m5',pcom_shock,'Sheet 1','B2');
    xlswrite('IRF_col_pcom_m5',col_header,'Sheet 1','A1');
    xlswrite('IRF_col_pcom_m5',row_header,'Sheet 1','A2');
    xlswrite('IRF_col_pcom_low_m5',pcom_low68,'Sheet 1','B2');
    xlswrite('IRF_col_pcom_low_m5',col_header,'Sheet 1','A1');
    xlswrite('IRF_col_pcom_low_m5',row_header,'Sheet 1','A2');
    xlswrite('IRF_col_pcom_up_m5',pcom_up68,'Sheet 1','B2');
    xlswrite('IRF_col_pcom_up_m5',col_header,'Sheet 1','A1');
    xlswrite('IRF_col_pcom_up_m5',row_header,'Sheet 1','A2');

    xlswrite('IRF_col_cr_m5',cr_shock,'Sheet 1','B2');
    xlswrite('IRF_col_cr_m5',col_header,'Sheet 1','A1');
    xlswrite('IRF_col_cr_m5',row_header,'Sheet 1','A2');
    xlswrite('IRF_col_cr_low_m5',cr_low68,'Sheet 1','B2');
    xlswrite('IRF_col_cr_low_m5',col_header,'Sheet 1','A1');
    xlswrite('IRF_col_cr_low_m5',row_header,'Sheet 1','A2');
    xlswrite('IRF_col_cr_up_m5',cr_up68,'Sheet 1','B2');
    xlswrite('IRF_col_cr_up_m5',col_header,'Sheet 1','A1');
    xlswrite('IRF_col_cr_up_m5',row_header,'Sheet 1','A2');
    
elseif which_country == 4
    
    xlswrite('IRF_per_wgdp_m5',wgdp_shock,'Sheet 1','B2');
    xlswrite('IRF_per_wgdp_m5',col_header,'Sheet 1','A1');
    xlswrite('IRF_per_wgdp_m5',row_header,'Sheet 1','A2');
    xlswrite('IRF_per_wgdp_low_m5',wgdp_low68,'Sheet 1','B2');
    xlswrite('IRF_per_wgdp_low_m5',col_header,'Sheet 1','A1');
    xlswrite('IRF_per_wgdp_low_m5',row_header,'Sheet 1','A2');
    xlswrite('IRF_per_wgdp_up_m5',wgdp_up68,'Sheet 1','B2');
    xlswrite('IRF_per_wgdp_up_m5',col_header,'Sheet 1','A1');
    xlswrite('IRF_per_wgdp_up_m5',row_header,'Sheet 1','A2');

    xlswrite('IRF_per_pcom_m5',pcom_shock,'Sheet 1','B2');
    xlswrite('IRF_per_pcom_m5',col_header,'Sheet 1','A1');
    xlswrite('IRF_per_pcom_m5',row_header,'Sheet 1','A2');
    xlswrite('IRF_per_pcom_low_m5',pcom_low68,'Sheet 1','B2');
    xlswrite('IRF_per_pcom_low_m5',col_header,'Sheet 1','A1');
    xlswrite('IRF_per_pcom_low_m5',row_header,'Sheet 1','A2');
    xlswrite('IRF_per_pcom_up_m5',pcom_up68,'Sheet 1','B2');
    xlswrite('IRF_per_pcom_up_m5',col_header,'Sheet 1','A1');
    xlswrite('IRF_per_pcom_up_m5',row_header,'Sheet 1','A2');

    xlswrite('IRF_per_cr_m5',cr_shock,'Sheet 1','B2');
    xlswrite('IRF_per_cr_m5',col_header,'Sheet 1','A1');
    xlswrite('IRF_per_cr_m5',row_header,'Sheet 1','A2');
    xlswrite('IRF_per_cr_low_m5',cr_low68,'Sheet 1','B2');
    xlswrite('IRF_per_cr_low_m5',col_header,'Sheet 1','A1');
    xlswrite('IRF_per_cr_low_m5',row_header,'Sheet 1','A2');
    xlswrite('IRF_per_cr_up_m5',cr_up68,'Sheet 1','B2');
    xlswrite('IRF_per_cr_up_m5',col_header,'Sheet 1','A1');
    xlswrite('IRF_per_cr_up_m5',row_header,'Sheet 1','A2');

end