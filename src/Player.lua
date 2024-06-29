--[[
    GD50 2024
    Gradius Remake

    -- Player Class --
    
    Author: Michael Chi
    mchi1@ualberta.ca

    Represents a ship which the player controls in the game by shooting bullets and/or missiles by holding down or pressing the space bar and movement with the arrow keys.  
    If player collides with bullets, asteroids, or enemy ships, the game is over.
]]
Player = Class{}


function Player:init()
    self.image = love.graphics.newImage('graphics/bird.png')
    -- initialize dimensions and velocities
    self.x = 16
    self.y = VIRTUAL_HEIGHT / 2 - 7
    self.width = self.image:getWidth() - 2
    self.height = self.image:getHeight() - 1
    self.dx = 0
    self.dy = 0
end

--[[
    AABB collision that expects a target.
]]
function Player:collides(target)
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                self.y + self.height < target.y or self.y > target.y + target.height)
end

function Player:update(dt)
    if love.keyboard.isDown('up') then
        self.dy = -MOVE_SPEED
    elseif love.keyboard.isDown('down') then
        self.dy = MOVE_SPEED
    else
        self.dy = 0
    end

    if love.keyboard.isDown('left') then
        self.dx = -MOVE_SPEED
    elseif love.keyboard.isDown('right') then
        self.dx = MOVE_SPEED
    else
        self.dx = 0
    end

    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt)
    else
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt)
    end

    if self.dx < 0 then
        self.x = math.max(0, self.x + self.dx * dt)
    else
        self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx * dt)
    end
end

function Player:render()
    love.graphics.draw(self.image, self.x, self.y)
end