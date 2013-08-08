-------------------------------------------------------------------------------
-- global "constants"
-------------------------------------------------------------------------------
APP_NAME = "PEX Editor"
APP_DEBUG = true
APP_LOG = "pex_editor.log"
APP_VERSION = "0.1"

-- these are used to initialize the window
-- if running on a mobile platform, the DESIRED_* vars are ignored
-- as the system specifies the "window" size
local DESIRED_WIDTH = 960
local DESIRED_HEIGHT = 640
local DESIGN_WIDTH = 1280

-------------------------------------------------------------------------------
-- main loop setup for stable simulation
-------------------------------------------------------------------------------
MOAISim.setStep ( 1 / 60 )
MOAISim.clearLoopFlags ()
MOAISim.setLoopFlags ( MOAISim.SIM_LOOP_ALLOW_BOOST )
MOAISim.setLoopFlags ( MOAISim.SIM_LOOP_LONG_DELAY )
MOAISim.setBoostThreshold ( 0 )

-------------------------------------------------------------------------------
-- only log MOAI errors
-------------------------------------------------------------------------------
-- MOAILogMgr.setLogLevel(MOAILogMgr.LOG_WARNING)
MOAILogMgr.setLogLevel(MOAILogMgr.LOG_ERROR)

-------------------------------------------------------------------------------
-- needed when running inside the editor
-------------------------------------------------------------------------------
io.stdout:setvbuf("line")

-------------------------------------------------------------------------------
-- setup app logging
-------------------------------------------------------------------------------
if APP_DEBUG and APP_LOG then
	local logFile = io.open(MOAIEnvironment.documentDirectory .. APP_LOG, "w+")
	logFile:setvbuf("line")
	Logger.logTarget = function(...)
	    local args = {...}
	    for _,v in ipairs(args) do
			local s = tostring(v)
			-- log to console
			io.stdout:write(s)
            io.stdout:write('\t')
			-- then log to file
		    logFile:write(s)
            logFile:write('\t')
	    end
	    logFile:write("\n")
		io.stdout:write("\n")
	end
end

-------------------------------------------------------------------------------
-- disable DEBUG messages
-------------------------------------------------------------------------------
Logger.selector[Logger.LEVEL_DEBUG] = APP_DEBUG

-------------------------------------------------------------------------------
-- setup debug trace
-------------------------------------------------------------------------------
if APP_DEBUG then
	local STP = require "StackTracePlus"
	MOAISim.setTraceback(function(err)
	    local st = STP.stacktrace(nil, 3)
	    Logger.error(err)
	    Logger.error(string.gsub(st, "([^\n]*)\n", "\t\t%1\n"))
	    -- the rest goes to console
	    print(err)
	end)
end

-------------------------------------------------------------------------------
-- handy dumpTable function
-------------------------------------------------------------------------------
function dumpTable(tbl, indent)
	if not tbl then return end
	indent = indent or ""
	for i,v in ipairs(tbl) do
		Logger.info(indent .. tostring(i) .. ": " .. tostring(v))
		if type(v) == "table" then
			dumpTable(v, indent .. "  +")
		end
	end
	for k,v in pairs(tbl) do
		Logger.info(indent .. tostring(k) .. ": " .. tostring(v))
		if type(v) == "table" then
			dumpTable(v, indent .. "  +")
		end
	end
end

-------------------------------------------------------------------------------
-- app configuration
-------------------------------------------------------------------------------
local config = {
    title = APP_NAME  .. " v" .. APP_VERSION,
    screenWidth = MOAIEnvironment.horizontalResolution or DESIRED_WIDTH,
    screenHeight = MOAIEnvironment.verticalResolution or DESIRED_HEIGHT,
    viewScale = DESIRED_WIDTH / DESIGN_WIDTH,
    mainScene = "designer",
}

return config