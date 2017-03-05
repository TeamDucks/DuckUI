local M = {}

function isModuleAvailable(name)
  if package.loaded[name] then
    return true
  else
    for _, searcher in ipairs(package.searchers or package.loaders) do
      local loader = searcher(name)
      if type(loader) == 'function' then
        package.preload[name] = loader
        return true
      end
    end
    return false
  end
end

-- function M.printInfo()
--   local infoString = 'W='..love.graphics.getWidth()..'; H='..love.graphics.getHeight()..'; SN='..love.window.getPixelScale()
--   if isModuleAvailable('ui.conf') then
--     infoString = infoString .. '; S=' .. require('ui.conf').scale()
--   end
--   print(string.rep('-', #infoString))
--   print(infoString)
--   print(string.rep('-', #infoString))
-- end

function M.displayInfo(...)
  local flags
  if ... then
    flags = {...}
  else
    flags = {'dimension','mouse', 'fps'}
  end
  local flagDict = {}
  for _, flag in ipairs(flags) do
    flagDict[flag] = true
  end

  local w, h = love.graphics.getWidth(), love.graphics.getHeight()
  local s = love.window.getPixelScale()
  local x, y = love.mouse.getPosition()

  local lineSpace = 6
  local infoWidth = w - lineSpace

  local curY = 0
  function stepY()
    curY = curY + love.graphics.getFont():getHeight() + lineSpace
    return curY
  end
  curY = -stepY() + lineSpace

  if flagDict['dimension'] then
    love.graphics.printf('W='..w..'; H='..h..'; S='.. s, 0, stepY(), infoWidth, 'right')
  end
  if flagDict['mouse'] then
    love.graphics.printf('mX='..x..' mY='..y, 0, stepY(), infoWidth, 'right')
  end
  if flagDict['fps'] then
    love.graphics.printf('FPS=' .. love.timer.getFPS(), 0, stepY(), infoWidth, 'right')
  end
end

return M
