local cleanupCommands = {
    "r_cleardecals"
}

net.Receive( "CFC_RunAutoClean", function()
    local message = net.ReadString()

    for _, command in ipairs( cleanupCommands ) do
        RunConsoleCommand( command )
    end

    LocalPlayer():ChatPrint( message )
end )
