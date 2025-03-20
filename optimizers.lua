opt = class()


function opt:gradient_descent(theta , learning_rate , gradient, theta_vel , time_stamp)

    for j = 1, 3 do
        theta[j] = theta[j] + learning_rate * gradient[j] * time_stamp * theta_vel[j]
    end

end

-- function opt:rms_prop()

--     for j = 1, 3 do

--     end

--     for j = 1, 3 do

--     end

-- end

-- function opt:adam()

--     for j = 1, 3 do

--     end

-- end