clc
clear

Read_From_xls;
MatrixB;
DCLoadFlow;
ContigencyBonding;
 C = Bonding(:,13);

Filter_data = zeros(Jumlah_Saluran,2);

 for i=1:Jumlah_Saluran
    if C(i) < 100
        Filter_data(i,1)= abs(C(i)) ;
    end
 end

 for i=1:Jumlah_Saluran
     if (i==saluran_yang_lepas_N1)
         Filter_data(i,2) = 1;
     elseif C(i,1) > 100
         Filter_data(i,2) = 2;
     elseif Filter_data(i,1) > 90 &&  Filter_data(i) <=100
         Filter_data(i,2) = 3;
     elseif Filter_data(i,1) > 80 &&  Filter_data(i) <=90
         Filter_data(i,2) = 4;
     elseif Filter_data(i,1) > 70 &&  Filter_data(i) <=80
         Filter_data(i,2) = 5;
     elseif Filter_data(i,1) > 60 &&  Filter_data(i) <=70
         Filter_data(i,2) = 6;
     elseif Filter_data(i,1) > 50 &&  Filter_data(i) <=60
         Filter_data(i,2) = 7;
     elseif Filter_data(i,1) > 1 &&  Filter_data(i) <=50
         Filter_data(i,2) = 8;
     elseif Filter_data(i,1) < 1e-3
         Filter_data(i,2) = 8;
     end
 end

 Datatrain_Svm = [Bonding(:,10:13) Filter_data(:,:)];
 Datatest_Svm = [Bonding(:,10:13) Filter_data(:,1)];
% % C = abs(Bonding(:,12)*100) > linedata(:,7);
% 
% fast = fft(C);
% realFast = abs(fast);
% 
% 
% 
% figure
% stem(realFast)
% title ('FFT Contigency Bounding')
% xlabel('Saluran')
% ylabel('delta theta I-J ')
