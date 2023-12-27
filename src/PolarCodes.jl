module PolarCodes

include("Encode.jl")
include("Decode.jl")

N = 16;
K = 8;

message = rand(Bool, K);
codeword = encode(message, N);

end 
