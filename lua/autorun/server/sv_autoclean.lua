util.AddNetworkString( "CFC_RunAutoClean" )
local rawget = rawget
local IsValid = IsValid

local messageCount = #CFCAutoClean.clearingServerMessages
local ConVarFlags = {FCVAR_ARCHIVE, FCVAR_NOTIFY}
local DEFAULT_CLEAN_INTERVAL_IN_SECONDS = "500"
local autocleanInterval = CreateConVar( "cfc_autoclean", DEFAULT_CLEAN_INTERVAL_IN_SECONDS, ConVarFlags, "Autocleans the server based on seconds given" )

local random = math.random
local messagesCount = #CFCAutoClean.clearingServerMessages

local function runCleanupCommandsOnPlayers()
    net.Start( "CFC_RunAutoClean" )
        net.WriteUInt( random( messagesCount ), 8 )
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

    if removedCount == 0 then return end

    local message = "Removed " .. tostring( removedCount ) .. " object"

    if removedCount > 1 then message = message .. "s" end

    runCleanupCommandsOnPlayers( message )
end

local function runCleanupFunctions()
    runCleanupCommandsOnPlayers()
    removeUnownedWeapons()
end

timer.Create( "CFC_AutoClean", autocleanInterval:GetInt(), 0, runCleanupFunctions )
