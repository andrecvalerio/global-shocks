%% Computation of Forecast Error Variance Decomposition (FEVD) 
% Using the strategy proposed in chapter 4 of Lutkepohl and Killian (2016).
% It uses the following matrix computed from Zha's code: Bhat, Aphat, and
% A0hat.
% A0hat is the strucutural impact matrix: nvar X nvar; each column is one
% equation
% Bhat is the reduced form lagged coefficients matrix: (nvar*lags+1) X nvar;
% each column is one equation; last row is the intercept. It comes in blocks
% of nvar X lags, each block constructed for one specific lag.
% Aphat- structural form lagged coefficients matrix:(nvar*lags+1) X nvar;
% each coluumn is one equation.
% These matrices are related in the following way: Aphat*inv(A0hat)=Bhat, or
% Aphat=Bhat*A0hat

h          = 16; %forecast horizon

B0inv_step = transpose(A0hat); %agora, cada linha é uma equação
B0inv      = inv(B0inv_step);%matriz de impacto invertida   

tB         = transpose(Bhat);
Astep      = tB(:,1:nvar*lags);
Ik         = eye(nvar);
zero       = zeros(nvar);

%for nlags=4
A = [Astep
    Ik zero zero zero
    zero Ik zero zero
    zero zero Ik zero];
J = [Ik zeros(nvar,nvar*(lags-1))];

theta = zeros(nvar,nvar,h);
for j = 1:h
    theta(:,:,j) = J*(A^(j-1))*transpose(J)*B0inv;
end

fev = zeros(nvar,nvar,h);

% Initiate fevd for h=1:
sqrsum = theta(:,:,1).*theta(:,:,1);
addsqrsum = sqrsum;
mspe = sum(sqrsum(:,:,1),2); %column vector with sum of each row
%fev(:,:,1)=100*addsqrsum./(mspe*ones(1,nvar));
fev(:,:,1) = addsqrsum./(mspe*ones(1,nvar));

for j = 2:h
    sqrsum = theta(:,:,j).*theta(:,:,j);
    addsqrsum = addsqrsum+sqrsum;
    mspe = mspe+sum(sqrsum,2); %column vector with sum of each row
    %fev(:,:,j)=100*addsqrsum./(mspe*ones(1,nvar));
    fev(:,:,j) = addsqrsum./(mspe*ones(1,nvar));
end 

%% Post analysis
% I tranform the fev(nvar,nvar,h) cell into a matrix of size (h,nvar^2)
% In this way, it's easier to perform data analysis, like creating tables
% or graphs.

% First, I create an intermediary cell to store the results in order to
% have all responses to a unique shock in each cell. Therefore, in cell
% DV(:,:,1) we have the decomposition variance when we observe a shock in
% GDP, throughout the entire horizon of interest, and so forth.
DV = zeros(h,nvar,nvar);

% Loop to accomplish the first step. It simply take for each horizon and
% each shock the tranpose of the original matrix and store in DV
for i = 1:h
    for j = 1:nvar
        DV(i,:,j)=fev(:,j,i)';
    end
end

% This is the matrix of main interest, the one that will store the FEVD
VD=zeros(h,nvar^2); 

%Creating labels for the sheet where VD will be stored
col_header = ['Horizon',repmat(varlist,1,nvar)];
row_header = (1:h)';
row_header2 = (1:4)';

%Extracting the VD and saving it into an excel file.
for i = 1:nvar
    if i == 1
        VD(:,1:nvar) = DV(:,:,i);
    else
        VD(:,(i-1)*nvar+1:i*nvar) = DV(:,:,i);
    end
end

% saving irfs according to which model and which country is being estimated
if cf ~= 0
    name2 = namec(which_country,'_VD_cf_m',string(m));
else
   name2 = namec(which_country,'_VD_m',string(m));
end
xlswrite(name2,VD,'Sheet 1','B2');
xlswrite(name2,col_header,'Sheet 1','A1');
xlswrite(name2,row_header,'Sheet 1','A2');

