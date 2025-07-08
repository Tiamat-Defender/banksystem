-- Server strings
--util.AddNetworkString("ixopenbankmenu")
util.AddNetworkString("ixopenbankaccount")
util.AddNetworkString("ixclosebankaccount")
util.AddNetworkString("ixwithdraw")
util.AddNetworkString("ixdeposit")

-- Client string
util.AddNetworkString("ixgetbankmenu")

net.Receive("ixopenbankaccount", function(len, ply)
    local player = ply
    local character = player:GetCharacter()

    if not character then
        player:Notify("An issue occurred. Please try again.")
        return
    end

    if character:GetData("isaccountopen", false) then
        player:Notify("You already have an open account.")
        return
    end

    local balance = character:GetMoney()
    if balance < 500 then
        player:Notify("You need at least 500 dollars to open an account.")
        return
    end

    character:SetMoney(balance - 500)
    character:SetData("isaccountopen", true)
    character:SetData("bankbalance", 0)

    player:Notify("You opened a bank account!")
end)

net.Receive("ixclosebankaccount", function(len, ply)
    local player = ply
    local character = player:GetCharacter()

    if not character then
        player:Notify("An error has occurred. Please try again.")
        return
    end

    if not character:GetData("isaccountopen", false) then
        player:Notify("You don't have a bank account open!")
        return
    end

    local balance = character:GetMoney()
    local bankBalance = character:GetData("bankbalance", 0)

    character:SetData("isaccountopen", false)
    character:SetData("bankbalance", 0)
    character:SetMoney(balance + bankBalance)

    player:Notify("Your account has been closed and your money has been returned!")
end)

net.Receive("ixdeposit", function(len, ply)
    local player = ply
    local amount = net.ReadInt(32)

    local character = player:GetCharacter()
    if not character then return end

    if not character:GetData("isaccountopen", false) then
        player:Notify("You don't have a bank account!")
        return
    end

    local money = character:GetMoney()
    if money < amount then
        player:Notify("You lack the funds for this deposit.")
        return
    end

    character:SetMoney(money - amount)
    local currentBank = character:GetData("bankbalance", 0)
    character:SetData("bankbalance", currentBank + amount)

    player:Notify("You have deposited $" .. amount .. " into your bank account!")
end)

net.Receive("ixwithdraw", function(len, ply)
    local player = ply
    local amount = net.ReadInt(32)

    local character = player:GetCharacter()
    if not character then return end

    local bankBalance = character:GetData("bankbalance", 0)
    if bankBalance < amount then
        player:Notify("You lack the funds to withdraw!")
        return
    end

    character:SetData("bankbalance", bankBalance - amount)
    local money = character:GetMoney()
    character:SetMoney(money + amount)

    player:Notify("You have withdrawn $" .. amount .. " from your bank account!")
end)