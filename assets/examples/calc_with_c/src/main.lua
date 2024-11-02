function main()
    local x = get_arg_number(2)
    if not x then
        print("arg 2 not passed or its not a number")
        return
    end
    local operator = get_operator()
    if not operator then
        print("operator not passed or is invalid ")
        return
    end
    local y = get_arg_number(4)
    if not y then
        print("arg 2 not passed or its not a number")
        return
    end
    if operator == "+" then
        print(x + y)
    end
    if operator == "-" then
        print(x - y)
    end
    if operator == "*" then
        print(x * y)
    end
    if operator == "/" then
        print(x / y)
    end
end