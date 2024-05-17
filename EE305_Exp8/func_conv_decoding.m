function decoded_bits_packet_rx = func_conv_decoding(received_bits_packet_rx)
    
    decoded_bits_packet_rx = zeros(length(received_bits_packet_rx)/2,1);

    % V_n = path metric to state n(decimal)
    V0 = 0; V1 = 0; V2 = 0; V3 = 0;    
    M0 = []; M1 = []; M2 = []; M3 = []; % Pre-allocate the memory

    for ind = 1 : length(decoded_bits_packet_rx)
        % extract a pair of received bits in each iteration
        codeword = received_bits_packet_rx(2 * ind - 1 : 2 * ind);
        % metric_ab = branch metric when input = a(0 or 1), current state = b(decimal)
        metric_00 = sum(double(codeword ~= [0; 0]));
        metric_01 = sum(double(codeword ~= [1; 1]));
        metric_02 = sum(double(codeword ~= [0; 1]));
        metric_03 = sum(double(codeword ~= [1; 0]));
        metric_10 = sum(double(codeword ~= [1; 1]));
        metric_11 = sum(double(codeword ~= [0; 0]));
        metric_12 = sum(double(codeword ~= [1; 0]));
        metric_13 = sum(double(codeword ~= [0; 1]));

        % initial state is 00
        % available next states are 00 and 10
        if ind == 1
            V0 = metric_00;
            M0 = [0];
            V2 = metric_10;
            M2 = [1];
        else
            %% only one case possible to reach each state when ind == 2
            if ind == 2
                V0_t = V0 + metric_00;
                M0_t = [M0; 0];
                V1_t = V2 + metric_02;
                M1_t = [M2; 0];
                V2_t = V0 + metric_10;
                M2_t = [M0; 1];
                V3_t = V2 + metric_12;
                M3_t = [M2; 1];
            else
                % Compute path metric for each state
                %=======================================================================
                % path_mn = path metric from state m to state n
                % candidates for previous state of state 00 : 00, 01
                path_00 = V0 + metric_00;
                path_10 = V1 + metric_01;
                [V0_t, i0] = min([path_10, path_00]);

                % candidates for previous state of state 01 : 10, 11
                path_21 = V2 + metric_02;
                path_31 = V3 + metric_03;
                [V1_t, i1] = min([path_21, path_31]);

                % candidates for previous state of state 10 : 00, 01
                path_02 = V0 + metric_10;
                path_12 = V1 + metric_11;
                [V2_t, i2] = min([path_02, path_12]);

                % candidates for previous state of state 11 : 10, 11
                path_23 = V2 + metric_12;
                path_33 = V3 + metric_13;
                [V3_t, i3] = min([path_23, path_33]);

                %=======================================================================
                M0_t = [M1 * (i0 == 1) + M0 * (i0 == 2); 0];
                M1_t = [M2 * (i1 == 1) + M3 * (i1 == 2); 0];
                M2_t = [M0 * (i2 == 1) + M1 * (i2 == 2); 1];
                M3_t = [M2 * (i3 == 1) + M3 * (i3 == 2); 1];
            end
            V0 = V0_t; M0 = M0_t;
            V1 = V1_t; M1 = M1_t;
            V2 = V2_t; M2 = M2_t;
            V3 = V3_t; M3 = M3_t;
        end
    end
% Find the decoder output by comparing the final path metrics
%=======================================================================
% Write code here
[~, idx] = min([V0, V1, V2, V3]);


% choosing most likely path and saving it in decoded_bits_packet_rx
switch idx
    case 1, decoded_bits_packet_rx = M0;
    case 2, decoded_bits_packet_rx = M1;
    case 3, decoded_bits_packet_rx = M2;
    case 4, decoded_bits_packet_rx = M3;
end
%=======================================================================    
end