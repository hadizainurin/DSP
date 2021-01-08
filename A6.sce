//Plot the graph
clf(); //clear figure
subplot(3,1,1);
title("Original signal with noise")
ylabel ("Amplitude");
xlabel ("Frequency (Hz)");
plot2d(y1,abs(Y(1:N)/N)); //Clipping the original signal with noise

//Designing the Single-band Filter
for i=1 :length(t)
    if y1(i)>290 && y1(i)<2010; //frequency range for single band-reject ideal filter
        H(i)=0;
        Y(i)=Y(i)*H(i); //Reject bandwidth or H = 0
    else 
        H(i)=1; 
        Y(i)=Y(i)*H(i); //Accept Bandwidth or H = 1
    end
end

filter_noise= ifft(Y(1:N))
//Plot the single band-reject filter
subplot(3,1,2) 
plot2d(y1,H(1:N))
title("Single Band-reject ideal filter")
xlabel("Frequency (Hz)")
ylabel("Amplitude")
subplot(3,1,3) 

//Plot the impulse response
plot2d(impulse_response)
title("Impulse Response")
xlabel("Frequency (Hz)")
ylabel("Amplitude")
impulse_response=ifft(H)

//Testing and generating the sound wave
playsnd(filter_noise, fs); //Is possible to improve the filter performance through double band-reject filter instead of single filter
wavwrite(filter_noise, fs, "C:\Users\User\Desktop\Important\DSP\Assignment6\originalmessage.wav")
