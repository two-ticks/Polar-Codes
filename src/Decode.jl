
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
        nodePosition = (2^depth - 1) + node + 1 # position of node in node state vector
        if nodeState[nodePosition] == 0
            Ln = L[depth+1, nodePosition]
        else
            if nodeState[nodePosition] == 1
                L[depth+1, nodePosition] = L[depth, nodePosition]
            else
                L[depth+1, nodePosition] = 1 - L[depth, nodePosition]
            end
        end
    end
    return decodedMessage
end