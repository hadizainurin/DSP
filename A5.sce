//Reading the input of the sound
cd ("C:\Users\User\Desktop\Important\DSP\Assignment6");
[y, fs, bits] = wavread("message.wav");

//Test signal plot
//Y = fft(y); 
//plot (abs(Y)); //Results too big
//Not suitable, we look for different method

//Clipping the original signal
n = length(y);
N = n/2; //Half of the signal' 
x = (fs/2)/N; //Remember we only want half of the frequency components of the signal 
y1 = 0:x:((fs/2)-x); //for wave
Y = fft(y); //applying fft
clf(); //clear figure
subplot(3,1,1);
title("Original signal with noise")
ylabel ("Amplitude");
xlabel ("Frequency (Hz)");
plot2d(y1,abs(Y(1:N)/N)); //Clipping the original signal with noise

//From the result we obtained, now lets perform noise cancellation at the peak freq 300 & 2000
k = 0:1/fs:(length(y)/fs-1/fs);
noise_1 = (0.35)*(sin(2*%pi*300*k+%pi));  //The peak 1 noise
noise_2 = (0.35)*(sin(2*%pi*2000*k+%pi)); //The peak 2 noise
noise_cancellation = y + noise_1 + noise_2; //Noise cancellation
noise_FFT = fft(noise_cancellation); //Apply fft to noise
subplot (3,1,2);
plot2d(y1,abs(noise_FFT(1:N)/N));
title("Signal without noise")
ylabel ("Amplitude");
xlabel ("Frequency (Hz)");
//This will generate signal without noise

//Return to the time domain (just use function ifft)
Audio_NoiseSubtracted = ifft(noise_FFT);
subplot (3,1,3);
title("Signal without noise in time domain")
plot2d(Audio_NoiseSubtracted,y);
ylabel ("Amplitude");
xlabel ("Time");

//Testing and generating the sound wave
playsnd(Audio_NoiseSubtracted, fs);
wavwrite(Audio_NoiseSubtracted, fs, "C:\Users\User\Desktop\Important\DSP\Assignment6\originalmessage.wav")
