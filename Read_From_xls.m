% Membaca data dari kolom dan baris tertentu pada worksheet di file Excel
filename = 'Data IEEE 30 Bus System.xlsx'; % Ganti dengan nama file Excel Anda
sheet1 = 'Generator cost and emission'; % Ganti dengan nama worksheet yang sesuai
sheet2 = 'Bus_data'; % Ganti dengan nama worksheet yang sesuai
sheet3 = 'Line_Data'; % Ganti dengan nama worksheet yang sesuai
% Tentukan rentang sel yang ingin dibaca (misalnya, dari A2 hingga C5)

% Membaca data dari worksheet dan rentang yang ditentukan
data1 = readmatrix(filename,'Sheet',sheet1);
data2 = readmatrix(filename,'Sheet',sheet2);
data3 = readmatrix(filename,'Sheet',sheet3);
GeneratorUnit = size(data1,1);
Pmin = data1(:,2);
Pmax = data1(:,3);
Cost_a = data1(:,6);
Cost_b = data1(:,7);
Cost_c = data1(:,8);
busdata = data2(3:32,:);
linedata = data3(4:44,:);
cost =[Cost_c Cost_b Cost_a];
mwlimits = [Pmin Pmax];
Jumlah_Bus = size(busdata(:,1),1);
Jumlah_Saluran = length(linedata);
MW_Rating = (linedata(:,7).*0.8)


% Menampilkan data yang diambil
%disp('Data yang diambil dari file Excel:');
%disp(data1);