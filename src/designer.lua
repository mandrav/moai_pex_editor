module(..., package.seeall)

-- MOAIDebugLines.setStyle ( MOAIDebugLines.PROP_MODEL_BOUNDS, 2, 1, 1, 1 )
-- MOAIDebugLines.setStyle ( MOAIDebugLines.PROP_WORLD_BOUNDS, 2, 0.75, 0.75, 0.75 )

-- this function updates the slider's label with the current value while dragging the thumb
function defaultSliderChange(e)
	local slider = e.target
	local item = slider.item
	-- during construction, 'item' may be invalid...
	if not item then return end
	local text = slider:getValue()--item.value.min + e.value * (item.value.max - item.value.min)
	slider.displayLabel:setText(tostring(text))
	
	item.currentValue = text
	debughelper.debug(item.name, "=", text)
end

-- this function re-creates the particle system when the slider's thumb has been released
function defaultSliderEndChange(e)
	local filename = os.tmpname()
	save(filename)
	MOAIFileSystem.deleteFile(filename)
end

local adjustables = {
	{ name="conf_title", label = "Particle configuration" },
	
	{ name="duration",						label="Duration",				value={min=0,	max=10,		step=0.1} },

	{ name="maxParticles",					label="Max particles",			value={min=1,	max=500,	step=1} },
	{ name="particleLifeSpan",				label="Lifespan",				value={min=0,	max=10,		step=0.1} },
	{ name="particleLifespanVariance",		label="Lifespan variance",		value={min=0,	max=10,		step=0.1} },
	{ name="startParticleSize",				label="Start size",				value={min=1,	max=500,	step=1} },
	{ name="startParticleSizeVariance",		label="Start size variance",	value={min=0,	max=500,	step=1} },
	{ name="finishParticleSize",			label="End size",				value={min=1,	max=500,	step=1} },
	{ name="FinishParticleSizeVariance",	label="End size variance",		value={min=0,	max=500,	step=1} },
	{ name="angle",							label="Emitter angle",			value={min=0,	max=360,	step=1} },
	{ name="angleVariance",					label="Emitter angle variance",	value={min=0,	max=360,	step=1} },
	{ name="rotationStart",					label="Start rotation",			value={min=0,	max=360,	step=1} },
	{ name="rotationStartVariance",			label="Start rotation variance",value={min=0,	max=360,	step=1} },
	{ name="rotationEnd",					label="End rotation",			value={min=0,	max=360,	step=1} },
	{ name="rotationEndVariance",			label="End rotation variance",	value={min=0,	max=360,	step=1} },
	
	{ name="gravity_title", label = "Gravity emitter" },
	
	{ name="sourcePositionVariance", {
		{name="x", label="X variance",			value={min=0,	max=1000,	step=10} },
		{name="y", label="Y variance",			value={min=0,	max=1000,	step=10} },
	}},
	{ name="speed",							label="Speed",					value={min=0,	max=500,	step=1} },
	{ name="speedVariance",					label="Speed variance",			value={min=0,	max=500,	step=1} },
	{ name="gravity", {
		{name="x", label="Gravity X",				value={min=-500,max=500,	step=10} },
		{name="y", label="Gravity Y",				value={min=-500,max=500,	step=10} },
	}},
	{ name="tangentialAcceleration",		label="Tangential acceleration",value={min=-500,max=500,	step=10} },
	{ name="tangentialAccelVariance",		label="Tangential accel. variance",value={min=0,	max=500,	step=1} },
	{ name="radialAcceleration",			label="Radial acceleration",	value={min=-400,max=400,	step=10} },
	{ name="radialAccelVariance",			label="Radial accel. variance",	value={min=0,	max=500,	step=1} },
	
	{ name="radial_title", label = "Radial emitter" },
	
	{ name="maxRadius",						label="Max radius",				value={min=0,	max=500,	step=1} },
	{ name="maxRadiusVariance",				label="Max radius variance",	value={min=0,	max=500,	step=1} },
	{ name="minRadius",						label="Min radius",				value={min=0,	max=500,	step=1} },
	{ name="rotatePerSecond",				label="Degrees/second",			value={min=-360,max=360,	step=1} },
	{ name="rotatePerSecondVariance",		label="Degrees/second variance",value={min=0,	max=360,	step=1} },
	
	{ name="color_title", label = "Particle color" },
	
	{ name="startColor", {
		{name="red",	label="Start red",				value={min=0,	max=1,		step=0.05} },
		{name="green",	label="Start green",			value={min=0,	max=1,		step=0.05} },
		{name="blue",	label="Start blue",				value={min=0,	max=1,		step=0.05} },
		{name="alpha",	label="Start alpha",			value={min=0,	max=1,		step=0.05} },
	}},
	{ name="startColorVariance", {
		{name="red",	label="Start red variance",		value={min=0,	max=1,		step=0.05} },
		{name="green",	label="Start green variance",	value={min=0,	max=1,		step=0.05} },
		{name="blue",	label="Start blue variance",	value={min=0,	max=1,		step=0.05} },
		{name="alpha",	label="Start alpha variance",	value={min=0,	max=1,		step=0.05} },
	}},
	{ name="finishColor", {
		{name="red",	label="End red",				value={min=0,	max=1,		step=0.05} },
		{name="green",	label="End green",				value={min=0,	max=1,		step=0.05} },
		{name="blue",	label="End blue",				value={min=0,	max=1,		step=0.05} },
		{name="alpha",	label="End alpha",				value={min=0,	max=1,		step=0.05} },
	}},
	{ name="finishColorVariance", {
		{name="red",	label="End red variance",		value={min=0,	max=1,		step=0.05} },
		{name="green",	label="End green variance",		value={min=0,	max=1,		step=0.05} },
		{name="blue",	label="End blue variance",		value={min=0,	max=1,		step=0.05} },
		{name="alpha",	label="End alpha variance",		value={min=0,	max=1,		step=0.05} },
	}},
}

