
function f(a, b)
    return (1 .- 2 .* (a .< 0)) .* (1 .- 2 .* (b .< 0)) .* min.(abs.(a), abs.(b))
end

function g(a, b, c)
    return b .+ (1 .- 2 .* c) .* a
end

function decode(receivedCodeword, K)
    N = length(receivedCodeword)
    L = zeros(Int(log2(N) + 1), N)
    nodeState = zeros(1, 2 * N - 1)

    L[1, 1:N] = receivedCodeword # belief of root node

    node = 0
    depth = 0
    done = false

    while !done
        # leaf node
        if depth == log2(N)
            
        else
            nodePosition = (2^depth - 1) + node + 1 # position of node in node state vector
            if nodeState[nodePosition] == 0
                temp = 2^(log2(N) - depth)
                Ln = L[depth+1, temp * node + 1:temp * (node + 1)] # belief of node
                a  = Ln[1:temp/2]
                b  = Ln[temp/2 + 1:end]
                node = node * 2; depth += 1; # go to left child
                temp = temp / 2;
                L[depth+1, temp * node + 1:temp * (node + 1)] = f(a, b) # min-sum 
                nodeState[nodePosition] = 1
            else
                if nodeState[nodePosition] == 1

                    L[depth+1, nodePosition] = L[depth, nodePosition]
                else
                    L[depth+1, nodePosition] = 1 - L[depth, nodePosition]
                end
            end
        end
    end
    return decodedMessage
end