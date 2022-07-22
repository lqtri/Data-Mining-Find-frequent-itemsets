include("apriori.jl")
include("tree_projection.jl")
include("support_function.jl")

function main()
    data_files = ["foodmart.txt", "mushrooms.txt", "chess.txt", "retail.txt"]
    println("Chọn 1 trong các tập dữ liệu để chạy:
            1-foodmart.txt
            2-mushrooms.txt
            3-chess.txt
            4-retail.txt")

    print("Chọn tập dữ liệu (nhập số nguyên từ 1 - 4): ")
    index = readline()
    index = parse(Int64, index)
    if index>4 || index <1
        println("Không tồn tại tập dữ liệu")
        return 
    end

    print("Nhập minsup: ")
    minSup = readline()
    minSup = parse(Float64,minSup)
    if minSup>1 || minSup<=0
        println("minsup không hợp lệ")
        return
    end

    println("\nXét tập dữ liệu: ", data_files[index])
    println("Khai thác các tập phổ biến với minSup = ", minSup)
    
    data = readData("data/"*data_files[index])

    #----------Apriori----------
    println("\nApriori")
    @time  apriori = Apriori(data,minSup)

    if isempty(apriori)
        println("Không có tập phổ biến nào thỏa minSup")
    else
        printItemsets(apriori)
        println("Số tập phổ biến là: ",length(apriori))
    end

    #------Tree Projection------
    global counter = 0
    println("\nTree Projection")
    @time tree_projection = TreeProjection(data,minSup)

    if isempty(tree_projection.children)
        println("Không có tập phổ biến nào thỏa minSup")
    else
        DepthTreeTraversal(tree_projection)
        println("Số tập phổ biến là: ",counter)
    end
end

main()
