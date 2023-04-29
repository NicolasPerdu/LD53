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
 x_max = -1
 y_max = -1
 x_min = -1
 y_min = -1
 
 dirShoot={}
 shPos={}
 sh_max = 100
 for i=1,sh_max do
  dirShoot[i]={-1,-1}
  shPos[i]={-1,-1}
 end
	sh_auto_delay=20
	sh_auto_buf=0
 shoot=false
 
 --weapons
 xw1=200
 yw1=50
 
 xw2=100
 yw2=100
 
end

function AABB(b1, b2)
	if ((b2.bx >= b1.bx + b1.bw)
	or (b2.bx + b2.bw <= b1.bx)
	or (b2.by >= b1.by + b1.bh)
	or (b2.by + b2.bh <= b1.by)) then
		return false; 
	else
		return true;
	end 
end

function draw_sprite(angle, px, py, size, color)
	local math_cos = math.cos
	local math_sin = math.sin
	local pos_x_scl = px
	local pos_y_scl = py
 
 local a = pos_x_scl + size * math_cos(angle)
 local b = pos_y_scl + size * math_sin(angle)
 local c = pos_x_scl + size * math_cos(angle + size)
 local d = pos_y_scl + size * math_sin(angle + size)
 local e = pos_x_scl + size * math_cos(angle - size)
	local f = pos_y_scl + size * math_sin(angle - size)
	
	x_max = math.max(a,c,e)
	y_max = math.max(b,d,f)
	x_min = math.min(a,c,e)
	y_min = math.min(b,d,f)
	
	tri(
		a,
		b,
		c,
		d,
		e,
		f,
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
  
  	if i<sh_max then
  	 dirShoot[i] = norm({xmouse-x, ymouse-y})
  	 shPos[i] = {x, y}
  	 shoot = true
    
    -- recoil
    	 x=x-dirShoot[i][1]
      y=y-dirShoot[i][2]
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
	
	for i=1,sh_max do
		if shPos[i][1] > 0 then
			pix(shPos[i][1],shPos[i][2], 12)
			shPos[i]={shPos[i][1]+ dirShoot[i][1],shPos[i][2]+ dirShoot[i][2]}
 	 if shPos[i][1]>240 or shPos[i][2]>136 then
    shPos[i] = {-1,-1}
   end
  end
 end
	
	--pix(x, y, 12)
	-- draw weapon
	spr(1,xw1,yw1,0,1,0,0,1,1)
	rectb(xw1, yw1, 8, 8, 2)
	spr(2,xw2,yw2,0,1,0,0,1,1)
	rectb(xw2, yw2, 8, 8, 2)
	
	bw1 = {
 	bx= xw1, 
  by= yw1,
  bw= 8, 
  bh= 8 
 }
 
 bw2 = {
 	bx= xw2, 
  by= yw2,
  bw= 8, 
  bh= 8 
 }
	
	draw_sprite(math.pi + angleRad, x, y,10, 12)
	
	w=x_max-x_min
	h=y_max-y_min
	
	bp = {
 	bx= x, 
  by= y,
  bw= w, 
  bh= h 
 }
 
 col = AABB(bp, bw1)
 
 print("w1 : "..tostring(col),20,120)
	
 
	--mwh=math.max(w,h)
	rectb(x_min, y_min, w, h, 2)
end

-- <TILES>
-- 001:00000000000000c0cccccccccccccccccc0c0000cc000000cc000000cc000000
-- 002:000000000000000000cccc0000c0000000c00000000000000000000000000000
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
