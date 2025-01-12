
ground = class()

function ground:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
end

function ground:render()
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.rectangle('fill', 
                            self.x, 
                            self.y, 
                            self.width, 
                            self.height)
end
