-- title:   game title
-- author:  Nicolqs & Jake
-- desc:    short description
-- site:    website link
-- license: MIT License (change this to your license of choice)
-- version: 0.1
-- script:  lua

function BOOT() 
 x=120
 y=68
 --mx=0
 --my=0
 vx=0
 vy=0
 x_max=-1
 y_max=-1
 x_min=-1
 y_min=-1
 lifep = 100
 bp = {}

 max_speed_x=1
 max_speed_y=1
 
 --map
 map_gen=false
 
  --bgm
 music(0,0,0,true,true)
 
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
 num_w1=0
 num_w2=0
 
 w1_pos={}
	w2_pos={}
 
 w1_enabled={}
 w2_enabled={}
 
 --obstacle
 num_os_min=2
 num_os_max=5
 num_os=3
 os_life = {3, 3, 3}
 os_enabled = {true, true, true}
 bos = {{bx=20,by=20,bw=28,bh=28},
 {bx=200,by=40,bw=8,bh=8},
 {bx=100,by=100,bw=10,bh=10}}

 --goal
 num_dir=5
 dir_goal={}
 dir_goal_buffer={}
 index_goal = 1
 for i=1, num_dir do
  dir_goal_buffer[i] = math.random(0,3)
 end
 dir_goal =  dir_goal_buffer

 time_win = 100
 timer_begin = -1 
 timer_buffer = -1
 game_over = false 

 --ui
 score = 0

 --enemies
 num_en_min=3
 num_en_max=5
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
  
   -- speed boost
  num_sp = 0
  sp_enabled ={}
  sp_pos = {}
  sp_box = {}
  
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

function gen_wp()
 local rd = math.random
 w1_pos={}
	w2_pos={}
 w1_enabled={}
 w2_enabled={}
 num_w1 = rd(1,2)
 num_w2 = rd(1,2)
 
 for i=1, num_w1 do
  w1_enabled[i]=true
  w1_pos[i]={rd(1,240),rd(1,136)}
 end
 
 for i=1, num_w2 do
  w2_enabled[i]=true
  w2_pos[i]={rd(1,240),rd(1,136)}
 end
end

function gen_jw()
local rd = math.random
 num_jw = rd(3,10)
 jw_enabled ={}
 jw_pos={}
 jw_box={}
 for i=1, num_jw do
  jw_enabled[i]=true
  jw_pos[i]={rd(1,240), rd(1,136)}
  jw_box[i]={bx=jw_pos[i][1],by=jw_pos[i][2],bw=8,bh=8}
 end
end 

function gen_ob()
	local rd = math.random
	num_os=rd(num_os_min,num_os_max)
	os_enabled={}
	os_life={}
	bos={}
	for i=1, num_os do
		os_enabled[i]=true
		os_life[i]=3
		bos[i]={bx=rd(1,240),
		        by=rd(1,136),
		        bw=rd(5,30),
		        bh=rd(5,30)}
	end
end 

function gen_en()
	local rd = math.random
  
	num_en=rd(num_en_min,num_en_max)
	ens_enabled={}
	en_pos={}
	en_box={}
	
	for i=1, num_en do
		ens_enabled[i]=true
		en_pos[i]={rd(1,240),rd(1,136)}
		val=magnitude(x-en_pos[i][1], y-en_pos[i][2])
		while (val < 20) do
			en_pos[i]={rd(1,240),rd(1,136)}
			val=magnitude(x-en_pos[i][1], y-en_pos[i][2])
		end
		en_box[i]={bx=en_pos[i][1],
		           by=en_pos[i][2],
		           bw=8,
		           bh=8}
	end
end 

function render_sky()
	for i=0,240 do
		for j=0,136 do
			if mp[i] then
				if cntSky==0 then
			  pix(i,j,mp[i][j]+8)
				else
					pix(i-1,j,mp[i][j]+8)
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

function collision_sp()
	-- collision with speed boost
	for i=1,num_sp do
		if sp_enabled[i] then
			if AABB(bp, sp_box[i]) then
				sp_enabled[i]=false
				max_speed_x = max_speed_x + 0.5
				max_speed_y = max_speed_y + 0.5
			end
		end
	 end
	end

