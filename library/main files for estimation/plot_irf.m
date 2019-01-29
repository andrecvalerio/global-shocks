imfhat;      %matrix with IRFs
nlinha=ndv;  %number of variables;
nshock=4;    %how many shocks;

%imfhat is matriz of T X (nvar x nvar) dimension
%  - T = number of periods
%  - nvar x nvar - the default is to consider every variable in the system,
%  therefore each variable receive a shock and we observe the response of
%  all variables, hence nvar x nvar.
%  - The first nvar columns of imfhat shows the IRF of each variable in
%  response to a shock in the variable stored in the first column

% Organizing IRFs and CIs to plot
%IRF for shocks 3,4- WGDP, VIX, PCOM
which_shock=[3,4,5,6];  %variables that receive the shock - WGDP, VIX, PCOM
name_shock=varlist(which_shock);
new_nvar3=3; % number of line for plot

[t,numvar]=size(imfhat);
irf=zeros(t,nvar,nshock);
for n=1:length(which_shock)
irf(:,:,n)=imfhat(:,(nvar*(which_shock(n)-1)+1):(nvar*which_shock(n)));
end

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
   
irf_adj   = irf;
adj_low68 = irf_low68;
adj_up68  = irf_up68;

irf_adj(:,:,1) = irf(:,:,1);%.*(2.186557);
irf_adj(:,:,3) = irf(:,:,3);%.*(1.326154);

adj_low68(:,:,1) = irf_low68(:,:,1);%.*(2.186557);
adj_low68(:,:,3) = irf_low68(:,:,3);%.*(1.326154);

adj_up68(:,:,1) = irf_up68(:,:,1);%.*(2.186557);
adj_up68(:,:,3) = irf_up68(:,:,3);%.*(1.326154);

irf_adj(:,:,2)   = irf(:,:,2);%.*(-2.818251);
adj_low68(:,:,2) = irf_low68(:,:,2);%irf_up68(:,:,2).*(-2.818251);
adj_up68(:,:,2)  = irf_up68(:,:,2);%irf_low68(:,:,2).*(-2.818251);

% if which_country == 1
%     irf_adj(:,:,2)   = irf(:,:,2).*(2.818251);
%     adj_low68(:,:,2) = irf_low68(:,:,2).*(2.818251);
%     adj_up68(:,:,2)  = irf_up68(:,:,2).*(2.818251);
% else
%     irf_adj(:,:,2)   = irf(:,:,2).*(-2.818251);
%     adj_low68(:,:,2) = irf_up68(:,:,2).*(-2.818251);
%     adj_up68(:,:,2)  = irf_low68(:,:,2).*(-2.818251);
% end


zero=0*(1:imstp);
ncoluna=nshock;
figure('Name','Impulse Response Function and 68% C.Interval');
 %subplot(nvar,ncoluna,1);
I=1:nshock;
 for j=3:5;     % Ploting variables -> WGDP and Commodidites
     for n=1:nshock
         subplot(new_nvar3,ncoluna,I(n));
         plot (1:imstp,zero,'k-',1:imstp,irf_adj(:,j,n),'k-',1:imstp,adj_low68(:,j,n),'k:',1:imstp,adj_up68(:,j,n),'k:');
         ymax=max(0,1.20*max(adj_up68(:,j,n)));
         ymin=min(0,1.20*min(adj_low68(:,j,n)));
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

if which_country == 1       % saving for colazil
    saveas(gcf,'irf_intl_br','jpg');
elseif which_country == 2   %saving for Chile
    saveas(gcf,'irf_intl_ch','jpg');
elseif which_country == 3   %saving for Colombia
    saveas(gcf,'irf_intl_col','jpg');
elseif which_country == 5   %saving for Mexico
    saveas(gcf,'irf_intl_mex','jpg');
elseif which_country == 4   %saving for Peru
    saveas(gcf,'irf_intl_per','jpg');
end

wgdp_shock = irf_adj(:,:,1);
vix_shock  = irf_adj(:,:,2);
pcom_shock = irf_adj(:,:,3);
cr_shock   = irf_adj(:,:,4);

wgdp_low68 = adj_low68(:,:,1);
vix_low68  = adj_low68(:,:,2);
pcom_low68 = adj_low68(:,:,3);
cr_low68   = adj_low68(:,:,4);

