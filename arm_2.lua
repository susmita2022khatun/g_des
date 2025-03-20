arm = class()

function arm:init(Length, target, learning_rate, momentum, decay_rate, beta_1, beta_2, max_iters, tolerance, ini_theta, theta_vel, centerX, centerY)
    self.Length = Length
    self.initial_theta = ini_theta
    self.learning_rate = learning_rate
    self.momentum = momentum
    self.decay_rate = decay_rate
    self.beta_1 = beta_1
    self.beta_2 = beta_2
    self.max_iters = max_iters
    self.tolerance = tolerance
    self.target = target
    self.theta_vel = theta_vel

    self.cx = centerX
    self.cy = centerY

    self.theta = {ini_theta[1], ini_theta[2], ini_theta[3]}
    self.d_theta = {theta_vel[1], theta_vel[2], theta_vel[3]}

    self.loss_values = {}
end

function arm:reset()
    r = {math.random(0, 6), math.random(0, 6), math.random(0, 6)}
    self.theta = {math.pi*r[1]/3, math.pi*r[2]/3, math.pi*r[3]/3}
    self.d_theta = {self.theta_vel[1], self.theta_vel[2], self.theta_vel[3]}
end

function arm:forward_kinematics(theta)
    local x = self.Length[1] * math.cos(theta[1]) 
            + self.Length[2] * math.cos(theta[1] + theta[2]) 
            + self.Length[3] * math.cos(theta[1] + theta[2] + theta[3])

    local y = self.Length[1] * math.sin(theta[1]) 
            + self.Length[2] * math.sin(theta[1] + theta[2]) 
            + self.Length[3] * math.sin(theta[1] + theta[2] + theta[3])
    return {x, y}
end

function arm:compute_error(theta, target)
    local pos = self:forward_kinematics(theta)
    table.insert(self.loss_values, {x = target[1] - pos[1], y = target[2] - pos[2]})

    --graph potting
    if #self.loss_values > 10 then
        table.remove(self.loss_values, 1)
    end

    return {target[1] - pos[1], target[2] - pos[2]}
end

function arm:compute_jacobian(theta)
    local J = {
        {
            -self.Length[1] * math.sin(theta[1]) 
            - self.Length[2] * math.sin(theta[1] + theta[2]) 
            - self.Length[3] * math.sin(theta[1] + theta[2] + theta[3]),

            -self.Length[2] * math.sin(theta[1] + theta[2]) 
            - self.Length[3] * math.sin(theta[1] + theta[2] + theta[3]),  

            -self.Length[3] * math.sin(theta[1] + theta[2] + theta[3])
        },
        {
            self.Length[1] * math.cos(theta[1]) 
            + self.Length[2] * math.cos(theta[1] + theta[2]) 
            + self.Length[3] * math.cos(theta[1] + theta[2] + theta[3]),  

            self.Length[2] * math.cos(theta[1] + theta[2]) 
            + self.Length[3] * math.cos(theta[1] + theta[2] + theta[3]),

            self.Length[3] * math.cos(theta[1] + theta[2] + theta[3])
        }
    }
    return J
end

function arm:update(dt)
    local grad_t_min_1 = { 0, 0, 0 }
    local grad_scal_sum = 0
    local grad_scal_sum_t_min_1 = 0
    local var_min_1 = 0
    local mean_min_1 = { 0, 0, 0 }
    for i = 1, self.max_iters do
        local error = self:compute_error(self.theta, self.target)
        local error_magnitude = math.sqrt(error[1]^2 + error[2]^2)

        if error_magnitude < self.tolerance then
            print("Converged after " .. i .. " iterations.")
            break
        end

        local J = self:compute_jacobian(self.theta)
        local gradient = {
            J[1][1] * error[1] + J[2][1] * error[2],
            J[1][2] * error[1] + J[2][2] * error[2],
            J[1][3] * error[1] + J[2][3] * error[2]
        }

        for j = 1, 3 do
            grad_scal_sum = grad_scal_sum + gradient[j]^2
        end
        
        -- opt:grad_desc_momentum(self.theta, self.learning_rate, self.momentum, gradient, grad_t_min_1, self.theta_vel, dt)
        -- opt:gradient_descent(self.theta, self.learning_rate, gradient, self.theta_vel, dt)
        -- opt: adaptive_grad(self.theta, self.learning_rate, gradient, grad_scal_sum, self.theta_vel, dt)
        -- opt:rms_propagation(self.theta, self.learning_rate, gradient, grad_scal_sum_t_min_1, self.decay_rate, self.theta_vel, dt)
        opt: adam(self.theta, self.learning_rate, gradient, self.beta_1, self.beta_2, mean_min_1, var_min_1, self.theta_vel, dt)
        for j = 1, 3 do
            grad_t_min_1[j] = gradient[j]
        end

    end
end

function arm:render()
    local centerX, centerY = self.cx, self.cy
    local scale = 100  

    local joint1 = {0, 0}
    local joint2 = {self.Length[1] * math.cos(self.theta[1]), self.Length[1] * math.sin(self.theta[1])}
    local joint3 = {
        joint2[1] + self.Length[2] * math.cos(self.theta[1] + self.theta[2]),
        joint2[2] + self.Length[2] * math.sin(self.theta[1] + self.theta[2])
    }
    local end_effector = {
        joint3[1] + self.Length[3] * math.cos(self.theta[1] + self.theta[2] + self.theta[3]),
        joint3[2] + self.Length[3] * math.sin(self.theta[1] + self.theta[2] + self.theta[3])
    }

    love.graphics.setColor(0, 1, 0)
    love.graphics.circle("fill", centerX + self.target[1] * scale, centerY - self.target[2] * scale, 5)

    love.graphics.setColor(1, 1, 1)
    love.graphics.setLineWidth(3)  
    love.graphics.line(centerX, centerY, centerX + joint2[1] * scale, centerY - joint2[2] * scale)
    love.graphics.line(centerX + joint2[1] * scale, centerY - joint2[2] * scale, centerX + joint3[1] * scale, centerY - joint3[2] * scale)
    love.graphics.line(centerX + joint3[1] * scale, centerY - joint3[2] * scale, centerX + end_effector[1] * scale, centerY - end_effector[2] * scale)

    love.graphics.setColor(1, 0, 0)
    love.graphics.circle("fill", centerX + end_effector[1] * scale, centerY - end_effector[2] * scale, 5)
    love.graphics.circle("fill", centerX + joint1[1] * scale, centerY - joint1[2] * scale, 7)
    love.graphics.circle("fill", centerX + joint2[1] * scale, centerY - joint2[2] * scale, 7)
    love.graphics.circle("fill", centerX + joint3[1] * scale, centerY - joint3[2] * scale, 7)
end

