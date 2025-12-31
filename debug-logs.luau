local debugLogModule = {}
debugLogModule.__index = debugLogModule

function debugLogModule.initializeLog(category)
	local self = setmetatable({}, debugLogModule)

	self.logData = {}
	self.initialized = os.date("%Y-%m-%d %H:%M:%S") .. string.format(".%03d", math.floor((os.clock() % 1) * 1000))
	self.logCategory = category or "UNKNOWN"

	return self
end

function debugLogModule:log(args)
	args = args or {}
	
	if not self.logData then
		warn("Caller missing logData")
		return
	end
	
	local level = typeof(args.Level) == "string" and args.Level:upper() or "UNKNOWN"
	local system = typeof(args.System) == "string" and args.System:upper() or "UNKNOWN"
	local message = args.Message or "NO MESSAGE PROVIDED"
	
	table.insert(self.logData, `[{os.date("%Y-%m-%d %H:%M:%S") .. string.format(".%03d", math.floor((os.clock() % 1) * 1000))}] [{level}] [{system}] {message}`)
end

function debugLogModule:exportLogs()
	if not self.logData or not self.initialized or not self.logCategory then
		warn("Caller missing indexs")
		return
	end
	
	local top = `=== LOG CATEGORY: {self.logCategory} ===`
	local initialized = `LOG INITIALIZED: {self.initialized}`
	local exported = `LOG EXPORTED: {os.date("%Y-%m-%d %H:%M:%S") .. string.format(".%03d", math.floor((os.clock() % 1) * 1000))}`
	local bottom = string.rep("=", #top)
	local header = top .. "\n" .. initialized .. "\n" .. exported .. "\n" .. bottom
	
	return header .. "\n" .. table.concat(self.logData, "\n")
end

function debugLogModule:downloadLogs()
	
	if not writefile or not isfolder or not makefolder then
		warn("Executor missing functions")
		return
	end
	
	if not isfolder("Lerux-Debug") then
		makefolder("Lerux-Debug")
	end
	
	writefile("Lerux-Debug/" .. os.date("%Y-%m-%d %H:%M-%S") .. ".txt", self:exportLogs())
end

return debugLogModule