wgdp_up68 = adj_up68(:,:,1);
vix_up68  = adj_up68(:,:,2);
pcom_up68 = adj_up68(:,:,3);
cr_up68   = adj_up68(:,:,4);

col_header = ['Horizon', varlist];
row_header = (1:16)';

if which_country == 1
    
    xlswrite('IRF_br_wgdp',wgdp_shock,'Sheet 1','B2');
    xlswrite('IRF_br_wgdp',col_header,'Sheet 1','A1');
    xlswrite('IRF_br_wgdp',row_header,'Sheet 1','A2');
    xlswrite('IRF_br_wgdp_low',wgdp_low68,'Sheet 1','B2');
    xlswrite('IRF_br_wgdp_low',col_header,'Sheet 1','A1');
    xlswrite('IRF_br_wgdp_low',row_header,'Sheet 1','A2');
    xlswrite('IRF_br_wgdp_up',wgdp_up68,'Sheet 1','B2');
    xlswrite('IRF_br_wgdp_up',col_header,'Sheet 1','A1');
    xlswrite('IRF_br_wgdp_up',row_header,'Sheet 1','A2');

    xlswrite('IRF_br_vix',vix_shock,'Sheet 1','B2');
    xlswrite('IRF_br_vix',col_header,'Sheet 1','A1');
    xlswrite('IRF_br_vix',row_header,'Sheet 1','A2');
    xlswrite('IRF_br_vix_low',vix_low68,'Sheet 1','B2');
    xlswrite('IRF_br_vix_low',col_header,'Sheet 1','A1');
    xlswrite('IRF_br_vix_low',row_header,'Sheet 1','A2');
    xlswrite('IRF_br_vix_up',vix_up68,'Sheet 1','B2');
    xlswrite('IRF_br_vix_up',col_header,'Sheet 1','A1');
    xlswrite('IRF_br_vix_up',row_header,'Sheet 1','A2');

    xlswrite('IRF_br_pcom',pcom_shock,'Sheet 1','B2');
    xlswrite('IRF_br_pcom',col_header,'Sheet 1','A1');
    xlswrite('IRF_br_pcom',row_header,'Sheet 1','A2');
    xlswrite('IRF_br_pcom_low',pcom_low68,'Sheet 1','B2');
    xlswrite('IRF_br_pcom_low',col_header,'Sheet 1','A1');
    xlswrite('IRF_br_pcom_low',row_header,'Sheet 1','A2');
    xlswrite('IRF_br_pcom_up',pcom_up68,'Sheet 1','B2');
    xlswrite('IRF_br_pcom_up',col_header,'Sheet 1','A1');
    xlswrite('IRF_br_pcom_up',row_header,'Sheet 1','A2');

    xlswrite('IRF_br_cr',cr_shock,'Sheet 1','B2');
    xlswrite('IRF_br_cr',col_header,'Sheet 1','A1');
    xlswrite('IRF_br_cr',row_header,'Sheet 1','A2');
    xlswrite('IRF_br_cr_low',cr_low68,'Sheet 1','B2');
    xlswrite('IRF_br_cr_low',col_header,'Sheet 1','A1');
    xlswrite('IRF_br_cr_low',row_header,'Sheet 1','A2');
    xlswrite('IRF_br_cr_up',cr_up68,'Sheet 1','B2');
    xlswrite('IRF_br_cr_up',col_header,'Sheet 1','A1');
    xlswrite('IRF_br_cr_up',row_header,'Sheet 1','A2');
    
