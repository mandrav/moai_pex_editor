module(..., package.seeall)

Component = require "hp/gui/Component"

DIALOG_WIDTH = 640
DIALOG_HEIGHT = 320
DIALOG_PADDING = 10

DOUBLE_CLICK_TIME = 0.3

RESULT = nil

DIR = MOAIFileSystem.getWorkingDirectory()
DIR_FILES = {}
DIR_FILE_START = 1
TEXTS = {}

function centerInside(view, parent)
    view:setPos((parent:getWidth() - view:getWidth()) * 0.5, (parent:getHeight() - view:getHeight()) * 0.5)
end

function centerInsideHorz(view, parent)
    view:setPos((parent:getWidth() - view:getWidth()) * 0.5, view:getTop())
end

function onCreate(e)
    
    DIR_FILES = {}
    DIR_FILE_START = 1
    TEXTS = {}
    
    DIALOG_WIDTH = e.size and e.size[1] or DIALOG_WIDTH
    DIALOG_HEIGHT = e.size and e.size[2] or DIALOG_HEIGHT
    
    FILTER = e.filter or {"*"}
    
    CALLBACK = e.onResult
    
--     debughelper.debug("VALUE", e.value)
    local filename = MOAIFileSystem.getAbsoluteFilePath(e.value)
    local slash = string.find(string.reverse(filename), "/", 1, true)
    local path = string.sub(filename, 1, -slash)
    DIR = path
    selectedFile = string.sub(filename, -(slash - 1))
    debughelper.debug("DIR", DIR)
    debughelper.debug("FILENAME", selectedFile)
    

    view = View {
        scene = scene
    }
    
    frame = NinePatch {
        parent = view,
        texture = "skins/dialog.png",
        size = {DIALOG_WIDTH, DIALOG_HEIGHT},
    }

    local bgroup = Component {
        parent = view,
        layout = HBoxLayout {
            align = {"center", "center"},
            padding = {20, 20, 20, 20},
            gap = {20, 20},
        },
    }
    
    Button {
        parent = bgroup,
        text = "OK",
        onClick = onOK,
    }
    Button {
        parent = bgroup,
        text = "Cancel",
        onClick = onCancel,
    }

    bgroup:updateLayout()

    slider = Slider {
        parent = view,
        direction = Slider.DIRECTION_VERTICAL,
        size = {30, DIALOG_HEIGHT - DIALOG_PADDING - bgroup:getHeight()},
        value = 1,
        accuracy = 0.01,
        showProgress = false,
        onSliderChanged = onScrollSlider,
    }
    
    fview = View {
        parent = view,
        pos = {0, 0},
        size = {DIALOG_WIDTH - DIALOG_PADDING * 3 - slider:getWidth(), DIALOG_HEIGHT - DIALOG_PADDING - bgroup:getHeight()},
    }

    highlightGroup = Group { parent = fview }
    highlight = Sprite {
        parent = highlightGroup,
        texture = "skins/highlight.png",
    }
    
    local maxY = fview:getHeight()
    local currY = 0
    while true do
        local txt = TextLabel {
            parent = fview,
            text = "Wq",
            align = {"left", "center"},
        }
        txt:fitSize()
        txt:setSize(DIALOG_WIDTH - DIALOG_PADDING * 2 - slider:getWidth(), txt:getHeight())
        txt:setPos(DIALOG_PADDING, currY)
        if txt:getBottom() > maxY then
            fview:removeChild(txt)
            txt:dispose()
            break
        end
        currY = txt:getBottom()
        txt.index = #TEXTS + 1
        txt:addEventListener("touchDown", onClickFile)
        TEXTS[txt.index] = txt
    end
    highlight:setSize(fview:getWidth() - DIALOG_PADDING * 2, maxY / #TEXTS)
--     debughelper.debug("Lines:", #TEXTS)

    centerInside(frame, view)
    
    local fpx, fpy = frame:getPos()
    fview:setPos(fpx + DIALOG_PADDING, fpy + DIALOG_PADDING)
    
    slider:setPos(frame:getRight() - DIALOG_PADDING - slider:getWidth(), fpy + DIALOG_PADDING)
    
    bgroup:setPos(fpx + DIALOG_PADDING, frame:getBottom() - DIALOG_PADDING - bgroup:getHeight())
    centerInsideHorz(bgroup, view)
    
    lastHighlightClickTime = MOAISim.getElapsedTime()
    selectedIndex = 1
    listFiles()
    
    changeSliderNoCallback(#DIR_FILES)
    if selectedFile then
        for i,v in ipairs(DIR_FILES) do
            if v == selectedFile then
                setSelection(i)
                enureSelectionVisible()
                break
            end
        end
    end
end

function changeDirectoryTo(subDir)
    local _, bmax = slider:getValueBounds()
    DIR = MOAIFileSystem.getAbsoluteDirectoryPath(DIR .. "/" .. subDir)
--     debughelper.debug("changed to", DIR)
    DIR_FILE_START = 1
    listFiles()
    
    _, bmax = slider:getValueBounds()
    changeSliderNoCallback(bmax)
    setSelection(1)
end

function onClickFile(e)
    local txt = e.target
    local now = MOAISim.getElapsedTime()
    if now - lastHighlightClickTime <= DOUBLE_CLICK_TIME then
        -- double-click
        if string.sub(selectedFile, 1, 1) == "[" then -- dir
            changeDirectoryTo(string.sub(selectedFile, 2, -2))
        elseif selectedFile == ".." or selectedFile == "." then -- dir
            changeDirectoryTo(selectedFile)
        else
            onOK()
        end
    else
        setSelection(DIR_FILE_START + txt.index - 1)
        lastHighlightClickTime = now
    end
end

function onOK()
    if selectedFile ~= nil then
        CALLBACK(DIR .. selectedFile)
    else
        CALLBACK(nil)
    end
    close()
end

function onCancel()
    CALLBACK(nil)
    close()
end

function close()
    SceneManager:closeScene({animation="popOut"})
end

local manuallyChangingSlider = false
function changeSliderNoCallback(value)
    manuallyChangingSlider = true
    slider:setValue(value)
    manuallyChangingSlider = false
end

function onScrollSlider(e)
    if not slider or manuallyChangingSlider then return end
    
    local _, bmax = slider:getValueBounds()
    local v = bmax - math.floor(e.value) + 1
    
    DIR_FILE_START = v
    listFiles()
end

function enureSelectionVisible()
--     require('mobdebug').on()
    local _, bmax = slider:getValueBounds()
    local center = math.floor(#TEXTS / 2)
    
    DIR_FILE_START = selectedIndex - center
    if DIR_FILE_START < 1 then
        DIR_FILE_START = 1
    elseif DIR_FILE_START > #DIR_FILES - #TEXTS + 1 then
        DIR_FILE_START = #DIR_FILES - #TEXTS + 1
    end
    
    changeSliderNoCallback(bmax - DIR_FILE_START + 1)
    listFiles()
    setSelection(selectedIndex)
--     debughelper.debug("DIR_FILE_START", DIR_FILE_START)
end

function setSelection(index)
    local textIndex = index - DIR_FILE_START + 1
    highlightText(textIndex)
    
    selectedIndex = index
    selectedFile = DIR_FILES[selectedIndex]
end

function highlightText(index)
    for i=1,#TEXTS do
        if index == i then
            TEXTS[i]:setColor(0, 0, 0, 1)
            highlight:setPos(TEXTS[i]:getPos())
        else
            TEXTS[i]:setColor(1, 1, 1, 1)
        end
    end


    -- hmm, setVisible does not work?!?
--     highlight:setVisible(selectedIndex >= 1 and selectedIndex <= #TEXTS)
    highlightGroup:removeChild(highlight)
    if index >= 1 and index <= #TEXTS then
        highlight:setParent(highlightGroup)
    end
end

function listFiles()
    local dirs = MOAIFileSystem.listDirectories(DIR)
    local files = MOAIFileSystem.listFiles(DIR)
    
    table.sort(dirs, function(a,b) return a:lower() < b:lower() end)
    table.sort(files, function(a,b) return a:lower() < b:lower() end)
    
    DIR_FILES = {".", ".."}
    
    for _,v in ipairs(dirs) do
        if v:sub(1,1) ~= "." then
            DIR_FILES[#DIR_FILES + 1] = "[" .. v .. "]"
        end
    end
    for _,v in ipairs(files) do
        if v:sub(1,1) ~= "." then
            for _,f in ipairs(FILTER) do
                if v:match(f) then
                    DIR_FILES[#DIR_FILES + 1] = v
                end
            end
        end
    end
--     debughelper.debug("DIR_FILES", #DIR_FILES)
--     debughelper.debug("DIR_FILE_START", DIR_FILE_START)

    local highlightUpdated = false
    for i=1,#TEXTS do
        local fi = i + DIR_FILE_START - 1
        if fi <= #DIR_FILES then
            TEXTS[i]:setText(DIR_FILES[fi])
        else
            TEXTS[i]:setText("")
        end
        
        if fi == selectedIndex then
            highlightText(i)
            highlightUpdated = true
        end
    end
    
    if not highlightUpdated then
        highlightText(0)
    end

    
    local maxScroll = #DIR_FILES - #TEXTS + 1
    if maxScroll < 1 then maxScroll = 1 end
    slider:setValueBounds(1, maxScroll)
end
