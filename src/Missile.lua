--[[
    GD50 2024
    Gradius Remake

    -- Missile Class --
    
    Author: Michael Chi
    mchi1@ualberta.ca

    Represents missile powerup that damages enemy ships and can destroy asteroids.
]]

Missile = Class{}
    local image = love.graphics.newImage('graphics/missile.png')

function Missile:init(x, y)
    self.width = 16
    self.height = 16
    self.dx = BULLET_SPEED / 2

    -- aims the missiles upwards if player or option is below half of the screen
    if y > VIRTUAL_HEIGHT / 2 then
        self.dy = - BULLET_SPEED / 2
        self.direction = 'up'
        self.x = x + 16
        self.y = y

    -- aims the missiles downwards if player or option is above half of the screen
    else
        self.dy = BULLET_SPEED / 2
        self.direction = 'down'
        self.x = x + 32
        self.y = y + 8
    end
end

function Missile:collides(target)
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                self.y + self.height < target.y or self.y > target.y + target.height)
end

function Missile:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Missile:render()
    -- aims the missiles with a 45 degree rotation if ship or option is below half of the screen
    if self.direction == 'up' then
        love.graphics.draw(image, self.x, self.y, math.pi / 4, 1, 1)

    -- aims the missiles with a 135 degree rotation if ship or option is above half of the screen    
    else
        love.graphics.draw(image, self.x, self.y, 3 * math.pi / 4, 1, 1)
    end
end