% if m == 1
%     if cf ~= 0
%        if which_country == 1
%         xlswrite('VD_br_cf',VD,'Sheet 1','B2');
%         xlswrite('VD_br_cf',col_header,'Sheet 1','A1');
%         xlswrite('VD_br_cf',row_header,'Sheet 1','A2');
%     elseif which_country == 2
%         xlswrite('VD_ch_cf',VD,'Sheet 1','B2');
%         xlswrite('VD_ch_cf',col_header,'Sheet 1','A1');
%         xlswrite('VD_ch_cf',row_header,'Sheet 1','A2');
%     elseif which_country == 3
%         xlswrite('VD_col_cf',VD,'Sheet 1','B2');
%         xlswrite('VD_col_cf',col_header,'Sheet 1','A1');
%         xlswrite('VD_col_cf',row_header,'Sheet 1','A2');
%     elseif which_country == 4
%         xlswrite('VD_per_cf',VD,'Sheet 1','B2');
%         xlswrite('VD_per_cf',col_header,'Sheet 1','A1');
%         xlswrite('VD_per_cf',row_header,'Sheet 1','A2');
%         end 
%     else
%         if which_country == 1
%             xlswrite('VD_br',VD,'Sheet 1','B2');
%             xlswrite('VD_br',col_header,'Sheet 1','A1');
%             xlswrite('VD_br',row_header,'Sheet 1','A2');
%         elseif which_country == 2
%             xlswrite('VD_ch',VD,'Sheet 1','B2');
%             xlswrite('VD_ch',col_header,'Sheet 1','A1');
%             xlswrite('VD_ch',row_header,'Sheet 1','A2');
%         elseif which_country == 3
%             xlswrite('VD_col',VD,'Sheet 1','B2');
%             xlswrite('VD_col',col_header,'Sheet 1','A1');
%             xlswrite('VD_col',row_header,'Sheet 1','A2');
%         elseif which_country == 4
%             xlswrite('VD_per',VD,'Sheet 1','B2');
%             xlswrite('VD_per',col_header,'Sheet 1','A1');
%             xlswrite('VD_per',row_header,'Sheet 1','A2');
%         end
%     end
% elseif m == 2
%     if cf ~= 0
%         if which_country == 1
%             xlswrite('VD_br_m2_cf',VD,'Sheet 1','B2');
%             xlswrite('VD_br_m2_cf',col_header,'Sheet 1','A1');
%             xlswrite('VD_br_m2_cf',row_header,'Sheet 1','A2');
%         elseif which_country == 2
%             xlswrite('VD_ch_m2_cf',VD,'Sheet 1','B2');
%             xlswrite('VD_ch_m2_cf',col_header,'Sheet 1','A1');
%             xlswrite('VD_ch_m2_cf',row_header,'Sheet 1','A2');
%         elseif which_country == 3
%             xlswrite('VD_col_m2_cf',VD,'Sheet 1','B2');
%             xlswrite('VD_col_m2_cf',col_header,'Sheet 1','A1');
%             xlswrite('VD_col_m2_cf',row_header,'Sheet 1','A2');
%         elseif which_country == 4
%             xlswrite('VD_per_m2_cf',VD,'Sheet 1','B2');
%             xlswrite('VD_per_m2_cf',col_header,'Sheet 1','A1');
%             xlswrite('VD_per_m2_cf',row_header,'Sheet 1','A2');
%         end
%     else
%         if which_country == 1
%             xlswrite('VD_br_m2',VD,'Sheet 1','B2');
%             xlswrite('VD_br_m2',col_header,'Sheet 1','A1');
%             xlswrite('VD_br_m2',row_header,'Sheet 1','A2');
%         elseif which_country == 2
%             xlswrite('VD_ch_m2',VD,'Sheet 1','B2');
%             xlswrite('VD_ch_m2',col_header,'Sheet 1','A1');
%             xlswrite('VD_ch_m2',row_header,'Sheet 1','A2');
%         elseif which_country == 3
%             xlswrite('VD_col_m2',VD,'Sheet 1','B2');
%             xlswrite('VD_col_m2',col_header,'Sheet 1','A1');
%             xlswrite('VD_col_m2',row_header,'Sheet 1','A2');
%         elseif which_country == 4
%             xlswrite('VD_per_m2',VD,'Sheet 1','B2');
%             xlswrite('VD_per_m2',col_header,'Sheet 1','A1');
%             xlswrite('VD_per_m2',row_header,'Sheet 1','A2');
%         end
%     end
% elseif m == 3
%     if cf ~= 0
%         if which_country == 1
%             xlswrite('VD_br_m3_cf',VD,'Sheet 1','B2');
%             xlswrite('VD_br_m3_cf',col_header,'Sheet 1','A1');
%             xlswrite('VD_br_m3_cf',row_header,'Sheet 1','A2');
%         elseif which_country == 2
%             xlswrite('VD_ch_m3_cf',VD,'Sheet 1','B2');
%             xlswrite('VD_ch_m3_cf',col_header,'Sheet 1','A1');
%             xlswrite('VD_ch_m3_cf',row_header,'Sheet 1','A2');
%         elseif which_country == 3
%             xlswrite('VD_col_m3_cf',VD,'Sheet 1','B2');
%             xlswrite('VD_col_m3_cf',col_header,'Sheet 1','A1');
%             xlswrite('VD_col_m3_cf',row_header,'Sheet 1','A2');
%         elseif which_country == 4
%             xlswrite('VD_per_m3_cf',VD,'Sheet 1','B2');
%             xlswrite('VD_per_m3_cf',col_header,'Sheet 1','A1');
%             xlswrite('VD_per_m3_cf',row_header,'Sheet 1','A2');
%         end
%     else
%         if which_country == 1
%             xlswrite('VD_br_m3',VD,'Sheet 1','B2');
%             xlswrite('VD_br_m3',col_header,'Sheet 1','A1');
%             xlswrite('VD_br_m3',row_header,'Sheet 1','A2');
%         elseif which_country == 2
%             xlswrite('VD_ch_m3',VD,'Sheet 1','B2');
%             xlswrite('VD_ch_m3',col_header,'Sheet 1','A1');
%             xlswrite('VD_ch_m3',row_header,'Sheet 1','A2');
%         elseif which_country == 3
%             xlswrite('VD_col_m3',VD,'Sheet 1','B2');
%             xlswrite('VD_col_m3',col_header,'Sheet 1','A1');
%             xlswrite('VD_col_m3',row_header,'Sheet 1','A2');
%         elseif which_country == 4
%             xlswrite('VD_per_m3',VD,'Sheet 1','B2');
%             xlswrite('VD_per_m3',col_header,'Sheet 1','A1');
%             xlswrite('VD_per_m3',row_header,'Sheet 1','A2');
%         end
%     end
% elseif m == 4
%     if cf ~= 0
%         if which_country == 1
%             xlswrite('VD_br_m4_cf',VD,'Sheet 1','B2');
%             xlswrite('VD_br_m4_cf',col_header,'Sheet 1','A1');
%             xlswrite('VD_br_m4_cf',row_header,'Sheet 1','A2');
%         elseif which_country == 2
%             xlswrite('VD_ch_m4_cf',VD,'Sheet 1','B2');
%             xlswrite('VD_ch_m4_cf',col_header,'Sheet 1','A1');
%             xlswrite('VD_ch_m4_cf',row_header,'Sheet 1','A2');
%         elseif which_country == 3
%             xlswrite('VD_col_m4_cf',VD,'Sheet 1','B2');
%             xlswrite('VD_col_m4_cf',col_header,'Sheet 1','A1');
%             xlswrite('VD_col_m4_cf',row_header,'Sheet 1','A2');
%         elseif which_country == 4
%             xlswrite('VD_per_m4_cf',VD,'Sheet 1','B2');
%             xlswrite('VD_per_m4_cf',col_header,'Sheet 1','A1');
%             xlswrite('VD_per_m4_cf',row_header,'Sheet 1','A2');
%         end
%     else
%         if which_country == 1
%             xlswrite('VD_br_m4',VD,'Sheet 1','B2');
%             xlswrite('VD_br_m4',col_header,'Sheet 1','A1');
%             xlswrite('VD_br_m4',row_header,'Sheet 1','A2');
%         elseif which_country == 2
%             xlswrite('VD_ch_m4',VD,'Sheet 1','B2');
%             xlswrite('VD_ch_m4',col_header,'Sheet 1','A1');
%             xlswrite('VD_ch_m4',row_header,'Sheet 1','A2');
%         elseif which_country == 3
%             xlswrite('VD_col_m4',VD,'Sheet 1','B2');
%             xlswrite('VD_col_m4',col_header,'Sheet 1','A1');
%             xlswrite('VD_col_m4',row_header,'Sheet 1','A2');
%         elseif which_country == 4
%             xlswrite('VD_per_m4',VD,'Sheet 1','B2');
%             xlswrite('VD_per_m4',col_header,'Sheet 1','A1');
%             xlswrite('VD_per_m4',row_header,'Sheet 1','A2');
%         end
%     end
% elseif m == 5
%     if cf ~= 0
%         if which_country == 1
%             xlswrite('VD_br_m5_cf',VD,'Sheet 1','B2');
%             xlswrite('VD_br_m5_cf',col_header,'Sheet 1','A1');
%             xlswrite('VD_br_m5_cf',row_header,'Sheet 1','A2');
%         elseif which_country == 2
%             xlswrite('VD_ch_m5_cf',VD,'Sheet 1','B2');
%             xlswrite('VD_ch_m5_cf',col_header,'Sheet 1','A1');
%             xlswrite('VD_ch_m5_cf',row_header,'Sheet 1','A2');
%         elseif which_country == 3
%             xlswrite('VD_col_m5_cf',VD,'Sheet 1','B2');
%             xlswrite('VD_col_m5_cf',col_header,'Sheet 1','A1');
%             xlswrite('VD_col_m5_cf',row_header,'Sheet 1','A2');
%         elseif which_country == 4
%             xlswrite('VD_per_m5_cf',VD,'Sheet 1','B2');
%             xlswrite('VD_per_m5_cf',col_header,'Sheet 1','A1');
%             xlswrite('VD_per_m5_cf',row_header,'Sheet 1','A2');
%         end
%     else
%         if which_country == 1
%             xlswrite('VD_br_m5',VD,'Sheet 1','B2');
%             xlswrite('VD_br_m5',col_header,'Sheet 1','A1');
%             xlswrite('VD_br_m5',row_header,'Sheet 1','A2');
%         elseif which_country == 2
%             xlswrite('VD_ch_m5',VD,'Sheet 1','B2');
%             xlswrite('VD_ch_m5',col_header,'Sheet 1','A1');
%             xlswrite('VD_ch_m5',row_header,'Sheet 1','A2');
%         elseif which_country == 3
%             xlswrite('VD_col_m5',VD,'Sheet 1','B2');
%             xlswrite('VD_col_m5',col_header,'Sheet 1','A1');
%             xlswrite('VD_col_m5',row_header,'Sheet 1','A2');
%         elseif which_country == 4
%             xlswrite('VD_per_m5',VD,'Sheet 1','B2');
%             xlswrite('VD_per_m5',col_header,'Sheet 1','A1');
%             xlswrite('VD_per_m5',row_header,'Sheet 1','A2');
%         end
%     end
% elseif m == 6
%     if cf ~= 0
%         if which_country == 1
%             xlswrite('VD_br_m6_cf',VD,'Sheet 1','B2');
%             xlswrite('VD_br_m6_cf',col_header,'Sheet 1','A1');
%             xlswrite('VD_br_m6_cf',row_header,'Sheet 1','A2');
%         elseif which_country == 2
%             xlswrite('VD_ch_m6_cf',VD,'Sheet 1','B2');
%             xlswrite('VD_ch_m6_cf',col_header,'Sheet 1','A1');
%             xlswrite('VD_ch_m6_cf',row_header,'Sheet 1','A2');
%         elseif which_country == 3
%             xlswrite('VD_col_m6_cf',VD,'Sheet 1','B2');
%             xlswrite('VD_col_m6_cf',col_header,'Sheet 1','A1');
%             xlswrite('VD_col_m6_cf',row_header,'Sheet 1','A2');
%         elseif which_country == 4
%             xlswrite('VD_per_m6_cf',VD,'Sheet 1','B2');
%             xlswrite('VD_per_m6_cf',col_header,'Sheet 1','A1');
%             xlswrite('VD_per_m6_cf',row_header,'Sheet 1','A2');
%         end
%     else
%         if which_country == 1
%             xlswrite('VD_br_m6',VD,'Sheet 1','B2');
%             xlswrite('VD_br_m6',col_header,'Sheet 1','A1');
%             xlswrite('VD_br_m6',row_header,'Sheet 1','A2');
%         elseif which_country == 2
%             xlswrite('VD_ch_m6',VD,'Sheet 1','B2');
%             xlswrite('VD_ch_m6',col_header,'Sheet 1','A1');
%             xlswrite('VD_ch_m6',row_header,'Sheet 1','A2');
%         elseif which_country == 3
%             xlswrite('VD_col_m6',VD,'Sheet 1','B2');
%             xlswrite('VD_col_m6',col_header,'Sheet 1','A1');
%             xlswrite('VD_col_m6',row_header,'Sheet 1','A2');
%         elseif which_country == 4
%             xlswrite('VD_per_m6',VD,'Sheet 1','B2');
%             xlswrite('VD_per_m6',col_header,'Sheet 1','A1');
%             xlswrite('VD_per_m6',row_header,'Sheet 1','A2');
%         end
%     end
% elseif m == 7
%     if cf ~= 0
%         if which_country == 1
%             xlswrite('VD_br_m7_cf',VD,'Sheet 1','B2');
%             xlswrite('VD_br_m7_cf',col_header,'Sheet 1','A1');
%             xlswrite('VD_br_m7_cf',row_header,'Sheet 1','A2');
%         elseif which_country == 2
%             xlswrite('VD_ch_m7_cf',VD,'Sheet 1','B2');
%             xlswrite('VD_ch_m7_cf',col_header,'Sheet 1','A1');
%             xlswrite('VD_ch_m7_cf',row_header,'Sheet 1','A2');
%         elseif which_country == 3
%             xlswrite('VD_col_m7_cf',VD,'Sheet 1','B2');
%             xlswrite('VD_col_m7_cf',col_header,'Sheet 1','A1');
%             xlswrite('VD_col_m7_cf',row_header,'Sheet 1','A2');
%         elseif which_country == 4
%             xlswrite('VD_per_m7_cf',VD,'Sheet 1','B2');
%             xlswrite('VD_per_m7_cf',col_header,'Sheet 1','A1');
%             xlswrite('VD_per_m7_cf',row_header,'Sheet 1','A2');
%         end
%     else
%         if which_country == 1
%             xlswrite('VD_br_m7',VD,'Sheet 1','B2');
%             xlswrite('VD_br_m7',col_header,'Sheet 1','A1');
%             xlswrite('VD_br_m7',row_header,'Sheet 1','A2');
%         elseif which_country == 2
%             xlswrite('VD_ch_m7',VD,'Sheet 1','B2');
%             xlswrite('VD_ch_m7',col_header,'Sheet 1','A1');
%             xlswrite('VD_ch_m7',row_header,'Sheet 1','A2');
%         elseif which_country == 3
%             xlswrite('VD_col_m7',VD,'Sheet 1','B2');
%             xlswrite('VD_col_m7',col_header,'Sheet 1','A1');
%             xlswrite('VD_col_m7',row_header,'Sheet 1','A2');
%         elseif which_country == 4
%             xlswrite('VD_per_m7',VD,'Sheet 1','B2');
%             xlswrite('VD_per_m7',col_header,'Sheet 1','A1');
%             xlswrite('VD_per_m7',row_header,'Sheet 1','A2');
%         end
%     end
% elseif m == 8
%     if cf ~= 0
%         if which_country == 1
%             xlswrite('VD_br_m8_cf',VD,'Sheet 1','B2');
%             xlswrite('VD_br_m8_cf',col_header,'Sheet 1','A1');
%             xlswrite('VD_br_m8_cf',row_header,'Sheet 1','A2');
%         elseif which_country == 2
%             xlswrite('VD_ch_m8_cf',VD,'Sheet 1','B2');
%             xlswrite('VD_ch_m8_cf',col_header,'Sheet 1','A1');
%             xlswrite('VD_ch_m8_cf',row_header,'Sheet 1','A2');
%         elseif which_country == 3
%             xlswrite('VD_col_m8_cf',VD,'Sheet 1','B2');
%             xlswrite('VD_col_m8_cf',col_header,'Sheet 1','A1');
%             xlswrite('VD_col_m8_cf',row_header,'Sheet 1','A2');
%         elseif which_country == 4
%             xlswrite('VD_per_m8_cf',VD,'Sheet 1','B2');
%             xlswrite('VD_per_m8_cf',col_header,'Sheet 1','A1');
%             xlswrite('VD_per_m8_cf',row_header,'Sheet 1','A2');
%         end
%     else
%         if which_country == 1
%             xlswrite('VD_br_m8',VD,'Sheet 1','B2');
%             xlswrite('VD_br_m8',col_header,'Sheet 1','A1');
%             xlswrite('VD_br_m8',row_header,'Sheet 1','A2');
%         elseif which_country == 2
%             xlswrite('VD_ch_m8',VD,'Sheet 1','B2');
%             xlswrite('VD_ch_m8',col_header,'Sheet 1','A1');
%             xlswrite('VD_ch_m8',row_header,'Sheet 1','A2');
%         elseif which_country == 3
%             xlswrite('VD_col_m8',VD,'Sheet 1','B2');
%             xlswrite('VD_col_m8',col_header,'Sheet 1','A1');
%             xlswrite('VD_col_m8',row_header,'Sheet 1','A2');
%         elseif which_country == 4
%             xlswrite('VD_per_m8',VD,'Sheet 1','B2');
%             xlswrite('VD_per_m8',col_header,'Sheet 1','A1');
%             xlswrite('VD_per_m8',row_header,'Sheet 1','A2');
%         end
%     end
% elseif m == 9
%     if which_country == 1
%             xlswrite('VD_br_m8',VD,'Sheet 1','B2');
%             xlswrite('VD_br_m8',col_header,'Sheet 1','A1');
%             xlswrite('VD_br_m8',row_header,'Sheet 1','A2');
%         elseif which_country == 2
%             xlswrite('VD_ch_m8',VD,'Sheet 1','B2');
%             xlswrite('VD_ch_m8',col_header,'Sheet 1','A1');
%             xlswrite('VD_ch_m8',row_header,'Sheet 1','A2');
%         elseif which_country == 3
%             xlswrite('VD_col_m8',VD,'Sheet 1','B2');
%             xlswrite('VD_col_m8',col_header,'Sheet 1','A1');
%             xlswrite('VD_col_m8',row_header,'Sheet 1','A2');
%         elseif which_country == 4
%             xlswrite('VD_per_m8',VD,'Sheet 1','B2');
%             xlswrite('VD_per_m8',col_header,'Sheet 1','A1');
%             xlswrite('VD_per_m8',row_header,'Sheet 1','A2');
%      end
% end
%     
% 
%      