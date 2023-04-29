-- title:   game title
-- author:  game developer, email, etc.
-- desc:    short description
-- site:    website link
-- license: MIT License (change this to your license of choice)
-- version: 0.1
-- script:  lua

function BOOT() 
 x=96
 y=24
 dirShoot={}
 shPos={}
 
 for i=1,100 do
  dirShoot[i]={-1,-1}
  shPos[i]={-1,-1}
 end

	sh_auto_delay=20
	sh_auto_buf=0
 shoot=false
end

function draw_sprite(angle, px, py, size, color)
	local math_cos = math.cos
	local math_sin = math.sin
	local pos_x_scl = px
	local pos_y_scl = py
 
	tri(
		pos_x_scl + size * math_cos(angle),
		pos_y_scl + size * math_sin(angle),
		pos_x_scl + size * math_cos(angle + size),
		pos_y_scl + size * math_sin(angle + size),
		pos_x_scl + size * math_cos(angle - size),
		pos_y_scl + size * math_sin(angle - size),
		color
	)
 end
 
 function magnitude(x, y)
 	return math.sqrt(x*x+y*y)
 end
 
 function norm(vec)
 	mag = magnitude(vec[1], vec[2])
  vec[1] = vec[1]/mag
  vec[2] = vec[2]/mag
  return vec
 end

function TIC()
	local xmouse,ymouse,left,middle,right,scrollx,scrolly=mouse()
	
	if btn(0) then y=y-1 end
	if btn(1) then y=y+1 end
	if btn(2) then x=x-1 end
	if btn(3) then x=x+1 end
	
 if left then
 	if not shoot then
  	i = 1
  	while (shPos[i][1]>0) do
  		i = i+1
  	end
  
  	if i<100 then
  	 dirShoot[i] = norm({xmouse-x, ymouse-y})
  	 shPos[i] = {x, y}
  	 shoot = true
  	end
  end
 end
 
 if shoot then
 	if sh_auto_buf >= sh_auto_delay then
 		shoot = false
   sh_auto_buf = 0
 	else 
 		sh_auto_buf = sh_auto_buf+1
  end
 end

	cls(13)
 --spr(1+t%60//30*2,x,y,14,3,0,0,2,2)
	--print("HELLO WORLD!",84,84)
	
	angleRad = math.atan2(y-ymouse,x-xmouse)
	angle = (angleRad * 180 / math.pi + 360) %360
	print("x, y : "..xmouse..", "..ymouse,84,50)
	print("angle : "..angle,84,84)
	
	for i=1,100 do
		if shPos[i][1] > 0 then
			pix(shPos[i][1],shPos[i][2], 12)
			shPos[i]={shPos[i][1]+ dirShoot[i][1],shPos[i][2]+ dirShoot[i][2]}
 	 if shPos[i][1]>240 or shPos[i][2]>136 then
    shPos[i] = {-1,-1}
   end
  end
 end
	
	pix(x, y, 12)
	draw_sprite(math.pi + angleRad, x, y,10, 12)
	--t=t+1
end

-- <TILES>
-- 001:eccccccccc888888caaaaaaaca888888cacccccccacc0ccccacc0ccccacc0ccc
-- 002:ccccceee8888cceeaaaa0cee888a0ceeccca0ccc0cca0c0c0cca0c0c0cca0c0c
-- 003:eccccccccc888888caaaaaaaca888888cacccccccacccccccacc0ccccacc0ccc
-- 004:ccccceee8888cceeaaaa0cee888a0ceeccca0cccccca0c0c0cca0c0c0cca0c0c
-- 017:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
-- 018:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
-- 019:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
-- 020:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
-- </TILES>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- </SFX>

-- <PATTERNS>
-- 000:849608000000000000000000b00008000000000000000000000000000000000000000000800008000000000000000000b00008000000000000000000800008000000b00008000000d00008000000000000b00008d00008000000b00008000000a00008000000000000000000600008000000000000000000f00004000000000000000000f37206000000f00008000000f0000a000000f00008000000f00006000000f00004000000f00006000000000000000000000000000000000000000000
-- </PATTERNS>

-- <TRACKS>
-- 000:100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </TRACKS>

-- <PALETTE>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>

