function encoded_bits_packet_tx = func_conv_coding(bits_packet_tx)

    encoded_bits_packet_tx=zeros(length(bits_packet_tx)*2,1);
    
    % initial state
    state_0=0;
    state_1=0;
    
    A=[1 0 1];
    B=[1 1 1];
    
    for ind=1:length(bits_packet_tx)

        % encoded bits
        %=======================================================================
        % Write code here
        %=======================================================================
       
        % memory update
        %=======================================================================
        % Write code here
        %=======================================================================

    end
end
