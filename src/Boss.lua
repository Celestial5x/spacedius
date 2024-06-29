--[[
    GD50 2024
    Gradius Remake

    -- Boss Class --
    
    Author: Michael Chi
    mchi1@ualberta.ca

    Represents a boss ship which the spawns on the right edge of the screen after reaching a certain score threshold.
]]

Boss = Class{}
    
    -- https://opengameart.org/content/enemy-spaceship-2d-sprites-pixel-art
    local image = love.graphics.newImage('graphics/boss.png')

function Boss:init(y, level)
    -- initialize dimensions and velocities
    self.x = VIRTUAL_WIDTH - 128
    self.y = y
    self.width = 128
    self.height = 128
    self.dx = 0
    self.dy = math.random(2) == 1 and (-25) or 25

    -- set max health dependant on current level and used to draw boss health bar
    self.maxHealth = 100 + 10 * level

    -- track current health and used to update boss health bar
    self.health = 100 + 10 * level
end

function Boss:update(dt)
    -- basic ai movement from top edge to bottom edge of the screen
    if self.dy < 0 then
        self.y = math.max(-16, self.y + self.dy * dt)
        
        if self.y == -16 then
            self.dy = math.random(25,75)
        end

    else
        self.y = math.min(VIRTUAL_HEIGHT - self.height - 16, self.y + self.dy * dt)
        
        if self.y == VIRTUAL_HEIGHT - self.height - 16 then
            self.dy = -math.random(25,75)
        end
    end

    self.x = self.x + self.dx * dt
end

function Boss:collides(target)
    return not (self.x + target.width  < target.x  or self.x > target.x + target.width  or
                self.y + self.height < target.y or self.y > target.y + target.height)
end

function Boss:damage(dmg)
    self.health = self.health - dmg
end

function Boss:render()
    love.graphics.draw(image, self.x, self.y)
end