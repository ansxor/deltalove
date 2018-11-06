--- deltalove
--- background.lua -- provides a wrapper for battle backgrounds
--- Author: AnswerXOX
--- Commentary:
--- Code:

Background = {}
Background.__index = Background

function Background:new(timerLoop, init, update, draw)
   local this = {
      ___timer = 0,
      ___timer_toloop = timerLoop,
      ['___init'] = init,
      ['___update'] = update,
      ['___draw'] = draw
   }
   setmetatable(this, Background)
   --
   this:init()
   return this
end

function Background:init()
   self['___init'](self)
   --
   return
end

function Background:update(dt)
   self.___timer = (self.___timer + 1*dt) % self.___timer_toloop
   self['___update'](self)
   --
   return
end

function Background:draw()
   self['___draw'](self)
   --
   return
end

--- background.lua ends here
