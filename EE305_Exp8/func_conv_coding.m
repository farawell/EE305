function encoded_bits_packet_tx = func_conv_coding(bits_packet_tx)

    % length of bits_packet_tx: 128
    % length of encoded_bits_packet_tx: 256

    encoded_bits_packet_tx=zeros(length(bits_packet_tx)*2,1);
    
    % initial state
    state_0 = 0;
    state_1 = 0;
    
    A = [1 0 1];
    B = [1 1 1];
    
    for ind = 1 : length(bits_packet_tx) 

        % encoded bits
        %=======================================================================
        inputBit = bits_packet_tx(ind);
        encoderState = [inputBit state_0 state_1];

        % Here, we use the following property:
        % A XOR B == mod(sum(A, B), 2)
        % A: bit, B: bit, we use double() to handle carrier
        output_1 = mod(sum(double(encoderState .* A)), 2);
        output_2 = mod(sum(double(encoderState .* B)), 2);
        
        % Fill in the output array
        start_idx = 2 * ind - 1;
        end_idx = 2 * ind;
        encoded_bits_packet_tx(start_idx : end_idx) = [output_1; output_2];
        %=======================================================================
       
        % memory update
        %=======================================================================
        % Queue data structure
        state_1 = state_0;
        state_0 = inputBit;
        %=======================================================================
    end
end
