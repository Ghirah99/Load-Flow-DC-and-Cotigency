clc
clear

Read_From_xls;
MatrixB;
DCLoadFlow;
ContigencyBonding;

 C = Bonding(:,13);
% C = abs(Bonding(:,12)*100) > linedata(:,7);

fast = fft(C);
realFast = abs(fast);



figure
stem(realFast)
title ('FFT Contigency Bounding')
xlabel('Saluran')
ylabel('delta theta I-J ')
