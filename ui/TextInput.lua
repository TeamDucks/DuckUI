local conf = require 'ui.conf'

local BASE_FONT_SIZE = 12

local TextInput = {}

function TextInput.new(text, x, y, width, height)
  local font = love.graphics.newFont(BASE_FONT_SIZE * conf.scale())
  local instance = {
    x = x or 0,
    y = y or 0,
    width = width or 120 * conf.scale(),
    height = height or BASE_FONT_SIZE * 1.6 * conf.scale(),
    _focusing = false,
    _curPos = 1,
    _text = text or "",
    _drawableText = love.graphics.newText(font, text),
  }
  setmetatable(instance, {__index = TextInput})
  return instance
end

function TextInput:keypressed(key)
  if self._focusing then
    if key == 'backspace' then
      self._text = string.sub(self._text, 0, self._curPos - 1) .. string.sub(self._text, self._curPos + 1, #self._text)
      self._curPos = self._curPos - 1
    elseif key == 'return' or key == 'enter' then
      self._focusing = false
    elseif key == 'left' then
      self._curPos = math.max(self._curPos - 1, 0)
    elseif key == 'right' then
      self._curPos = math.min(self._curPos + 1, #self._text)
    end
  end
end

function TextInput:textinput(input)
  if self._focusing then
    self._text = string.sub(self._text, 0, self._curPos) .. input .. string.sub(self._text, self._curPos + 1, #self._text)
    self._curPos = self._curPos + 1
  end
end

function TextInput:draw()
  local r,g,b,a = love.graphics.getColor()
  if self._focusing then
    love.graphics.setColor(255,255,255,255)
  else
    love.graphics.setColor(200,200,200,255)
  end
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height, 2 * conf.scale(), 2 * conf.scale())
  love.graphics.setColor(0,0,0,255)
  if self._focusing then
    self._drawableText:set(string.sub(self._text, 0, self._curPos) .. '|' .. string.sub(self._text, self._curPos + 1, #self._text))
  else
    self._drawableText:set(self._text)
  end
  love.graphics.draw(self._drawableText, self.x + 4 * conf.scale(), self.y + (self.height - self._drawableText:getHeight()) / 2)

  love.graphics.setColor(r,g,b,a)
end

function TextInput:mousereleased(mouseX, mouseY, button)
  self:setFocus(mouseX > self.x and mouseX < self.x + self.width
                  and mouseY > self.y and mouseY < self.y + self.height)
end

function TextInput:setFocus(focus)
  if (focus) then
    self._focusing = true
    self._curPos = #self._text
  else
    self._focusing = false
  end
end

function TextInput:getWidth()
  return self._drawableText:getWidth()
end

function TextInput:getHeight()
  return self._drawableText:getHeight()
end


return TextInput
