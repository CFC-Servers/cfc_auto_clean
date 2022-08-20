util.AddNetworkString( "CFC_RunAutoClean" )

local IsValid = IsValid
local random = math.random
local rawget = rawget

local ConVarFlags = { FCVAR_ARCHIVE }
local autocleanEnabled = CreateConVar( "cfc_autoclean_enabled", 1, ConVarFlags, "Enables autoclean on the server." )
local autocleanInterval = CreateConVar( "cfc_autoclean_interval", 500, ConVarFlags, "Interval (in seconds) when the server will run autoclean commands." )
local autocleanClientNotify = CreateConVar( "cfc_autoclean_notification_enabled", 1, ConVarFlags, "Enables the client-side notification autoclean uses." )
local autocleanPrefix = CreateConVar( "cfc_autoclean_prefix", "CFC Auto Clean", ConVarFlags, "The prefix autoclean uses when printing messages to clients." )

cvars.AddChangeCallback( "cfc_autoclean_interval", function( _, _, value )
    timer.Adjust( "CFC_AutoClean", tonumber( value ) )
end )

local messagesCount = #CFCAutoClean.clearingServerMessages

local function runCleanupCommandsOnPlayers()
    net.Start( "CFC_RunAutoClean" )
        net.WriteBool( autocleanClientNotify:GetBool() )
        net.WriteString( autocleanPrefix:GetString() )
        net.WriteUInt( random( messagesCount ), 5 )
    net.Broadcast()
end

local function removeUnownedWeapons()
    local removedCount = 0
    local allEnts = ents.GetAll()
    local entsCount = #allEnts

    for i = 1, entsCount do
        local ent = rawget( allEnts, i )

        if IsValid( ent ) then
            local isUnownedWeapon = ent:IsWeapon() and not IsValid( ent.Owner )

            if isUnownedWeapon then
                removedCount = removedCount + 1
                ent:Remove()
            end
        end
    end
end

local function runCleanupFunctions()
    if not autocleanEnabled:GetBool() then return end
    runCleanupCommandsOnPlayers()
    removeUnownedWeapons()
end
timer.Create( "CFC_AutoClean", autocleanInterval:GetInt(), 0, runCleanupFunctions )
