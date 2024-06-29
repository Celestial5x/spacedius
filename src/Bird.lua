--[[
    Bird Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Bird is what we control in the game via clicking or the space bar; whenever we press either,
    the bird will flap and go up a little bit, where it will then be affected by gravity. If the bird hits
    the ground or a pipe, the game is over.
]]

Bird = Class{}


function Bird:init()
    self.image = love.graphics.newImage('graphics/bird.png')
    self.x = 16
    self.y = VIRTUAL_HEIGHT / 2 - 7

    self.width = self.image:getWidth() - 2
    self.height = self.image:getHeight() - 1
    self.dx = 0
    self.dy = 0
end

--[[
    AABB collision that expects a pipe, which will have an X and Y and reference
    global pipe width and height values.
]]
function Bird:collides(target)
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                self.y + self.height < target.y or self.y > target.y + target.height)
end

function Bird:update(dt)
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

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end