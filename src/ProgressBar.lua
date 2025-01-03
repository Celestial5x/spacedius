--[[
    GD50 2024
    Gradius Remake

    -- ProgressBar Class --
    
    Author: Michael Chi
    mchi1@ualberta.ca

    Represents a progress bar displaying the enemy boss health.
]]

ProgressBar = Class{}

function ProgressBar:init(def)
    -- initialize dimensions, color, and values
    self.x = def.x
    self.y = def.y
    
    self.width = def.width
    self.height = def.height
    
    self.color = def.color

    self.value = def.value
    self.max = def.max
end

function ProgressBar:setMax(max)
    self.max = max
end

function ProgressBar:setValue(value)
    self.value = value
end

function ProgressBar:update()

end

function ProgressBar:render()
    -- multiplier on width based on progress
    local renderWidth = (self.value / self.max) * self.width

    -- draw main bar, with calculated width based on value / max
    love.graphics.setColor(self.color.r, self.color.g, self.color.b, 1)
    
    if self.value > 0 then
        love.graphics.rectangle('fill', self.x, self.y, renderWidth, self.height, 3)
    end

    -- draw outline around actual bar
    love.graphics.setColor(0, 0, 255, 1)
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height, 3)
    love.graphics.setColor(1, 1, 1, 1)
end