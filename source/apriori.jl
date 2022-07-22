include("support_function.jl")

# Thuật toán Apriori
function Apriori(data, minSup)
    one_itemset = []   #Lưu các 1-itemset 
    eliminated = []     #Lưu các 1-itemset dưới minSup

    num_of_transaction = length(data)
    for transaction in data
        for i in transaction
            # Các 1-itemset chưa được thêm vào tập itemset[] và chưa bị loại sẽ được tiếp tục xét minSup
            if i ∉ one_itemset && i ∉ eliminated
                if countSupport([i],data)/num_of_transaction>=minSup
                    push!(one_itemset,i)
                else
                    push!(eliminated,i)
                end
            end
        end
    end

    freq_itemset::Vector{Vector{String}} = []

    # Chuyển các vector các item phổ biến thành từng tập phổ biến riêng lẻ và đưa vào tập phổ biến
    for i in one_itemset
        push!(freq_itemset,[i])
    end

    index = 2
    n = length(one_itemset)
    Ck = deepcopy(freq_itemset)
    Ck_1 = deepcopy(freq_itemset)

    # Phát sinh các itemset, kiểm tra độ support của chúng và thêm vào tập phổ biến nếu thỏa minSup
    while index<=n
        Ck = generate_candidate(Ck_1,one_itemset)
        temp = []   # Vector lưu lại các k-itemset thỏa minSup để phát sinh các (k+1)-itemset
        for iset in Ck
            if countSupport(iset,data)/num_of_transaction>=minSup
                push!(freq_itemset,iset)
                push!(temp,iset)
            end
        end
        Ck_1 = deepcopy(temp)
        index += 1
    end
    return freq_itemset
end