require 'class'
push = require 'push'
require 'ground'
require 'arm_2'

WINDOW_WIDTH = 800
WINDOW_HEIGHT = 600
VIRTUAL_WIDTH = 400
VIRTUAL_HEIGHT = 300

TARGET = {1.0, 1.0}  
LENGTH = {1.0, 1.0, 1.0}
LEARNING_RATE = 0.05
MAX_ITERS = 200
TOLERANCE = 1e-3
THETA_VEL = {0.4, 0.4, 0.4}
CENTER_X = 200  
CENTER_Y = 200
RADIUS = 15

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    THETA_INI = {math.pi / 4, -math.pi / 4, math.pi / 4}

    arm = arm(LENGTH, TARGET, LEARNING_RATE, MAX_ITERS, TOLERANCE, THETA_INI, THETA_VEL, CENTER_X, CENTER_Y)
    ground = ground(CENTER_X, CENTER_Y, RADIUS) 

    gameState = 'play' 

    --print("Game loaded, press ESC to exit.")
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'r' then
        arm:reset()
        
    end
end

function love.update(dt)
    if gameState == 'play' then
        arm:update(dt)
    end
end

function love.draw()
    push:apply('start')
    
    love.graphics.clear(0.1, 0.1, 0.1, 1) 
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Press 'r' to reset arm", 10, 10)

    ground:render()
    arm:render()

    push:apply('end')
end
