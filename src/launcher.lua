-- import
require "debughelper"
local modules = require "modules"
local config = require "config"

Logger.info(APP_NAME .. " starting up")
Logger.info("View size is: " .. tostring(config.screenWidth) .. "x" .. tostring(config.screenHeight) .. " (view scaled by " .. tostring(config.viewScale) .. ")")

-- start
Application:start(config)

-- SceneManager:openScene("level_select")
SceneManager:openScene(config.mainScene)
