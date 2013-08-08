module(..., package.seeall)

Component = require "hp/gui/Component"

DIALOG_WIDTH = 480
DIALOG_HEIGHT = 320
DIALOG_PADDING = 20

RESULT = 1

BLEND_MODES = {
    {name="ZERO", value=0},
    {name="ONE", value=1},
    {name="SOURCE_COLOR", value=768},
    {name="ONE_MINUS_SOURCE_COLOR", value=769},
    {name="SOURCE_ALPHA", value=770},
    {name="ONE_MINUS_SOURCE_ALPHA", value=771},
    {name="DESTINATION_ALPHA", value=772},
    {name="ONE_MINUS_DESTINATION_ALPHA", value=773},
    {name="DESTINATION_COLOR", value=774},
    {name="ONE_MINUS_DESTINATION_COLOR", value=775},
}

function centerInside(view, parent)
    view:setPos((parent:getWidth() - view:getWidth()) * 0.5, (parent:getHeight() - view:getHeight()) * 0.5)
end

function centerInsideHorz(view, parent)
    view:setPos((parent:getWidth() - view:getWidth()) * 0.5, view:getTop())
end

function onCreate(e)
    
    CALLBACK = e.onResult
    print(e.value)
    

    view = View {
        scene = scene
    }
    
    frame = NinePatch {
        parent = view,
        texture = "skins/dialog.png",
        size = {DIALOG_WIDTH, DIALOG_HEIGHT},
    }

    local group = Component {
        parent = view,
        layout = VBoxLayout {
            align = {"center", "top"},
            padding = {DIALOG_PADDING, DIALOG_PADDING, DIALOG_PADDING, DIALOG_PADDING},
            gap = {5, 5},
        },
    }
    
    for i,v in ipairs(BLEND_MODES) do
        local cb = Checkbox {
            parent = group,
            text = v.name,
            checked = v.value == e.value,
            size = {DIALOG_WIDTH - DIALOG_PADDING * 2, 40},
            onToggle = function(e)
                if e.target:isChecked() then
                    RESULT = v.value
                    for n=1,#BLEND_MODES do
                        if n ~= i then
                            BLEND_MODES[n].checkbox:setChecked(false)
                        end
                    end
                end
            end,
        }
        BLEND_MODES[i].checkbox = cb
    end

    local bgroup = Component {
        parent = view,
        layout = HBoxLayout {
            align = {"center", "center"},
            padding = {5, 5, 5, 5},
            gap = {5, 5},
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

    group:updateLayout()
    bgroup:updateLayout()
    
    frame:setSize(group:getWidth() + DIALOG_PADDING * 2, group:getHeight() + bgroup:getHeight() + DIALOG_PADDING * 2)
    centerInside(frame, view)
    
    local fpx, fpy = frame:getPos()
    group:setPos(fpx + DIALOG_PADDING, fpy + DIALOG_PADDING)
    centerInsideHorz(group, view)
    
    bgroup:setPos(0, group:getBottom())
    centerInsideHorz(bgroup, view)
end

function onOK()
    CALLBACK(RESULT)
    close()
end

function onCancel()
    CALLBACK(-1)
    close()
end

function close()
    SceneManager:closeScene({animation="popOut"})
end
