function [recBits]=projectECE569Receiver(totalSignal,params,rxParams)

%% 1. Extract information from parameter structures
N = params.N;                      % number of symbols
bitsPerSym = params.bitsPerSym;    % number of bits in a symbol
numSamp = params.sampPerPulse;     % number of samples per pulse
pulsesPerSym = params.pulsePerSym; % number of pulses in a symbol
bitFileName = params.bitFileName;  % file name which contains the correct bits
                                   % for the purpose of computing the bit error
                                   % rate.

Fdes = rxParams.desiredFreq;
BWCoef = rxParams.BWcoef;
shapedPulse = rxParams.shapedPulse;
pulseEn = rxParams.pulseEn;

load(bitFileName)

%% 2. Down-convert the desired signal from the pass-band
downSeq = (0:(N*pulsesPerSym*numSamp-1))';

% The I samples are on the inphase carrier (the cosine), and the Q samples are
% on the quadrature carrier (the sine).
totalRecSignalI = totalSignal.*cos(2*pi*Fdes*downSeq);
totalRecSignalQ = totalSignal.*sin(2*pi*Fdes*downSeq);

totalRecSignalI = totalRecSignalI(rxParams.delay+1:end);
totalRecSignalQ = totalRecSignalQ(rxParams.delay+1:end);

M = 95;
h = firpm(M,[0 0.4 0.475 1],[1 1 0 0]);
hSpec = fft(h);

totalRecSignalI = conv2(totalRecSignalI,h','same');
totalRecSignalQ = conv2(totalRecSignalQ,h','same');

%% 3. Perform FSK demodulation, and build the array of decoded bits
recBits = [];
prevPhase = 0;

leftOver = length(totalRecSignalI);
k = 1;

while(leftOver > numSamp)
    
    currBatchI = totalRecSignalI(k:k+pulsesPerSym*numSamp-1,1);
    currBatchQ = totalRecSignalQ(k:k+pulsesPerSym*numSamp-1,1);
    
    phasePulse = [prevPhase;atan2(currBatchQ,currBatchI)];
    for n = 1:pulsesPerSym*numSamp
        while(phasePulse(n+1) - phasePulse(n) > pi)
            phasePulse(n+1) = phasePulse(n+1) - 2*pi;
        end
        
        while(phasePulse(n+1) - phasePulse(n) < -pi)
            phasePulse(n+1) = phasePulse(n+1) + 2*pi;
        end
    end
    
    freqPulse  = diff(phasePulse)/BWCoef/2/pi;
    detectedE  = freqPulse'*shapedPulse/pulseEn;
    prevPhase  = phasePulse(pulsesPerSym*numSamp+1);

    if((detectedE >= 0) && (detectedE < 1/2))
        recBits = [recBits ;0;0];
    elseif(detectedE > 1/2)
        recBits = [recBits ;0;1];
    elseif((detectedE < 0) && (detectedE >= -1/2))
        recBits = [recBits ;1;1];
    else
        recBits = [recBits ;1;0];
    end
    
    k = k + numSamp;
    leftOver = leftOver - numSamp;
end
desiredBits(length(recBits)+1:length(desiredBits))=0;
recBits(length(desiredBits))=0;
%% 4. Compute and display the bit error rate
bitErrRate = sum((recBits-desiredBits(1:length(recBits))).^2)/(length(recBits));
disp(['The Bit Error Rate (BER) = ' num2str(bitErrRate*100) '%']);
disp(' ');
