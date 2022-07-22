#Biến global dùng để đếm số itemset phổ biến
counter = 0

# Hàm đọc dữ liệu từ filename
function readData(filename)
    lines = readlines(filename)
    data = []
    for line in lines
        push!(data,split(line))
    end
    return data 
end

# Hàm xuất các tập phổ biến ra màn hình
function printItemsets(itemset)
    for i in itemset
        println(i)
    end
end

# Hàm đếm số lượng support của itemset trên bộ dữ liệu, thực chất là đếm số giao tác mà itemset có mặt trong đó
function countSupport(i,data)
    count = 0
    for transaction in data
        if issubset(i,transaction)
            count += 1
        end
    end
    return count
end

# Tìm vị trí phần tử bắt đầu thích hợp trong tập 1-itemset để phát sinh dữ liệu (tránh bị trùng lặp)
function findCombinationPoint(itemset,one_itemset)
    if isempty(itemset)
        return 1
    else
        return findfirst(isequal(last(itemset)), one_itemset)+1
    end
end

# Hàm phát sinh thêm 1 item cho 1 itemset, trả về một tập các itemset mới
function combination(itemset,one_itemset)
    new_itemset = []
    combination_point = findCombinationPoint(itemset,one_itemset)

    for i in combination_point:length(one_itemset)
        tmp = deepcopy(itemset)
        item = one_itemset[i]
        if item ∉ tmp
            push!(tmp,item)
            push!(new_itemset,tmp)           
        end
    end
    return new_itemset
end

# Hàm phát sinh tập itemset mới mà các itemset có k phần tử từ tập các itemset mà các itemset có k-1 phần tử
function generate_candidate(itemset,one_itemset)
    k_itemset = []
    for i in itemset
        new_itemset = combination(i,one_itemset)
        for j in new_itemset
            push!(k_itemset,j)
        end
    end
    return k_itemset
end