function collision_jw()
-- collision with jewel
for i=1,num_jw do
	if jw_enabled[i] then
		if AABB(bp, jw_box[i]) then
			jw_enabled[i]=false
			score = score + 3
		end
	end
 end
end

-- PERLIN NOISE FUNCTION END

function update_goal(dir)
	if dir_goal_buffer[index_goal]==dir then
		index_goal = index_goal+1
	else
		dir_goal_buffer = dir_goal
		index_goal = 1
	end
end 

function transition_map()
	-- begin of the level
	--if mx==0 and x<0 and my==0 then
		--x=0
	--end

	-- end of the map top
	if y<0 then
		y=130
		--my=my-18
		map_gen=false
		update_goal(0)
	end

	-- end of the map right
	if x>=240 then
		x=0
		--mx=mx+30
		update_goal(1)
		map_gen=false
	end

	-- end of the map bottom
	if y>=136 then
 		y=0
		--my=my+18
		map_gen=false
		update_goal(2)
	end

	-- end of the map left 
	if x<0 then
		x=236
		--mx=mx-30
		map_gen=false
		update_goal(3)
	end 

	--if mx==0 and x<0 and my>0 then
	--	x=240
		--my=my-18
	--	map_gen=false
	--end
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

function shooting(xmouse, ymouse)
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
		  sfx (19,14,10,1,15,4) 
	   dirShoot[i] = norm({xmouse-x, ymouse-y})
		  shPos[i] = {x, y}
		  shoot = true
	  
	   -- recoil
	   x=x-dirShoot[i][1]
	   y=y-dirShoot[i][2]
	  elseif sh_type==1 then
		  sfx (19,14,10,1,15,4)
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

 function render_col_small_gun()
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
						os_life[j] = os_life[j]-1
						if os_life[j] <= 0 then
   	 						os_enabled[j] = false
						end
     					shPos[i] = {-1,-1}
    				end
			 		shPosBox[i]=bb
				end
			end
			
			for j=1,num_en do
				if ens_enabled[j] then
    				-- collision bullet enemies
    				if AABB(bb, en_box[j]) then 
						num_sp = num_sp + 1
						sp_enabled[num_sp] = true
						sp_pos[num_sp] = {en_pos[j][1], en_pos[j][2]}
						sp_box[num_sp] =  {bx=en_pos[j][1],by=en_pos[j][2],bw=8,bh=8}
						ens_enabled[j] = false
     					shPos[i] = {-1,-1}
						score = score + 1
    				end 
			 		shPosBox[i]=bb
				end
			end
		
			--rectb(bb.bx, bb.by, bb.bw, bb.bh,2)
			shPos[i]={shPos[i][1]+ dirShoot[i][1],shPos[i][2]+ dirShoot[i][2]}
 	 		if shPos[i][1]>240 or shPos[i][2]>136 then
    			shPos[i] = {-1,-1}
   			end
  		end
 	end
end

function render_sp()
	for i=1,num_sp do
		if sp_enabled[i] then
			spr(6,sp_pos[i][1],sp_pos[i][1],0,1,0,0,1,1)
		end
	end 
end

function render_col_big_gun()
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
		 os_life[j] = os_life[j]-3
		if os_life[j] <= 0 then
   	 		os_enabled[j] = false
		end
      shPosBig[i] = {-1,-1}
     end 
			  shPosBigBox[i]=bb
			 end
			end
			
			for j=1,num_en do
			if ens_enabled[j] then
    -- collision bullet enemies
    if AABB(bb, en_box[j]) then 
		num_sp = num_sp + 1
		sp_enabled[num_sp] = true
		sp_pos[num_sp] = {en_pos[j][1], en_pos[j][2]}
		sp_box[num_sp] = {bx=en_pos[j][1],by=en_pos[j][2],bw=8,bh=8}
	 	ens_enabled[j] = false
		shPosBig[i] = {-1,-1}
		score = score + 1
    end 
			 shPosBigBox[i]=bb
			end
			end
			
			--rectb(bb.bx,bb.by,bb.bw,bb.bh, 2)
			shPosBig[i]={shPosBig[i][1]+ dirShootBig[i][1],shPosBig[i][2]+ dirShootBig[i][2]}
 	 if shPosBig[i][1]>240 or shPosBig[i][2]>136 then
    shPosBig[i] = {-1,-1}
   end
  end
 end
