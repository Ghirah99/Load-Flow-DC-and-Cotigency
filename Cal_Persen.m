function persen = Cal_Persen(nilai, total)
    % Fungsi untuk menghitung nilai persentase
    % Input:
    %   nilai: nilai yang ingin dihitung persentasenya
    %   total: total nilai sebagai pembagi
    % Output:
    %   persen: nilai persentase
    
    % Validasi input
    if total == 0
        error('Total tidak boleh nol.');
    end
    
    % Hitung persentase
    persen = (nilai / total) * 100;
    
    % Tampilkan hasil
    % fprintf('Persentase: %.2f%%\n', persen);
end
