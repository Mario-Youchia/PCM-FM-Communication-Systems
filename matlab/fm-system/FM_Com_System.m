clc
clear
close all

t = 0:1/1000:1-1/1000;
a = 2; %Carrier amplitude
fm = 10; %Message frequency
fc = 100; %Carrier frequency
m = cos(2*pi*fm*t);
m_b = tril(ones(length(m)));
m_c = m.*m_b;
sum_m = sum(m_c,2);
plot(t,a*cos(2*pi*fc*t+((100/fm)*2*pi*sum_m').*(1/1000)));
hold on
plot(t,m);
grid on
ylim([-3 3])
xlabel ('Time(s)');
ylabel ('Amplitude');
title('Message and Modulated Signal')
f = -1000/2:1:1000/2-1;
M = fftshift(fft(m));
S = fftshift(fft(a*cos(2*pi*fc*t+((100/fm)*2*pi*sum_m').*(1/1000))));
figure
plot(f,abs(M)/1000);
title('Frequency Domain Representation of the Signals')
plot(f,abs(S)/1000);
grid on
xlabel('Frequency (Hz)')
ylabel('Magnitude')
dem = diff(a*cos(2*pi*fc*t+((100/fm)*2*pi*sum_m').*(1/1000)));                 
dem = [0,dem];
r_lo = dem.*(cos(2*pi*fc*t));
[b,a] = butter(10,2*fc/1000);
r_flt = filter(b,a,r_lo);
R_flt = fftshift(fft(r_flt));
figure()
plot(f,abs(R_flt)/1000);
title('Frequency Representation of the Demodulated Signal')
xlabel('Frequency (Hz)')
ylabel('Magnitude')
grid on
figure()
plot(t,r_flt)
xlabel ('Time(s)');
ylabel ('Amplitude');
grid on
title('Demodulated Signal')