--[[
    GD50 2024
    Gradius Remake

    -- GameOverState Class --
    
    Author: Michael Chi
    mchi1@ualberta.ca

    The state in which we've lost and get our score displayed to us. Should
    transition to the EnterHighScore state if we exceeded one of our stored high scores, else back
    to the StartState.
]]

GameOverState = Class{__includes = BaseState}

function GameOverState:enter(params)
    self.score = params.score
    self.highScores = params.highScores
end

function GameOverState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        -- see if score is higher than any in the high scores table
        local highScore = false
        
        -- keep track of what high score ours overwrites, if any
        local scoreIndex = 11

        for i = 10, 1, -1 do
            local score = self.highScores[i].score or 0
            if self.score > score then
                highScoreIndex = i
                highScore = true
            end
        end

        if highScore then
            gSounds['high-score']:play()
            gStateMachine:change('enter-high-score', {
                highScores = self.highScores,
                score = self.score,
                scoreIndex = highScoreIndex
            }) 
        else 
            gStateMachine:change('title', {
                highScores = self.highScores
            }) 
        end
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function GameOverState:render()
    love.graphics.setFont(gFonts['zelda'])
    love.graphics.printf('GAME OVER', 0, VIRTUAL_HEIGHT / 3 - 42, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['zelda-small'])
    love.graphics.printf('FINAL SCORE: ' .. tostring(self.score), 0, VIRTUAL_HEIGHT / 2  - 2,
        VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press ENTER or RETURN!', 0, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 4 - 10,
        VIRTUAL_WIDTH, 'center')
end