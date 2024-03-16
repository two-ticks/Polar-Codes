function f(a, b)
    return (1 .- 2 .* (a .< 0)) .* (1 .- 2 .* (b .< 0)) .* min.(abs.(a), abs.(b))
end

function g(a, b, c)
    return b .+ (1 .- 2 .* c) .* a
end

function decode(receivedCodeword, K::Int)
    N = length(receivedCodeword)
    L = zeros(Int(log2(N) + 1), N)
    nodeState = zeros(1, 2 * N - 1)
    n::Int = log2(N)


    frozenBits = Q[1:N-K]
    L[1, 1:N] = receivedCodeword # belief of root node
    u_hat = zeros(Int, n + 1, N)

    node::Int = 0
    depth::Int = 0
    done = false
    # temp::Int = 0

    while !done
        # leaf node
        if depth == n

            if any(frozenBits .== node + 1) # check if node is a frozen bit
                u_hat[depth+1, node+1] = 0
            else
                if L[depth+1, node+1] >= 0
                    u_hat[depth+1, node+1] = 0
                else
                    u_hat[depth+1, node+1] = 1
                end
            end

            if node == N - 1
                done = true
            else
                node = floor(Int, node / 2)
                depth -= 1 # go to parent
            end

        else
            # non-leaf node
            nodePosition = (2^depth - 1) + node + 1 # position of node in node state vector
            if nodeState[nodePosition] == 0
                temp = 2^(n - depth)
                Ln = L[depth+1, temp*node+1:temp*(node+1)] # belief of node
                a = Ln[1:Int(temp / 2)]
                b = Ln[Int(temp / 2)+1:end]
                node = node * 2
                depth += 1 # go to left child
                temp = Int(temp / 2)
                L[depth+1, temp*node+1:temp*(node+1)] = f(a, b) # min-sum 
                nodeState[nodePosition] = 1
            else
                if nodeState[nodePosition] == 0 # left child
                    temp = 2^(n - depth)
                    Ln = L[depth+1, temp*node+1:temp*(node+1)] # belief of node
                    a = Ln[1:Int(temp / 2)]
                    b = Ln[Int(temp / 2)+1:end]

                    node = node * 2
                    depth += 1 # go to left child
                    temp = Int(temp / 2)
                    L[depth+1, temp*node+1:temp*(node+1)] = f(a, b) # min-sum
                    nodeState[nodePosition] = 1
                else
                    if nodeState[nodePosition] == 1 # right child
                        temp = 2^(n - depth)
                        Ln = L[depth+1, temp*node+1:temp*(node+1)] # belief of node
                        a = Ln[1:Int(temp / 2)]
                        b = Ln[Int(temp / 2)+1:end]

                        leftNode = 2 * node
                        leftDepth = depth + 1
                        leftTemp = Int(temp / 2)
                        u_hat_n = u_hat[leftDepth+1, leftTemp*leftNode+1:leftTemp*(leftNode+1)]
                        node = node * 2 + 1
                        depth += 1 # go to right child
                        temp = Int(temp / 2)
                        L[depth+1, temp*node+1:temp*(node+1)] = g(a, b, u_hat_n) # min-sum
                        nodeState[nodePosition] = 2
                    else
                        temp = 2^(n - depth)
                        leftNode = 2 * node
                        rightNode = 2 * node + 1
                        cdepth = depth + 1
                        ctemp = Int(temp / 2)
                        u_hatLeft = u_hat[cdepth+1, ctemp*leftNode+1:ctemp*(leftNode+1)]
                        u_hatRight = u_hat[cdepth+1, ctemp*rightNode+1:ctemp*(rightNode+1)]
                        u_hat[depth+1, temp*node+1:temp*(node+1)] = [mod.(u_hatLeft + u_hatRight, 2) u_hatRight]
                        node = floor(Int, node / 2)
                        depth -= 1 # go to parent 
                    end
                end
            end
        end
    end

    QN = Q[Q.<=N]
    return u_hat[n+1, QN[N-K+1:end]]
end


function successiveCancellationDecode(receivedCodeword, K::Int, L::Int, crcPoly)
    


end