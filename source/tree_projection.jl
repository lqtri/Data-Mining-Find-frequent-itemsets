include("support_function.jl")

# Cấu trúc cây gồm tập cha và các tập con được phát sinh thêm 1 item từ tập cha
struct Tree
    itemset :: Vector{String}
    children :: Vector{Tree}
end

# In các tập phổ biến theo DFS
function DepthTreeTraversal(tree::Tree)
    if isempty(tree.children)
        return
    end
    for child in tree.children
        global counter += 1
        println(child.itemset)
        DepthTreeTraversal(child)
    end
end  

# Thêm các itemset lên cây
function addItemSetOnTree(tree::Tree,one_itemset)
    if length(tree.itemset)==length(one_itemset)
        return
    end

    new_children = combination(tree.itemset,one_itemset)
    for child in new_children
        new_node = Tree(child,[])
        push!(tree.children,new_node)
        addItemSetOnTree(new_node,one_itemset)
    end
end

# Tỉa các nhánh không phổ biến (không thỏa minSup)
function pruningTree(tree::Tree, data, N, minSup)
    if isempty(tree.children)
        return 
    end

    index = 1
    n = length(tree.children)
    while index <= n
        if countSupport(tree.children[index].itemset,data)/N<minSup
            deleteat!(tree.children,index)
            n -= 1
            continue
        end
        pruningTree(tree.children[index],data,N,minSup)
        index += 1
    end
end   

# Thuật toán Tree Projection
function TreeProjection(data,minSup)
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

    ItemsetTree = Tree([],[])
    addItemSetOnTree(ItemsetTree,one_itemset)
    pruningTree(ItemsetTree,data,num_of_transaction,minSup)
    
    return ItemsetTree
end