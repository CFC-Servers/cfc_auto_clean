local cleanupCommands = {
    "r_cleardecals"
}

net.Receive( "CFC_RunAutoClean", function()
    message = net.ReadString()

    for _, command in pairs( cleanupCommands ) do
        RunConsoleCommand( command )
    end

    LocalPlayer():ChatPrint( message )
end )
