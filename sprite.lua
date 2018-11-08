--- deltalove
--- sprite.lua -- A sprite wrapper for deltalove
--- Author: AnswerXOX
--- Commentary:
--[[
   This should provide an easy-to-use wrapper for sprites since it can be a pain to make
   constant sprites and animation. Sprites depend on animations in order to work as they
   are the base of their display data.
]]--
--- Code:

-- Sprite Class

Sprite = {}
Sprite.__index = Sprite

function Sprite:new(anim, x, y, sx, sy, ox, oy)
   sx, sy, ox, oy = sx or 1, sy or 1, ox or 0, oy or 0
   local this = {
      x = x, y = y,
      anim = anim,
      sx = sx, sy = sy, rot = 0,
      ox = ox, oy = oy
   }
   setmetatable(this, Sprite)
   --
   return this
end

function Sprite:update(dt)
   self.anim:update(dt)
   --
   return
end

function Sprite:draw()
   local i, q = self.anim.img, self.anim.quads[self.anim.frame]
--   q = love.graphics.newQuad(0, 0, 32, 32, i:getDimensions())
   love.graphics.draw(i, q, self.x, self.y, self.rot, self.sx, self.sy, self.ox, self.oy)
   --
   return
end

-- Animation Class
-- (note, animations can only control the current visual of the sprite)
Animation = {}
Animation.__index = Animation

local function generateAnimationQuads(quads, img)
   local rets = {}
   local i = 0
   local imgW, imgH = img:getDimensions()
   for i = 1, #quads do
      local q = quads[i]
      local x, y, w, h = q.x, q.y, q.w, q.h
      table.insert(rets, love.graphics.newQuad(x, y, w, h, imgW, imgH))
   end
   --
   return rets
end

function Animation:new(quad, image, ref_rate, loop)
   local anim_quads = generateAnimationQuads(quad, image)
   local this = {
      timer = 0,
      frame = 1,
      rate = ref_rate,
      quads = anim_quads,
      img = image,
      loop = loop or true
   }
   setmetatable(this, Animation)
   
   --
   return this
end

function Animation:update(dt)
   self.timer = self.timer + 1*dt
   -- is the timer over the refresh rate?
   if self.timer > self.rate then
      if self.frame+1 >= #self.quads then
	 if self.loop == true then
	    self.frame = 1
	 end
      else
	 self.frame = self.frame + 1
      end
      self.timer = 0
   end
   --
   return
end

function Animation:draw()
   -- placeholder function
   return
end

function Animation:get()
--   print(self.quads[self.frame])
   
   return self.img, self.quads[self.frame]
end

--- sprite.lua ends here