elseif which_country == 2
    
    xlswrite('IRF_ch_wgdp',wgdp_shock,'Sheet 1','B2');
    xlswrite('IRF_ch_wgdp',col_header,'Sheet 1','A1');
    xlswrite('IRF_ch_wgdp',row_header,'Sheet 1','A2');
    xlswrite('IRF_ch_wgdp_low',wgdp_low68,'Sheet 1','B2');
    xlswrite('IRF_ch_wgdp_low',col_header,'Sheet 1','A1');
    xlswrite('IRF_ch_wgdp_low',row_header,'Sheet 1','A2');
    xlswrite('IRF_ch_wgdp_up',wgdp_up68,'Sheet 1','B2');
    xlswrite('IRF_ch_wgdp_up',col_header,'Sheet 1','A1');
    xlswrite('IRF_ch_wgdp_up',row_header,'Sheet 1','A2');

    xlswrite('IRF_ch_vix',vix_shock,'Sheet 1','B2');
    xlswrite('IRF_ch_vix',col_header,'Sheet 1','A1');
    xlswrite('IRF_ch_vix',row_header,'Sheet 1','A2');
    xlswrite('IRF_ch_vix_low',vix_low68,'Sheet 1','B2');
    xlswrite('IRF_ch_vix_low',col_header,'Sheet 1','A1');
    xlswrite('IRF_ch_vix_low',row_header,'Sheet 1','A2');
    xlswrite('IRF_ch_vix_up',vix_up68,'Sheet 1','B2');
    xlswrite('IRF_ch_vix_up',col_header,'Sheet 1','A1');
    xlswrite('IRF_ch_vix_up',row_header,'Sheet 1','A2');

    xlswrite('IRF_ch_pcom',pcom_shock,'Sheet 1','B2');
    xlswrite('IRF_ch_pcom',col_header,'Sheet 1','A1');
    xlswrite('IRF_ch_pcom',row_header,'Sheet 1','A2');
    xlswrite('IRF_ch_pcom_low',pcom_low68,'Sheet 1','B2');
    xlswrite('IRF_ch_pcom_low',col_header,'Sheet 1','A1');
    xlswrite('IRF_ch_pcom_low',row_header,'Sheet 1','A2');
    xlswrite('IRF_ch_pcom_up',pcom_up68,'Sheet 1','B2');
    xlswrite('IRF_ch_pcom_up',col_header,'Sheet 1','A1');
    xlswrite('IRF_ch_pcom_up',row_header,'Sheet 1','A2');

    xlswrite('IRF_ch_cr',cr_shock,'Sheet 1','B2');
    xlswrite('IRF_ch_cr',col_header,'Sheet 1','A1');
    xlswrite('IRF_ch_cr',row_header,'Sheet 1','A2');
    xlswrite('IRF_ch_cr_low',cr_low68,'Sheet 1','B2');
    xlswrite('IRF_ch_cr_low',col_header,'Sheet 1','A1');
    xlswrite('IRF_ch_cr_low',row_header,'Sheet 1','A2');
    xlswrite('IRF_ch_cr_up',cr_up68,'Sheet 1','B2');
    xlswrite('IRF_ch_cr_up',col_header,'Sheet 1','A1');
    xlswrite('IRF_ch_cr_up',row_header,'Sheet 1','A2');
    
elseif which_country == 3
    
    xlswrite('IRF_col_wgdp',wgdp_shock,'Sheet 1','B2');
    xlswrite('IRF_col_wgdp',col_header,'Sheet 1','A1');
    xlswrite('IRF_col_wgdp',row_header,'Sheet 1','A2');
    xlswrite('IRF_col_wgdp_low',wgdp_low68,'Sheet 1','B2');
    xlswrite('IRF_col_wgdp_low',col_header,'Sheet 1','A1');
    xlswrite('IRF_col_wgdp_low',row_header,'Sheet 1','A2');
    xlswrite('IRF_col_wgdp_up',wgdp_up68,'Sheet 1','B2');
    xlswrite('IRF_col_wgdp_up',col_header,'Sheet 1','A1');
    xlswrite('IRF_col_wgdp_up',row_header,'Sheet 1','A2');

    xlswrite('IRF_col_vix',vix_shock,'Sheet 1','B2');
    xlswrite('IRF_col_vix',col_header,'Sheet 1','A1');
    xlswrite('IRF_col_vix',row_header,'Sheet 1','A2');
    xlswrite('IRF_col_vix_low',vix_low68,'Sheet 1','B2');
    xlswrite('IRF_col_vix_low',col_header,'Sheet 1','A1');
    xlswrite('IRF_col_vix_low',row_header,'Sheet 1','A2');
    xlswrite('IRF_col_vix_up',vix_up68,'Sheet 1','B2');
    xlswrite('IRF_col_vix_up',col_header,'Sheet 1','A1');
    xlswrite('IRF_col_vix_up',row_header,'Sheet 1','A2');

    xlswrite('IRF_col_pcom',pcom_shock,'Sheet 1','B2');
    xlswrite('IRF_col_pcom',col_header,'Sheet 1','A1');
    xlswrite('IRF_col_pcom',row_header,'Sheet 1','A2');
    xlswrite('IRF_col_pcom_low',pcom_low68,'Sheet 1','B2');
    xlswrite('IRF_col_pcom_low',col_header,'Sheet 1','A1');
    xlswrite('IRF_col_pcom_low',row_header,'Sheet 1','A2');
    xlswrite('IRF_col_pcom_up',pcom_up68,'Sheet 1','B2');
    xlswrite('IRF_col_pcom_up',col_header,'Sheet 1','A1');
    xlswrite('IRF_col_pcom_up',row_header,'Sheet 1','A2');

    xlswrite('IRF_col_cr',cr_shock,'Sheet 1','B2');
    xlswrite('IRF_col_cr',col_header,'Sheet 1','A1');
    xlswrite('IRF_col_cr',row_header,'Sheet 1','A2');
    xlswrite('IRF_col_cr_low',cr_low68,'Sheet 1','B2');
    xlswrite('IRF_col_cr_low',col_header,'Sheet 1','A1');
    xlswrite('IRF_col_cr_low',row_header,'Sheet 1','A2');
    xlswrite('IRF_col_cr_up',cr_up68,'Sheet 1','B2');
    xlswrite('IRF_col_cr_up',col_header,'Sheet 1','A1');
    xlswrite('IRF_col_cr_up',row_header,'Sheet 1','A2');
    
