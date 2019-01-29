
for i = 1:4
    which_country = i;
    m             = 1;
    model         = 'ftd_cholesky';
    
    msstart_setup
    msprob
    msprobg
    close all
    
    Bhat(3:5,6)   = 0;
    Bhat(11:13,6) = 0;
    Bhat(19:21,6) = 0;
    Bhat(27:29,6) = 0;
    
    A0hat(3:5,6)  = 0;
    
    fevd
end
    
