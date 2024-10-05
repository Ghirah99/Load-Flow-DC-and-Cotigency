clc
clear


Read_From_xls;
DCPowerFlow;
%Jumlah saluran pada sistem IEEE 14 bus
%OPEN ///////////////////////////Perhitungan theta
%CLOSE//////////////////////////Perhitungan theta
%OPEN //////////////////////////Perhitungan f0pq

Bonding = zeros(Jumlah_Bus, 10);


for i=1:Jumlah_Bus
    from_bus = linedata(i,1);
    to_bus = linedata(i,2);
    reaktansi = linedata(i,4);
    %Kolom ke 6 adalah nilai dari f0pq
    Bonding(i,1) = (theta(from_bus) - theta(to_bus))/(reaktansi);
end

%%%CLOSE /////////////////////Perhitungan f0pq
%%OPEN delta fpq max

for i=1:Jumlah_Bus
    reaktansi = linedata(i,4);
    MWLim = linedata(i,7);
    f0pq = Bonding(i,1);
    %Kolom 7 adalah nilai dari delta fpq max
    deltafpqmax = MWLim - f0pq;
    Bonding(i,2) = deltafpqmax;
end

%%%CLOSE delta fpq max
%%OPEN delta fpq max xpq

for i=1:Jumlah_Bus
    reaktansi = linedata(i,4);
    deltafpqmax = Bonding(i,2);
    %Kolom 8 adalah nilai dari delta fpq max xpq
    deltafpqmaxXpq = abs(deltafpqmax*reaktansi);
    Bonding(i,3) = deltafpqmaxXpq;
end

%CLOSE delta fpq max xpq
%OPEN

for i=1:Jumlah_Bus
    deltafpqmaxXpq = Bonding(i,3);
    %Kolom 9 adalah nilai terkecil dari deltafpqmaxXpq
    mindeltafpqmaxXpq = min(deltafpqmaxXpq);
    Bonding(:, 4) = mindeltafpqmaxXpq;
end

%%%CLOSE
%%OPEN

for i=1:Jumlah_Bus
    from_bus = linedata(i,1);
    to_bus = linedata(i,2);
    reaktansi = linedata(i,4);

    %Kolom 10 adalah nilai delta theta from bus

    Bonding(i,5) = ((X(from_bus,from_bus)-X(from_bus,to_bus))*reaktansi)/(reaktansi-(X(from_bus,from_bus)+X(to_bus,to_bus)-2*X(from_bus,to_bus)));
    %Kolom 11 adalah nilai delta theta to bus
    Bonding(i,6) = ((X(to_bus,from_bus)-X(to_bus,to_bus))*reaktansi)/(reaktansi-(X(from_bus,from_bus)+X(to_bus,to_bus)-X(from_bus,to_bus)));
end

%%CLOSE
%%OPEN delta theta

for i=1:Jumlah_Bus
    f0pq = Bonding(i,1);
    sensitivitas_1 = Bonding(i,5);
    sensitivitas_2 = Bonding(i,6);
    %Kolom ke 12 adalah nilai delta theta 1
    Bonding(i,7) = sensitivitas_1*f0pq;
    %Kolom ke 13 adalah nilai delta theta 2
    Bonding(i,8) = sensitivitas_2*f0pq;
    %Kolom ke 14 adalah nilai pengurangan
    Bonding(i,9) = abs(Bonding(i,7)-Bonding(i,8));
end

%%%CLOSE
%%OPEN validasi

for i=1:Jumlah_Bus
    mindeltafpqmaxXpq = Bonding(:, 4);
    if  Bonding(i,9)<mindeltafpqmaxXpq;
        Bonding(i,10) = 1;
    elseif Bonding(i,9)>mindeltafpqmaxXpq;
        Bonding(i,10) = 0;
    end
end

%% OPEN /////////////// Penenentuan aman tidaknya saluran////////////////%%

disp('>>Perhitungan step A (wilayah N-1 dan N-3 sama<<)')
disp('>>Nilai ?fpqmaxXpq adalah nilai di kolom 15<<')
disp(' ')
saluran_yang_lepas_N1 = input('- Masukan saluran N-1 yang lepas = saluran ');
saluran_wilayah_N3 = input('- Masukan saluran N-3 = saluran ');
if linedata(saluran_wilayah_N3,14)<linedata(saluran_wilayah_N3,9);
    disp('=>Saluran di subsistem N-2 aman dari overload ')
    program=0;
else
    disp('=>Saluran di subsistem N-2 mengalami overload lanjutkan ke stepB ')
    program=1;
    disp(' ')
end
while program==1
    disp('>>Perhitungan step B (wilayah N-3 diperluas)<<')
    disp(' ')
    saluran_yang_lepas_N1 = input('- Masukan saluran N-1 yang lepas = saluran');
    saluran_wilayah_N3 = input('- Masukan saluran N-3 = saluran');
    if linedata(saluran_wilayah_N3,14)<linedata(saluran_wilayah_N3,9);
        disp('=>Saluran di subsistem N-2 aman dari overload ')
        program=0;
    else
        disp('=>Saluran di subsistem N-2 mengalami overload perluas lagi wilayah N-3 ')
        program=1;
        disp(' ')
    end
    6
end
for i=1:Jumlah_Bus
    if ~(i==saluran_yang_lepas_N1)
        from_bus_kena = linedata(i,2);
        to_bus_kena = linedata(i,3);
        reaktansi_lepas = linedata(saluran_yang_lepas_N1,4);
        reaktansi_kena = linedata(i,4);
        from_bus_lepas = linedata(saluran_yang_lepas_N1,2);
        to_bus_lepas = linedata(saluran_yang_lepas_N1,3);
        base_flow_kena = abs(linedata(i,6));
        base_flow_lepas = abs(linedata(saluran_yang_lepas_N1,6));
        linedata(i,16) = (reaktansi_lepas/reaktansi_kena*...
            (X(from_bus_kena,from_bus_lepas)-...
            X(to_bus_kena,from_bus_lepas)-...
            X(from_bus_kena,to_bus_lepas)+...
            X(to_bus_kena,to_bus_lepas)))/(reaktansi_lepas-...
            X(from_bus_lepas,from_bus_lepas)+...
            X(to_bus_lepas,to_bus_lepas)-...
            2*(X(from_bus_lepas,to_bus_lepas)));
        faktor_d = linedata(i,16);
        linedata(i,17) = base_flow_kena + faktor_d*base_flow_lepas;
    end
end