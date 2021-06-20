%%for red colour data change ekranrgb as ekranrgb(x,y,1)
%%for green colour data change ekranrgb as ekranrgb(x,y,2)
%%for blue colour data change ekranrgb as ekranrgb(x,y,3)
%%also change the file name correspondingly

ekranrgb = imread('ekranyeni.png');
counter=0;
N = 307200; %% the length of the data, ie the memory depth.
word_len = 8; %% The number of bits occupied by each unit

fid=fopen('BLUE_DATA.mif','w');% open file
fprintf(fid, 'DEPTH = %d;\n', N);
fprintf(fid, 'WIDTH = %d;\n', word_len);
 
fprintf(fid,'ADDRESS_RADIX = UNS;\n'); %% specifies the address as decimal
fprintf(fid,'DATA_RADIX = HEX;\n'); %% specifies that the data is in hexadecimal
fprintf(fid, 'CONTENT ');
fprintf(fid, 'BEGIN\n');

for x = 1 : 1 :480  
for y = 1 : 1: 640
    fprintf(fid, ' %X : %x;\n',counter,ekranrgb(x,y,3));
    counter=counter+1;
end
end
 fprintf(fid,'END;\n'); %% end of output
 fclose(fid); %% closes the file