function locateTextureInPath(file)
    return ResourceManager:getFilePath(file)
end

function load(filename)
    -- add pex dir in path
    local lastSep = filename:find("/[^/]*$")
    if lastSep then
        lastSep = lastSep - 1
        local path = filename:sub(1, lastSep)
        local dir = MOAIFileSystem.getRelativePath(path)
        ResourceManager:addPath(dir)
    end
    
	debughelper.log("Reading PEX file: " .. filename)
	local pex = MOAIXmlParser.parseFile ( filename )
	if pex.type == "particleEmitterConfig" and pex.children then
		for k,v in pairs(pex.children) do
-- 			debughelper.debug("Node " .. k)
			local node = v[1]
			if node and node.attributes then
				if k == "texture" then
                    texture = locateTextureInPath(node.attributes["name"])
				elseif k == "duration" or
						k == "maxParticles" or k == "particleLifeSpan" or k == "particleLifespanVariance" or
						k == "startParticleSize" or k == "startParticleSizeVariance" or k == "finishParticleSize" or
						k == "FinishParticleSizeVariance" or k == "angle" or k == "angleVariance" or
						k == "rotationStart" or k == "rotationStartVariance" or k == "rotationEnd" or
						k == "rotationEndVariance" or k == "speed" or k == "speedVariance" or
						k == "tangentialAcceleration" or k == "tangentialAccelVariance" or k == "radialAcceleration" or
						k == "radialAccelVariance" or k == "maxRadius" or k == "maxRadiusVariance" or
						k == "minRadius" or k == "rotatePerSecond" or k == "rotatePerSecondVariance" then
					
					findRowByName(adjustables, k).currentValue = node.attributes["value"]
					
				elseif k == "sourcePositionVariance" or k == "gravity" then
					local row = findRowByName(adjustables, k)
					findRowByName(row[1], "x").currentValue = node.attributes["x"]
					findRowByName(row[1], "y").currentValue = node.attributes["y"]
				elseif k == "startColor" or k == "startColorVariance" or
						k == "finishColor" or k == "finishColorVariance" then
					
					local row = findRowByName(adjustables, k)
					findRowByName(row[1], "red").currentValue = node.attributes["red"]
					findRowByName(row[1], "green").currentValue = node.attributes["green"]
					findRowByName(row[1], "blue").currentValue = node.attributes["blue"]
					findRowByName(row[1], "alpha").currentValue = node.attributes["alpha"]
					
				elseif k == "emitterType" then
					emitterType = tonumber(node.attributes["value"])
				elseif k == "blendFuncSource" then
                    blendFuncSource = tonumber(node.attributes["value"])
				elseif k == "blendFuncDestination" then
                    blendFuncDestination = tonumber(node.attributes["value"])
				else
					debughelper.warn("Unknown node: " .. k)
				end
			end
		end
		debughelper.log("Finished reading PEX file: " .. filename)
	else
		debughelper.error("Not a PEX file or file empty: " .. filename)
	end
	applySliderValues()
	showHideEmitterType()
	recreateParticleSystem(filename)
	openedFile = filename
