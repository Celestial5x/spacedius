--[[
    -- TitleScreenState Class --
    
    Author: Michael Chi
    mchi1@ualberta.ca

    The TitleScreenState is the starting screen of the game, shown on startup. It should
    display "Start" and "High Scores".
]]

TitleScreenState = Class{__includes = BaseState}

-- whether we're highlighting "Start" or "High Scores"
local highlighted = 1
function TitleScreenState:enter(params)
    self.highScores = params.highScores
end
function TitleScreenState:update(dt)
    -- toggle highlighted option if we press an arrow key up or down
    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
        highlighted = highlighted == 1 and 2 or 1
        gSounds['select']:play()
    end

    -- transition to countdown when enter/return are pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        if highlighted == 1 then
            gStateMachine:change('countdown', {
                highScores = self.highScores
            })
        else
            gStateMachine:change('high-scores',{
                highScores = self.highScores
            })

        end
    end
end

function TitleScreenState:render()
    -- simple UI code
    love.graphics.setFont(gFonts['zelda'])
    love.graphics.setColor(0, 0, 139, 1)
    love.graphics.printf('SPACEDIUS', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['zelda-small'])
        love.graphics.setColor(1, 1, 1, 1)

    if highlighted == 1 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.printf('START', 0, 170, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(1, 1, 1, 1)
    if highlighted == 2 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.printf("HIGH SCORES", 0, VIRTUAL_HEIGHT / 2 + 70,
        VIRTUAL_WIDTH, 'center')

    -- reset the color
    love.graphics.setColor(1, 1, 1, 1)
end