end

function obstacle_collision()
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
end

function gen_random_map()
	if not map_gen then
		gen_ob()
		gen_en()
		gen_jw()
		gen_wp()
		map_gen=true 
	end
end

function input_system()
	if btn(0) then
		vy=vy-0.2
		--	sfx (28,12,-1,0,2,4)
 	end
	if btn(1) then
		vy=vy+0.2
		--	sfx (28,12,-1,0,2,4)
 	end
	if btn(2) then
	 vx=vx-0.2
	--	sfx (28,12,-1,0,2,4)
 end
	if btn(3) then
	 vx=vx+0.2
	--	sfx (28,12,-1,0,2,4)
 end
	
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
		
	vx = clamp(vx, -max_speed_x, max_speed_x)
	vy = clamp(vy, -max_speed_y, max_speed_y)
end

function check_render_timer()
	if timer_buffer > 0 then
		timer_buffer = time()
	 end
	
	 if timer_begin < 0 then 
	  timer_begin = time()
	  timer_buffer = timer_begin
	 end
	
	  diff_time = math.floor((timer_buffer-timer_begin)/1000)
	  rest = time_win-diff_time
	
	  if rest <= 0 then
		game_over = true
	  end
	
	  print("time: "..tostring(rest),180,5,0)
end

function wp1_collision()
-- collision with weapon 1
for i=1, num_w1 do
	if w1_enabled[i] then
	 spr(1,w1_pos[i][1],w1_pos[i][2],0,1,0,0,1,1)
		--rectb(w1_pos[i][1],w1_pos[i][2], 8, 8, 2)
		bw1 = {
			   bx= w1_pos[i][1], 
			by= w1_pos[i][2],
			bw= 8, 
			bh= 8 
		   }
	 col_big = AABB(bp, bw1)
	 if col_big then
		 w1_enabled[i]=false
	  sh_type = 1
	 end
	end
   end
end

function wp2_collision()
-- collision with weapon 2
for i=1, num_w2 do
	if w2_enabled[i] then
	 spr(2,w2_pos[i][1],w2_pos[i][2],0,1,0,0,1,1)
		--rectb(w2_pos[i][1], w2_pos[i][2], 8, 8, 2)
	 bw2 = {
			   bx= w2_pos[i][1], 
			by= w2_pos[i][2],
			bw= 8, 
			bh= 8 
		   }
	 col_small = AABB(bp, bw2)
	 if col_small then
		 w2_enabled[i]=false
	  sh_type = 2
	 end
	end
   end
end

function render_enemies()
-- render the enemies
for i=1,num_en do 
	if ens_enabled[i] then
	 --rectb(en_box[i].bx,en_box[i].by,en_box[i].bw,en_box[i].bh,2)
	 spr(3,en_pos[i][1],en_pos[i][2],0,1,0,0,1,1)
	end
   end 
end

function render_jw()
	for i=1,num_jw do
		if jw_enabled[i] then
		  --rectb(jw_box[i].bx,jw_box[i].by,jw_box[i].bw,jw_box[i].bh,2)
		  spr(4,jw_pos[i][1],jw_pos[i][2],0,1,0,0,1,1)
		 end
		end
end

function TIC()

	gen_random_map()
	
  	-- crosshair cursor
	poke(0x3FFB,1)	
	
	-- input system for the player
	local xmouse,ymouse,left,middle,right,scrollx,scrolly=mouse()
	
	input_system()
	
 if left then
 	shooting(xmouse,ymouse)
 end
 	-- need to be after the recoil to have the last position x and y 
 	angleRad = math.atan2(y-ymouse,x-xmouse)
	angle = (angleRad * 180 / math.pi + 360) %360
 
 if shoot then
 	if sh_auto_buf >= sh_auto_delay then
 		shoot = false
   sh_auto_buf = 0
 	else 
 		sh_auto_buf = sh_auto_buf+1
  end
 end
 
 transition_map()

-- RENDERING START
cls(13)

if num_dir == index_goal then
	print("MISSION COMPLETE!",84,84)
	return
end
if game_over then
	print("GAME OVER",84,84)
	return
end

render_sky()

