util.AddNetworkString( "CFC_RunAutoClean" )

local IsValid = IsValid
local random = math.random

local ConVarFlags = { FCVAR_ARCHIVE }
local autocleanEnabled = CreateConVar( "cfc_autoclean_enabled", true, ConVarFlags, "Enables autoclean on the server." )
local autocleanInterval = CreateConVar( "cfc_autoclean_interval", 500, ConVarFlags, "Interval (in seconds) when the server will run autoclean commands." )
local autocleanClientNotify = CreateConVar( "cfc_autoclean_notification_enabled", true, ConVarFlags, "Enables the client-side notification autoclean uses." )
local autocleanPrefix = CreateConVar( "cfc_autoclean_prefix", "CFC Auto Clean", ConVarFlags, "The prefix autoclean uses when printing messages to clients." )

local messagesCount = #CFCAutoClean.clearingServerMessages

local function runCleanupCommandsOnPlayers()
    net.Start( "CFC_RunAutoClean" )
        net.WriteBool( autocleanClientNotify:GetBool() )
        net.WriteBool( autocleanPrefix:GetString() )
        net.WriteUInt( random( messagesCount ), 5 )
    net.Broadcast()
end

local function removeUnownedWeapons()
    local removedCount = 0
    local allEnts = ents.GetAll()

    for _, ent in ipairs( allEnts ) do
        if IsValid( ent ) then
            local isUnownedWeapon = ent:IsWeapon() and not IsValid( ent.Owner )

            if isUnownedWeapon then
                removedCount = removedCount + 1
                ent:Remove()
            end
        end
    end

    if removedCount == 0 then return end

    local pluralize = removedCount > 1 and "s" or ""
    local message = "Removed " .. tostring( removedCount ) .. " object" .. pluralize

    runCleanupCommandsOnPlayers( message )
end

local function runCleanupFunctions()
    if not autocleanEnabled:GetBool() then return end
    runCleanupCommandsOnPlayers()
    removeUnownedWeapons()
end
timer.Create( "CFC_AutoClean", autocleanInterval:GetInt(), 0, runCleanupFunctions )
