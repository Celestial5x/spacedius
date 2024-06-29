--[[
    GD50 2024
    Gradius Remake

    -- StartState Class --
    
    Author: Michael Chi
    mchi1@ualberta.ca

    The PlayState class is the bulk of the game, where the player actually controls the player ship and
    avoids asteroids, enemy ships, and bullets. Player can collect powerups that spawn at a random chance 
    when defeating enemy ships. Levels are gained after defeating a boss which spawns after reaching a 
    player score threshold.When the player collides with an asteroid, enemy ships, or bullets, we should 
    go to the GameOver state, where we then go back to the high score state or main menu.
]]

PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.player = Player()
    self.planes = {}
    self.planeTimer = 0
    self.score = 0
    self.bullets = {}
    self.playerBulletTimer = 0
    self.spawnPlane = math.random(2, 5)
    self.spawnAsteroid = math.random(4, 8)
    self.spawnBullet = math.random(1, 2)
    self.bulletTimer = 0
    self.asteroidTimer = 0
    self.asteroids = {}
    self.powerups = {}
    self.options = {}
    self.optionTimer = 0
    self.missiles = {}
    self.toggleMissile = false
    self.toggleBoss = false
    self.boss = nil
    self.bossPoints = 1500
    self.bossBulletTimer = 0
    self.bossShoot = math.random(1, 2)
    self.bossSpawnTimer = 0
    self.level = 1
end

function PlayState:enter(params)
    self.highScores = params.highScores
