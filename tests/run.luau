--!strict

local Bootstrap = require("../src/shared/Bootstrap")

assert(
	Bootstrap.message("Server") == "[StealTheHouse] Server bootstrap ready; shared module loaded.",
	"server startup must identify its context and confirm the shared module loaded"
)
assert(
	Bootstrap.message("Client") == "[StealTheHouse] Client bootstrap ready; shared module loaded.",
	"client startup must identify its context and confirm the shared module loaded"
)

for _, context in { "", "Unknown" } do
	local ok, message = pcall(Bootstrap.message, context)
	assert(not ok, "invalid bootstrap contexts must fail instead of reporting success")
	assert(
		string.find(tostring(message), "bootstrap context must be Server or Client", 1, true),
		"invalid bootstrap contexts must explain the failure"
	)
end

print("PASS: shared bootstrap messages and invalid-context assertions")
