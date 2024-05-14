function bit_stream_tx = func_PCM_coding(data, bitsPerSample)

    bit_stream_tx = zeros(length(data)*bitsPerSample,1);
    bits = zeros(bitsPerSample,1);


    % Convert the data to digital signal
    for ind = 1 : length(data)
        value = data(ind);  % Each data value ranges from -1 to 1
        % Scale value to [-2^(bitsPerSample-1)-0.5, 2^(bitsPerSample-1)-0.5]
        value = (2^(bitsPerSample-1)-0.5) * value; % scaling
        
        %=======================================================================
        %PCM coding

        % Round down the variable 'value'
        flr = floor(value);

        % When 'flr' is negative (2's complement)
        if (flr < 0)
            flr = flr + 2^(bitsPerSample);
        end

        % Convert each elements in 'flr' to binary number
        bits = de2bi(flr, bitsPerSample, 'left-msb');
        %=======================================================================
        
        % Save the converted binary number in bit_stream_tx array
        bit_stream_tx( (ind-1)* bitsPerSample +1: ind* bitsPerSample ) = bits;
       
    end
end