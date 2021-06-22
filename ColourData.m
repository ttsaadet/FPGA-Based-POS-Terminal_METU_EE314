%%matlab code that is used for to obtain colour datas of image in .mif
%%format
ekranrgb = imread('ekranyeni.png');
counter_r=0;
counter_g=0;
counter_b=0;

N = 307200; %% the length of the data, ie the memory depth.
word_len = 8; %% The number of bits occupied by each unit

%%--------R-E-D---D-A-T-A--------
fid_r=fopen('RED_DATA.mif','w');% open file
fprintf(fid_r, 'DEPTH = %d;\n', N);
fprintf(fid_r, 'WIDTH = %d;\n', word_len);
 
fprintf(fid_r,'ADDRESS_RADIX = UNS;\n'); %% specifies the address as decimal
fprintf(fid_r,'DATA_RADIX = HEX;\n'); %% specifies that the data is in hexadecimal
fprintf(fid_r, 'CONTENT ');
fprintf(fid_r, 'BEGIN\n');

for x = 1 : 1 :480  
for y = 1 : 1: 640
    fprintf(fid_r, ' %d : %x;\n',counter_r,ekranrgb(x,y,1));
    counter_r=counter_r+1;
end
end
 fprintf(fid_r,'END;\n'); %% end of output
 fclose(fid_r); %% closes the file
 
%%--------G-R-E-E-N-----D-A-T-A--------
fid_g=fopen('GREEN_DATA.mif','w');% open file
fprintf(fid_g, 'DEPTH = %d;\n', N);
fprintf(fid_g, 'WIDTH = %d;\n', word_len);
 
fprintf(fid_g,'ADDRESS_RADIX = UNS;\n'); %% specifies the address as decimal
fprintf(fid_g,'DATA_RADIX = HEX;\n'); %% specifies that the data is in hexadecimal
fprintf(fid_g, 'CONTENT ');
fprintf(fid_g, 'BEGIN\n');

for x = 1 : 1 :480  
for y = 1 : 1: 640
    fprintf(fid_g, ' %d : %x;\n',counter_g,ekranrgb(x,y,2));
    counter_g=counter_g+1;
end
end
 fprintf(fid_g,'END;\n'); %% end of output
 fclose(fid_g); %% closes the file
 
 %%--------B-L-U-E------D-A-T-A--------
fid_b=fopen('BLUE_DATA.mif','w');% open file
fprintf(fid_b, 'DEPTH = %d;\n', N);
fprintf(fid_b, 'WIDTH = %d;\n', word_len);
 
fprintf(fid_b,'ADDRESS_RADIX = UNS;\n'); %% specifies the address as decimal
fprintf(fid_b,'DATA_RADIX = HEX;\n'); %% specifies that the data is in hexadecimal
fprintf(fid_b, 'CONTENT ');
fprintf(fid_b, 'BEGIN\n');

for x = 1 : 1 :480  
for y = 1 : 1: 640
    fprintf(fid_b, ' %d : %x;\n',counter_b,ekranrgb(x,y,3));
    counter_b=counter_b+1;
end
end
 fprintf(fid_b,'END;\n'); %% end of output
 fclose(fid_b); %% closes the file
