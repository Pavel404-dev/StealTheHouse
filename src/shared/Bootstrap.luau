--!strict

local Bootstrap = {}

function Bootstrap.message(context: string): string
	assert(context == "Server" or context == "Client", "bootstrap context must be Server or Client")
	return string.format("[StealTheHouse] %s bootstrap ready; shared module loaded.", context)
end

return Bootstrap
