require 'class'
push = require 'push'
require 'ground'
require 'optimizers'
require 'arm_2'
--require 'graph'

WINDOW_WIDTH = 1600
WINDOW_HEIGHT = 800
VIRTUAL_WIDTH = 1600
VIRTUAL_HEIGHT = 800

TARGET = {1.0, 1.0}  
LENGTH = {1.0, 1.0, 1.0}
LEARNING_RATE = { 0.001 , 0.1 , 0.1 , 0.01 , 0.01 }
MOMENTUM = 0.9
DECAY_RATE = 0.9
BETA_1 = 0.9
BETA_2 = 0.999
MAX_ITERS = 200
TOLERANCE = 1e-3
THETA_VEL = { {0.02, 0.02, 0.02} , {0.2 , 0.2 , 0.2} , {0.4 , 0.4, 0.4} , {0.4 , 0.4, 0.4} , {0.2 , 0.2, 0.2} }
CENTER_X = {VIRTUAL_WIDTH/2 - 600 , VIRTUAL_WIDTH/2 - 300 , VIRTUAL_WIDTH/2 , VIRTUAL_WIDTH/2 + 300 , VIRTUAL_WIDTH/2 + 600 }
CENTER_Y = VIRTUAL_HEIGHT / 3
RADIUS = 15
ORIGIN_X = {VIRTUAL_WIDTH/2 - 600 , VIRTUAL_WIDTH/2 - 300 , VIRTUAL_WIDTH/2 , VIRTUAL_WIDTH/2 + 300 , VIRTUAL_WIDTH/2 + 600 }
ORIGIN_Y = VIRTUAL_HEIGHT / 3
X_VEL = 1.0
SCALE = 1.0
EPSILON = 0.00000001
OPT_TAG = {'sgd', 'gd', 'adagrad', 'rmsprop', 'adam'}


-- for sgd momentum = 0.9
-- lr = 0.001
-- theta vel = 0.02 for observable changes

-- for gd lr = 0.01
-- theta vel = 0.2 for observable change

--for adagrad lr = 0.1
--theta vel = 0.4 for observable changes

-- for rmsprop lr = 0.01
-- theta vel = 0.4 for observable chnages

-- for adam lr = 0.01
-- theta vel = 0.4 for observable changes

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    THETA_INI = {math.pi / 4, -math.pi / 4, math.pi / 4}

    arm_1 = arm(LENGTH, TARGET, LEARNING_RATE[1], MOMENTUM, DECAY_RATE, BETA_1, BETA_2, MAX_ITERS, TOLERANCE, THETA_INI, THETA_VEL[1], CENTER_X[1], CENTER_Y, OPT_TAG[1])
    arm_2 = arm(LENGTH, TARGET, LEARNING_RATE[2], MOMENTUM, DECAY_RATE, BETA_1, BETA_2, MAX_ITERS, TOLERANCE, THETA_INI, THETA_VEL[2], CENTER_X[2], CENTER_Y, OPT_TAG[2])
    arm_3 = arm(LENGTH, TARGET, LEARNING_RATE[3], MOMENTUM, DECAY_RATE, BETA_1, BETA_2, MAX_ITERS, TOLERANCE, THETA_INI, THETA_VEL[3], CENTER_X[3], CENTER_Y, OPT_TAG[3])
    arm_4 = arm(LENGTH, TARGET, LEARNING_RATE[4], MOMENTUM, DECAY_RATE, BETA_1, BETA_2, MAX_ITERS, TOLERANCE, THETA_INI, THETA_VEL[4], CENTER_X[4], CENTER_Y, OPT_TAG[4])
    arm_5 = arm(LENGTH, TARGET, LEARNING_RATE[5], MOMENTUM, DECAY_RATE, BETA_1, BETA_2, MAX_ITERS, TOLERANCE, THETA_INI, THETA_VEL[5], CENTER_X[5], CENTER_Y, OPT_TAG[5])
    ground = ground(CENTER_X, CENTER_Y, RADIUS) 
    --graph = graph(ORIGIN_X, ORIGIN_Y,X_VEL, arm.loss_values, SCALE)

    gameState = 'play' 

end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'r' then
        arm_1:reset()
        arm_2:reset()
        arm_3:reset()
        arm_4:reset()
        arm_5:reset()
        --graph: reset()
        
    end
end

function love.update(dt)
    if gameState == 'play' then
        arm_1:update(dt)
        arm_2:update(dt)
        arm_3:update(dt)
        arm_4:update(dt)
        arm_5:update(dt)
        --graph:update(dt)
    end
end

function love.draw()
    push:apply('start')
    
    love.graphics.clear(0.1, 0.1, 0.1, 1) 
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Press 'r' to reset arm", 10, 10)

    ground:render()
    arm_1:render()
    arm_2:render()
    arm_3:render()
    arm_4:render()
    arm_5:render()
    --graph:render()

    push:apply('end')
end
