clc
clear

Read_From_xls;
MatrixB;
DCLoadFlow;
ContigencyBonding;

 C = Bonding(:,9)<Bonding(:,4);
% C = abs(Bonding(:,12)*100) > linedata(:,7);

fast = fft(C);
realFast = real(fast);



figure
stem(real(fast))
title ('FFT Contigency Bounding')
xlabel('Saluran')
ylabel('delta theta I-J ')
