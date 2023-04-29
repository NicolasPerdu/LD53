-- title:   game title
-- author:  Nicolqs & Jake
-- desc:    short description
-- site:    website link
-- license: MIT License (change this to your license of choice)
-- version: 0.1
-- script:  lua

function BOOT() 
 x=96
 y=24
 mx=0
 my=0
 vx=0
 vy=0
 x_max=-1
 y_max=-1
 x_min=-1
 y_min=-1
 
 -- small weapon
 dirShoot={}
 shPos={}
 shPosBox={}
 
 --heavy weapon with recoil
 dirShootBig={}
 shPosBig={}
 shPosBigBox={}
 
 sh_max = 100
 for i=1,sh_max do
  dirShoot[i]={-1,-1}
  shPos[i]={-1,-1}
  dirShootBig[i]={-1,-1}
  shPosBig[i]={-1,-1}
 end
	sh_auto_delay=20
	sh_auto_buf=0
 shoot=false
 sh_type=2
 
 --weapons
 xw1=200
 yw1=50
 
 xw2=100
 yw2=100
 
 w1_enabled=true
 w2_enabled=true
 
 --obstacle
 num_os=3
 os_enabled ={true, true, true}
 bos = {{bx=20,by=20,bw=28,bh=28},
 {bx=200,by=40,bw=8,bh=8},
 {bx=100,by=100,bw=10,bh=10}}
 
 --enemies
 num_en=3
 ens_enabled ={true, true, true}
 --bens = {{x1=0,y1=0,x2=10,y2=0,x3=5,y3=20},
 --{x1=180,y1=120,x2=187,y2=121,x3=195,y3=114},
 --{x1=30,y1=94,x2=12,y2=101,x3=18,y3=110}}
 en_pos = {{0, 0}, {180, 120}, {30, 94}}
 en_box = {{bx=0,by=0,bw=8,bh=8},
  {bx=180,by=120,bw=8,bh=8},
  {bx=30,by=94,bw=8,bh=8}}
  
  -- jewel to pick up
  num_jw = 3
  jw_enabled ={true, true, true}
  jw_pos = {{20, 50}, {30, 60}, {40, 80}}
  jw_box = {{bx=20,by=50,bw=8,bh=8},
  {bx=30,by=60,bw=8,bh=8},
  {bx=40,by=80,bw=8,bh=8}}
  
  -- PERLIN NOISE
 cntSky=0
	bufferSky=1
	seed = math.floor(math.random() * (1 << 16))
	mp={}
	value1=0
	value2=0
	for i=0,240 do
		mp[i]={}
  		for j=0,136 do
  			-- note that each memory
  			-- cell holds two pixels
  			value1=perlin(j*2,i)
			value2=perlin(j*2+1,i)
   			mp[i][j]=value1 + value2 * 16
   			--trace(mp[i][j])
   			--mset(i//8,j//8,mp[i][j]%16)
  		end
 	end
end

function render_sky()
	for i=0,240 do
		for j=0,136 do
			if mp[i+mx*8] then
				if cntSky==0 then
			  pix(i,j,mp[i+mx*8][j]+8)
				else
					pix(i-1,j,mp[i+mx*8][j]+8)
				end
			end
		end 
	end
	
	bufferSky=bufferSky+1
	
	if bufferSky%120==0 then
		bufferSky=1
	 	if cntSky==0 then
	  		cntSky=1
	 	else
	  		cntSky=0
	 	end 
	end
end

-- PERLIN NOISE FUNCTION

-- deterministic 2d random, constants are arbitrary
function noise(a, b) 
    return ((a * 8754213 ~ b * 38678557 ~ seed) % 631) / 631
end

-- cosine interpolation between two values
function interpolate(a, b, factor)
    local ft = factor * math.pi
    local f = (1 - math.cos(ft)) * 0.5
    return  a * (1 - f) + b * f;
end

-- perlin noise
function perlin(i, j)
    local octave = 3
    local total = 0
    local n_total = 0

    for n = 1, 5 do
        local x = math.floor(i / octave)
        local y = math.floor(j / octave)

        -- compute noise cell
        local v1 = noise(x, y)
        local v2 = noise(x + 1, y)
        local v3 = noise(x, y + 1)
        local v4 = noise(x + 1, y + 1)

        -- interpolate at given scale
        local factor_x = (i % octave) / octave
        local factor_y = (j % octave) / octave

        local value1 = interpolate(v1, v2, factor_x)
        local value2 = interpolate(v3, v4, factor_x)
        local value3 = interpolate(value1, value2, factor_y)

        total = total + value3 * n
        octave = octave * 3
        n_total = n_total + n
    end

    total = total / n_total

    -- convert to color (7 colors)
    intensity = math.floor(1 / (1 + math.exp(-(total -0.65)* 9)) * 7)
    return intensity
end

-- PERLIN NOISE FUNCTION END

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

function compute_sprite(angle, px, py, size, color)
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
	
	return a,b,c,d,e,f,color
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
 
 function clamp(n, low, high) return math.min(math.max(n, low), high) end

function TIC()

-- input system for the player
	local xmouse,ymouse,left,middle,right,scrollx,scrolly=mouse()
	
	if btn(0) then vy=vy-0.2 end
	if btn(1) then vy=vy+0.2 end
	if btn(2) then vx=vx-0.2 end
	if btn(3) then vx=vx+0.2 end
	
	if not btn(0) 
		and not btn(1)
		and not btn(2)
		and not btn(3) then 
		cst = 0.05
		if vx>0 then
		 vx = math.max(0, vx - cst)
		else
			vx = math.min(0, vx + cst)
		end
		
		if vy>0 then
			vy = math.max(0, vy - cst)
		else 
		 vy = math.min(0, vy + cst)
		end
	end
		
	vx = clamp(vx, -1, 1)
	vy = clamp(vy, -1, 1)
	
 if left then
 	if not shoot then
  	i = 1
   if sh_type==2 then 
  	 while (shPos[i][1]>0) do
  		 i = i+1
  	 end
   elseif sh_type==1 then
    while (shPosBig[i][1]>0) do
  		 i = i+1
  	 end
   end 
  
  	if i<sh_max then
  	 if sh_type==2 then 
     dirShoot[i] = norm({xmouse-x, ymouse-y})
  	  shPos[i] = {x, y}
  	  shoot = true
    
     -- recoil
     x=x-dirShoot[i][1]
     y=y-dirShoot[i][2]
    elseif sh_type==1 then
     dirShootBig[i] = norm({xmouse-x, ymouse-y})
  	  shPosBig[i] = {x, y}
  	  shoot = true
    
     -- recoil
     recoil=2
     x=x-dirShootBig[i][1]*recoil
     y=y-dirShootBig[i][2]*recoil
    end
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
	render_sky()
 --spr(1+t%60//30*2,x,y,14,3,0,0,2,2)
	--print("HELLO WORLD!",84,84)
	
	angleRad = math.atan2(y-ymouse,x-xmouse)
	angle = (angleRad * 180 / math.pi + 360) %360
	--print("x, y : "..xmouse..", "..ymouse,84,50)
	--print("angle : "..angle,84,84)
	
	a,b,c,d,e,f,color = compute_sprite(math.pi + angleRad, x, y,10, 12)
	w=x_max-x_min
	h=y_max-y_min
	
	bp = {
 	bx= x_min, 
  by= y_min,
  bw= w, 
  bh= h 
 }
 
 -- input system for the enemy
 speed_en = 0.2
 for i=1,num_en do
 	if ens_enabled[i] then
 	 dir = norm({x-en_pos[i][1], y-en_pos[i][2]})
 	 en_pos[i]= {en_pos[i][1]+ dir[1]*speed_en,en_pos[i][2]+ dir[2]*speed_en} 
   en_box[i].bx=en_pos[i][1]
   en_box[i].by=en_pos[i][2]
  
   if AABB(bp, en_box[i]) then
			 -- collision enemy player 
		 end
		end
 end
 
 -- collision with jewel
 for i=1,num_jw do
 	if jw_enabled[i] then
   if AABB(bp, jw_box[i]) then
			 jw_enabled[i]=false 
		 end
		end
 end
	 
 rectb(x_min, y_min, w, h, 2)
	
	-- obstacles collision
	for j=1,num_os do
	 if os_enabled[j] and AABB(bp, bos[j]) then
	 	xp = x + vx
 	 yp = y + vy
   a2,b2,c2,d2,e2,f2,color2 = compute_sprite(math.pi + angleRad, xp, yp,10, 12)
	  w2=x_max-x_min
	  h2=y_max-y_min
		
		 bp = {
 	  bx= x_min, 
    by= y_min,
    bw= w, 
    bh= h 
   }
		
		 if AABB(bp, bos[j]) then
			 vx=-0.5*vx
			 vy=-0.5*vy
		 end
	 end
 end	
	a,b,c,d,e,f,color = compute_sprite(math.pi + angleRad, x, y,10, 12)
	

	x = x + vx
	y = y + vy
	 
	-- render obstacle
	for j=1,num_os do
	 if os_enabled[j] then
   rect(bos[j].bx,bos[j].by,bos[j].bw,bos[j].bh,2)
	 end
	end
	
	for i=1,sh_max do
		if shPos[i][1] > 0 then
			pix(shPos[i][1],shPos[i][2], 12)
		
			bb = {
 	  bx= shPos[i][1]-1, 
    by= shPos[i][2]-1,
    bw= 2, 
    bh= 2 
   }
   
   for j=1,num_os do
   if os_enabled[j] then
    -- collision bullet obstacle
    if AABB(bb, bos[j]) then 
   	 os_enabled[j] = false
     shPos[i] = {-1,-1}
    end
			 shPosBox[i]=bb
			end
			end
			
			for j=1,num_en do
			if ens_enabled[j] then
    -- collision bullet enemies
    if AABB(bb, en_box[j]) then 
   	 ens_enabled[j] = false
     shPos[i] = {-1,-1}
    end 
			 shPosBox[i]=bb
			end
			end
		
			rectb(bb.bx, bb.by, bb.bw, bb.bh,2)
			shPos[i]={shPos[i][1]+ dirShoot[i][1],shPos[i][2]+ dirShoot[i][2]}
 	 if shPos[i][1]>240 or shPos[i][2]>136 then
    shPos[i] = {-1,-1}
   end
  end
 end
 
 for i=1,sh_max do
		if shPosBig[i][1] > 0 then
			circ(shPosBig[i][1],shPosBig[i][2],5, 12)
			
			bb = {
 	  bx= shPosBig[i][1]-5, 
    by= shPosBig[i][2]-5,
    bw= 11, 
    bh= 11 
   }
   
   for j=1,num_os do
    if os_enabled[j] then
    -- collision bullet obstacle
     if AABB(bb, bos[j]) then 
    	 os_enabled[j] = false
      shPosBig[i] = {-1,-1}
     end 
			  shPosBigBox[i]=bb
			 end
			end
			
			for j=1,num_en do
			if ens_enabled[j] then
    -- collision bullet enemies
    if AABB(bb, en_box[j]) then 
   	 ens_enabled[j] = false
     shPosBig[i] = {-1,-1}
    end 
			 shPosBigBox[i]=bb
			end
			end
			
			rectb(bb.bx,bb.by,bb.bw,bb.bh, 2)
			shPosBig[i]={shPosBig[i][1]+ dirShootBig[i][1],shPosBig[i][2]+ dirShootBig[i][2]}
 	 if shPosBig[i][1]>240 or shPosBig[i][2]>136 then
    shPosBig[i] = {-1,-1}
   end
  end
 end
	
	--pix(x, y, 12)
	-- draw weapon
	if w1_enabled then 
	 spr(1,xw1,yw1,0,1,0,0,1,1)
	 rectb(xw1, yw1, 8, 8, 2)
	end
	
	if w2_enabled then 
	 spr(2,xw2,yw2,0,1,0,0,1,1)
	 rectb(xw2, yw2, 8, 8, 2)
	end
	
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
 
 for i=1,num_jw do
 if jw_enabled[i] then
   rectb(jw_box[i].bx,
  				 		jw_box[i].by,
  			 			jw_box[i].bw,
  		 				jw_box[i].bh,
         2
   )
   spr(4,jw_pos[i][1],jw_pos[i][2],0,1,0,0,1,1)
  end
 end
	
	tri(a,b,c,d,e,f,color)
 
 -- render the enemies
 for i=1,num_en do 
  --tri(bens[i].x1,
  --bens[i].y1,
  --bens[i].x2,
  --bens[i].y2,
  --bens[i].x3,
  --bens[i].y3,
  --color)
  if ens_enabled[i] then
   rectb(en_box[i].bx,
  				 		en_box[i].by,
  			 			en_box[i].bw,
  		 				en_box[i].bh,
         2
   )
   spr(3,en_pos[i][1],en_pos[i][2],0,1,0,0,1,1)
  end
 end 
 
 
 -- collision with weapon 1
 if w1_enabled then
  col_big = AABB(bp, bw1)
  if col_big then
  	w1_enabled=false
   sh_type = 1
  end
 end
 
 -- collision with weapon 2
 if w2_enabled then
  col_small = AABB(bp, bw2)
  if col_small then
 	 w2_enabled=false
   sh_type = 2
  end
 end 
 
 --print("w1 : "..tostring(col_big),20,120)
	--print("tri: "..a..", "..b..", "..c,20,60)
	--print("tri: "..d..", "..e..", "..f,20,80)
 
	--mwh=math.max(w,h)
end

-- <TILES>
-- 001:00000000000000c0cccccccccccccccccc0c0000cc000000cc000000cc000000
-- 002:000000000000000000cccc0000c0000000c00000000000000000000000000000
-- 003:0003000000333300333333333331333303313133033131330333333000333330
-- 004:0000000000444400044c444004cc444004444440044444400044440000000000
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

