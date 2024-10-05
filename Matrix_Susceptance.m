% Define the number of buses
%Jumlah Bus
num_buses = Jumlah_Bus;

% Define line data: [From Bus, To Bus, Reactance (X)]
linedata;
    

% Initialize the susceptance matrix B with zeros
B = zeros(num_buses);

% Fill the susceptance matrix B
numlines = size(linedata, 1);

for k = 1:numlines
    from_bus = linedata(k, 1);
    to_bus = linedata(k, 2);
    reactance = linedata(k, 3);
    
    susceptance = 1 / reactance;  % Susceptance B = 1/X
    
    % Off-diagonal elements
    B(from_bus, to_bus) = -susceptance;
    B(to_bus, from_bus) = -susceptance;
    
    % Diagonal elements
    B(from_bus, from_bus) = B(from_bus, from_bus) + susceptance;
    B(to_bus, to_bus) = B(to_bus, to_bus) + susceptance;
end

% Display the susceptance matrix
% fprintf('The susceptance matrix B (in p.u.) is:\n');
% disp(B);
