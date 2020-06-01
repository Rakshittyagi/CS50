WINDOW_HEIGHT=720
WINDOW_WIDTH=720
virtual_width=455
virtual_height=455
player1=0
player2=0
player1y=20
player2y=virtual_height-30
paddlespeed=400
ballx=virtual_width/2-3
bally=virtual_height/2-3
winningplayer=0
Class=require 'class'
push=require'push'
require'Ball'
require'Paddle'
function love.load()
    love.window.setTitle('Pong')
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest','nearest')
    smallfont=love.graphics.newFont('pixeled.ttf',8)
    
    scorefont=love.graphics.newFont('pixeled.ttf',35)
    
    push:setupScreen(virtual_width,virtual_height,WINDOW_WIDTH,WINDOW_HEIGHT,{
        fullscreen=false,
        vsync=true,
        resizable=true
    })
    sound ={
        ['paddlecollision'] = love.audio.newSource('paddle.wav','static'),
        ['screenhit']= love.audio.newSource('screen.wav','static'),
        ['point'] = love.audio.newSource('out.wav','static'),
        ['victory'] = love.audio.newSource('Luis Fonsi, Daddy Yankee - Despacito ft. Justin Bieber (LyricsEnglish).mp3','static')
    }
    paddle1=Paddle(virtual_width/2-220,20,5,20)
    paddle2=Paddle(virtual_width/2+220,virtual_height-30,5,20)
    ball=Ball(virtual_width/2-3,virtual_height/2-3,6,6)
    serveplayer=math.randomseed(2)==1 and 1 or 2
    if serveplayer== 1 then
        ball.dx=400
    elseif serveplayer== 2 then
        ball.dx=-400    
    end    
    gamestate='start'
    
    
end

function love.resize(w,h)
    push:resize(w,h)

end
function love.update(dt)
    if gamestate=='play'then
        if ball.x<=virtual_width/2-222 then
            player2=player2+1
            serveplayer=1
            sound['point']:play()
            ball:reset()
            ball.dx=200
            if player2 == 3 then
                gamestate='victory'
                winningplayer=2
                sound['victory']:play()
            else
                gamestate='serve'
            end
            
        elseif ball.x>=virtual_width/2+222 then
            player1=player1+1
            serveplayer=2
            sound['point']:play()
            ball:reset()
            ball.dx=-200
            if player1 == 3 then
                gamestate='victory'
                winningplayer=1
                sound['victory']:play()
            else
                gamestate='serve'
            end
        end    
    end
    if ball:collides(paddle1) then
        ball.dx=-ball.dx 
        sound['paddlecollision']:play()
    end    
    if ball:collides(paddle2) then
        ball.dx=-ball.dx
        sound['paddlecollision']:play()
    end
    if ball.y<=0 then
        ball.dy=-ball.dy
        ball.y=0
        sound['screenhit']:play()
    end
    if ball.y>=virtual_height-6 then
        ball.dy=-ball.dy
        ball.y=virtual_height-6
        sound['screenhit']:play()
    end            

    if love.keyboard.isDown('w') then
        paddle1.dy=-paddlespeed
      
    elseif love.keyboard.isDown('s') then
        paddle1.dy=paddlespeed
    else
        paddle1.dy=0    
    end
    if ball.dy>0 then
        --if paddle2.y<ball.y then
        if gamestate=='play'  then
        
          paddle2.y=ball.y
        end
    elseif ball.dy<0 then
        if gamestate=='play' then
            paddle2.y=ball.y
        end 
            
      
    else
        paddle2.dy=0    
    end    
    paddle1:update(dt)
    paddle2:update(dt)
    if gamestate=='play' then
        ball:update(dt)
    end    
    

end    
function love.keypressed(key)
    if key=='escape' then
        love.event.quit()
     
    elseif key=='return' or key=='enter'then
        if gamestate=='start'then
            gamestate='serve'   
        elseif gamestate=='serve' then
            gamestate='play'
        elseif gamestate=='victory' then
            gamestate='start'    
            player1=0
            player2=0
        end    
    end   
end    


function love.draw()
    push:apply('start')
    love.graphics.clear(40/255,40/255,50/255,255/255)
    ball:render()
    
    paddle1:render()
    paddle2:render()
    love.graphics.setFont(smallfont)
    if gamestate=='start' then

        love.graphics.printf('Welcome to pong',0,20,virtual_width,'center')   
        love.graphics.printf('Press enter to play',0,35,virtual_width,'center')
    elseif gamestate=='serve'    then
        love.graphics.printf('player '..tostring(serveplayer)..' to serve',0,20,virtual_width,'center')    
        love.graphics.printf('Press enter ',0,35,virtual_width,'center')
    elseif gamestate=='victory' then
        love.graphics.printf('player '..tostring(winningplayer)..' wins',0,20,virtual_width,'center')   
        love.graphics.printf('Press enter to play again',0,35,virtual_width,'center')
    end    
    love.graphics.setFont(scorefont)
    love.graphics.print(player1,virtual_width/2-60,virtual_height/3.5)
    love.graphics.print(player2,virtual_width/2+40,virtual_height/3.5)
    displayFPS()
    push:apply('end')
end    
function displayFPS()

    love.graphics.setColor(0,1,0,1)
    love.graphics.setFont(smallfont)
    love.graphics.print('FPS:'..tostring (love.timer.getFPS()),40,22)
end    