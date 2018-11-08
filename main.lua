--- deltalove
--- main.lua -- main process of deltalove
--- Author: AnswerXOX
--- Commentary:
--[[
   deltalove should result in giving a fully customizable battle experience that is identical to that of
   deltarune's, this is based off of the same idea that Unitale was based off of.
]]--
--- Code:

-- tweening library
flux = require "lib.flux"

-- virtual resolution handling library
push = require "lib.push"
push_settings = {
   raster = {x = 640, y = 480},
   window = {x = 640, y = 480},
   config = {fullscreen=false,resizable=true}
}

-- constants
local CONSTANTS = {
   FPS = 30
}


-- external code
require 'sprite'
require 'background'

-- set graphics filtering
love.graphics.setDefaultFilter("nearest", "nearest", 0)

-- load default resources
default = {
   image = {
      ['logo'] = love.graphics.newImage('/media/logo.png'),
      ['ralsei'] = love.graphics.newImage('/media/ralsei.png'),
      ['heart'] = love.graphics.newImage('/media/heart.png'),
      ['danmaku_region'] = love.graphics.newImage('/media/danmaku_region.png')
   },
   audio = {
      ['battle'] = love.audio.newSource('/media/battle.ogg', 'stream'),
      ['title'] = love.audio.newSource('/media/title.ogg', 'stream')
   },
   backgrounds = {
      ['default'] = Background:new(100,
				   function(s) end,
				   function(s) end,
				   function(s)
				      local t, l = s.___timer, s.___timer_toloop/2
				      local r,g,b,a = love.graphics.getColor()
				      local line = love.graphics.line
				      
				      for i = -2, 14 do
					 for j = -2, 14 do
					    love.graphics.setColor(6, 0, 6, 100)
					    line(i*l-t, j*l-t, i*l-t+l, j*l-t)
					    line(i*l-t, j*l-t, i*l-t, j*l-t+l)
					    --
					    love.graphics.setColor(13, 0, 13, 100)
					    line(i*l+t, j*l+t, i*l+t+l, j*l+t)
					    line(i*l+t, j*l+t, i*l+t, j*l+t+l)
					    --
					 end
				      end
				      love.graphics.setColor(r,g,b,a)
      end)
   },
   font = love.graphics.setNewFont('/media/fnt.ttf',32)
}

-- put animations in a different place as it depends on things already existing in the default table
default.animations = {
   ralsei = {
      ['idle'] = Animation:new({
	    {x=0,y=0,w=50,h=47},
	    {x=50,y=0,w=50,h=47},
	    {x=100,y=0,w=50,h=47},
	    {x=150,y=0,w=50,h=47},
	    {x=200,y=0,w=50,h=47}
			       }, default.image['ralsei'], 3)
   },
   ['logo'] = Animation:new({
	 {x=0,y=0,w=224,h=34}},default.image['logo'], 1),
   ['heart'] = Animation:new({
	 {x=0,y=0,w=16,h=16}}, default.image['heart'], 1),
   ['danmaku_region'] = Animation:new({
	 {x=0,y=0,w=150,h=150}}, default.image['danmaku_region'], 1)
}

-- game states
states = {
   old = '',
   current = 'title',
   scenes = {
      ['title'] = require('scene.title'),
      ['battle'] = require('scene.battle')
   }
}

function love.load()
   -- initialize virtual resolution
   push:setupScreen(push_settings.raster.x, push_settings.raster.y, push_settings.window.x, push_settings.window.y, push_settings.config)
   --
   return
end

function love.update(dt)
   -- tweening
   flux.update(dt)
   -- correct delta time to frames
   dt = (dt) * CONSTANTS.FPS
   -- check state
   if states.old ~= states.current then
      -- finish state if the name is anything that isn't empty
      if states.old ~= '' then
	 -- check if state actually exists
	 if states.scenes[states.old] ~= nil then
	    states.scenes[states.old]:finish()
	 -- if it doesn't, return an error
	 else
	    error(states.old .. " isn't a valid scene.")
	 end
      end
      -- start state if the name is anything that isn't empty
      -- also, if it is empty, end the game
      if states.current ~= '' then
	 -- check if state exists
	 if states.scenes[states.current] ~= nil then
	    states.scenes[states.current]:start()
	 -- if it doesn't, end the application
	 else
	    love.event.quit()
	 end
      else
	 love.event.quit()
      end
      states.old = states.current
   end
   -- update state
   states.scenes[states.current]:update(dt)
   --
   return
end

function love.draw()
   push:start()
   -- render state
   states.scenes[states.current]:draw()
   --
   push:finish()
   return
end

function love.resize(w, h)
   push:resize(w, h)
   --
   return
end

function love.keypressed(key, scancode, rep)
   -- check if the current state has a keypressed event to detect
   -- keys with
   if (states.scenes[states.current]["keypressed"] ~= nil) then
      states.scenes[states.current]:keypressed(key, scancode, rep)
   end
   -- F4: Fullscreen toggle
   if (scancode == "f4" and rep == false) then
      push:switchFullscreen(push_settings.window.x, push_settings.window.y)
   end
   --
   return
end

--- main.lua ends here
