--[[
-- TODO: Find a way to get this type of structure to work
-- Ideally we'd have one place that both the client and server can read the clientside commands

CFC = CFC or {}

local AutoClean = {}

local ClientCommands = {}
ClientCommands["r_cleardecals"] = true
ClientCommands["stopsound"] = true

AutoClean.ClientCommands = ClientCommands
CFC.AutoClean = AutoClean
--]]
