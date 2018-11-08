--- deltalove
--- title.lua -- title screen state
--- Author: AnswerXOX
--- Commentary:
--[[
   This title screen should give a basic screen that shows information about the different battles that are available,
   scrolling through each of the battles should display a description and encounter label/name.
]]--
--- Code:

local title = {}
local animation_timer = 90
local menuSelections = {
   {text="Run battle test.",scene="battle"},
   {text="Exit the game.",scene=""}
}
local selectedOption = 0

local test_ralsei

local logo = {sprite=nil}
local heart = nil

function title:start()
--   default.audio['title']:setLooping(true)
  -- love.audio.play(default.audio['title'])
   default.audio['title']:setLooping(true)
   love.audio.play(default.audio['title'])
   logo.sprite = Sprite:new(default.animations['logo'], 0, 0)
   logo.sprite.sx, logo.sprite.sy = 2, 2
   heart = Sprite:new(default.animations['heart'], 200, 212)
   --
   return
end

function title:update(dt)
   -- do sine animation for logo
   animation_timer = (animation_timer + 0.05 * dt) % 360
   local y = 24 + math.sin(animation_timer)* 4
   logo.sprite.y = y
   logo.sprite.x = 640/2-(224)
   logo.sprite:update(dt)
   heart:update(dt)
   --
   return
end

function title:draw()
   --
   logo.sprite:draw()
   -- draw menu selection items
   local i = 0
   for i = 1, #menuSelections do
      -- highlight yellow if option is selected
      if (selectedOption+1 == i) then
	 love.graphics.setColor(255,255,0,255)
      else -- otherwise highlight white
	 love.graphics.setColor(255,255,255,255)
      end
      love.graphics.print(menuSelections[i].text, 230, 140+64*i)
   end
   heart:draw()
   --
   return
end

function title:finish()
   love.audio.stop(default.audio['title'])
   --
   return
end

function title:keypressed(key, scancode, rep)
   if ((scancode == "down" or scancode == "up") and rep == false) then
      selectedOption = (selectedOption + 1) % 2
      flux.to(heart, 0.25, {x=200, y=212+selectedOption*64})
   end
   if (scancode == "z" and rep == false) then
      states.current = menuSelections[selectedOption + 1].scene
   end
   --
   return
end

return title

--- title.lua ends here