end

-- helper for save()
local function _writeElement(f, name, ...)
	f:write("<")
	f:write(name)
	f:write(" ")
	for i=1,#arg,2 do
		f:write(arg[i])
		f:write("=\"")
		f:write(arg[i+1])
		f:write("\" ")
	end
	f:write("/>\n")
end

function save(filename)
	if not filename then
		debughelper.error("No filename given; aborting save")
		return
	end
	
	debughelper.debug("Writing PEX file: " .. filename)
	
	local f = io.open(filename, "w+")
	if not f then
		debughelper.error("Failed to open PEX file for writing: " .. filename)
		return
	end

	local cwd = MOAIFileSystem.getWorkingDirectory()
	local texAbs = MOAIFileSystem.getAbsoluteFilePath(texture)
	local tmpAbs = string.sub(filename, 1, -string.find(string.reverse(filename), "/", 1, true))
	MOAIFileSystem.setWorkingDirectory(tmpAbs)
	local texName = MOAIFileSystem.getRelativePath(texAbs)-- .. "particles/cloudlet.png"
	MOAIFileSystem.setWorkingDirectory(cwd)
--     print(texName)

-- 	debughelper.debug("Tmp path: " .. tmpAbs)
-- 	debughelper.debug("Tex path: " .. texAbs)
-- 	debughelper.debug("Rel path: " .. texName)
-- 	debughelper.debug("Cwd path: " .. cwd)

	f:write("<particleEmitterConfig>\n")
	_writeElement(f, "texture", "name", texName)
	
	for _,v in ipairs(adjustables) do
		if #v == 0 and v.currentValue then
			_writeElement(f, v.name, "value", v.currentValue)
		else
			local attrs = {}
			for _,c in ipairs(v[1]) do
				attrs[#attrs + 1] = c.name
				attrs[#attrs + 1] = c.currentValue
			end
			_writeElement(f, v.name, unpack(attrs))
		end
	end
	
	_writeElement(f, "emitterType", "value", emitterType) --  (0: gravity, 1: radial)
	_writeElement(f, "blendFuncSource", "value", blendFuncSource)
	_writeElement(f, "blendFuncDestination", "value", blendFuncDestination)
	
	f:write("</particleEmitterConfig>\n")
	
	showHideEmitterType()

	
-- 	case 0:     return Context3DBlendFactor.ZERO; break;
-- 	case 1:     return Context3DBlendFactor.ONE; break;
-- 	case 0x300 768: return Context3DBlendFactor.SOURCE_COLOR; break;
-- 	case 0x301 769: return Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR; break;
-- 	case 0x302 770: return Context3DBlendFactor.SOURCE_ALPHA; break;
-- 	case 0x303 771: return Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA; break;
-- 	case 0x304 772: return Context3DBlendFactor.DESTINATION_ALPHA; break;
-- 	case 0x305 773: return Context3DBlendFactor.ONE_MINUS_DESTINATION_ALPHA; break;
-- 	case 0x306 774: return Context3DBlendFactor.DESTINATION_COLOR; break;
-- 	case 0x307 775: return Context3DBlendFactor.ONE_MINUS_DESTINATION_COLOR; break;
					
-- 	debughelper.debug("Writing PEX file: " .. filename)
-- 	PEXWriter.write(filename, pex)
-- 	debughelper.debug("Done writing PEX file: " .. filename)

	f:close()
	debughelper.debug("PEX file written: " .. filename)

	recreateParticleSystem(filename)
end

function findRowByName(tbl, name)
	for _,r in ipairs(tbl) do
		if r.name == name then
			return r
		end
	end
	return nil
end

function recreateParticleSystem(filename)
	if particle ~= nil then
		particle:stopParticle()
		particle:stop()
		pview:removeChild(particle)
		particle = nil
	end
    local function protectedCall()
        particle = Particles.fromPex(filename or "particles/deathBlossomCharge.pex")
    end
    if pcall(protectedCall) then
        particle:setParent(pview)
        particle.emitter:setLoc(PWIDTH * 0.5, Application.viewHeight * 0.5)
        particle.emitter:forceUpdate()
        particle:start()
        particle:startParticle()
        
        local duration = tonumber(findRowByName(adjustables, "duration").currentValue)
--         debughelper.debug("DURATION", duration)
        restartButton:setEnabled(duration > 0)
    else
        showError("Failed to recreate the particle system!\nThe program will now exit.\nCheck console for details...", true)
    end
end

function applySliderValues()
	for _,v in ipairs(adjustables) do
		if #v == 0 then
			if v.slider then
-- 				print(v.label, v.currentValue)
				v.slider:setValue(tonumber(v.currentValue))
			end
		else
			for _,c in ipairs(v[1]) do
				if c.slider then
-- 					print(v.label, v.currentValue)
					c.slider:setValue(tonumber(c.currentValue))
				end
			end
		end
	end
end

-- show/hide gravity/radial emitter settings based on type
function showHideEmitterType()
	local t = emitterType
	local row = nil
	
	findRowByName(adjustables, "gravity_title").hidden = t ~= 0
	row = findRowByName(adjustables, "sourcePositionVariance")
	findRowByName(row[1], "x").hidden = t ~= 0
	findRowByName(row[1], "y").hidden = t ~= 0
	findRowByName(adjustables, "speed").hidden = t ~= 0
	findRowByName(adjustables, "speedVariance").hidden = t ~= 0
	row = findRowByName(adjustables, "gravity")
	findRowByName(row[1], "x").hidden = t ~= 0
	findRowByName(row[1], "y").hidden = t ~= 0
	findRowByName(adjustables, "tangentialAcceleration").hidden = t ~= 0
	findRowByName(adjustables, "tangentialAccelVariance").hidden = t ~= 0
	findRowByName(adjustables, "radialAcceleration").hidden = t ~= 0
	findRowByName(adjustables, "radialAccelVariance").hidden = t ~= 0

	findRowByName(adjustables, "radial_title").hidden = t == 0
	findRowByName(adjustables, "maxRadius").hidden = t == 0
	findRowByName(adjustables, "maxRadiusVariance").hidden = t == 0
	findRowByName(adjustables, "minRadius").hidden = t == 0
	findRowByName(adjustables, "rotatePerSecond").hidden = t == 0
	findRowByName(adjustables, "rotatePerSecondVariance").hidden = t == 0
	
	if group then
		group:removeChildren()
		for _,v in ipairs(adjustables) do
			if #v == 0 then
				v.group:setVisible(not hidden)
				if v.group and not v.hidden then
					group:addChild(v.group)
				end
			else
				for _,c in ipairs(v[1]) do
					c.group:setVisible(not hidden)
					if c.group and not c.hidden then
						group:addChild(c.group)
					end
				end
			end
		end
	end
end

PWIDTH = 400 -- particle-view width
BWIDTH = 100 -- buttons width
BHEIGHT = 40 -- buttons height
BGAP = 5 -- gap between buttons
TWIDTH = BWIDTH + BGAP * 2 -- tools-view (buttons) width

function createParticleView()
	--
	-- particles view
	--
	
    pview = View {
        scene = scene,
		pos = {0, 0},
		size = {PWIDTH, Application.viewHeight},
	}

	local bg = Mesh.newRect(0, 0, PWIDTH, Application.viewHeight, "#ffffff")
	bg:setParent(pview)
    
    pview:setColor(0.2, 0.2, 0.2, 1)
end

function createSlidersView()
	--
	-- main (sliders) view
	--
	
    view = View {
        scene = scene,
		pos = {PWIDTH, 0},
		size = {Application.viewWidth - PWIDTH - TWIDTH, Application.viewHeight},
	}

	bg = Mesh.newRect(0, 0, Application.viewWidth - PWIDTH - TWIDTH, Application.viewHeight, "#444444")
	bg:setParent(view)
	
    scroller = Scroller {
        parent = view,
        layout = VBoxLayout {
			align = {"left", "top"},
			padding = {0, 0, 0, 0},
            gap = {0, 0},
        },
		hBounceEnabled = false
    }
	
	Component = require "hp/gui/Component"
	group = Component {
		parent = scroller,
        layout = VBoxLayout {
			align = {"center", "top"},
			padding = {0, 0, 0, 0},
            gap = {0, 0},
        },
	}
	
	for _,v in ipairs(adjustables) do
		local has_children = #v > 0
		local is_title = not has_children and v.value == nil
		
		if not has_children then
			createSlider(v, is_title)
		else
			for _,c in ipairs(v[1]) do
				createSlider(c, c.value == nil)
			end
		end
	end
end

function createSlider(adj, is_title)
	local x = 10
	local lw = 240
	local vw = 60
	local gap = 10
	local pw = Application.viewWidth - PWIDTH - TWIDTH - lw - gap - vw - gap - gap - gap -- take all free space
	local w = lw + gap + pw + gap + vw - gap
	local h = 38

	local localGroup = Group {
		parent = group
	}
	
	if is_title then
		local bg = Mesh.newRect(x, 0, w, h, {"#00aa00", "#004400", 90})
		bg:setParent(localGroup)

		TextLabel {
			parent = localGroup,
			text = adj.label,
			pos = {x, 0},
			size = {w, h},
			textSize = 24,
			font = "fonts/arialbd.ttf",
			align = {"center", "center"},
		}
	else
		TextLabel {
			parent = localGroup,
			text = adj.label,
			pos = {x, 0},
			size = {lw, h},
			textSize = 16,
			align = {"right", "center"},
		}
		local slider = Slider {
			parent = localGroup,
			pos = {x + lw + gap, 0},
			size = {pw, h},
			value = 0,
			valueBounds = {adj.value.min, adj.value.max},
			accuracy = adj.value.step,
			onSliderChanged = defaultSliderChange,
			onSliderEndChange = defaultSliderEndChange,
		}
		local label = TextLabel {
			parent = localGroup,
			text = tostring(tonumber(adj.currentValue)),
			pos = {x + lw + gap + pw + gap, 0},
			size = {vw, h},
			textSize = 16,
			align = {"left", "center"},
		}
		
		slider.item = adj
		slider.displayLabel = label
		adj.slider = slider
	end
	
	localGroup:resizeForChildren()
	adj.group = localGroup
end

function createToolsView()
	--
	-- tools view (buttons)
	--
	
	bview = View {
        scene = scene,
		pos = {Application.viewWidth - TWIDTH, 0},
		size = {TWIDTH, Application.viewHeight},
	}

	bg = Mesh.newRect(0, 0, TWIDTH, Application.viewHeight, {"#00aa00", "#004400", 90})
	bg:setParent(bview)
	
    tgroup = Component {
        parent = bview,
        layout = VBoxLayout {
			align = {"center", "top"},
			padding = {BGAP, 5, BGAP, 5},
            gap = {BGAP, 5},
        },
    }
	
	restartButton = Button {
		parent = tgroup,
		text = "Restart",
		size = {BWIDTH, BHEIGHT * 2},
        enabled = false,
		onClick = function() particle:stopParticle() particle:startParticle() end,
	}
    Component { -- spacer
        parent = tgroup,
        size = {BWIDTH, BHEIGHT},
    }
    textureButton = Button {
        parent = tgroup,
        text = "Texture",
        size = {BWIDTH, BHEIGHT},
        onClick = selectTexture,
    }
	emitterButton = Button {
		parent = tgroup,
		text = "Emitter",
		size = {BWIDTH, BHEIGHT},
		onClick = selectEmitterType,
	}
    blendSrcButton = Button {
        parent = tgroup,
        text = "Blend src",
        size = {BWIDTH, BHEIGHT},
        onClick = selectBlendSrcMode,
    }
    blendDstButton = Button {
        parent = tgroup,
        text = "Blend dst",
        size = {BWIDTH, BHEIGHT},
        onClick = selectBlendDstMode,
    }
    Component { -- spacer
        parent = tgroup,
        size = {BWIDTH, BHEIGHT},
    }
    bgColorButton = Button {
        parent = tgroup,
        text = "BG color",
        size = {BWIDTH, BHEIGHT},
        onClick = selectBgColor,
    }
    Component { -- spacer
        parent = tgroup,
        size = {BWIDTH, BHEIGHT},
    }
	reloadButton = Button {
		parent = tgroup,
		text = "Reload",
		size = {BWIDTH, BHEIGHT},
		onClick = function()
            confirm("Are you sure you want to reload?\nYou will lose <c:ff0000>ALL</c> modifications!",
                function() -- yes
                     load(openedFile)
                end)
        end,
	}
    loadButton = Button {
        parent = tgroup,
        text = "Load",
        size = {BWIDTH, BHEIGHT},
        onClick = function()
            if openedFile then
                confirm("Are you sure you want to load another\nfile?\nYou will lose <c:ff0000>ALL</c> modifications!",
                    function() -- yes
                        loadPS()
                    end)
            else
                loadPS()
            end
        end,
    }
    saveButton = Button {
        parent = tgroup,
        text = "Save",
        size = {BWIDTH, BHEIGHT},
        onClick = function() save(openedFile) end,
    }
end

function enableAll(en)
    -- sliders
    for _,v in ipairs(adjustables) do
        if #v ~= 0 then
            for _,c in ipairs(v[1]) do
                if c.slider then
                    c.slider:setEnabled(en)
                end
            end
        else
            if v.slider then
                v.slider:setEnabled(en)
            end
        end
    end
    
    -- buttons
--     restartButton:setEnabled(en)
    textureButton:setEnabled(en)
    emitterButton:setEnabled(en)
    blendSrcButton:setEnabled(en)
    blendDstButton:setEnabled(en)
    bgColorButton:setEnabled(en)
    reloadButton:setEnabled(en)
    loadButton:setEnabled(en)
    saveButton:setEnabled(en)
end

function onCreate(params)
	-- init
	for _,v in ipairs(adjustables) do
		v.currentValue = 0
		
		if #v ~= 0 then
			for _,c in ipairs(v[1]) do
				c.currentValue = 0
			end
		end
	end

	createParticleView()
	createSlidersView()
	createToolsView()
	
    enableAll(false)
    loadButton:setEnabled(true)
end

function onStart()
    if APP_DEBUG then
        debughelper.attach(scene)
    end

-- 	load("particles/deathBlossomCharge.pex")
--     selectBgColor()
end

function onStop()
    if APP_DEBUG then
        debughelper.detach()
    end
end

function loadPS()
    SceneManager:openScene("file_dialog",
    {
        animation = "popIn",
        size = {480, 640},
        value = openedFile,
        filter = {"%.pex$"},
        onResult = onPS,
    })
end

function onPS(value)
    if value == nil then return end
    load(value)
    
    local success = particle ~= nil
    enableAll(success)
end

function selectTexture()
    SceneManager:openScene("file_dialog",
    {
        animation = "popIn",
        size = {480, 640},
        value = texture,
        filter = {"%.png$", "%.jpg$", "%.jpeg$", "%.tga$", "%.bmp$"},
        onResult = onTexture,
    })
end

function onTexture(value)
    if value == nil then return end
    texture = MOAIFileSystem.getRelativePath(value)
    particle:setTexture(texture)
    print("FILE", texture)
end

function selectBgColor()
    SceneManager:openScene("color_dialog",
    {
        animation = "popIn",
        size = {480, 320},
        value = {pview:getColor()},
        onResult = onBgColor,
    })
end

function onBgColor(value)
    if not value then return end
    pview:setColor(unpack(value))
end

function selectBlendSrcMode()
    SceneManager:openScene("blendmode_dialog",
    {
        animation = "popIn",
        value = blendFuncSource,
        onResult = onBlendSrcMode,
    })
end

function onBlendSrcMode(value)
    if value == -1 then return end
    blendFuncSource = value
    particle:setBlendMode(blendFuncSource, blendFuncDestination)
end

function selectBlendDstMode()
    SceneManager:openScene("blendmode_dialog",
    {
        animation = "popIn",
        value = blendFuncDestination,
        onResult = onBlendDstMode,
    })
end

function onBlendDstMode(value)
    if value == -1 then return end
    blendFuncDestination = value
    particle:setBlendMode(blendFuncSource, blendFuncDestination)
end

function selectEmitterType()
	SceneManager:openScene("emitter_dialog",
	{
		animation = "popIn",
		size = {740, 320},
		type = DialogBox.TYPE_CONFIRM,
		title = "Emitter Type Selection",
		text = "Please select the emitter type to use. There are two available\ntypes to choose from: <c:ff0000>GRAVITY</c> and <c:ff0000>RADIAL</c>.\n\nMake your choice...",
		buttons = {"Gravity", "Radial", "Cancel"},
		onResult = onEmitterType,
	})
end

function onEmitterType(e)
	if e.resultIndex == 3 then
		-- cancel
		return
	end
	emitterType = e.resultIndex - 1
	save(os.tmpname())
end

function showError(errorText, fatal)
    SceneManager:openScene("generic_dialog",
    {
        animation = "popIn", backAnimation = "popOut",
        size = {480, 240},
        type = DialogBox.TYPE_ERROR,
        title = "Error",
        text = errorText,
        buttons = {"OK"},
        onResult = function() if fatal then os.exit() end end,
    })        
end

function confirm(text, yesCallback, noCallback)
    SceneManager:openScene("generic_dialog",
    {
        animation = "popIn", backAnimation = "popOut",
        size = {480, 240},
        type = DialogBox.TYPE_CONFIRM,
        title = "Confirmation",
        text = text,
        buttons = {"Yes", "No"},
        onResult = function(e)
            Executors.callLater(function()
                if e.resultIndex == 1 and yesCallback then
                    yesCallback()
                elseif e.resultIndex == 2 and noCallback then
                    noCallback()
                end
            end)
        end,
    })        
end
