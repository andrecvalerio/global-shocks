% This is the matrix of main interest, the one that will store the FEVD
VD=zeros(h,nvar^2); 

%Creating labels for the sheet where VD will be stored
col_header = ['Horizon',repmat(varlist,1,nvar)];
row_header = (1:h)';
row_header2 = (1:4)';

%Extracting the VD and saving it into an excel file.
for i = 1:nvar
    for j = 1:h
        if i == 1
            VD(j,1:nvar) = fev(i,:,j);
        else
            VD(j,(i-1)*nvar+1:i*nvar) = fev(i,:,j);
        end
    end
end

xlswrite('VD_br',VD,'Sheet 1','B2');
xlswrite('VD_br',col_header,'Sheet 1','A1');
xlswrite('VD_br',row_header,'Sheet 1','A2');