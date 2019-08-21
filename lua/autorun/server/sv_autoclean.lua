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

local clearingServerMessages = {
    "[CFC - AutoClean] Scrubbing the ethernet..",
    "[CFC - AutoClean] Dusting the heatsinks..",
    "[CFC - AutoClean] Applying more thermal paste..",
    "[CFC - AutoClean] Tidying..",
    "[CFC - AutoClean] Replacing internet juice..",
    "[CFC - AutoClean] Washing threads..",
    "[CFC - AutoClean] Cleaning forks..",
    "[CFC - AutoClean] Downloading more RAM..",
    "[CFC - AutoClean] Updating drivers..",
    "[CFC - AutoClean] Installing more antivirus..",
    "[CFC - AutoClean] Brushing teeth..",
    "[CFC - AutoClean] Cleaning behind the ears..",
    "[CFC - AutoClean] Vacuuming..",
    "[CFC - AutoClean] Taking vitamins..",
    "[CFC - Antibullying] Calling moms..",
    "[CFC - Antiminge] Removing users..",
    "[CFC - Crimial] Stealing copies of phatmania..",
    "[CFC - Raincore] Soaking your builds..",
    "[CFC - Minecraftcore] removing legokidlogans minecraft e2..",
    "[CFC - Anticheat] Removing RadioJackal..",
    "[CFC - Antispam] Removing chat..",
    "[CFC - Antimicspam] Removing voicechat..",
    "[CFC - Robostaff] Banning all humans..",
    "[CFC - Spartan] Deleting boats..",
    "[CFC - Minecraft] Commencing crash..",
    "[CFC - Phatcore] Removing minges..",
    "[CFC - Antiphatcore] Commencing dazzling..",
    "[CFC - Awards] Handing MetaKnight award for having lemon cat..",
    "[CFC - Piracy] Downloading pirated phatmania..",
    "[CFC - Antirdm] Calling admins..",
    "[CFC - Musiccore] Purchasing phatmania album..",
    "[CFC - Fashion] Purchasing phatso merchandise..",
    "[CFC - Mingecore] Spawning emitters..",
    "[CFC - Chefcore] Burning the food..",
    "[CFC - Chefcore] Consulting Gordon Ramsay..",
    "[CFC - Discordmanager] Removing permissions.."
}

local function getClearingServerMessage()
    return table.Random( clearingServerMessages )
end

local function runCleanupCommandsOnPlayers()
    for command, _ in pairs( clientCleanupCommands ) do
        net.Start( "CFC_AutoClean_RunCommand" )
        net.WriteString( command )
        net.Broadcast()
    end

    notificationMsg = getClearingServerMessage()

    notifyPlayers( notificationMsg )
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
