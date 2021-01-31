b = 4; //Number of bits
N = 120; //Number of samples
n = 0:N-1;  //Index
x = sin(((2*%pi)*n)/N);  //Sine function
x = mtlb_i(x,x>=1,1-%eps); 
xq = floor((x+1)*(2^(b-1)));
xq = xq/(2^(b-1));
xq = xq-(2^(b)-1)/2^(b);
xe = x-xq ; //Quantization error
plot(x,"b"); 
plot(xq,"r"); 
plot(xe,"g");
hl = legend(['Original Signal';'Quantized Signal';'Quantizing Error']);
