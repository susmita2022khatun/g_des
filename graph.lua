graph = class()

function graph:init(origin_x, origin_y, x_vel, y_val, scale)
    self.origin_x = origin_x
    self.origin_y = origin_y
    self.x_vel = x_vel
    self.y_val = y_val  
    self.scale = scale
end

function graph:reset()
    self.y_val = {}  
end

function graph:update(dt)
    self.origin_x = self.origin_x - self.x_vel * dt  
end

function graph:render()
    if #self.y_val < 2 then
        return
    end

    love.graphics.setColor(1, 1, 1)  
    love.graphics.line(self.origin_x - 50, self.origin_y, self.origin_x + 50, self.origin_y)

    for i = 1, #self.y_val - 1 do
        local val_1 = math.sqrt(self.y_val[i].x^2 + self.y_val[i].y^2)
        local val_2 = math.sqrt(self.y_val[i].x^2 + self.y_val[i].y^2)
        local x1 = self.origin_x + (i - 1) * 20
        local y1 = self.origin_y - val_1 * self.scale
        local x2 = self.origin_x + i * 20
        local y2 = self.origin_y - val_2 * self.scale

        love.graphics.line(x1, y1, x2, y2)
    end
end
