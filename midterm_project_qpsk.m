close all; clear; clc;
M = 4;                 % Modulation order
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
        if dataBit(i,1)==0 && dataBit(i,2)==0
            dataSym(i)=1;
        elseif dataBit(i,1)==0 && dataBit(i,2)==1
            dataSym(i)=j;
        elseif dataBit(i,1)==1 && dataBit(i,2)==0
            dataSym(i)=-1;
        elseif dataBit(i,1)==1 && dataBit(i,2)==1
            dataSym(i)=-j;
        end
        
        % Symbol to signal
        txSig(i)=dataSym(i);
        noise=sqrt(10^(-SNR/10)/2)*(randn+j*randn);
        rxSig(i)=txSig(i) + noise;

        % Signal judgement
        if real(rxSig(i)) - imag(rxSig(i)) > 0 && real(rxSig(i)) + imag(rxSig(i)) > 0
            rxSym(i) = 0;
            rxBit(i,1) = 0; rxBit(i,2) = 0;
        elseif real(rxSig(i)) - imag(rxSig(i)) < 0 && real(rxSig(i)) + imag(rxSig(i)) > 0
            rxSym(i) = 1;
            rxBit(i) = 0; rxBit(i,2) = 1;
        elseif real(rxSig(i)) - imag(rxSig(i)) < 0 && real(rxSig(i)) + imag(rxSig(i)) < 0
            rxSym(i) = 2;
            rxBit(i) = 1; rxBit(i,2) = 0;
        elseif real(rxSig(i)) - imag(rxSig(i)) > 0 && real(rxSig(i)) + imag(rxSig(i)) < 0
            rxSym(i) = 3;
            rxBit(i) = 1; rxBit(i,2) = 1;
        end

        % Bit error detection
        for x = 1 : k
            if dataBit(i,x) ~= rxBit(i,x)
                numBitErr=numBitErr+1;
            end
        end

        % symbol error detection
        if (2*dataBit(i,1) + dataBit(i,2)) ~= rxSym(i) 
            numSymErr=numSymErr+1;
        end
    end

    berEst(ind)=numBitErr/(numSymPerFrame*k);
    serEst(ind)=numSymErr/(numSymPerFrame);
    ind = ind+1;
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
axis([-3,3,-2,2])