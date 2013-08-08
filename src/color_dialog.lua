module(..., package.seeall)

local PAD = 10

function onCreate(e)
    local width = (type(e.size) == "table" and e.size and e.size[1]) or 480
    local height = (type(e.size) == "table" and e.size and e.size[2]) or 320
    local colorNames = {"Red", "Green", "Blue"}
    print(width, height)
    
    color = e.value or {0,0,0,1}
    callback = e.onResult

    view = View {
        scene = scene
    }
    
    frame = Panel {
        parent = view,
        pos = {(view:getWidth() - width) * 0.5, (view:getHeight() - height) * 0.5},
        size = {width, height},
--         layout = VBoxLayout {
--             align = {"center", "top"},
--             padding = {PAD, PAD, PAD, PAD},
--             gap = {PAD, PAD},
--         },
    }
    
    -- measure texts size
    local tmp = TextLabel {
        parent = frame,
        text = "Green"
    }
    tmp:fitSize()
    local titleW, titleH = tmp:getSize()
    tmp:setText('0.000')
    tmp:fitSize()
    local valueW, valueH = tmp:getSize()
    frame:removeChild(tmp)
    tmp:dispose()
    tmp = nil
    
    local progressW = width - PAD * 2 - titleW - PAD * 4 - valueW
    local y = PAD
    
    for i=1,3 do
        local group = Component {
            parent = frame,
            pos = {PAD, y},
            layout = HBoxLayout {
                align = {"left", "center"},
                padding = {PAD, PAD, PAD, PAD},
                gap = {PAD, PAD},
            },
        }
        
        local title = TextLabel {
            parent = group,
            text = colorNames[i],
            size = {titleW, titleH},
            align = {"left", "center"},
        }
        
        local slider = Slider {
            parent = group,
            size = {progressW, 38},
            value = color[i],
            valueBounds = {0, 1},
            accuracy = 0.01,
            onSliderChanged = onSliderChanged,
        }
        
        local value = TextLabel {
            parent = group,
            text = tostring(color[i]),
            size = {valueW, valueH},
            align = {"right", "center"},
        }
        
        slider.index = i
        slider.text = value
        
        group:updateLayout()
        
        y = y + group:getHeight() + PAD
    end
    
    y = y + PAD

    rect = Graphics {
        parent = frame,
        size = {width - PAD * 2, 40},
        pos = {PAD, y},
    }
    rect:setPenColor(unpack(color)):fillRect()
    rect:setPenColor(1, 1, 1, 1):drawRect()

    y = y + 40 + PAD
    
    local bgroup = Component {
        parent = frame,
        pos = {PAD, y},
        size = {width - PAD * 2, 40},
        layout = HBoxLayout {
            align = {"center", "center"},
            padding = {PAD, PAD, PAD, PAD},
            gap = {PAD, PAD},
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
    
    frame:setSize(frame:getWidth(), bgroup:getBottom() + PAD)
end

function onSliderChanged(e)
    local slider = e.target
    if not slider.text then return end
    slider.text:setText(tostring(e.value))
    color[slider.index] = e.value
    rect:setPenColor(unpack(color)):fillRect()
    rect:setPenColor(1, 1, 1, 1):drawRect()
end

function onOK()
    if callback then
        callback(color)
    end
    close()
end

function onCancel()
    if callback then
        callback(nil)
    end
    close()
end

function close()
    SceneManager:closeScene({animation="popOut"})
end
