function symbols_packet_tx = func_QPSK_modulation(encoded_bits_packet_tx)

    j=sqrt(-1);
    number_of_bits_per_symbol = 2;
    len= length(encoded_bits_packet_tx) / number_of_bits_per_symbol;
    
    symbols_packet_tx = zeros(len, 1);
    
    b00 = [0; 0];
    b01 = [0; 1];
    b10 = [1; 0];
    b11 = [1; 1];
    
    s00 = (1+j)/sqrt(2);
    s01 = (1-j)/sqrt(2);
    s10 = (-1+j)/sqrt(2);
    s11 = (-1-j)/sqrt(2);    
    
    for ind = 1 : len
    %=======================================================================  
    % Perform QPSK modulation (cf. PCM)
        % Adding a mapping from bit patterns to QPSK symbols
        bit_patterns = [b00 b01 b10 b11];
        symbols = [s00 s01 s10 s11];    

        sym_idx_start = (ind - 1) * number_of_bits_per_symbol + 1;
        sym_idx_end = ind * number_of_bits_per_symbol;
        bits = encoded_bits_packet_tx(sym_idx_start : sym_idx_end);

        for k = 1 : 4
            if isequal(bits, bit_patterns(:, k))
                symbols_packet_tx(ind) = symbols(k);
                break;
            end
        end
    %=======================================================================    
    end

end
