function data_array_rx = func_PCM_decoding(bit_stream_rx, bitsPerSample)

    len = length(bit_stream_rx)/bitsPerSample ;    
    data_array_rx = zeros(len, 1);
    
    for ind = 1 : len        
        
        bits = bit_stream_rx( (ind-1)* bitsPerSample +1: ind* bitsPerSample );
        %=======================================================================

        % If 'bitsPerSample' = n, 'pow2' is [2^(n-1) 2^(n-2) ... 2^1 2^0]
        pow2 = 2.^(bitsPerSample -1 : -1 : 0);

        % When MSB is 1, use 2's complement to make negative number
        bits(1) = -bits(1);

        % 'pow2' is 1 X 'bitsPerSample' matrix and 'bits' is 'bitsPerSample' X 1 matrix
        % Add 0.5 to cancel subtraction of 0.5 in func_PCM_coding.m
        value = pow2 * bits + 0.5;
        %=======================================================================
        
        data_array_rx(ind) = value/(2^(bitsPerSample-1)-0.5); % scaling to [-1,1]
        
    end
end