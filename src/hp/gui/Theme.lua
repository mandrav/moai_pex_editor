--------------------------------------------------------------------------------
-- This is a standard GUI theme.
-- Can not dynamically change the theme.
--------------------------------------------------------------------------------

-- import
local Sprite            = require "hp/display/Sprite"
local NinePatch         = require "hp/display/NinePatch"

-- module define
local M                 = {}

M.Button = {
    normal = {
        skin = "skins/button-normal.png",
        skinClass = NinePatch,
        skinColor = {1, 1, 1, 1},
        font = "VL-PGothic",
        textSize = 16,
        textColor = {0.0, 0.0, 0.0, 1},
        textPadding = {10, 5, 10, 8},
    },
    selected = {
        skin = "skins/button-selected.png",
    },
    over = {
        skin = "skins/button-over.png",
    },
    disabled = {
        skin = "skins/button-disabled.png",
        textColor = {0.5, 0.5, 0.5, 1},
    },
}

M.Checkbox = {
    normal = {
        skin = "skins/checkbox_normal.png",
        skinClass = NinePatch,
        skinColor = {1, 1, 1, 1},
        skinScaleFactor = 1,
        font = "VL-PGothic",
        textSize = 20,
        textColor = {1, 1, 1, 1},
        textPadding = {-10, 5, 0, 5},
    },
    selected = {
        skin = "skins/checkbox_selected.png",
    },
    disabled = {
        textColor = {0.5, 0.5, 0.5, 1},
        skinColor = {0.5, 0.5, 0.5, 1},
    },
}

M.Joystick = {
    normal = {
        baseSkin = "skins/joystick_base.png",
        knobSkin = "skins/joystick_knob.png",
        baseColor = {1, 1, 1, 1},
        knobColor = {1, 1, 1, 1},
    },
    disabled = {
        baseColor = {0.5, 0.5, 0.5, 1},
        knobColor = {0.5, 0.5, 0.5, 1},
    },
}

M.Panel = {
    normal = {
        backgroundSkin = "skins/dialog.png",
        backgroundSkinClass = NinePatch,
        backgroundColor = {1, 1, 1, 1},
    },
    disabled = {
        backgroundColor = {0.5, 0.5, 0.5, 1},
    },
}

M.MessageBox = {
    normal = {
        backgroundSkin = "skins/panel.png",
        backgroundSkinClass = NinePatch,
        backgroundColor = {1, 1, 1, 1},
        font = "VL-PGothic",
        textPadding = {20, 20, 15, 15},
        textSize = 20,
        textColor = {0, 0, 0, 1},
    },
    disabled = {
        backgroundColor = {0.5, 0.5, 0.5, 1},
        textColor = {0.2, 0.2, 0.2, 1},
    },
}

M.Slider = {
    normal = {
        bg = "skins/slider_background.png",
        thumb = "skins/slider_thumb.png",
        progress = "skins/slider_progress.png",
        color = {1, 1, 1, 1},
    },
    disabled = {
        color = {0.5, 0.5, 0.5, 1},
    },
}

M.DialogBox = {
    normal = {
        backgroundSkin = "skins/dialog.png",
        backgroundSkinClass = NinePatch,
        backgroundColor = {1, 1, 1, 1},
        font = "VL-PGothic",
        textPadding = {10, 10, 10, 10},
        textSize = 20,
        textColor = {1, 1, 1, 1},
        titleFont = "fonts/arialbd.ttf",
        titlePadding = {0, 0, 0, 0},
        titleSize = 32,
        titleColor = {1, 1, 0, 1},
        iconPadding = {10, 10, 0, 10},
        iconScaleFactor = 0.5,
        iconInfo = "skins/info.png",
        iconConfirm = "skins/okay.png",
        iconWarning = "skins/warning.png",
        iconError = "skins/error.png",
        buttonsPadding = {10, 0, 10, 10},
    },
    disabled = {
        backgroundColor = {0.5, 0.5, 0.5, 1},
        textColor = {0.2, 0.2, 0.2, 1},
        titleColor = {0.2, 0.2, 0, 1},
    },
}

return M