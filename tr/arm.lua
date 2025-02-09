local arm = {}

-- Length of the two arm segments
arm.L1 = 1.0
arm.L2 = 1.0
arm.L3 = 1.0
-- Target position (x, y)
arm.target = {1.5, 0.5}

-- Learning rate for gradient descent
arm.learning_rate = 0.08

-- Maximum number of iterations
arm.max_iters = 200

-- Tolerance for stopping
arm.tolerance = 1e-3

function arm.forward_kinematics(theta)
    local x = arm.L1 * math.cos(theta[1]) + arm.L2 * math.cos(theta[1] + theta[2]) + arm.L3*math.cos(theta[1] + theta[2] + theta[3])
    local y = arm.L1 * math.sin(theta[1]) + arm.L2 * math.sin(theta[1] + theta[2]) + arm.L3*math.sin(theta[1] + theta[2] + theta[3])
    return {x, y}
end

function arm.compute_error(theta, target)
    local pos = arm.forward_kinematics(theta)
    return {target[1] - pos[1], target[2] - pos[2]}
end

function arm.compute_jacobian(theta)
    local J = {
        {-arm.L1 * math.sin(theta[1]) - arm.L2 * math.sin(theta[1] + theta[2]) - arm.L3 * math.sin(theta[1] + theta[2] + theta[3]), 
         -arm.L2 * math.sin(theta[1] + theta[2]) - arm.L3 * math.sin(theta[1] + theta[2] + theta[3]),  
         -arm.L3 * math.sin(theta[1] + theta[2] + theta[3])},
        { arm.L1 * math.cos(theta[1]) + arm.L2 * math.cos(theta[1] + theta[2]) + arm.L3 * math.cos(theta[1] + theta[2] + theta[3]),  
          arm.L2 * math.cos(theta[1] + theta[2]) + arm.L3 * math.cos(theta[1] + theta[2] + theta[3]),
          arm.L3 * math.cos(theta[1] + theta[2] + theta[3])}
    }
    return J
end

function arm.optimize()
    local theta = {5*math.pi/4 , 5*math.pi/4 , 5*math.pi/4  }
    local arm_positions = {}
    local errors = {}

    for i = 1, arm.max_iters do
        local error = arm.compute_error(theta, arm.target)
        local error_magnitude = math.sqrt(error[1]^2 + error[2]^2)
        table.insert(errors, error_magnitude)

        if error_magnitude < arm.tolerance then
            print("Converged after " .. i .. " iterations.")
            break
        end

        local joint1 = {0, 0}
        local joint2 = {arm.L1 * math.cos(theta[1]), arm.L1 * math.sin(theta[1])}
        local joint3 = {
            joint2[1] + arm.L2 * math.cos(theta[1] + theta[2]),
            joint2[2] + arm.L2 * math.sin(theta[1] + theta[2])
        }
        local end_effector = {
            joint3[1] + arm.L3 * math.cos(theta[1] + theta[2] + theta[3]),
            joint3[2] + arm.L3 * math.sin(theta[1] + theta[2] + theta[3])
        }
        table.insert(arm_positions, {joint1, joint2, joint3, end_effector})

        local J = arm.compute_jacobian(theta)

        local gradient = {
            J[1][1] * error[1] + J[2][1] * error[2],
            J[1][2] * error[1] + J[2][2] * error[2],
            J[1][3] * error[1] + J[2][3] * error[2]
        }
        
        theta[1] = theta[1] + arm.learning_rate * gradient[1]
        theta[2] = theta[2] + arm.learning_rate * gradient[2]
        theta[3] = theta[3] + arm.learning_rate * gradient[3]
    end

    return arm_positions
end

return arm
