clc
clear
Read_From_xls;
% Analisis Aliran Daya DC Menggunakan Metode Linear untuk IEEE 30 Bus

% Data IEEE 30 Bus
% Nomor bus, Bus type (1=Slack, 2=PQ, 3=PV), P (MW), Q (MVar), V (pu), theta (degree), P_Gen (MW), Q_Gen (MVar), P_Load (MW), Q_Load (MVar), Qmin (MVar), Qmax (MVar)

% Data Saluran IEEE 30 Bus
% Dari bus, Ke bus, R (pu), X (pu), B (pu), RateA (MVA), RateB (MVA), RateC (MVA), Ratio, Angle, Status, Angmin, Angmax

% Parameter Sistem
num_bus = size(busdata, 1);
num_line = size(linedata, 1);

% Matrices
B = zeros(num_bus);
P = zeros(num_bus, 1);

% Membuat matriks B (susceptance) dan matriks P (power)
for i = 1:num_line
    from = linedata(i, 1);
    to = linedata(i, 2);
    x = linedata(i, 4);   
    B(from, to) = -1/x;
    B(to, from) = B(from, to);
end

for i = 1:num_bus
    B(i, i) = -sum(B(i, :));
    if busdata(i, 2) == 1  % Slack bus
        P(i) = 0;
    else
        P(i) = busdata(i, 5) - busdata(i, 7);
    end
end

BI = inv(B);
% Menghitung sudut tegangan (theta) menggunakan metode DC power flow
theta = BI*P;

% Output hasil
disp('Bus | Theta (rad)');
disp(theta);

% Menampilkan hasil aliran daya pada tiap saluran
disp('Line Flow Results:');
for i = 1:num_line
    from = linedata(i, 1);
    to = linedata(i, 2);
    flow = (theta(from) - theta(to)) / linedata(i, 4);
    fprintf('Line %d-%d: %f MW\n', from, to, flow);
end
