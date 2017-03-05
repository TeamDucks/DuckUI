local TextInput = require 'ui.TextInput'
local uiConf = require 'ui.conf'
local dev = require 'dev'

love.window.setMode(800, 600, {x = 0, y = 0, highdpi = true})

local S = 1.5
local W = love.graphics.getWidth()
local H = love.graphics.getHeight()

local graphics, mouse

uiConf.scale(S * 2)

---- WORLD ---------------------------------------------------------------------

local world = {
  _entities = {}
}

function world:add(entity)
  self._entities[#self._entities+1] = entity
end

function world:invoke(callbackName, ...)
  for _, e in ipairs(self._entities) do
    if (e[callbackName]) then
      e[callbackName](e, ...)
    end
  end
end

function decorate(fn, decorator)
  return function(...)
    decorator(...)
    if fn then
      fn(...)
    end
  end
end

function world:register(love)
  for _, method in ipairs{'update', 'mousepressed', 'mousereleased',
                          'keypressed', 'keyreleased', 'draw', 'textinput'} do
    love[method] = decorate(love[method], function (...)
                              self:invoke(method, ...)
                            end)
  end
end

--------------------------------------------------------------------------------

function love.load()
  love.graphics.setFont(love.graphics.newFont(12 * S))
  love.keyboard.setKeyRepeat(true)
  world:add(TextInput.new("Hello TextInput", 10, 10))
end

function love.draw()
  dev.displayInfo('mouse', 'fps')
end

world:register(love)
