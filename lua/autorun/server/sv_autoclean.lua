util.AddNetworkString( "CFC_AutoClean_RunCommand" )

local ConVarFlags = {FCVAR_ARCHIVE, FCVAR_NOTIFY}
local DEFAULT_CLEAN_INTERVAL_IN_SECONDS = "500"
CreateConVar("cfc_autoclean", DEFAULT_CLEAN_INTERVAL_IN_SECONDS, ConVarFlags, "Autocleans the server based on seconds given")

local clientCleanupCommands = {
    ["r_cleardecals"] = true,
    ["stopsound"] = true
}

local function notifyPlayers( notification )
    local message = "[CFC_Autoclean] " .. notification

    print( message )

    for _, ply in pairs( player.GetHumans() ) do
        ply:ChatPrint( message )
    end
end

local function runCleanupCommandsOnPlayers()
    for command, _ in pairs( clientCleanupCommands ) do
        net.Start( "CFC_AutoClean_RunCommand" )
        net.WriteString( command )
        net.Broadcast()
    end

    notifyPlayers( "Cleaning server..." )
end

local function removeUnownedWeapons()
    local removedCount = 0

    for _, entity in pairs( ents.GetAll() ) do
        if not IsValid( entity ) then continue end

        local isUnownedWeapon = entity:IsWeapon() and not IsValid( entity.Owner )
        
        if isUnownedWeapon then
            removedCount = removedCount + 1
            entity:Remove()
        end
    end
    
    local message = "Removed " .. tostring( removedCount ) .. " objects."
    notifyPlayers( message )
end

local function runCleanupFunctions()
    runCleanupCommandsOnPlayers()
    removeUnownedWeapons()
end

timer.Create( "CFC_AutoClean", GetConVar( "cfc_autoclean" ):GetInt(), 0, runCleanupFunctions )

hook.Remove( "APG_lagDetected", "CFC_CleanOnLag" )
hook.Add( "APG_lagDetected", "CFC_CleanOnLag", runCleanupFunctions )
