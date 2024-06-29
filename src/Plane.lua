--[[
    GD50 2024
    Gradius Remake

    -- Plane Class --
    
    Author: Michael Chi
    mchi1@ualberta.ca

    Represents the enemy ships that randomly spawn in our game which can shoot bullets towards the player.
]]

Plane = Class{}


function Plane:init(y, skin)

    -- initialize dimensions and velocities
    self.x = VIRTUAL_WIDTH + 16
    self.y = y
    self.skin = skin
    self.width = 32
    self.height = 32
    self.dx = -math.random(30,60)
    self.dy = math.random(-10,10)
    self.health = 1
end

function Plane:update(dt)
    -- restrict enemy ship below the top edge of the screen and give it some random vertical velocity when touching the top edge of the screen
    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt)
        
        if self.y == 0 then
            self.dy = math.random(10)
        end
    -- restrict enemy ship above the bottom edge of the screen and give it some random vertical velocity when touching the bottom edge of the screen
    else
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt)
        
        if self.y == VIRTUAL_HEIGHT - self.height then
            self.dy = -math.random(10)
        end
    end

    self.x = self.x + self.dx * dt


end
function Plane:collides(target)
    return not (self.x + self.width < target.x  or self.x > target.x + target.width  or
                self.y + self.height < target.y or self.y > target.y + target.height)
end

function Plane:damage(dmg)
    self.health = self.health - dmg 
end

function Plane:render()
    love.graphics.draw(gTextures['planes'], gFrames['ships'][self.skin], self.x, self.y)
end