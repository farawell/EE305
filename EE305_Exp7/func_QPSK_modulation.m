function symbols_packet_tx = func_QPSK_modulation(encoded_bits_packet_tx)

    j=sqrt(-1);
    number_of_bits_per_symbol = 2;
    len= length(encoded_bits_packet_tx)/number_of_bits_per_symbol;
    
    symbols_packet_tx = zeros(len,1);
    
    b00 = [0; 0];
    b01 = [0; 1];
    b10 = [1; 0];
    b11 = [1; 1];
    
    s00 = (1+j)/sqrt(2);
    s01 = (1-j)/sqrt(2);
    s10 = (-1+j)/sqrt(2);
    s11 = (-1-j)/sqrt(2);    
    
    for ind=1:len
    %=======================================================================  
    % Perform QPSK modulation (cf. PCM)
        bits = encoded_bits_packet_tx((ind-1)*number_of_bits_per_symbol + 1 : ind * number_of_bits_per_symbol);
        if bits == b00
            symbols_packet_tx(ind) = s00;
        elseif bits == b01
            symbols_packet_tx(ind) = s01;
        elseif bits == b10
            symbols_packet_tx(ind) = s10;
        elseif bits == b11
            symbols_packet_tx(ind) = s11;
        end
    %=======================================================================    
    end

end