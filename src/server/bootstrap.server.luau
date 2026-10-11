--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Bootstrap = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Bootstrap"))

print(Bootstrap.message("Server"))
