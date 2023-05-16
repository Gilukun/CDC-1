Win = {}

function Win.Load()
    Img_WIN = love.graphics.newImage("Images/WIN.png")
end

function Win.Update(dt)
end

function Win.Draw()
    love.graphics.draw(
        Img_WIN,
        love.graphics.getWidth() / 2,
        love.graphics.getHeight() / 2,
        0,
        1,
        1,
        Img_WIN:getWidth() / 2,
        Img_WIN:getHeight() / 2
    )
end

return Win
