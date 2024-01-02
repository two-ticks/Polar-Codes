module PolarCodes

include("Encode.jl")
include("Decode.jl")

N = 16;
K = 8;

message = Int.(rand(Bool, K));
println("Message: ", message);
codeword = encode(message, N);
println("Codeword: ", codeword);

end