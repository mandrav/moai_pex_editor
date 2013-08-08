----------------------------------------------------------------
-- This class is a general checkbox.
----------------------------------------------------------------

-- import
local table             = require "hp/lang/table"
local class             = require "hp/lang/class"
local Event             = require "hp/event/Event"
local Component         = require "hp/gui/Component"

-- class define
local M                 = class(Component)
local super             = Component

-- States
M.STATE_NORMAL          = "normal"
M.STATE_SELECTED        = "selected"
M.STATE_DISABLED        = "disabled"

-- Events
M.EVENT_TOGGLE          = "toggle"

--------------------------------------------------------------------------------
-- Initializes the internal variables.
--------------------------------------------------------------------------------
function M:initInternal()
    super.initInternal(self)
    self._selected = false
    self._touching = false
    self._touchIndex = nil
    self._themeName = "Checkbox"
    self._skinResizable = true
    self._firstUpdated = false
end

--------------------------------------------------------------------------------
-- Create a child objects.
--------------------------------------------------------------------------------
function M:createChildren()
    local skinClass = self:getStyle("skinClass")
    self._skinClass = skinClass
    self._background = skinClass(self:getStyle("skin"))
    
    local scaleFactor = self:getStyle("skinScaleFactor")
    if scaleFactor ~= 1 then
        local sw, sh = self._background:getSize()
        self._background:setSize(sw * scaleFactor, sh * scaleFactor)
    end

    local textPadding = self:getStyle("textPadding")
    local paddingLeft, _, _, _ = unpack(textPadding)
    self._leftOffset = self._background:getWidth() + paddingLeft

    self._label = TextLabel()
    self._label:setAlignment(MOAITextBox.LEFT_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)

    self:addChild(self._background)
    self:addChild(self._label)

    self:setSize(self._background:getSize())
end

--------------------------------------------------------------------------------
-- Update the display.
--------------------------------------------------------------------------------
function M:updateDisplay()
    local background = self._background
    background:setColor(unpack(self:getStyle("skinColor")))
    background:setTexture(self:getStyle("skin"))

    local label = self._label
    label:setColor(unpack(self:getStyle("textColor")))
    label:setTextSize(self:getStyle("textSize"))
    label:setFont(self:getStyle("font"))
    
--     label:fitSize()
--     label:setPos(self._leftOffset, 0)
--     self:setSize(self._leftOffset + label:getWidth(), self:getHeight())
end

--------------------------------------------------------------------------------
-- Up the button.
-- There is no need to call directly to the basic.
-- @param idx Touch index
--------------------------------------------------------------------------------
function M:doUpButton()
    if not self:isSelected() then
        return
    end
    self._selected = false

    self:setCurrentState(M.STATE_NORMAL)
    self:dispatchEvent(M.EVENT_TOGGLE)
end

--------------------------------------------------------------------------------
-- Down the button.
-- There is no need to call directly to the basic.
--------------------------------------------------------------------------------
function M:doDownButton()
    if self:isSelected() then
        return
    end
    self._selected = true
    
    self:setCurrentState(M.STATE_SELECTED)
    self:dispatchEvent(M.EVENT_TOGGLE)
end

--------------------------------------------------------------------------------
-- Sets the text.
-- @param text text
--------------------------------------------------------------------------------
function M:setText(text)
    self._text = text
    self._label:setText(text)
end

--------------------------------------------------------------------------------
-- Returns the text.
-- @param text text
--------------------------------------------------------------------------------
function M:getText()
    return self._text
end

--------------------------------------------------------------------------------
-- Returns whether the button is selected.
-- @return selected
--------------------------------------------------------------------------------
function M:isSelected()
    return self._selected
end

function M:setValue(value)
    if value then
        self:doDownButton()
    else
        self:doUpButton()
    end
end

-- synonyms
M.getValue = M.isSelected
M.isChecked = M.isSelected
M.setChecked = M.setValue

--------------------------------------------------------------------------------
-- Set the event listener that is called when the user click the button.
-- @param func click event handler
--------------------------------------------------------------------------------
function M:setOnToggle(func)
    self:setEventListener(M.EVENT_TOGGLE, func)
end

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- This event handler is called when touched.
-- @param e Touch Event
--------------------------------------------------------------------------------
function M:touchDownHandler(e)
    if self._touching then
        return
    end
    e:stop()
    
    self._touchIndex = e.idx
    self._touching = true
    
    if self:isChecked() then
        self:doUpButton()
    else
        self:doDownButton()
    end
end

--------------------------------------------------------------------------------
-- This event handler is called when the button is released.
-- @param e Touch Event
--------------------------------------------------------------------------------
function M:touchUpHandler(e)
    if e.idx ~= self._touchIndex then
        return
    end
    e:stop()
    
    if self._touching then
        self._touching = false
        self._touchIndex = nil
    end
end

--------------------------------------------------------------------------------
-- This event handler is called when you move on the button.
-- @param e Touch Event
--------------------------------------------------------------------------------
function M:touchMoveHandler(e)
    if e.idx ~= self._touchIndex then
        return
    end
    e:stop()
    
    if self._touching and not self:hitTestWorld(e.x, e.y) then
        self._touching = false
        self._touchIndex = nil
    end
end

--------------------------------------------------------------------------------
-- This event handler is called when you move on the button.
-- @param e Touch Event
--------------------------------------------------------------------------------
function M:touchCancelHandler(e)
end

--------------------------------------------------------------------------------
-- This event handler is called when resizing.
-- @param e resize event
--------------------------------------------------------------------------------
function M:resizeHandler(e)
    local background = self._background
--     background:setSize(self:getWidth(), self:getHeight())

    local textPadding = self:getStyle("textPadding")
    local paddingLeft, paddingTop, paddingRight, paddingBottom = unpack(textPadding)

    local label = self._label
    label:setSize(self:getWidth() - background:getWidth() - paddingLeft - paddingRight, math.max(background:getHeight(), self:getHeight()) - paddingTop - paddingBottom)
    label:setPos(background:getRight() + paddingLeft, paddingTop)
end

--------------------------------------------------------------------------------
-- This event handler is called when the enabled state changes.
-- @param e event
--------------------------------------------------------------------------------
function M:enabledChangedHandler(e)
    if not self:isEnabled() then
        self._touching = false
        self._touchIndex = 0
    end
end

return M