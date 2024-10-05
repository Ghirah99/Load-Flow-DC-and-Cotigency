% clc
% clear
% Read_From_xls;
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

%% Membuat matriks B (susceptance) dan matriks P (power)
% for i = 1:num_line
%     from = linedata(i, 1);
%     to = linedata(i, 2);
%     x = linedata(i, 4);   
%     B(from, to) = -1/x;
%     B(to, from) = B(from, to);
% end
for k = 1:num_line
    from_bus = linedata(k, 1);
    to_bus = linedata(k, 2);
    reactance = linedata(k, 4);
    
    susceptance = 1 / reactance;  % Susceptance B = 1/X
    
    % Off-diagonal elements
    B(from_bus, to_bus) = -susceptance;
    B(to_bus, from_bus) = -susceptance;
    
    % Diagonal elements
    B(from_bus, from_bus) = B(from_bus, from_bus) + susceptance;
    B(to_bus, to_bus) = B(to_bus, to_bus) + susceptance;
end

for i = 1:num_bus
    B(i, i) = -sum(B(i, :));
    if busdata(i, 2) == 1  % Slack bus
        P(i) = 0;
    else
        P(i) = busdata(i, 5) - busdata(i, 7);
    end
end

X = inv(B);
%% Menghitung sudut tegangan (theta) menggunakan metode DC power flow
theta = X*P;

% % Output hasil
% disp('Bus | Theta (rad)');
% disp(theta);
fprintf('SOLUTION:\n');
 fprintf('Angles in radians on the bus voltage phasors are:\n'); 
 for i=1:num_bus
      fprintf('teta%.d  =  %.4f rad   (%.4f degres)  \n',i,theta(i),rad2deg(theta(i)));
 end

%% Menampilkan hasil aliran daya pada tiap saluran
disp('Line Flow Results:');
for i = 1:num_line
    from = linedata(i, 1);
    to = linedata(i, 2);
    flow = (theta(from) - theta(to)) / linedata(i, 4);
    fprintf('Line %d-%d: %f MW\n', from, to, flow);
end
