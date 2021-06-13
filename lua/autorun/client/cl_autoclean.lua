local cleanupCommands = {
    "r_cleardecals"
}

local cleanupCommandsCount = #cleanupCommands

net.Receive( "CFC_RunAutoClean", function()
    local idx = net.ReadUInt( 8 )
    local message = CFCAutoClean.clearingServerMessages[idx]

    for i = 1, cleanupCommandsCount do
        local command = cleanupCommands[i]
        RunConsoleCommand( command )
    end

    LocalPlayer():ChatPrint( message )
end )
