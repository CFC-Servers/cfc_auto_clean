local cleanupCommands = {
    "r_cleardecals"
}

local cleanupCommandsCount = #cleanupCommands

local grey = Color( 175, 175, 175 )
local white = Color( 255, 255, 255 )

net.Receive( "CFC_RunAutoClean", function()
    local idx = net.ReadUInt( 8 )
    local message = CFCAutoClean.clearingServerMessages[idx]

    for i = 1, cleanupCommandsCount do
        local command = cleanupCommands[i]
        RunConsoleCommand( command )
    end

    chat.AddText( grey, "[", white, "CFC AutoClean", grey, "]", white, message )
end )
