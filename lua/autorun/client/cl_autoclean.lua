local cleanupCommands = {
    "r_cleardecals"
}

local prefixColor = Color( 41, 41, 41 )
local messageColor = Color( 190, 190, 190 )

net.Receive( "CFC_RunAutoClean", function()
    local shouldShowClientMessages = net.ReadBool()
    net.ReadString()
    local messageIndex = net.ReadUInt( 5 )
    local message = CFCAutoClean.clearingServerMessages[messageIndex]

    for _, command in ipairs( cleanupCommands ) do
        RunConsoleCommand( command )
    end

    if not shouldShowClientMessages then return end
    chat.AddText( prefixColor, "• ", messageColor, message )
end )