--print("life : "..tostring(lifep),84,84, 0)
--print("life : "..tostring(game_over),84,104, 0)
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
			lifep= lifep-1
			if lifep < 0 then
				game_over = true
			end
		end
	end
 end
 
 collision_jw()
 collision_sp()
	 
 --rectb(x_min, y_min, w, h, 2)
	
	-- obstacles collision
	obstacle_collision()

	a,b,c,d,e,f,color = compute_sprite(math.pi + angleRad, x, y,10, 12)
	
	x = x + vx
	y = y + vy
	 
	-- render obstacle
	for j=1, num_os do
	 if os_enabled[j] then
   rect(bos[j].bx,bos[j].by,bos[j].bw,bos[j].bh,2)
	 end
	end
	
	render_col_small_gun()
	render_col_big_gun()
 
	render_jw()
	render_sp()
	
 -- render the player
	tri(a,b,c,d,e,f,color)
 
 render_enemies()
 
 wp1_collision()
 wp2_collision()

 -- display life
 rect(10,10,lifep//2,5,2)
 
 -- goal
 --print("goal : "..tostring(dir_goal_buffer[index_goal]),200,10)
	
 spr(5,220,10,0,1,0,dir_goal_buffer[index_goal],1,1)
 print("score: "..tostring(score),120,5, 0)

 print("speed: "..tostring(max_speed_x),5,130, 0)
	
 check_render_timer()

end

-- <TILES>
-- 001:000000000ccccc000c0000c00c0000c00ccccc000c000c000c0000c000000000
-- 002:0000000000c00c0000cccc000c0cc0c00c0000c00c0000c00c0000c000000000
-- 003:0055550005155150555115555515515555555555555115550515515000555500
-- 004:200000020303303000444400034cc430034cc430004444000303303020000002
-- 005:002cc20002cccc202cccccc2cc2cc2cc222cc222002cc200002cc200002cc200
-- 006:00cccc000c0000000c00000000ccc00000000c0000000c0000000c000cccc000
-- </TILES>

-- <SPRITES>
-- 001:ccf00fccfcf00fcf0fc00cf000000000000000000fc00cf0fcf00fcfccf00fcc
-- 240:00000000fffffffffcfffffcfcfffffcfcfffffcfcfffffcfcccccfcffffffff
-- 241:00000000fffffffffcccccfcfcfffffcfcccccfcfcfffffcfcfffffcffffffff
-- 242:00000000ffffff00ccccff00ffffff00ccccff00ffffff00ccccff00ffffff00
-- 243:00000000fffffffff1212122f1111212f1212122f1111212f1212122ffffffff
-- 244:00000000ffffffff2323233322223233232323332222323323232333ffffffff
-- 245:00000000ffffffff3434344433334344343434443333434434343444ffffffff
-- 246:00000000ffffffff4454545544444545445454554444454544545455ffffffff
-- 247:00000000ffffffff5555656555555556555565655555555655556565ffffffff
-- 248:00000000ffffffff6666666756666666666666675666666666666667ffffffff
-- 249:00000000ffffffff6767777766767777676777776676777767677777ffffffff
-- 250:00000000ffffffff77a7a7af77777a7f77a7a7af77777a7f77a7a7afffffffff
-- </SPRITES>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:00000000fffffffffffffff000000000
-- 002:02468ace02468ace02468ace02468ace
-- 003:0123456789abcdef0123456789abcdef
-- 004:00112233445566778899aabbccddeeff
-- 005:0123456789abcdeffedcba9876543210
-- 006:789abcdefedcba988765432101234567
-- 007:eeeeee77777777eeeeeeee4544441eee
-- 008:55555555556789555520012323455555
-- 009:bbbbbbbbaaaa99988877777666665555
-- 010:cccccccccbbbbaa98876655554444444
-- 011:0012234566533345567889a976667789
-- 015:8c828f838e848c858b868a868a878987
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000309000000000
-- 001:010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100010001000100106000000000
-- 002:020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200000000000000
-- 003:030003000300030003000300030003000300030003000300030003000300030003000300030003000300030003000300030003000300030003000300000000000000
-- 004:040004000400040004000400040004000400040004000400040004000400040004000400040004000400040004000400040004000400040004000400107000000000
-- 005:050005000500050005000500050005000500050005000500050005000500050005000500050005000500050005000500050005000500050005000500404000000000
-- 006:050005000500050005000500050005000500050005000500050005000500050005000500050005000500050005000500050005000500050005000500404000000000
-- 007:070007000700070007000700070007000700070007000700070007000700070007000700070007000700070007000700070007000700070007000700200000000000
-- 008:080008000800080008000800080008000800080008000800080008000800080008000800080008000800080008000800080008000800080008000800106000000000
-- 009:090009000900090009000900090009000900090009000900090009000900090009000900090009000900090009000900090009000900090009000900000000000000
-- 010:090009000900090009000900090009000900090009000900090009000900090009000900090009000900090009000900090009000900090009000900000000000000
-- 011:0a000a000a000a000a000a000a000a000a000a000a000a000a000a000a000a000a000a000a000a000a000a000a000a000a000a000a000a000a000a00300000000000
-- 012:0b000b000b000b000b000b000b000b000b000b000b000b000b000b000b000b000b000b000b000b000b000b000b000b000b000b000b000b000b000b00107000000000
-- 013:0c000c000c000c000c000c000c000c000c000c000c000c000c000c000c000c000c000c000c000c000c000c000c000c000c000c000c000c000c000c00000000000000
-- 014:0f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f00106000000000
-- 016:00c000c010b010a020903080407050506040703080209010a000c000d000e000f000f000f000f000f000f000f000f000f000f000f000f000f000f000107000000000
-- 017:04c004c014b014a024903480447054506440743084209410a400c400d400e400f400f400f400f400f400f400f400f400f400f400f400f400f400f400107000000000
-- 018:07c007c017b017a027903780477057506740773087209710a700c700d700e700f700f700f700f700f700f700f700f700f700f700f700f700f700f700107000000000
-- 019:0cc00cc01cb01ca02c903c804c705c506c407c308c209c10ac00cc00dc00ec00fc00fc00fc00fc00fc00fc00fc00fc00fc00fc00fc00fc00fc00fc00107000000000
-- 020:85e085d085b085a0859085708570756075507550654065405530553045204520452045105510651075009500b500c500e500f500f500f500f500f500305000000000
-- 021:81e081d081b081a0819081708170715071607170616061605160515041504150414041405130612071109100b100c100e100f100f100f100f100f100105000000e00
-- 022:8be08bd08bb08ba08b908b708b707b607b507b506b406b405b305b304b204b204b204b105b106b107b009b00bb00cb00eb00fb00fb00fb00fb00fb00105000000000
-- 023:8be08bd08bb08ba08b908b708b707b607b507b506b406b405b305b304b204b204b204b105b106b107b009b00bb00cb00eb00fb00fb00fb00fb00fb00105000000000
-- 028:0d07fd750dd7fdf60d26fd150d05fd040d03fd020d01fd00fd00fd00fd00fd00fd00fd00fd00fd00fd00fd00fd00fd00fd00fd00fd00fd00fd00fd009800000c0700
-- 029:0c990cbd0ccb0ccffcbcfca9fc9efc920c8d0c9bfca1fcbd0c000c00fc00fc000c000c00fc00fc000c000c00fc00fc000c000c00fc00fc000c000c00810000080c0c
-- 030:0c000c000c000c000c000c000c000c000c000c000c000c000c000c000c000c000c000c000c000c000c000c000c000c000c000c000c000c000c000c00609000000000
-- 032:88e088d088b088a0889088708870785078607870686068605860585048504850484048405830682078109800b800c800e800f800f800f800f800f800100000000e00
-- 033:87e087d087b087a0879087708770775077607770676067605760575047504750474047405730672077109700b700c700e700f700f700f700f700f700100000000e00
-- 034:81e081d081b081a0819081708170715071607170616061605160515041504150414041405130612071109100b100c100e100f100f100f100f100f100105000000e00
-- 036:05001500150015002500350035004500550055006500650075007500850085009500a500a500b500b500c500c500d500d500d500e500e500e500f500304000000000
-- 037:76007600760066006600560056004600460046004600460056006600760086009600a600b600c600d600e600f600f600f600f600f600f600f600f600300000000000
-- 040:c500c500c500c500c500c500c500c500c500c500c500c500c500c500c500c500c500c500c500c500c500c500c500c500c500c500c500c500c500c500200000000000
-- 041:c600c600c600c600c600c600c600c600c600c600c600c600c600c600c600c600c600c600c600c600c600c600c600c600c600c600c600c600c600c600200000000000
-- 042:cb00cb00cb00cb00cb00cb00cb00cb00cb00cb00cb00cb00cb00cb00cb00cb00cb00cb00cb00cb00cb00cb00cb00cb00cb00cb00cb00cb00cb00cb00200000000000
-- 043:c700c700c700c700c700c700c700c700c700c700c700c700c700c700c700c700c700c700c700c700c700c700c700c700c700c700c700c700c700c700200000000000
-- 044:0150019001a001a001900190a180a18091709170816091609150a140b130b120c120c110c110d100d100d100e100e100e100e100e100e100f100f10012b000000000
-- 045:0cf70cf70cf79c77cc20dc10ec00fc00fc00fc00fc00fc00fc00fc00fc00fc00fc00fc00fc00fc00fc00fc00fc00fc00fc00fc00fc00fc00fc00fc00f8b000000000
-- 046:8c000c00ac004c00dc008c00ec00ec00fc00fc00fc00fc00fc00fc00fc00fc00fc00fc00fc00fc00fc00fc00fc00fc00fc00fc00fc00fc00fc00fc0071b000000000
-- 047:0c002c005c008c00ac00dc00dc00ec00ec00ec00ec00ec00fc00fc00fc00fc00fc00fc00fc00fc00fc00fc00fc00fc00fc00fc00fc00fc00fc00fc0010b000000000
-- </SFX>

-- <PATTERNS>
-- 000:8008c2000000f008ee0000008008c20000000008c00000008008c20000000000000000008008c20000000000000000008008c2000000f008ee0000008008c20000000000000000008008c20000000000000000008008c20000000000000000008008c2000000f008ee0000008008c20000000000000000008008c20000000000000000008008c20000000000000000008008c2000000f008ee0000008008c2000000f008ee0000008008c2000000f008ee0000008008c2000000f008ee000000
-- 001:0008d0000000f008f4000000f008de000000000000000000000000000000f008f4000000f008de000000f008f4000000000000000000f008f4000000f008de000000000000000000000000000000f008f4000000f008de000000f008f4000000000000000000f008f4000000f008de000000000000000000000000000000f008f4000000f008de000000f008f40000000008d0000000f008f4000000f008de000000f008f4000000f008f4000000f008f4000000f008de000000f008f4000000
-- 002:000000000000f008ee0008e00000000000000000000000000000000000000000000000000000000000000008e0000000000000000000f008ee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f008ee0000000000000000000000000000000000000000000008e00000000000000000000008e0000000000000000000f008ee000000f008ee000000f008ee000000f008ee000000f008ee000000f008ee000000f008ee000000
-- 003:0000000008f0f008f40008f0000000000000000000000000000000000000f008f4000000000000000000f008f4000000000000000000f008f40000000000000000000008f0000000000000000000f008f4000000000000000000f008f4000000000000000000f008f4000000000000000000000000000000000000000000f008f4000000000000000000f008f40000000008f0000000f008f40008f00008f00008f0f008f40008f0f008f40008f0f008f40008f0f008f40008f0f008f40008f0
-- 009:f37256000840000840000000b00058000000000000000000000000000000000000000000000050000000000000000000000000000000000000000000a00058000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800058000000100000000000800058000000100050000000800058000000100000000000800058000000100000000000800058000050f0005800005080005a000000f00058000000800058000000100050000000
-- 010:b06412000000000000000000b00014000000000000000000000000000000000000000000b00012000000b00014000000a00012000000000000000000a00014000000000000000000000000000000000000000000a00012000000a00014000000f00010000000000000000000f00012000000000000000000000010000000000000000000f00010000000f00012000000f00010000010100010000000f00010000000f00012000000f00010000000f00012000000f00010000000000010100010
-- 044:000000000000400006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </PATTERNS>

-- <TRACKS>
-- 000:0000c20000c21000c21000c21000c21000c21800c21800c21800c2000a00180ac2180ac2180ac2180ac21800c21000c2a00000
-- </TRACKS>

-- <PALETTE>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>

