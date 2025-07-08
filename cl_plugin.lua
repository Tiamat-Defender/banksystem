if CLIENT then
net.Receive("ixgetbankmenu", function(len, ply)
    local hasaccount = net.ReadBool()
    local balance = net.ReadInt(32)
    local player = net.ReadPlayer()

    local Frame = vgui.Create("DFrame")
    Frame:Center()
    Frame:SetSize(300, 150)
    Frame:SetTitle("Banker")
    Frame:SetDraggable(false)
    Frame:ShowCloseButton(true)
    Frame:MakePopup()

    local WelcomeLabel = vgui.Create("DLabel", Frame)
    WelcomeLabel:SetPos(118, 0)
    WelcomeLabel:SetText("Peoples Bank")
    WelcomeLabel:SizeToContents()

    if hasaccount then
        local AccountBalance = vgui.Create("DLabel", Frame)
        AccountBalance:SetPos(118, 28)
        AccountBalance:SetText("Account Balance: $" .. balance)
        AccountBalance:SizeToContents()

        local AmountEntry = vgui.Create("DTextEntry", Frame)
        AmountEntry:SetPos(108, 56)
        AmountEntry:SetSize(104, 19)
        AmountEntry:SetPlaceholderText("Amount")

        AmountEntry.OnChange = function(self)
            local text = self:GetText()
            local filtered = text:gsub("[^0-9]", "")
            if text ~= filtered then
                self:SetText(filtered)
                self:SetCaretPos(#filtered)
            end
        end

        local DepositButton = vgui.Create("DButton", Frame)
        DepositButton:SetText("Deposit")
        DepositButton:SetPos(108, 78)
        DepositButton:SetSize(51, 17)
        DepositButton:SetTextColor(Color(0, 255, 0))
        DepositButton.DoClick = function()
            local amount = tonumber(AmountEntry:GetValue()) or 0
            if amount > 0 then
                net.Start("ixdeposit")
                    net.WritePlayer(player)
                    net.WriteInt(amount, 32)
                net.SendToServer()
                balance = balance + amount
                AccountBalance:SetText("Account Balance: $" .. balance)
                AccountBalance:SizeToContents()
            end
        end

        local WithdrawButton = vgui.Create("DButton", Frame)
        WithdrawButton:SetText("Withdraw")
        WithdrawButton:SetPos(161, 78)
        WithdrawButton:SetSize(51, 17)
        WithdrawButton:SetTextColor(Color(255, 0, 0))
        WithdrawButton.DoClick = function()
            local amount = tonumber(AmountEntry:GetValue()) or 0
            if amount > 0 then
                net.Start("ixwithdraw")
                    net.WritePlayer(player)
                    net.WriteInt(amount, 32)
                net.SendToServer()
            end
            balance = balance - amount
            AccountBalance:SetText("Account Balance: $" .. balance)
            AccountBalance:SizeToContents()
        end

        local CloseAccount = vgui.Create("DButton", Frame)
        CloseAccount:SetText("Close Account")
        CloseAccount:SetPos(116, 99)
        CloseAccount:SetSize(86, 19)
        CloseAccount:SetTextColor(Color(255, 0, 0))
        CloseAccount.DoClick = function()
            net.Start("ixclosebankaccount")
                net.WritePlayer(player)
            net.SendToServer()
            Frame:Close()
        end
    else
        local NoAccountLabel = vgui.Create("DLabel", Frame)
        NoAccountLabel:SetPos(78, 32)
        NoAccountLabel:SetText("You Dont Have An Account!")
        NoAccountLabel:SizeToContents()


        local OpenAccount = vgui.Create("DButton", Frame)
        OpenAccount:SetText("Open Account")
        OpenAccount:SetPos(118, 65)
        OpenAccount:SetSize(86, 19)
        OpenAccount:SetTextColor(Color(0, 255, 0))
        OpenAccount.DoClick = function()
            net.Start("ixopenbankaccount")
                net.WritePlayer(player)
            net.SendToServer()
            Frame:Close()
        end
    end
end)
end