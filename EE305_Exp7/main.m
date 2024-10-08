%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Matlab Script                 %
%       EE305, Lab 7 & 8              %
%       Spring 2024                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The file 'voice.mat' includes a 20-second long piece of speech sampled at
% 8kHz under the matlab array named 'data' with values contained in [-1,1].

% Our goal in labs 7 & 8 are to perform
%  1. Perform PCM waveform encoding from matlab array 'data'
%  2. Perform QPSK modulation and demodulation
%  3. Perform convoluational encoding and decoding
%  4. Assess voice quality for different SNR values

% Clear the workspace & Command window
clear all;
clc;

% Basic settings
j = sqrt(-1);
f_sample = 8000;  % samples per second
bitsPerSample = 3; % PCM coding parameter
block_size = 128;  % number of bits per packet
EbNo_array_dB = [0:2:10]; % [0 2 4 6 8 10]


%%%%%%%%%%%%% Load the data
load music;
plot(data); % check data
disp('data size')
size(data)

data_array_rx = zeros(size(data)); % Initialization

%%%%%%%%%%%%% PCM Waveform encoding
bit_stream_tx = func_PCM_coding(data, bitsPerSample); 
%%%% Insert script:  Use 8bit O2C offset 2's complement binary scheme 
%%%% to represent a value x[n], where -1 <= x[n] <= 1
%%%% data => s[n]
disp('size of bit_stream_tx')
size(bit_stream_tx)

number_of_packets = length(bit_stream_tx) / block_size; % block_size = 128

% Initialization
bit_stream_rx = zeros(length(bit_stream_tx),1); 
BER = zeros(length(EbNo_array_dB),1);
BER_theo = zeros(length(EbNo_array_dB),1);

% Iterate 6 times for each dB (EbNo_array_dB)
for iebno = 1 : length(EbNo_array_dB)
    EbNo_dB=EbNo_array_dB(iebno);
    EbNo_dB;
    EbNo = 10^(0.1*EbNo_dB);
    % Calcuate signal gain and noise variance from EbNo:  
    % Eb/No = 0.5 Es/No = 0.5 * gain^2/No;                                                  
    % sigma^2 = No/2
    %=======================================================================
    gain = 1;
    sigma = sqrt(0.5*(0.5*gain^2/EbNo));
    %======================================================================= 
    
    for ipacket = 1 : number_of_packets

        %%%%%%%%%%%%% Take a packet from bit_stream_tx
        % Extract a packet from bit_stream_tx
        start_idx = (ipacket - 1) * block_size + 1;
        end_idx = ipacket * block_size;
        
        % Ensure indices are valid
        if end_idx > length(bit_stream_tx)
            error('End index exceeds the length of bit_stream_tx.');
        end
        
        % Extract the ipacket-th packet
        bits_packet_tx = bit_stream_tx(start_idx : end_idx);
        
        %%%%%%%%%%%%% Convolutional Channel Coding(Exp 8)
        %encoded_bits_packet_tx = func_conv_coding(bits_packet_tx);
        encoded_bits_packet_tx =  bits_packet_tx;    

        %%%%%%%%%%%%% QPSK modulation
        % generate symbol_block of complex symbols with unit magnitude
        symbols_packet_tx = func_QPSK_modulation(encoded_bits_packet_tx);        

        %%%%%%%%%%%%% AWGN and Receiver
        %=======================================================================
        % Get the size of the input symbols packet
        arr_size = size(symbols_packet_tx);  

        % Generate complex Gaussian noise
        AWGN = sigma * (randn(arr_size) + 1j * randn(arr_size));

        % Add noise to the transmitted symbols to simulate the received symbols
        symbols_packet_rx = symbols_packet_tx + AWGN;
        %=======================================================================
        
        %%%%%%%%%%%%% Hard-decision QPSK demodulation
        received_bits_packet_rx = func_QPSK_demodulation(symbols_packet_rx);    
        
        %%%%%%%%%%%%% Convolutional Decoding
        %decoded_bits_packet_rx = func_conv_decoding(received_bits_packet_rx);
        decoded_bits_packet_rx = received_bits_packet_rx;        
        
        %%%%%%%%%%%%% Reconstruct the whole file
        bit_stream_rx(start_idx : end_idx) = decoded_bits_packet_rx;
    end
    
    %=======================================================================
    % For each Eb/No, compute empirical and theoretical BER
    BER_theo(iebno) = erfc(sqrt(EbNo))/2;
    BER(iebno) = sum(xor(bit_stream_rx, bit_stream_tx))/length(bit_stream_tx);

    %=======================================================================

    % PCM decoding and replay the sound
    disp('bit stream rx size')
    size(bit_stream_rx)
    data_array_rx = func_PCM_decoding(bit_stream_rx,bitsPerSample); %added
    sum(abs(data - data_array_rx)) %added 
    plot(data_array_rx)

    % generate sound using the array 'data' with 8kHz sampling rate with 8 bit resolution.
    sound(data_array_rx,8000); 
 
    disp('paused after one iebno iteration')
    pause
   
end   

%% plot BER
figure (1)
semilogy(EbNo_array_dB,BER,'--x') %added
hold on 
grid on
semilogy(EbNo_array_dB,BER_theo,'-o') %added 
xlabel('Eb/No [dB]');
ylabel('BER');
legend('BER', 'BER-theo')
