close all; clear; clc;
M = 16;                 % Modulation order
k = log2(M);            % Bits per symbol
numSymPerFrame = 100000;   % Number of QAM symbols per frame 
ind=1;

for SNR = 0 : 2 : 10 % EsN0(dB), SNR for 16QAM: average value Eb=1,Es=4 (Eb=1,Es=2 for QPSK)
    % Initialization
    dataBit = randi([0 1],numSymPerFrame,k);
    dataSym = zeros(numSymPerFrame,1);
    txSig = zeros(numSymPerFrame,1);
    rxSig = zeros(numSymPerFrame,1);
    rxSym = zeros(numSymPerFrame,1);
    rxBit = zeros(numSymPerFrame,k);
    numSymErr=0;
    numBitErr=0;

    for i = 1 : numSymPerFrame
        % Bit to symbol
        if dataBit(i,1)==0 && dataBit(i,2)==0 && dataBit(i,3)==0 && dataBit(i,4)==0 % 0000
            dataSym(i) = -3;
        elseif dataBit(i,1)==0 && dataBit(i,2)==0 && dataBit(i,3)==0 && dataBit(i,4)==1 % 0001
            dataSym(i) = -2+j;
        elseif dataBit(i,1)==0 && dataBit(i,2)==0 && dataBit(i,3)==1 && dataBit(i,4)==0 % 0010
            dataSym(i) = -1+j*2;
        elseif dataBit(i,1)==0 && dataBit(i,2)==0 && dataBit(i,3)==1 && dataBit(i,4)==1 % 0011
            dataSym(i) = j*3;
        elseif dataBit(i,1)==0 && dataBit(i,2)==1 && dataBit(i,3)==0 && dataBit(i,4)==0 % 0100
            dataSym(i) = -2-j;
        elseif dataBit(i,1)==0 && dataBit(i,2)==1 && dataBit(i,3)==0 && dataBit(i,4)==1 % 0101
            dataSym(i) = -1;
        elseif dataBit(i,1)==0 && dataBit(i,2)==1 && dataBit(i,3)==1 && dataBit(i,4)==0 % 0110
            dataSym(i) = j;
        elseif dataBit(i,1)==0 && dataBit(i,2)==1 && dataBit(i,3)==1 && dataBit(i,4)==1 % 0111
            dataSym(i) = 1+j*2;
        elseif dataBit(i,1)==1 && dataBit(i,2)==0 && dataBit(i,3)==0 && dataBit(i,4)==0 % 1000
            dataSym(i) = -1-j*2;
        elseif dataBit(i,1)==1 && dataBit(i,2)==0 && dataBit(i,3)==0 && dataBit(i,4)==1 % 1001
            dataSym(i) = -j;
        elseif dataBit(i,1)==1 && dataBit(i,2)==0 && dataBit(i,3)==1 && dataBit(i,4)==0 % 1010
            dataSym(i) = 1;
        elseif dataBit(i,1)==1 && dataBit(i,2)==0 && dataBit(i,3)==1 && dataBit(i,4)==1 % 1011
            dataSym(i) = 2+j;
        elseif dataBit(i,1)==1 && dataBit(i,2)==1 && dataBit(i,3)==0 && dataBit(i,4)==0 % 1100
            dataSym(i) = -j*3;
        elseif dataBit(i,1)==1 && dataBit(i,2)==1 && dataBit(i,3)==0 && dataBit(i,4)==1 % 1101
            dataSym(i) = 1-j*2;
        elseif dataBit(i,1)==1 && dataBit(i,2)==1 && dataBit(i,3)==1 && dataBit(i,4)==0 % 1110
            dataSym(i) = 2-j;
        elseif dataBit(i,1)==1 && dataBit(i,2)==1 && dataBit(i,3)==1 && dataBit(i,4)==1 % 1111
            dataSym(i) = 3;
        end

        % Symbol to signal
        txSig(i)=dataSym(i);
        noise=sqrt(10^(-SNR/10)/2)*(randn+j*randn);
        rxSig(i)=txSig(i) + noise;

        % Signal judgement
        if real(rxSig(i)) + imag(rxSig(i)) < -2 && 2 < imag(rxSig(i)) - real(rxSig(i))
            rxSym(i) = 0;
            rxBit(i,1) = 0; rxBit(i,2) = 0; rxBit(i,3) = 0; rxBit(i,4) = 0;
        elseif -2 < real(rxSig(i)) + imag(rxSig(i)) && real(rxSig(i)) + imag(rxSig(i)) < 0 && 2 < imag(rxSig(i)) - real(rxSig(i))
            rxSym(i) = 1;
            rxBit(i,1) = 0; rxBit(i,2) = 0; rxBit(i,3) = 0; rxBit(i,4) = 1;
        elseif 0 < real(rxSig(i)) + imag(rxSig(i)) && real(rxSig(i)) + imag(rxSig(i)) < 2 && 2 < imag(rxSig(i)) - real(rxSig(i))
            rxSym(i) = 2;
            rxBit(i,1) = 0; rxBit(i,2) = 0; rxBit(i,3) = 1; rxBit(i,4) = 0;
        elseif 2 < real(rxSig(i)) + imag(rxSig(i)) && 2 < imag(rxSig(i)) - real(rxSig(i))
            rxSym(i) = 3;
            rxBit(i,1) = 0; rxBit(i,2) = 0; rxBit(i,3) = 1; rxBit(i,4) = 1;

        elseif real(rxSig(i)) + imag(rxSig(i)) < -2 && 0 < imag(rxSig(i)) - real(rxSig(i)) && imag(rxSig(i)) - real(rxSig(i)) < 2
            rxSym(i) = 4;
            rxBit(i,1) = 0; rxBit(i,2) = 1; rxBit(i,3) = 0; rxBit(i,4) = 0;
        elseif -2 < real(rxSig(i)) + imag(rxSig(i)) && real(rxSig(i)) + imag(rxSig(i)) < 0 && 0 < imag(rxSig(i)) - real(rxSig(i)) && imag(rxSig(i)) - real(rxSig(i)) < 2
            rxSym(i) = 5;
            rxBit(i,1) = 0; rxBit(i,2) = 1; rxBit(i,3) = 0; rxBit(i,4) = 1;
        elseif 0 < real(rxSig(i)) + imag(rxSig(i)) && real(rxSig(i)) + imag(rxSig(i)) < 2 && 0 < imag(rxSig(i)) - real(rxSig(i)) && imag(rxSig(i)) - real(rxSig(i)) < 2
            rxSym(i) = 6;
            rxBit(i,1) = 0; rxBit(i,2) = 1; rxBit(i,3) = 1; rxBit(i,4) = 0;
        elseif 2 < real(rxSig(i)) + imag(rxSig(i)) && 0 < imag(rxSig(i)) - real(rxSig(i)) && imag(rxSig(i)) - real(rxSig(i))< 2
            rxSym(i) = 7;
            rxBit(i,1) = 0; rxBit(i,2) = 1; rxBit(i,3) = 1; rxBit(i,4) = 1;

        elseif real(rxSig(i)) + imag(rxSig(i)) < -2 && -2 < imag(rxSig(i)) - real(rxSig(i)) && imag(rxSig(i)) - real(rxSig(i)) < 0
            rxSym(i) = 8;
            rxBit(i,1) = 1; rxBit(i,2) = 0; rxBit(i,3) = 0; rxBit(i,4) = 0;
        elseif -2 < real(rxSig(i)) + imag(rxSig(i)) && real(rxSig(i)) + imag(rxSig(i)) < 0 && -2 < imag(rxSig(i)) - real(rxSig(i)) && imag(rxSig(i)) - real(rxSig(i)) < 0
            rxSym(i) = 9;
            rxBit(i,1) = 1; rxBit(i,2) = 0; rxBit(i,3) = 0; rxBit(i,4) = 1;
        elseif 0 < real(rxSig(i)) + imag(rxSig(i)) && real(rxSig(i)) + imag(rxSig(i)) < 2 && -2 < imag(rxSig(i)) - real(rxSig(i)) && imag(rxSig(i)) - real(rxSig(i)) < 0
            rxSym(i) = 10;
            rxBit(i,1) = 1; rxBit(i,2) = 0; rxBit(i,3) = 1; rxBit(i,4) = 0;
        elseif 2 < real(rxSig(i)) + imag(rxSig(i)) && -2 < imag(rxSig(i)) - real(rxSig(i)) && imag(rxSig(i)) - real(rxSig(i)) < 0
            rxSym(i) = 11;
            rxBit(i,1) = 1; rxBit(i,2) = 0; rxBit(i,3) = 1; rxBit(i,4) = 1;

        elseif real(rxSig(i)) + imag(rxSig(i)) < -2 && imag(rxSig(i)) - real(rxSig(i)) < -2
            rxSym(i) = 12;
            rxBit(i,1) = 1; rxBit(i,2) = 1; rxBit(i,3) = 0; rxBit(i,4) = 0;
        elseif -2 < real(rxSig(i)) + imag(rxSig(i)) && real(rxSig(i)) + imag(rxSig(i)) < 0 && imag(rxSig(i)) - real(rxSig(i)) < -2
            rxSym(i) = 13;
            rxBit(i,1) = 1; rxBit(i,2) = 1; rxBit(i,3) = 0; rxBit(i,4) = 1;
        elseif 0 < real(rxSig(i)) + imag(rxSig(i)) && real(rxSig(i)) + imag(rxSig(i)) < 2 && imag(rxSig(i)) - real(rxSig(i)) < -2
            rxSym(i) = 14;
            rxBit(i,1) = 1; rxBit(i,2) = 1; rxBit(i,3) = 1; rxBit(i,4) = 0;
        elseif 2 < real(rxSig(i)) + imag(rxSig(i)) && imag(rxSig(i)) - real(rxSig(i)) < -2
            rxSym(i) = 15;
            rxBit(i,1) = 1; rxBit(i,2) = 1; rxBit(i,3) = 1; rxBit(i,4) = 1;
        end
        
        % Bit error detection
        for x = 1 : k
            if dataBit(i,x) ~= rxBit(i,x)
                numBitErr=numBitErr+1;
            end
        end

        % Symbol error detection
        if (8*dataBit(i,1) + 4*dataBit(i,2) + 2*dataBit(i,3) + dataBit(i,4)) ~= rxSym(i) 
            numSymErr=numSymErr+1;
        end
    end

    berEst(ind)=numBitErr/(numSymPerFrame*k);
    serEst(ind)=numSymErr/(numSymPerFrame);
    ind=ind+1;
end

% BER / SNR
figure()
semilogy([0:2:10],berEst,'*-');
grid on;
legend('Estimated QPSK BER');
xlabel('SNR (dB)');
ylabel('BER');

% SER / SNR
figure()
semilogy([0:2:10],serEst,'*-');
grid on;
legend('Estimated QPSK SER');
xlabel('SNR (dB)');
ylabel('SER');

% Constellation
figure()
plot(real(rxSig),imag(rxSig),'rx'); hold on; grid on;
plot(real(txSig),imag(txSig),'b*'); 
axis([-5,5,-4,4])