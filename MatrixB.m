% Parameter Sistem
num_bus = size(busdata, 1);
num_line = size(linedata, 1);

% Matrices
B = zeros(num_bus);
P = zeros(num_bus, 1);
%% Membuat matriks B (susceptance) dan matriks P (power)
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
X=B;

for i = 1:num_bus
       if busdata(i, 2) == 1  % Slack bus
        P(i) = 0;
    else
        P(i) = (busdata(i, 7) - busdata(i, 5))/100;
    end
end