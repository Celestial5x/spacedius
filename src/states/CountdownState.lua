--[[
    GD50 2024
    Gradius Remake

    -- CountdownState Class --
    
    Author: Michael Chi
    mchi1@ualberta.ca
]]

CountdownState = Class{__includes = BaseState}

-- takes 1 second to count down each time
COUNTDOWN_TIME = 0.75

function CountdownState:init()
    self.count = 3
    self.timer = 0
end

--[[
    Keeps track of how much time has passed and decreases count if the
    timer has exceeded our countdown time. If we have gone down to 0,
    we should transition to our PlayState.
]]
function CountdownState:enter(params)
    self.highScores = params.highScores
end
function CountdownState:update(dt)
    self.timer = self.timer + dt

    -- loop timer back to 0 (plus however far past COUNTDOWN_TIME we've gone)
    -- and decrement the counter once we've gone past the countdown time
    if self.timer > COUNTDOWN_TIME then
        self.timer = self.timer % COUNTDOWN_TIME
        self.count = self.count - 1

        -- when 0 is reached, we should enter the PlayState
        if self.count == 0 then
            gStateMachine:change('play', {
                highScores = self.highScores})
        end
    end
end

function CountdownState:render()
    -- render count big in the middle of the screen
    love.graphics.setFont(gFonts['zelda'])
    love.graphics.printf(tostring(self.count), 0, 110, VIRTUAL_WIDTH, 'center')
end