function tableKicks=Fields2Kicks(Fields,Brho)
% Fields2Kicks         convert fields [T,T/m,etc...] into MADX kicks
    tableKicks=zeros(size(Fields));
    tableKicks=Fields./Brho;
end