end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('p') then
            self.paused = false
            gSounds['pause']:play()
            gSounds['music']:play()
        else 
            return
        end
    elseif love.keyboard.wasPressed('p') then
        self.paused = true
        gSounds['pause']:play()
        gSounds['music']:pause()
        return
    end

    self.playerBulletTimer = self.playerBulletTimer + dt

    if self.playerBulletTimer > 0.25 then

        if love.keyboard.isDown('space') then
            table.insert(self.bullets, Bullet(self.player.x + self.player.width - 16, self.player.y + self.player.height / 2 - 19, 1))
            gSounds['pause']:setVolume(0.5)
            gSounds['laser2']:play()

            if self.toggleMissile then
                table.insert(self.missiles, Missile(self.player.x, self.player.y))
            end

            if #self.options > 0 then
                for k, option in pairs(self.options) do
                    table.insert(self.bullets, Bullet(option.x + option.width - 16, option.y + option.height / 2 - 19, 1))
                    if self.toggleMissile then
                        table.insert(self.missiles, Missile(option.x - 16, option.y))
                    end
                end
            end
            self.playerBulletTimer = 0
        end
    end

    -- update timer for plane spawning
    self.planeTimer = self.planeTimer + dt 

    -- spawn planes randomly 
    if self.planeTimer > self.spawnPlane then
        local y = math.random(VIRTUAL_HEIGHT - 32)

        for i = 1, math.random(2) + self.level do
        -- add a random number planes at the right edge of the screen
            table.insert(self.planes, Plane(math.max(0, y - 25 * math.random(2, 10)), math.random(4)))
        end

        -- reset timer
        self.planeTimer = 0
        self.spawnPlane = math.random(2, 4)
    end

    -- for every plane..
    for k, plane in pairs(self.planes) do
        plane:update(dt)
    end

    -- remove plane if it passes left edge of the screen
    for k, plane in pairs(self.planes) do
        if plane.x <= 0 then
            table.remove(self.planes, k)
        end

        -- remove plane if health drops below 0
        if plane.health <= 0 then

            -- random chance to spawn a powerup after being destroyed
            if math.random(5) == 1 then
                if #self.options < self.level and #self.options < 4 and not self.toggleMissile then
                    table.insert(self.powerups, Powerup(plane.x + 24, plane.y + 24, math.random(1, 2)))
                elseif #self.options < self.level and #self.options < 4 and self.toggleMissile then
                    table.insert(self.powerups, Powerup(plane.x + 24, plane.y + 24, 1))
                elseif not self.toggleMissile then
                    table.insert(self.powerups, Powerup(plane.x + 24, plane.y + 24, 2))
                end
            end
            gSounds['explosion1']:stop()            
            gSounds['explosion1']:setVolume(0.5)            
            gSounds['explosion1']:play()
            self.score = self.score + 100  + 10 * (self.level - 1)
            table.remove(self.planes, k)
        end        
    end

    -- simple collision between player and plane
    for k, plane in pairs(self.planes) do
        if plane:collides(self.player) then
            gSounds['explosion1']:play()
            gSounds['hurt']:play()
            gStateMachine:change('game-over', {
            score = self.score,
            highScores = self.highScores
            })
        end
    end

    -- update timer for asteroid spawning
    self.asteroidTimer = self.asteroidTimer + dt

    if self.asteroidTimer > self.spawnAsteroid then
        -- add a new asteroid end of the screen randomly at right edge of the screen
        table.insert(self.asteroids, Asteroid(math.random(VIRTUAL_HEIGHT)))
        
        -- reset timer
        self.asteroidTimer = 0
        self.spawnAsteroid = math.random(4, 8)
    end

    -- for every asteroid..
    for k, asteroid in pairs(self.asteroids) do
        asteroid:update(dt)
    end
    
    -- detect player collision with asteroid and change to GameOver state
    for k, asteroid in pairs(self.asteroids) do
        if self.player:collides(asteroid) then
            gSounds['explosion1']:play()
            gSounds['hurt']:play()
            gStateMachine:change('game-over', {
            score = self.score,
            highScores = self.highScores
            })
        end

        -- detect player bullet collision with asteroid and remove bullets
        for l, bullet in pairs(self.bullets) do
            if bullet:collides(asteroid) and bullet.skin == 1 then
                table.remove(self.bullets, l)
            end
        end
    end

    -- update timer for enemy bullet firing
    self.bulletTimer = self.bulletTimer + dt

    if #self.planes > 0 then
        if self.bulletTimer > self.spawnBullet then
            -- chance to shoot bullet towards the player
            for k, plane in pairs(self.planes) do      
                if math.random(2) == 1 and plane.x < VIRTUAL_WIDTH then
                    table.insert(self.bullets, Bullet(self.planes[k].x - 8, self.planes[k].y - 8, 3, self.player.x, self.player.y))
                    gSounds['laser1']:setVolume(0.5)
                    gSounds['laser1']:play()
                end
                self.bulletTimer = 0
                self.spawnBullet = math.random(1, 2)
            end
        end
    end

    -- for every bullet..
    for k, bullet in pairs(self.bullets) do
        bullet:update(dt)
    end

    -- remove player bullets (blue) if it passes the right edge of screen or enemy bullets (red or yellow) it if passes the left edge of screen
    for k, bullet in pairs(self.bullets) do
        if bullet.x > VIRTUAL_WIDTH and bullet.skin == 1 or bullet.x < -30 then
            table.remove(self.bullets, k)
        end
    end

    -- detect player bullet collision with planes and does damage
    for k, bullet in pairs(self.bullets) do
        for l, plane in pairs(self.planes) do
            if plane:collides(bullet) and bullet.skin == 1 and bullet.x < VIRTUAL_WIDTH - 16 then
                plane:damage(1)
                table.remove(self.bullets, k)
            end

        end

        -- detect enemy bullet collision with player and goes to Game Over state
        if bullet.skin ~= 1 then
            if self.player:collides(bullet) then
                gSounds['explosion1']:play()
                gSounds['hurt']:play()
                gStateMachine:change('game-over', {
                score = self.score,
                highScores = self.highScores
                })
            end

            -- detect enemy bullet collision with options and removes bullets
            if #self.options > 0 then
                for l, option in pairs(self.options) do
                    if bullet:collides(option) then
                        table.remove(self.bullets, k)
                    end
                end
            end
        end 
    end

    -- for every powerup..
    for k, powerup in pairs(self.powerups) do
        powerup:update(dt)
    end


    for k, powerup in pairs(self.powerups) do
        -- option powerup; the number of options the player has is restricted to the level up to a maximum of 4
        if powerup:collides(self.player) and #self.options < 4 and powerup.type == 1 then
            if #self.options == 0 and self.level > #self.options then
                gSounds['pickup']:stop()
                gSounds['pickup']:play()
                table.insert(self.options, Option(self.player.x, self.player.y, 1))
                table.remove(self.powerups, k)
            elseif #self.options == 1 and self.level > #self.options then
                gSounds['pickup']:stop()
                gSounds['pickup']:play()
                table.insert(self.options, Option(self.player.x, self.player.y, 2))
                table.remove(self.powerups, k)
            elseif #self.options == 2 and self.level > #self.options then
                gSounds['pickup']:stop()
                gSounds['pickup']:play()
                table.insert(self.options, Option(self.player.x, self.player.y, 3))
                table.remove(self.powerups, k)
            elseif #self.options == 3 and self.level > #self.options then
                gSounds['pickup']:stop()
                gSounds['pickup']:play()
                table.insert(self.options, Option(self.player.x, self.player.y, 4))
                table.remove(self.powerups, k)
            else
                table.remove(self.powerups, k)
            end

        -- missile power up
        elseif powerup:collides(self.player) and not self.toggleMissile and powerup.type == 2 then
            self.toggleMissile = true
            gSounds['pickup']:stop()
            gSounds['pickup']:play()
        elseif powerup:collides(self.player) then
            table.remove(self.powerups, k)
        end
    end


    -- update player based on input
    self.player:update(dt)

    -- update option powerup based on the number of options the player has
    if #self.options > 0 then
        for k, option in pairs(self.options) do
            option:update(self.player.x, self.player.y, self.optionTimer, #self.options)
        end
        -- updates timer for rotation around the ship
        if self.optionTimer < 720 then
                self.optionTimer = self.optionTimer + 1
            else
                self.optionTimer = 0
        end
    end

    -- remove missiles if they pass the top edge or bottom edge of the screen
    for k, missile in pairs(self.missiles) do
        if missile.y < -16 or missile.y > VIRTUAL_HEIGHT then
            table.remove(self.missiles, k)
        end
    end

    -- for every missile
    for k, missile in pairs(self.missiles) do
        missile:update(dt)
    end


    for k, missile in pairs(self.missiles) do
        -- detect missile collision with enemy ships and does damage
        for l, plane in pairs(self.planes) do
            if missile:collides(plane) then
                plane:damage(1)
                table.remove(self.missiles, k)
            end
        end
        -- detect missile collision with asteroid and removes asteroid
        for l, asteroid in pairs(self.asteroids) do
            if missile:collides(asteroid) then
                gSounds['explosion2']:stop()
                gSounds['explosion2']:play()
                table.remove(self.missiles, k)
                table.remove(self.asteroids, l)
            end
        end
    end

    -- if player score exceeds a threshold, then give a warning and spawn the boss after 6 seconds
    if self.score > self.bossPoints and not self.toggleBoss then
        self.bossSpawnTimer = self.bossSpawnTimer + dt
        gSounds['siren']:setVolume(0.75)
        gSounds['siren']:play()
        if self.bossSpawnTimer > 6 then
            self.toggleBoss = true
            self.boss = Boss(math.random(50, VIRTUAL_HEIGHT - 128), self.level)
            self.bossSpawnTimer = 0
        end
    end

    -- updates boss if spawned
    if self.toggleBoss then
        self.boss:update(dt)
    end
    
    -- shows boss health bar if spawned
    if self.toggleBoss then

        self.bossHealthBar = ProgressBar{
            x = VIRTUAL_WIDTH / 2 - 92,
            y = VIRTUAL_HEIGHT - 20,
            width = 186,
            height = 8,
            color = {r = 189/255, g = 32/255, b = 32/255},
            value = self.boss.health,
            max = self.boss.maxHealth
        }

        -- detect boss collision with player and goes to GameOver state
        if self.boss:collides(self.player) then
            gSounds['explosion1']:play()
            gSounds['hurt']:play()
            gStateMachine:change('game-over', {
                score = self.score,
                highScores = self.highScores
                })
        end

        -- update bullet timer for boss
        self.bossBulletTimer = self.bossBulletTimer + dt
        
        -- spawn boss bullets
        
        if self.bossBulletTimer > self.bossShoot / 1.5 and math.random(100) == 1 then
            table.insert(self.bullets, Bullet(self.boss.x, self.boss.y + 24, 2))
            table.insert(self.bullets, Bullet(self.boss.x, self.boss.y + 96, 2))
            gSounds['laser']:stop()                
            gSounds['laser']:setVolume(0.5)
            gSounds['laser']:play()
        end

        if self.bossBulletTimer > self.bossShoot then

            table.insert(self.bullets, Bullet(self.boss.x, self.boss.y + 24, 2))
            table.insert(self.bullets, Bullet(self.boss.x, self.boss.y + 96, 2))
            gSounds['laser']:stop()                
            gSounds['laser']:setVolume(0.5)
            gSounds['laser']:play()
            self.bossBulletTimer = 0
            self.bossShoot = math.random(1,2)
        end

        -- detect bullet collision with boss and does damage
        for k, bullet in pairs(self.bullets) do
            if self.boss:collides(bullet) and bullet.skin == 1 then
                self.boss:damage(1)
                gSounds['wall-hit']:stop()
                gSounds['wall-hit']:play()
                table.remove(self.bullets, k)
            end
        end

        -- detect missile collision with boss and does damage
        for k, missile in pairs(self.missiles) do
            if self.boss:collides(missile) then
                self.boss:damage(1)
                gSounds['wall-hit']:stop()
                gSounds['wall-hit']:play()
                table.remove(self.missiles, k)
            end
        end

        -- if boss health falls below 0 then boss is destroyed; awards points, updates next player score threshold for next boss spawn and increases level
        if self.boss.health <= 0 then
            self.boss = nil
            self.toggleBoss = false
            gSounds['explosion2']:play()
            self.score = self.score + 5000  + 500 * self.level
            self.level = self.level + 1
            self.bossPoints = self.bossPoints + 5000 + 2500 * self.level 
            gSounds['levelup']:setVolume(0.5)
            gSounds['levelup']:play()
        end
    end
end

function PlayState:render()
    for k, plane in pairs(self.planes) do
        plane:render()
    end

    for k, asteroid in pairs(self.asteroids) do
        asteroid:render()
    end

    for k, powerup in pairs(self.powerups) do
        powerup:render()
    end

    love.graphics.setFont(gFonts['zelda-mini'])
    love.graphics.print('SCORE: ' .. tostring(self.score), 8, 8)
    love.graphics.print('LEVEL: ' .. tostring(self.level), 8, VIRTUAL_HEIGHT - 24)

    self.player:render()

    if #self.options > 0 then
        for k, option in pairs(self.options) do
            option:render()
        end
    end

    if #self.missiles > 0 then
        for k, missile in pairs(self.missiles) do
            missile:render()
        end
    end

    for k, bullet in pairs(self.bullets) do
        bullet:render()
    end

    if self.toggleBoss then
        self.boss:render()
        self.bossHealthBar:render()
    end
    if self.score > self.bossPoints and not self.toggleBoss then
        love.graphics.setFont(gFonts['zelda'])
        love.graphics.setColor(255, 0, 0, 1)
        love.graphics.printf("WARNING!", 0, VIRTUAL_HEIGHT/2 - 32, VIRTUAL_WIDTH, 'center')
        love.graphics.setColor(1, 1, 1, 1)
    end

    if self.paused then
    love.graphics.setFont(gFonts['zelda'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT/2 - 32, VIRTUAL_WIDTH, 'center')
    end
end
