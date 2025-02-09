ground = class()

function ground:init(x, y, radius)
    self.x = x
    self.y = y
    self.radius = radius
end

function ground:render()
    love.graphics.setColor(0, 1, 0)
    love.graphics.circle("fill", self.x, self.y, self.radius)
end
