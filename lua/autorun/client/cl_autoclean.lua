local cleanupCommands = {
    "r_cleardecals"
}

local grey = Color( 175, 175, 175 )
local white = Color( 255, 255, 255 )

net.Receive( "CFC_RunAutoClean", function()
    local shoudShowClientMessages = net.ReadBool()
    local messagePrefix = net.ReadString()
    local messageIndex = net.ReadUInt( 5 )
    local message = CFCAutoClean.clearingServerMessages[messageIndex]

    for _, command in ipairs( cleanupCommands ) do
        RunConsoleCommand( command )
    end

    if not shoudShowClientMessages then return end
    chat.AddText( grey, "[", white, messagePrefix, grey, "]", white, message )
end )
