--[[
    GD50 2024
    Gradius Remake

    -- Powerup Class --
    
    Author: Michael Chi
    mchi1@ualberta.ca


	Represents a powerup which will spawn from defeating enemy ships.
	]]

Powerup = Class{}

local powerupOption = love.graphics.newImage('graphics/powerup-option.png')

local powerupMissile = love.graphics.newImage('graphics/missile.png')

function Powerup:init(x, y, type)
	-- initialize dimensions and velocities
	self.x = x - 16
	self.y = y + 8
	-- type 1 is the option powerup; type 2 is the missile powerup
	self.type = type
	self.width = 12
	self.height = 12
	self.dx = -35
	self.dy = 0
end

function Powerup:collides(target)
	return not (self.x + self.width < target.x or self.x > target.x + target.width or
                self.y + self.height < target.y or self.y > target.y + target.height)
end

function Powerup:update(dt)
	self.x = self.x + self.dx * dt 
end

function Powerup:render()
	if self.type == 1 then
		love.graphics.draw(powerupOption, self.x, self.y)
	else
		love.graphics.draw(powerupMissile, self.x, self.y)		
	end
end