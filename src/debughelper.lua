module(..., package.seeall)

local buffer = {}

function attach(scene)
	Logger.debug("Attaching DebugHelper")
	view = View {
		scene = scene
	}

	text = TextLabel {
		parent = view,
        textSize = 14,
		text = "Wq",
		align = {"left", "bottom"},
		pos = {0, 0},
		size = {view:getWidth(), view:getHeight()},
	}

	local x1, y1, x2, y2 = text:getStringBounds(1, 2)
    -- string bounds do not seem to take scaling into account
	local yd = math.floor((y2 - y1 + 1) * Application:getViewScale())
	buffer_lines = math.floor(view:getHeight() / yd)
	Logger.debug("Debug buffer lines: " .. tostring(buffer_lines))

	Logger.debug("DebugHelper attached")
    log("Debugger initialized")
end

function detach()
	Logger.debug("Detaching DebugHelper")
	view:getScene():removeChild(view)
	view:removeChild(text)
	text = nil
	view = nil
	Logger.debug("DebugHelper detached")
end

local function _log( color, ... )
	local str = ""
    local args = {...}
    
    if color then
        str = "<c:" .. color .. ">"
    end
    
	for _,v in ipairs(args) do
		str = str .. " " .. tostring(v)
	end
    
    if color then
        str = str .. "</c>"
    end
    
	buffer[#buffer + 1] = str

	while #buffer > buffer_lines do
		table.remove(buffer, 1)
	end

	str = ""
	for _,v in ipairs(buffer) do
		str = str .. v .. "\n"
	end

	text:setText(str)
end

function debug(...)
    _log("00ff00", ...)
    Logger.debug(...)
end

function log( ... )
    _log(nil, ...)
    Logger.info(...)
end

function warn(...)
    _log("ffff00", ...)
    Logger.warn(...)
end

function error(...)
    _log("ff0000", ...)
    Logger.error(...)
end
