--[[
    GD50 2024
    Gradius Remake

    -- Bullet Class --
    
    Author: Michael Chi
    mchi1@ualberta.ca

    Represents a bullet which will damage other ships. Friendly bullets (blue) damage enemy ships while enemy bullets (red and yellow) damage the player. 
    When the player collides with one of the enemy bullets, it's game over.
]]

Bullet = Class{}

function Bullet:init(x, y, skin, playerX, playerY)
    self.x = x
    self.y = y
    
    -- skin 1 is friendly bullets (blue) while skin 2 and 3 are enemy bullets (red and yellow, respectively)
    self.skin = skin
    self.playerX = playerX
    self.playerY = playerY
    self.dy = 0
    self.dx = 0

    -- skin 2 is boss bullets (red) which are wider than other bullets
    if self.skin == 2 then
        self.width = 30
        self.height = 15

    else
        self.width = 15
        self.height = 15
    end
    
    -- calculates the difference in y coordinates between the player and enemy ship to allow enemy bullets to target the player
    if self.playerY ~= nil then
        self.deltaY = self.playerY - self.y
    end
end



function Bullet:collides(target)
        return not (self.x + self.width < target.x or self.x > target.x + target.width or
                self.y + self.height < target.y or self.y > target.y + target.height)
end

function Bullet:update(dt)

    -- friendly bullets (blue) shoot to the right
    if self.skin == 1 then
        self.dx = BULLET_SPEED

    -- enemy bullets (red and yellow) shoot to the left
    elseif self.skin == 2 then
        self.dx = -BULLET_SPEED
    
    -- enemby bullets (yellow) aim towards the player
    else
        self.dx = -BULLET_SPEED
        self.dy = self.deltaY
    end

    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Bullet:render()
    if self.skin == 1 then
        love.graphics.draw(gTextures['main'], gFrames['bullets'][self.skin], self.x, self.y)
    elseif self.skin == 2 then
        love.graphics.draw(gTextures['bullet-strips'], gFrames['bullet-strips'][11], self.x, self.y)
    else
        love.graphics.draw(gTextures['enemy-bullets'], gFrames['enemy-bullets'][1], self.x, self.y)
    end
end