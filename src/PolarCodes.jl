module PolarCodes

include("Encode.jl")
include("Decode.jl")

N = 16;
K = 8;

message = rand(Bool, K);
println("Message: ", message);
codeword = encode(message, N);

end
