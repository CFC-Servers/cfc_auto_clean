local isAllowedCommand = {
    ["stopsound"] = true,
    ["r_cleardecals"] = true
}

local function notifyPlayer( notification )
    local message = "[CFC_AutoClean] " .. notification

    print( message )
end

net.Receive( "CFC_AutoClean_RunCommand", function() 
    local command = net.ReadString()

    if isAllowedCommand[command] then
        notifyPlayer( "The server is running '" .. command .. "' on your client.." )
        RunConsoleCommand( command )
    end
end)
