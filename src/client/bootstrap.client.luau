--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Bootstrap = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Bootstrap"))

print(Bootstrap.message("Client"), "Player:", Players.LocalPlayer.Name)
