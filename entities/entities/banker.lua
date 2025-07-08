AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Banker"
ENT.Author = "Tiamat_Defender"
ENT.Category = "Tiamats Bank System"
ENT.Purpose = "Allows Players to store money in a bank."
ENT.Spawnable = true

if SERVER then
    function ENT:Initialize()
        if SERVER then
            self:SetModel("models/suits/male_09_open.mdl")
            self:PhysicsInit( SOLID_VPHYSICS )
            self:SetMoveType( MOVETYPE_VPHYSICS )
            self:SetSolid( SOLID_VPHYSICS )
            local phys = self:GetPhysicsObject()
            if phys:IsValid() then
                phys:Wake()
            end
            self:ResetSequence("idle_all_01")
            self:SetPlaybackRate(1)
            self.NextUseTime = 0
        end
    end

    function ENT:Use(activator)
    --One second cooldown.
    if CurTime() < self.NextUseTime then return end
    self.NextUseTime = CurTime() + 1

    if IsValid(activator) and activator:IsPlayer() then
        local character = activator:GetCharacter()
        if not character then return end
        net.Start("ixgetbankmenu")
            net.WriteBool(character:GetData("isaccountopen", false))
            net.WriteInt(character:GetData("bankbalance", 0), 32)
        net.Send(activator)
    end
end

end

if not CLIENT then return end

function ENT:Draw()
    self:DrawModel()
end
