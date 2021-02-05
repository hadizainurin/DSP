//Reading the input of the sound
clc;clear;
cd ("C:\Users\User\Desktop\Important\DSP\Assignment6");
[y, fs, bits] = wavread("message.wav");

/* To plot te graph to get the cutoff frequency
//Clipping the original signal
n=length(y)
N=n/2;
x=(fs/2)/N;
y1=[0:x:((fs/2)-x)];
Y=fft(y); //Convert to frequency domain

clf(); //clear figure
subplot(3,1,1);
title("Original signal with noise")
ylabel ("Amplitude");
xlabel ("Frequency (Hz)");
plot2d(y1,abs(Y(1:N)/N)); //Clipping the original signal with noise
*/

//Time axis for the continuoues signal (not necessary to take this signal)
//tmin = 0; tmax = 1;
//t = linspace(tmin,tmax,256) //Scilab has 256 linearly spaced points between 0 to 1, so we limit it to 256
//Not working so different method is used down below

//Using te cutoff frequency we obtained from the previous assignment A5 & A6 which were 240 & 2010
cfreq1 = 260 //cutoff freq 1
cfreq2 = 2010 //cutoff freq2
N = 21; //21-point filter
//Therefore with M + 1
M = N - 1; //Result in 20 filter order
freqt1 = cfreq1/fs; //Transition Frequecy 1
freqt2 = cfreq2/fs; //Transition Frequency 2

//FIR Filtering in time domain = multiplication of fft in freq domain

n = (1:N);
//windows function from w12 (we are using rect function with hamm)
/*
  h_Rect = 1;
  h_hann = 0.5-0.5*cos(2*%pi*(n-1)/(M-1));
  h_hamm = 0.54-(0.46*cos((2*%pi*n)/M));
  h_balckmann = 0.42-0.5*cos(2*%pi*n/(M-1))+0.08*cos(4*%pi*n/(M-1));
*/
h_hamm = 0.42-0.5*cos(2*%pi*n/(M-1))+0.08*cos(4*%pi*n/(M-1)); //The Hamming Windows Function equation
h_hann = 0.5-0.5*cos(2*%pi*(n-1)/(M-1));

//Low Pass (lp) with cutoff frequency 1
[f1lp] = filt_sinc(N,freqt1);
lpf_windows1 =  (f1lp .*h_hann);

//Low Pass filter with cutoff freq 2 
[f2lp] = filt_sinc(N,freqt1);
lpf_windows2 =  (f2lp .*h_hamm);
//Perform spectral inversion for high pass filter
f2hp =- lpf_windows2;
//Add to center
f2hp(11) = f2hp(11) + 1; //To center the symmetry the sample must be even

//Form single-stage band-reject filter using lw pass and high pass filter
x1 = lpf_windows1 + f2hp;
bandreject_padding = cat(2,x1, zeros(1,7979)) //Pad the signal 7979
Bpad = abs(fft(bandreject_padding)) //linear magnitude
Blog = 20*log10(Bpad) //logarithmic

yfiltered = convol(x1, y ) //convoluted to filter the signal
//plot 

subplot(2,3,1)
plot(n,lpf_windows1,"o-")
title("Hanning Window Filter")
xlabel("frequency")
ylabel("Amplitude")

subplot(2,3,2)
plot(n,lpf_windows2,"o-")
title("Hamming Window Filter")
xlabel("n")
ylabel("Amplitude")

subplot(2,3,3)
plot(n,f2hp,"o-")
title("Highpass Filter")
xlabel("n")
ylabel("Amplitude")

subplot(2,3,4)
plot(n,x1,"o-")
title("Band reject filter")
xlabel("n")
ylabel("Amplitude")

subplot(2,3,5)
plot(Bpad(1:fs/2),'b')
title(" Linear Magnitude of the Windowed-Sinc Filter");
set(gca(), 'grid', [0 1]*color('gray'));
xlabel("Frequency(Hz)")
ylabel('Magnitude')

subplot(2,3,6)
plot(Blog(1:fs/2),'b')
title(" Logarithmic Magnitude of the Windowed-Sinc Filter");
set(gca(), 'grid', [0 1]*color('gray'));
xlabel("Frequency(Hz)")
ylabel('Magnitude')

//Testing and generating the sound wave
playsnd(yfiltered, fs); //Is possible to improve the filter performance through double band-reject filter instead of single filter
wavwrite(yfiltered, fs, "C:\Users\User\Desktop\Important\DSP\Assignment7\newfiltermessage.wav")