elseif which_country == 4
    
    xlswrite('IRF_per_wgdp',wgdp_shock,'Sheet 1','B2');
    xlswrite('IRF_per_wgdp',col_header,'Sheet 1','A1');
    xlswrite('IRF_per_wgdp',row_header,'Sheet 1','A2');
    xlswrite('IRF_per_wgdp_low',wgdp_low68,'Sheet 1','B2');
    xlswrite('IRF_per_wgdp_low',col_header,'Sheet 1','A1');
    xlswrite('IRF_per_wgdp_low',row_header,'Sheet 1','A2');
    xlswrite('IRF_per_wgdp_up',wgdp_up68,'Sheet 1','B2');
    xlswrite('IRF_per_wgdp_up',col_header,'Sheet 1','A1');
    xlswrite('IRF_per_wgdp_up',row_header,'Sheet 1','A2');

    xlswrite('IRF_per_vix',vix_shock,'Sheet 1','B2');
    xlswrite('IRF_per_vix',col_header,'Sheet 1','A1');
    xlswrite('IRF_per_vix',row_header,'Sheet 1','A2');
    xlswrite('IRF_per_vix_low',vix_low68,'Sheet 1','B2');
    xlswrite('IRF_per_vix_low',col_header,'Sheet 1','A1');
    xlswrite('IRF_per_vix_low',row_header,'Sheet 1','A2');
    xlswrite('IRF_per_vix_up',vix_up68,'Sheet 1','B2');
    xlswrite('IRF_per_vix_up',col_header,'Sheet 1','A1');
    xlswrite('IRF_per_vix_up',row_header,'Sheet 1','A2');

    xlswrite('IRF_per_pcom',pcom_shock,'Sheet 1','B2');
    xlswrite('IRF_per_pcom',col_header,'Sheet 1','A1');
    xlswrite('IRF_per_pcom',row_header,'Sheet 1','A2');
    xlswrite('IRF_per_pcom_low',pcom_low68,'Sheet 1','B2');
    xlswrite('IRF_per_pcom_low',col_header,'Sheet 1','A1');
    xlswrite('IRF_per_pcom_low',row_header,'Sheet 1','A2');
    xlswrite('IRF_per_pcom_up',pcom_up68,'Sheet 1','B2');
    xlswrite('IRF_per_pcom_up',col_header,'Sheet 1','A1');
    xlswrite('IRF_per_pcom_up',row_header,'Sheet 1','A2');

    xlswrite('IRF_per_cr',cr_shock,'Sheet 1','B2');
    xlswrite('IRF_per_cr',col_header,'Sheet 1','A1');
    xlswrite('IRF_per_cr',row_header,'Sheet 1','A2');
    xlswrite('IRF_per_cr_low',cr_low68,'Sheet 1','B2');
    xlswrite('IRF_per_cr_low',col_header,'Sheet 1','A1');
    xlswrite('IRF_per_cr_low',row_header,'Sheet 1','A2');
    xlswrite('IRF_per_cr_up',cr_up68,'Sheet 1','B2');
    xlswrite('IRF_per_cr_up',col_header,'Sheet 1','A1');
    xlswrite('IRF_per_cr_up',row_header,'Sheet 1','A2');

end