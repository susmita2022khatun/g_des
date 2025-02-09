local arm = require("arm")
local positions = arm.optimize()

local current_frame = 1
local total_frames = #positions

local animation_speed = 0.2 
local time_elapsed = 0

function love.load()
    love.window.setMode(800, 800)
    if total_frames == 0 then
        print("No positions available. Optimization might have failed.")
    end
end

function love.draw()
    if total_frames == 0 then
        love.graphics.print("No positions to display.", 300, 400)
        return
    end

    local centerX, centerY = 400, 400
    local scale = 200

    love.graphics.setColor(0, 1, 0)
    love.graphics.circle("fill", centerX + arm.target[1] * scale, centerY - arm.target[2] * scale, 5)

    local frame = positions[current_frame]
    local joint1, joint2, joint3, end_effector = frame[1], frame[2], frame[3], frame[4]

    love.graphics.setColor(1, 1, 1) 
    love.graphics.line(
        centerX + joint1[1] * scale, centerY - joint1[2] * scale,
        centerX + joint2[1] * scale, centerY - joint2[2] * scale
    )
    love.graphics.line(
        centerX + joint2[1] * scale, centerY - joint2[2] * scale,
        centerX + joint3[1] * scale, centerY - joint3[2] * scale
    )
    love.graphics.line(
        centerX + joint3[1] * scale, centerY - joint3[2] * scale,
        centerX + end_effector[1] * scale, centerY - end_effector[2] * scale
    )

    love.graphics.setColor(1, 0, 0) 
    love.graphics.circle("fill", centerX + joint2[1] * scale, centerY - joint2[2] * scale, 5)
    love.graphics.circle("fill", centerX + joint3[1] * scale, centerY - joint3[2] * scale, 5)
    love.graphics.circle("fill", centerX + end_effector[1] * scale, centerY - end_effector[2] * scale, 5)
end

function love.update(dt)
    if total_frames > 0 then
        time_elapsed = time_elapsed + dt*2

        if time_elapsed >= animation_speed then
            current_frame = current_frame + 1
            time_elapsed = 0 
        end
        if current_frame > total_frames then
            current_frame = total_frames
        end
    end
end
