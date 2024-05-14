function data_array_rx = func_PCM_decoding(bit_stream_rx, bitsPerSample)

    len = length(bit_stream_rx)/bitsPerSample ;    
    data_array_rx = zeros(len, 1);
    
    for ind=1:len        
        
        bits = bit_stream_rx( (ind-1)* bitsPerSample +1: ind* bitsPerSample );
        %=======================================================================
        % Check MSB and decoding
        pow2 = 2.^(bitsPerSample -1 : -1 : 0);
        bits(1) = -bits(1);
        value = pow2 * bits + 0.5;
        %=======================================================================
        
        data_array_rx(ind) = value/(2^(bitsPerSample-1)-0.5); % scaling to [-1,1]
        
    end
end