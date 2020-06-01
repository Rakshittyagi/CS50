Ball=Class{}

function Ball:init(x,y,width,height)
    self.x=x
    self.y=y
    self.width=width
    self.height=height

    --self.dx=math.random(2)==1 and 400 or -400
    self.dy=math.random(-100,100)
end
function Ball:update(dt)
    self.x=self.x+self.dx*dt
    self.y=self.y+self.dy*dt

end
function Ball:collides(box)
    if self.x>box.x+box.width or box.x>self.x+self.width then

        return false
    end    
    if self.y>box.y+box.height or box.y>self.y+self.height then

        return false
    end
    return true      
end    
function Ball:reset()
    self.x=virtual_width/2-3
    self.y=virtual_height/2-3
    
    self.dx=math.random(2)==1 and 200 or -200
    self.dy=math.random(-50,50)

end        
function Ball:render()
    love.graphics.rectangle('fill',self.x,self.y,6,6)
end