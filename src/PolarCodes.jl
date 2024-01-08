module PolarCodes

include("Encode.jl")
include("Decode.jl")

N = 16;
K = 8;

rate = K/N;
EbN0dB = 5;
EbN0 = 10^(EbN0dB/10);
σ = sqrt(1/(2*rate*EbN0));

message = Int.(rand(Bool, K));
println("Message: ", message);
codeword = encode(message, N);
println("Codeword: ", codeword);

## BPSK Modulation
modulatedCodeword = 1 .- 2 .* codeword;
# println("Modulated Codeword: ", modulatedCodeword);
receivedCodeword = modulatedCodeword + σ * randn(N); # AWGN Channel

decodedMessage = decode(receivedCodeword, K);

end