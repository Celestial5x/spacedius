--[[
    GD50 2024
    Gradius Remake

    -- Option Class --
    
    Author: Michael Chi
    mchi1@ualberta.ca

	Represents an option powerup which follow the player in a circular pattern around the ship.
	]]

Option = Class{}

local image = love.graphics.newImage('graphics/option.png')

function Option:init(x, y, counter)

	-- initialize dimensions and velocities
	self.x = x + 16
	self.y = y + 20
	self.width = 16
	self.height = 16	
	self.dx = 0
	self.dy = 0

    -- counter to keep track of the number of options
    self.counter = counter
end

function Option:update(X, Y, timer, number)
    self.centerX = X
    self.centerY = Y
    local i = timer
    local R = 36
    self.number = number

    -- math for rotation 3 options equally spaced around the player
    if self.number == 3 then
        if self.counter == 1 then
            self.x = self.centerX + 8 + R * math.cos(math.pi * i / 180) 
            self.y = self.centerY + R * math.sin(math.pi * i / 180)
        elseif self.counter == 2 then
            self.x = self.centerX + 8 + R * math.cos(math.pi * i / 180 + 2 * math.pi / 3) 
            self.y = self.centerY + R * math.sin(math.pi * i / 180 + 2 * math.pi / 3)
        else
            self.x = self.centerX + 8 + R * math.cos(math.pi * i / 180 - 2 * math.pi / 3) 
            self.y = self.centerY + R * math.sin(math.pi * i / 180 - 2 * math.pi / 3)        
        end
    
    -- math for rotation 1, 2, or 4 option(s) equally spaced around the player
    else
        if self.counter == 1 then
            self.x = self.centerX + 8 + R * math.cos(math.pi * i / 180) 
            self.y = self.centerY + R * math.sin(math.pi * i / 180)
        elseif self.counter == 2 then
            self.x = self.centerX + 8 + R * math.cos(math.pi * i / 180 + math.pi) 
            self.y = self.centerY + R * math.sin(math.pi * i / 180 + math.pi)
        elseif self.counter == 3 then
            self.x = self.centerX + 8 + R * math.cos(math.pi * i / 180 + math.pi / 2) 
            self.y = self.centerY + R * math.sin(math.pi * i / 180 + math.pi / 2)        
        else
            self.x = self.centerX + 8 + R * math.cos(math.pi * i / 180 - math.pi / 2) 
            self.y = self.centerY + R * math.sin(math.pi * i / 180 - math.pi / 2)        
        end
    end
end

function Option:render()
	love.graphics.draw(image, self.x, self.y)
end