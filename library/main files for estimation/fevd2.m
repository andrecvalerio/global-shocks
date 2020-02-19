%Compute the Forecast Error Variance Decomposition (FEVD) using the
%strategy proposed in chapter 4 of Lutkepohl and Killian (2016).
%It uses the following matrix computed from Zha's code: Bhat, Aphat, and
%A0hat.
%A0hat is the strucutural impact matrix: nvar X nvar; each column is one
%equation
%Bhat is the reduced form lagged coefficients matrix: (nvar*lags+1) X nvar;
%each column is one equation; last row is the intercept. It comes in blocks
%of nvar X lags, each block constructed for one specific lag.
%Aphat- structural form lagged coefficients matrix:(nvar*lags+1) X nvar;
%each coluumn is one equation.
%These matrices are related in the following way: Aphat*inv(A0hat)=Bhat, or
%Aphat=Bhat*A0hat
%eplhat é a matriz de resíduos forma reduzida. Dimensão: nobs X 8

nobs=size(eplhat,1);
yhat=zeros(size(var_reg,1)-lags,nvar); %initiate fitted values from reduced VAR
for p=(1+lags):size(var_reg,1)
    if lags==4
        ycond=[var_reg(p-1,:),var_reg(p-2,:),var_reg(p-3,:),var_reg(p-4,:) 1];
    end
    if lags==3
        ycond=[var_reg(p-1,:),var_reg(p-2,:),var_reg(p-3,:) 1];
    end
    if lags==2
        ycond=[var_reg(p-1,:),var_reg(p-2,:) 1];
    end
    yhat(p-lags,:)=ycond*Bhat;  %fitted values frm reduced VAR
end
res_hat=var_reg((1+lags):size(var_reg,1),:)-yhat;  %residuals from reduced VAR
varcov_reduced=transpose(res_hat)*res_hat/nobs; %var-cov from reduced VAR
B0=transpose(A0hat); %after transposing, each line becomes an equation
B0inv=inv(B0);%inverted impact matrix
orth_resid=res_hat*transpose(B0inv); %orthogonalized residuals
varcov_struct=transpose(orth_resid)*orth_resid;
h=16;%20; %forecast horizon
tB=transpose(Bhat);  %transpose the matrix of reduced form coefficients
Astep=tB(:,1:nvar*lags);
Ik=eye(nvar);
zero=zeros(nvar);

%creating matrix A and J that is the same as proposed in the book of Lutkepohl
%and Killian (2016), chapter 4 when working with FEVD.

if lags==4
    A=[Astep
    Ik zero zero zero
    zero Ik zero zero
    zero zero Ik zero];
end
if lags==3
    A=[Astep
    Ik zero zero
    zero Ik zero];
end
if lags==2
    A=[Astep
    Ik zero];
end
J=[Ik zeros(nvar,nvar*(lags-1))];
theta=zeros(nvar,nvar,h);
for j=1:h
    theta(:,:,j)=J*(A^(j-1))*transpose(J)*B0inv;
end
structvar=diag(varcov_struct);
structvarmatrix=ones(nvar,1)*transpose(structvar);
fev=zeros(nvar,nvar,h);
%initiate fevd for h=1:
%sqrsum=theta(:,:,1).*theta(:,:,1).*structvarmatrix;
sqrsum=theta(:,:,1).*theta(:,:,1);
addsqrsum=sqrsum;
mspe=sum(sqrsum(:,:,1),2); %column vector with sum of each row
fev(:,:,1)=100*addsqrsum./(mspe*ones(1,nvar));

for j=2:h
    %sqrsum=theta(:,:,j).*theta(:,:,j).*structvarmatrix;
    sqrsum=theta(:,:,j).*theta(:,:,j);
    addsqrsum=addsqrsum+sqrsum;
    mspe=mspe+sum(sqrsum,2); %column vector with sum of each row
    fev(:,:,j)=100*addsqrsum./(mspe*ones(1,nvar));
    j
end
fev

%Preparing the ouput to be exported to excel
horizon=[4,8,12,16]; %Forecasting horizon for publishing the FEVD
worldgdp=zeros(nvar,length(horizon));
vix=zeros(nvar,length(horizon));
pcomm=zeros(nvar,length(horizon));
svngspread=zeros(nvar,length(horizon));
forex=zeros(nvar,length(horizon));
gdp=zeros(nvar,length(horizon));
cpi=zeros(nvar,length(horizon));
intrate=zeros(nvar,length(horizon));

%The next conditions stablishes where the first domestic variable starts. 
%Impulse Response of National Variables runs from nvar=domestic1:end.
if m==1
    domestic1=4; 
