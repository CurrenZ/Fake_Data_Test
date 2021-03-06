mSignalID = fopen('meditation.txt', 'r');
lSignalID = fopen('lightsource_Large_Amplitude.txt', 'r');
filteredID = fopen('filteredSignal.txt', 'r');

formatSpec = '%f';

mSignal = fscanf(mSignalID, formatSpec);
lSignal = fscanf(lSignalID, formatSpec);
filteredSignal = fscanf(filteredID, formatSpec);

fclose(mSignalID);
fclose(lSignalID);
fclose(filteredID);

mixedSignal = (mSignal * (10^(-6/20)) + lSignal * (10^(-6/20)));
%mixedSignal = mSignal + lSignal;
%mixedSignal = round(mixedSignal * 100)/100;

cSignal = czConvolution(mSignal, lSignal);
cSignal = cSignal';

mSignalFT = fft(mSignal);
%mSignalFT = abs(mSignalFT);
f = 0:250/length(mSignalFT):250;
f = f';
fakeSignalFT = mSignalFT;
fakeSignalFT(1501) = 50*fakeSignalFT(1501);
fakeSignal = ifft(fakeSignalFT);
fakeSignal = real(fakeSignal);

[mSpectrum_psdx, mFreq] = powerSpectrum(mSignal, 250);
[mixedSpectrum_psdx, mixedFreq] = powerSpectrum(mixedSignal, 250);
%cSpectrum_psdx = powerSpectrum(cSignal);
[fakeSpectrum_psdx, fakeFreq] = powerSpectrum(fakeSignal, 250);
[filtered_psdx, filteredFreq] = powerSpectrum(filteredSignal, 250);


function [psdx, freqT] = powerSpectrum(x, ffss)
rng default;
Fs = ffss;
t = 0:1/Fs:1-1/Fs;

N = length(x);
xdft = fft(x);
xdft = xdft(1:N/2+1);
psdx = (1/(Fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = 0:Fs/length(x):Fs/2;
freqT = freq';
%plot(freq,10*log10(psdx))
%grid on
%title('Periodogram Using FFT')
%xlabel('Frequency (Hz)')
%ylabel('Power/Frequency (dB/Hz)')
end


function ccc = czConvolution(x, h)
x = x';
h = h';
m = length(x);
n = length(h);
X = [x, zeros(1, n)];
H = [h, zeros(1, m)];
for i=1:n+m-1
    Y(i) = 0;
    for j=1:m
        if (i-j+1>0)
            Y(i) = Y(i)+X(j)*H(i-j+1);
        else
        end
    end
end
ccc = Y;
end





















