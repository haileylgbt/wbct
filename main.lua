player = {startpos = {x = 0, y = 0}, x = 0, y = 0, w = 100, h = 100, color = {r = 255, g = 255, b = 255}}
deathblocks = {}
finishblock = {x = 700, y = 500, w = 100, h = 100, color = {r = 0, g = 255, b = 0}}
game = {levelID = 1}
text = " "
clear = love.audio.newSource("lvup.wav")
death = love.audio.newSource("ded.wav")
win = love.audio.newSource("victory.wav")
win:setLooping(false)
theend = love.audio.newSource("endfornow.wav")
theend:setLooping(true)
bgm = love.audio.newSource("Quirby64 - Chordlands.mp3")
function love.load()
	local deathblockPrototype = {x = 1000, y = 1000, w = 100, h = 100, color = {r = 255, g = 0, b = 0}, isMoving = false, udlr = "ud", direction = "up"}
  local metatable = {__index = deathblockPrototype}
	function loadLevelByID(id)
		if id == 1 then
			text = "1: Dangers"
			table.insert(deathblocks, setmetatable({x=200, y=200}, metatable))
		end
		if id == 2 then
			text = "2: Double Trouble"
			deathblocks = {}
			table.insert(deathblocks, setmetatable({x=200, y=200}, metatable))
			table.insert(deathblocks, setmetatable({x=500, y=300}, metatable))
		end
		if id == 3 then
			text = "3: Moving Magic"
			deathblocks = {}
			table.insert(deathblocks, setmetatable({x=400, y=300, isMoving = true}, metatable))
		end
		if id == 4 then
			text = "4: Magic Mover XXL"
			deathblocks = {}
			table.insert(deathblocks, setmetatable({x=300, y=0, isMoving = true}, metatable))
			table.insert(deathblocks, setmetatable({x=400, y=500, isMoving = true, udlr = "lr", direction = "left"}, metatable))
		end
		if id == 5 then
			text = "5: Maze"
			deathblocks = {}
			table.insert(deathblocks, setmetatable({x=100, y=0}, metatable))
			table.insert(deathblocks, setmetatable({x=100, y=100}, metatable))
			table.insert(deathblocks, setmetatable({x=100, y=200}, metatable))
			table.insert(deathblocks, setmetatable({x=0, y=400}, metatable))
			table.insert(deathblocks, setmetatable({x=100, y=400}, metatable))
			table.insert(deathblocks, setmetatable({x=300, y=500}, metatable))
			table.insert(deathblocks, setmetatable({x=300, y=400}, metatable))
			table.insert(deathblocks, setmetatable({x=300, y=300}, metatable))
			table.insert(deathblocks, setmetatable({x=300, y=200}, metatable))
			table.insert(deathblocks, setmetatable({x=300, y=100}, metatable))
			table.insert(deathblocks, setmetatable({x=500, y=0}, metatable))
			table.insert(deathblocks, setmetatable({x=500, y=100}, metatable))
			table.insert(deathblocks, setmetatable({x=500, y=200}, metatable))
			table.insert(deathblocks, setmetatable({x=500, y=300}, metatable))
			table.insert(deathblocks, setmetatable({x=600, y=500}, metatable))
		end
		if id == 6 then
			text = "Part 1 Clear!"
			deathblocks = {}
			love.audio.pause(bgm)
			win:play()
		end
		if id == 7 then
			text = "This is the end for now. Next update will include more levels!"
			deathblocks = {}
			love.audio.pause(win)
			theend:play()
		end
end
	love.window.setMode(800, 600)

	loadLevelByID(1)

	love.audio.play(bgm)
end

function love.update(dt)
	love.window.setTitle("white block coming through")

	-- Collision detection function;
-- Returns true if two boxes overlap, false if they don't;
-- x1,y1 are the top-left coords of the first box, while w1,h1 are its width and height;
-- x2,y2,w2 & h2 are the same, but for the second box.
  function CheckCollision(o1, o2)
    return o1.x < o2.x+o2.w and
           o2.x < o1.x+o1.w and
           o1.y < o2.y+o2.h and
           o2.y < o1.y+o1.h
  end
	for i,v in ipairs(deathblocks) do
    if CheckCollision(player, v) then
			love.audio.play(death)
      player.x = player.startpos.x
      player.y = player.startpos.y
    end
  end

	if CheckCollision(player, finishblock) then
		love.audio.play(clear)
		game.levelID = game.levelID + 1
		player.x = player.startpos.x
		player.y = player.startpos.y
		loadLevelByID(game.levelID)
	end

	for i,v in ipairs(deathblocks) do
    if v.isMoving == true then
      if v.y == 0 then
        v.direction = "down"
      elseif v.y == 500 then
        v.direction = "up"
      end
      if v.direction == "down" then
        v.y = v.y + 5
      elseif v.direction == "up" then
        v.y = v.y - 5
		end
    end
  end
end

function love.keypressed(key)
	if key == "right" then
		player.x = player.x + player.w
	end
	if key == "left" then
		player.x = player.x - player.w
	end
	if key == "down" then
		player.y = player.y + player.h
	end
	if key == "up" then
		player.y = player.y - player.h
	end
end

function love.draw()
	love.graphics.setColor(finishblock.color.r, finishblock.color.g, finishblock.color.b)
	love.graphics.rectangle("fill", finishblock.x, finishblock.y, finishblock.w, finishblock.h)


  for i,v in ipairs(deathblocks) do
		love.graphics.setColor(v.color.r, v.color.g, v.color.b)
		love.graphics.rectangle("fill", v.x, v.y, v.w, v.h)
  end

	love.graphics.setColor(player.color.r, player.color.g, player.color.b)
	love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)

	love.graphics.printf(text, 600, 0, 100, "right", 0, 2, 2)


	love.graphics.print(player.x)
	love.graphics.print(player.y, 50)
end
