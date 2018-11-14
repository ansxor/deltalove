--- deltalove
--- battle.lua -- the main battle process
--- Author: AnswerXOX
--- Commentary:
--- Code:

local battle = {
    friendlies = {
        -- test friendly
        ['test_ralsei'] = {
            color = {20, 20, 20},
            HP = {cur = 70, max = 70},
            sprite = Sprite:new(default.animations.ralsei['idle'], 0, 0)
        }
    }
 }

local conf = nil
local state = {
   list = {"selectMove", "selectEnemy", "selectOption", "fight", "danmaku"},
   current = "danmaku"
}

local heart = nil

-- danmaku region
local danmakuRegion = {
   region = {
      x = push_settings.raster.x/2, y = push_settings.raster.y/2,
      w = 150, h = 150
   },
   focus = 0,
   loading = false, loaded = false,
   -- the heart will only be drawn if the danmaku region is loaded (the animation is completed)
}

danmakuRegion.sprite = Sprite:new(default.animations['danmaku_region'], danmakuRegion.region.x, danmakuRegion.region.y, 0, 0, danmakuRegion.region.w/2, danmakuRegion.region.h/2)

danmakuRegion.heart = {
   sprite = Sprite:new(default.animations['heart'], danmakuRegion.region.x, danmakuRegion.region.y, 1, 1, 8, 8),
   x = danmakuRegion.region.w/2, y = danmakuRegion.region.h/2, speed = 2
}

function danmakuRegion:init()
   danmakuRegion.loading = true
   flux.to(danmakuRegion.sprite, .5, {rot = math.pi * 2, sx = 1, sy = 1}):oncomplete(function()
	 danmakuRegion.loaded = true
										    end)
   flux.to(danmakuRegion, 0.5, { focus = 100 })
   --
   return
end

function battle:setBattleConfig(filename)
   conf = require(filename)
   --
   return
end

function battle:start()
   -- make danmaku region
   
   -- play the bopn
   default.audio['battle']:setLooping(true)
   love.audio.play(default.audio['battle'])
   --

   return
end

function battle:update(dt)
   default.backgrounds['default']:update(dt)
   local k,v = nil, nil
   -- handle friendlies
   for k,v in pairs(battle.friendlies) do
      v.sprite.x, v.sprite.y = 32, 40
      v.sprite.x, v.sprite.y = 2, 2
      v.sprite:update(dt)
   end
   -- handle enemies
   -- #TODO ADD SAMPLE ENEMY
   -- handle current state
   local st = state.current
   if     (st == "selectMove")   then
      --
   elseif (st == "selectEnemy")  then
      --
   elseif (st == "selectOption") then
      --
   elseif (st == "fight")        then
      --
   elseif (st == "danmaku")      then
      if (danmakuRegion.loading == false) then
	 danmakuRegion:init()
      end
      if (danmakuRegion.loaded == true) then
	 -- update heart position
	 local h = danmakuRegion.heart
	 local hs = h.sprite
	 local dr = danmakuRegion.region
	 hs.x, hs.y = dr.x - dr.w / 2 + h.x, dr.y - dr.h / 2 + h.y
	 do -- controlling of the heart
	    local s = love.keyboard.isScancodeDown
	    if     s('left')  then
	       h.x = h.x - h.speed
	    elseif s('right') then
	       h.x = h.x + h.speed
	    end
	    if     s('up')   then
	       h.y = h.y - h.speed
	    elseif s('down') then
	       h.y = h.y + h.speed
	    end
	 end
      end
      --
   end
   --
   return
end

function battle:draw()
   default.backgrounds['default']:draw()
   local k,v = nil,nil
   -- handle friendlies
   for k,v in pairs(battle.friendlies) do
      v.sprite:draw()
   end
   -- put a focus or not on the background
   -- #TODO FIX BLENDING
   --[[do
      local r, g, b, a = love.graphics.getColor()
      love.graphics.setColor(0, 0, 0, danmakuRegion.focus)
      love.graphics.polygon('fill',
			    0, 0,
			    push_settings.raster.x, 0,
			    push_settings.raster.x, push_settings.raster.y,
			    0, push_settings.raster.y)
      love.graphics.setColor(r, g, b, a)
      end]]--
   -- draw danmaku region
   danmakuRegion.sprite:draw()
   -- handle state
   local st = state.current
   if     (st == "selectMove")   then
      --
   elseif (st == "selectEnemy")  then
      --
   elseif (st == "selectOption") then
      --
   elseif (st == "fight")        then
      --
   elseif (st == "danmaku")      then
      if (danmakuRegion.loaded == true) then
	 danmakuRegion.heart.sprite:draw()
      end
      --
   end
   --
   return
end

function battle:finish()
   --
   return
end

function battle:keypressed(key, scancode, rep)
   local st = state.current
   if (st == 'danmaku') then

   end
   --
   return
end

return battle

--- battle.lua ends here
