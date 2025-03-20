opt = class()


function opt:gradient_descent(theta , learning_rate , gradient, theta_vel , time_stamp)

    for j = 1, 3 do
        theta[j] = theta[j] + learning_rate * gradient[j] * time_stamp * theta_vel[j]
    end

end


function opt:grad_desc_momentum(theta, learning_rate, momentum, gradient, grad_t_min_1, theta_vel, time_stamp)
    local change_x = {0, 0, 0}
    for j = 1, 3 do
        change_x[j] = learning_rate * gradient[j] + momentum * grad_t_min_1[j]
        theta[j] = theta[j] + change_x[j] * time_stamp * theta_vel[j]
        grad_t_min_1[j] = change_x[j]  
    end
end


function opt:adaptive_grad(theta, learning_rate, gradient, grad_scal_sum, theta_vel, time_stamp)

    for j = 1, 3 do
        theta[j] = theta[j] + learning_rate * gradient[j] * time_stamp * theta_vel[j] / math.sqrt(grad_scal_sum + 0.0000001)
    end

end


function opt:rms_propagation(theta, learning_rate, gradient, grad_scal_sum_t_min_1 , decay_rate, theta_vel, time_stamp)
    local g_sum = 0
    for j = 1, 3 do
        g_sum = g_sum + gradient[j]^2
    end

    grad_scal_sum_t_min_1 = grad_scal_sum_t_min_1 * decay_rate + (1 - decay_rate) * g_sum
    -- print(grad_scal_sum_t_min_1)
    for j = 1, 3 do
        theta[j] = theta[j] + learning_rate * gradient[j] * time_stamp * theta_vel[j]/math.sqrt(grad_scal_sum_t_min_1 + 0.00000001)
    end

end


function opt:adam(theta, learning_rate, gradient, beta_1 , beta_2, mean_min_1, var_min_1, theta_vel, time_stamp)

    local g_sum = 0

    for j = 1, 3 do
        mean_min_1[j] = beta_1 * mean_min_1[j] + (1 - beta_1) * gradient[j]
        g_sum = g_sum + gradient[j]^2
    end

    var_min_1 = beta_2 * var_min_1 + (1 - beta_2) * g_sum

    local m_bar = {0, 0, 0}
    local v_bar = 0
    for j =1, 3 do
        m_bar[j] = mean_min_1[j]/(1 - beta_1^j)
    end

    v_bar = var_min_1/(1 - beta_2)

    for j = 1, 3 do
        theta[j] = theta[j] + learning_rate * m_bar[j] * theta_vel[j] * time_stamp / (math.sqrt(v_bar) + 0.00000001)
    end

end