elseif m==2 | m==4 | m==5
    domestic1=3;
elseif m==3
    domestic1=2;
end              
for t=1:length(horizon)
    svngspread(:,t)=transpose(fev(domestic1,:,horizon(t)));
    forex(:,t)=transpose(fev(domestic1+1,:,horizon(t)));
    gdp(:,t)=transpose(fev(domestic1+2,:,horizon(t)));
    cpi(:,t)=transpose(fev(domestic1+3,:,horizon(t)));
    intrate(:,t)=transpose(fev(domestic1+4,:,horizon(t)));
end

%International variables FEV. It will be computed only when 
%which_country==1 because the values are equal for all countries.
%I will not compute when model==3, because I would only have pcomm as
%an international variable.
if which_country==1
    for t=1:length(horizon)
        if m==1
            worldgdp(:,t)=transpose(fev(1,:,horizon(t)));
            vix(:,t)=transpose(fev(2,:,horizon(t)));
            pcomm(:,t)=transpose(fev(3,:,horizon(t)));
        elseif m==2
            worldgdp(:,t)=transpose(fev(1,:,horizon(t)));
            pcomm(:,t)=transpose(fev(2,:,horizon(t)));
        elseif m==4
            vix(:,t)=transpose(fev(1,:,horizon(t)));
            pcomm(:,t)=transpose(fev(2,:,horizon(t)));
        elseif m==5
            worldgdp(:,t)=transpose(fev(1,:,horizon(t)));
            vix(:,t)=transpose(fev(2,:,horizon(t)));
        end
    end
end

%if model==1
%    shockname={'intldem','intluncert','intlsupply','uncert','forex','demand','supply','monetary'};
%elseif model==2
%    shockname={'intldem','intlsupply','uncert','forex','demand','supply','monetary'};
%elseif model==3
%    shockname={'intlsupply','uncert','forex','demand','supply','monetary'};
%elseif model==4
%    shockname={'intluncert','intlsupply','uncert','forex','demand','supply','monetary'};
%elseif model==5
%    shockname={'intldem','intluncert','uncert','forex','demand','supply','monetary'};
%    end
shockname={'intldem','intluncert','intlsupply','uncert','forex','demand','supply','monetary'};
row_header = shockname';

%Can turn this block off after deciding about indxPrior and indxDummy
xlswrite('fevd',{'indxPrior'},which_country,'A1');  %This indicates if the indxPrior=0 or 1
xlswrite('fevd',indxPrior,which_country,'B1');      %This indicates if the indxPrior=0 or 1
xlswrite('fevd',{'indxDummy'},which_country,'A2');  %This indicates if the indxDummy=0 or 1
xlswrite('fevd',indxDummy,which_country,'B2');      %This indicates if the indxDummy=0 or 1
% end this little block

xlswrite('fevd',svngspread,which_country,'B5');
xlswrite('fevd',[{'svngspread'} 4 8 12 16],which_country,'A4');
xlswrite('fevd',row_header,which_country,'A5');

xlswrite('fevd',forex,which_country,'B15');
xlswrite('fevd',[{'forex'} 4 8 12 16],which_country,'A14');
xlswrite('fevd',row_header,which_country,'A15');

xlswrite('fevd',gdp,which_country,'B25');
xlswrite('fevd',[{'GDP'} 4 8 12 16],which_country,'A24');
xlswrite('fevd',row_header,which_country,'A25');

xlswrite('fevd',cpi,which_country,'B35');
xlswrite('fevd',[{'CPI'} 4 8 12 16],which_country,'A34');
xlswrite('fevd',row_header,which_country,'A35');

xlswrite('fevd',intrate,which_country,'B45');
xlswrite('fevd',[{'Int.rate'} 4 8 12 16],which_country,'A44');
xlswrite('fevd',row_header,which_country,'A45');

if which_country==1
    xlswrite('fevd',worldgdp,which_country,'B55');
    xlswrite('fevd',[{'world GDP'} 4 8 12 16],which_country,'A54');
    xlswrite('fevd',row_header,which_country,'A55');
    
    xlswrite('fevd',vix,which_country,'B65');
    xlswrite('fevd',[{'VIX'} 4 8 12 16],which_country,'A64');
    xlswrite('fevd',row_header,which_country,'A65');
    
    xlswrite('fevd',pcomm,which_country,'B75');
    xlswrite('fevd',[{'Comm Price'} 4 8 12 16],which_country,'A74');
    xlswrite('fevd',row_header,which_country,'A75');
end
