--[[
    GD50 2024
    Gradius Remake

    -- Boss Class --
    
    Author: Michael Chi
    mchi1@ualberta.ca

    -- Dependencies --

    A file to organize all of the global dependencies for our project, as
    well as the assets for our game, rather than pollute our main.lua file.
]]

--
-- libraries
--
Class = require 'lib/class'
push = require 'lib/push'
Timer = require 'lib/knife.timer'
--
-- our own code
--

-- utility
require 'src/constants'
require 'src/StateMachine'
require 'src/Util'

-- game states
require 'src/states/BaseState'
require 'src/states/PlayState'
require 'src/states/CountdownState'
require 'src/states/GameOverState'
require 'src/states/TitleScreenState'
require 'src/states/HighScoreState'
require 'src/states/EnterHighScoreState'


-- general
require 'src/Player'
require 'src/Plane'
require 'src/Bullet'
require 'src/Asteroid'
require 'src/PowerUp'
require 'src/Option'
require 'src/Missile'
require 'src/Boss'
require 'src/ProgressBar'

gSounds = {
    ['explosion1'] = love.audio.newSource('sounds/explosion1.wav', 'static'),
    ['explosion2'] = love.audio.newSource('sounds/explosion2.wav', 'static'),
    ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
    ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
    ['pause'] = love.audio.newSource('sounds/pause.wav', 'static'),
    -- http://oblidivmmusic.blogspot.com.es/
    ['music'] = love.audio.newSource('sounds/space_heroes.ogg', 'static'),
    ['pickup'] = love.audio.newSource('sounds/pickup.wav', 'static'),
    ['laser'] = love.audio.newSource('sounds/laser.wav', 'static'),
    ['laser1'] = love.audio.newSource('sounds/laser1.wav', 'static'),
    ['laser2'] = love.audio.newSource('sounds/laser2.wav', 'static'),
    ['high-score'] = love.audio.newSource('sounds/high_score.wav', 'static'),
    ['select'] = love.audio.newSource('sounds/select.wav', 'static'),
    ['wall-hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
    ['levelup'] = love.audio.newSource('sounds/levelup.wav', 'static'),
    ['siren'] = love.audio.newSource('sounds/siren.wav', 'static')
    }


 gTextures = {
    ['main'] = love.graphics.newImage('graphics/main.png'),
    ['planes'] = love.graphics.newImage('graphics/planes.png'),
    ['missile'] = love.graphics.newImage('graphics/missile.png'),
    -- Bonsaiheldin https://opengameart.org/content/sci-fi-space-simple-bullets
    ['enemy-bullets'] = love.graphics.newImage('graphics/enemy-bullets.png'),
    ['bullet-strips'] = love.graphics.newImage('graphics/bullet-strips.png')
}


gFrames = {
    ['bullets'] = GenerateQuads(gTextures['main'], 39, 39),
    ['enemy-bullets'] = GenerateQuads(gTextures['enemy-bullets'], 39, 39),
    ['ships'] = GenerateQuads(gTextures['planes'], 32, 32),
    ['bullet-strips'] = GenerateQuads(gTextures['bullet-strips'], 31, 22)
}
gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32),
    ['zelda'] = love.graphics.newFont('fonts/zelda.otf', 64),
    ['zelda-small'] = love.graphics.newFont('fonts/zelda.otf', 32),
    ['zelda-mini'] = love.graphics.newFont('fonts/zelda.otf', 16)
}