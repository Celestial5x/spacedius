--[[
    GD50 2024
    Gradius Remake

    -- Asteroid Class --
    
    Author: Michael Chi
    mchi1@ualberta.ca

    The Asteroid class represents the asteroids that randomly spawn in our game, which act as obstacles in the level.
    The asteroids cannot be damaged with bullets and but can destroyed with the missile powerup. When the player collides
    with one of the asteroids, it's game over.
]]

Asteroid = Class{}
local image = love.graphics.newImage('graphics/asteroid.png')

function Asteroid:init(y)
    self.x = VIRTUAL_WIDTH + 16
    self.y = y
    self.width = 16
    self.height = 16
    self.dx = -math.random(15, 30)
    self.dy = math.random(-10, 10)
end

function Asteroid:update(dt)
    self.y = self.y + self.dy * dt
    self.x = self.x + self.dx * dt
end

function Asteroid:render()
    love.graphics.draw(image, self.x, self.y)
end