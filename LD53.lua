-- title:   Sky Package Assault
-- author:  Nicolas Perdu & Iakov Kyriacou-Smith
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
 ax=0
 ay=0
 anim_index = 1
 anim_counter = 0
 anim_id = {281, 297, 313, 329}
 anim_enabled = false
 x_anim = 0
 y_anim = 0
 num_ini_a_x = 0
 num_ini_a_y = 0
 num_max_a = 7
 x_max=-1
 y_max=-1
 x_min=-1
 y_min=-1
 lifep = 100
 bp = {}

 radius1 = 30
 radius2 = 20
 radius3 = 10

 max_speed_x = 1
 max_speed_y = 1

 max_real_speed_x = 4
 max_real_speed_y = 4
 
 --map
 map_gen=false
 margin = 10
 margin_ob = 30
 
  --bgm
-- music(0,0,0,true,true)
 
 -- small weapon
 dirShoot={}
 shPos={}
 shPosBox={}

 --SCN
 prevSCN=0
 
 --heavy weapon with recoil
 dirShootBig={}
 shPosBig={}
 shPosBigBox={}

 inv_frame = false
 inv_counter = 0
 inv_counter_max = 30
 
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
 num_os_min=0
 num_os_max=0
 num_os=3
 os_life = {3, 3, 3}
 os_enabled = {true, true, true}
 bos = {{bx=20,by=20,bw=28,bh=28},
 {bx=200,by=40,bw=8,bh=8},
 {bx=100,by=100,bw=10,bh=10}}

-- payload
payload_picked = false
payload_enabled = false
payload_pos_1 = {math.random(20, 220), math.random(20, 116)}
payload_pos_2 = {math.random(20, 220), math.random(20, 116)}
payload_pos_3 = {math.random(20, 220), math.random(20, 116)}

time_win_fare = 100
timer_begin_fare = -1
timer_buffer_fare = -1

 --goal
 num_goal=3
 goal_pos={}
 goal_enabled=false
 num_dir=4
 dir_goal={}
 dir_goal_buffer={}
 index_goal = 1
 type_goal = 1 -- 1 for payload 2 for goal 
 fill_direction_goal()

 time_win = 100
 timer_begin = -1 
 timer_buffer = -1

 taking_damage = false
 cntTake = 0

 game_win = false
 game_over = false 

 --ui
 score = 0
 fare_score = 0
 mult_score = 1

 --enemies
 num_en_min=3
 num_en_max=5
 num_en=3
 ens_enabled = {true, true, true}
 en_pos = {{0, 0}, {180, 120}, {30, 94}}
 en_box = {{bx=0,by=0,bw=8,bh=8},
  {bx=180,by=120,bw=8,bh=8},
  {bx=30,by=94,bw=8,bh=8}}

  num_en_sh_min=1
  num_en_sh_max=3
  num_en_sh=0
  ens_sh_enabled = {}
  en_sh_pos = {}
  en_sh_box = {}
  en_sh_bullet_pos = {}
  en_sh_bullet_dir = {}
  en_sh_bullet_box = {}
  en_sh_bullet_enabled = {}
  num_sh_bullet = {}
  en_sh_delay_shooting = {}
  
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

   -- cooldown boost
   num_cl = 0
   cl_enabled ={}
   cl_pos = {}
   cl_box = {}

   -- time boost
   num_tm = 0
   tm_enabled = {}
   tm_pos = {}
   tm_box = {}

   -- life boost
   num_lf = 0
   lf_enabled = {}
   lf_pos = {}
   lf_box = {}
  
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

function fill_direction_goal()
	dir_goal={}
	dir_goal_buffer={}
	index_goal = 1
	for i=1, num_dir do
	 dir_goal_buffer[i] = math.random(0,3)
	end
	dir_goal =  dir_goal_buffer
end

function render_anim()
	if anim_enabled then
		spr(anim_id[anim_index],x_anim - 4,y_anim - 4,0,1,0,0,1,1)
		if anim_counter > 2 then
				anim_index = anim_index + 1
				anim_counter = 0
			end
		if anim_index == 5 then
			anim_enabled = false
			anim_index = 0
		end
		anim_counter = anim_counter + 1 
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
  w1_pos[i]={rd(1+margin,240),rd(1+margin,136-margin)}
 end
 
 for i=1, num_w2 do
  w2_enabled[i]=true
  w2_pos[i]={rd(1+margin,240-margin),rd(1+margin,136-margin)}
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
  jw_pos[i]={rd(1+margin,240-margin), rd(1+margin,136-margin)}
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

		--x_ob = 0
		--y_ob = 0
		-- if x > 200 and x < 240 then -- right
			-- x_ob = rd(1+margin,240-margin)
		-- else if x > 0 and x < 40 then -- left
		-- else if y > 0 and y < 40 then -- top
		-- else if y > 100 and x < 136 then -- bottom

		bos[i]={bx=rd(1+margin_ob,240-margin_ob),
		        by=rd(1+margin_ob,136-margin_ob),
		        bw=rd(5,30),
		        bh=rd(5,30)}
	end
end 

function gen_en_sh()
	local rd = math.random
  
	num_en_sh=rd(num_en_sh_min,num_en_sh_max)
	ens_sh_enabled={}
	en_sh_pos={}
	en_sh_box={}
	en_sh_bullet_pos={}
	en_sh_bullet_dir={}
	en_sh_bullet_box={}
	num_sh_bullet = {}
	en_sh_delay_shooting={}
	
	for i=1, num_en_sh do
		ens_sh_enabled[i]=true
		en_sh_delay_shooting[i]=0
		en_sh_pos[i]={rd(1+margin,240-margin),rd(1+margin,136-margin)}
		val=magnitude(x-en_sh_pos[i][1], y-en_sh_pos[i][2])
		while (val < 30) do
			en_sh_pos[i]={rd(1+margin,240-margin),rd(1+margin,136-margin)}
			val=magnitude(x-en_sh_pos[i][1], y-en_sh_pos[i][2])
		end
		en_sh_box[i]={bx=en_sh_pos[i][1],
		           by=en_sh_pos[i][2],
		           bw=8,
		           bh=8}
		num_sh_bullet[i]=0
		en_sh_bullet_pos[i]={}
		en_sh_bullet_dir[i]={}
		en_sh_bullet_box[i]={}
		en_sh_bullet_enabled[i]={}
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
		en_pos[i]={rd(1+margin,240-margin),rd(1+margin,136-margin)}
		val=magnitude(x-en_pos[i][1], y-en_pos[i][2])
		while (val < 20) do
			en_pos[i]={rd(1+margin,240-margin),rd(1+margin,136-margin)}
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

function collision_cl()
	-- collision with cooldown boost
	for i=1,num_cl do
		if cl_enabled[i] then
			if AABB(bp, cl_box[i]) then
				sfx (48,36,16,3,7,5)
				cl_enabled[i]=false
				sh_auto_delay = sh_auto_delay-1
			end
		end
	 end
	end

	function collision_tm()
		-- collision with time boost
		for i=1,num_tm do
			if tm_enabled[i] then
				if AABB(bp, tm_box[i]) then
					sfx (48,36,16,3,7,5)
					tm_enabled[i]=false
					timer_begin = timer_begin + 10000
				end
			end
		 end
		end

		function collision_lf()
			-- collision with cooldown boost
			for i=1,num_lf do
				if lf_enabled[i] then
					if AABB(bp, lf_box[i]) then
							sfx (48,36,16,3,7,5)
						lf_enabled[i]=false
						lifep = lifep+10
					end
				end
			 end
			end

function collision_sp()
	-- collision with speed boost
	for i=1,num_sp do
		if sp_enabled[i] then
			if AABB(bp, sp_box[i]) then
				sfx (48,36,16,3,7,5)
				sp_enabled[i]=false
				max_speed_x = max_speed_x + 0.3
				max_speed_y = max_speed_y + 0.3
				max_speed_x = clamp(max_speed_x, -max_real_speed_x, max_real_speed_x)
				max_speed_y = clamp(max_speed_y, -max_real_speed_y, max_real_speed_y)
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
			lifep = lifep + 1
			sfx (48,36,16,3,7,5)
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
			anim_enabled = true
		 if sh_type==2 then
		  sfx (19,14,10,1,15,4) 
	   dirShoot[i] = norm({xmouse-x, ymouse-y})
		  shPos[i] = {x, y}
		  shoot = true
	  
	   -- recoil
	   recoil=1.5
	   vx=vx-dirShoot[i][1]*recoil
	   vy=clamp(vx, -1, 1)
	   vy=vy-dirShoot[i][2]*recoil
	   vy=clamp(vy, -1, 1)
	   num_ini_a_x = 0
	   num_ini_a_y = 0
	  elseif sh_type==1 then
		  sfx (19,14,10,1,15,4)
	   	  dirShootBig[i] = norm({xmouse-x, ymouse-y})
		  shPosBig[i] = {x, y}
		  shoot = true
	  
	   	  -- recoil
	   	  recoil=4
	   	  vx=vx-dirShootBig[i][1]*recoil
		  vx=clamp(vx, -1, 1)
	   	  vy=vy-dirShootBig[i][2]*recoil
		  vy=clamp(vy, -1, 1)
		  num_ini_a_x = 0
		  num_ini_a_y = 0
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

 function gen_boost_ob(j)
	ch = math.random(1, 2)
	if(ch == 1) then
		--spawn time 
		num_tm = num_tm + 1				
		tm_enabled[num_tm] = true
		tm_pos[num_tm] = {bos[j].bx, bos[j].by}
		tm_box[num_tm] =  {bx=bos[j].bx,by=bos[j].by,bw=8,bh=8}
	else
		--spawn life
		num_lf = num_lf + 1				
		lf_enabled[num_lf] = true
		lf_pos[num_lf] = {bos[j].bx, bos[j].by}
		lf_box[num_lf] =  {bx=bos[j].bx,by=bos[j].by,bw=8,bh=8}
	end  
end 

 function gen_boost(j)
	ch = math.random(1, 2)
	if(ch == 1) then 
		num_sp = num_sp + 1				
		sp_enabled[num_sp] = true
		sp_pos[num_sp] = {en_pos[j][1], en_pos[j][2]}
		sp_box[num_sp] =  {bx=en_pos[j][1],by=en_pos[j][2],bw=8,bh=8}
	else
		num_cl = num_cl + 1				
		cl_enabled[num_cl] = true
		cl_pos[num_cl] = {en_pos[j][1], en_pos[j][2]}
		cl_box[num_cl] =  {bx=en_pos[j][1],by=en_pos[j][2],bw=8,bh=8}
	end
 end

 function gen_boost_sh(j)
	ch = math.random(1, 2)
	if(ch == 1) then 
		num_sp = num_sp + 1				
		sp_enabled[num_sp] = true
		sp_pos[num_sp] = {en_sh_pos[j][1], en_sh_pos[j][2]}
		sp_box[num_sp] =  {bx=en_sh_pos[j][1],by=en_sh_pos[j][2],bw=8,bh=8}
	else
		num_cl = num_cl + 1				
		cl_enabled[num_cl] = true
		cl_pos[num_cl] = {en_sh_pos[j][1], en_sh_pos[j][2]}
		cl_box[num_cl] =  {bx=en_sh_pos[j][1],by=en_sh_pos[j][2],bw=8,bh=8}
	end
 end 

 function update_score_kill()
	if payload_picked then 
		fare_score = fare_score + mult_score*10
		mult_score = mult_score + 1
	end
end

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
							gen_boost_ob(j)
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
      sfx (28,25,16,2,7,5) 
						gen_boost(j)
						ens_enabled[j] = false
     					shPos[i] = {-1,-1}
						update_score_kill()
    				end 
			 		shPosBox[i]=bb
				end
			end

			for j=1,num_en_sh do
				if ens_sh_enabled[j] then
    				-- collision bullet enemies
    				if AABB(bb, en_sh_box[j]) then
      sfx (28,25,16,2,7,5)  
						gen_boost_sh(j)
						ens_sh_enabled[j] = false
     					shPos[i] = {-1,-1}
						update_score_kill()
    				end 
			 		shPosBox[i]=bb
				end
			end
		
			--rectb(bb.bx, bb.by, bb.bw, bb.bh,2)
			shPos[i]={shPos[i][1]+dirShoot[i][1] * 2.5,shPos[i][2]+dirShoot[i][2] * 2.5}
 	 		if shPos[i][1]>240 or shPos[i][2]>136 or shPos[i][1]<0 or shPos[i][2]<0 then
    			shPos[i] = {-1,-1}
   			end
  		end
 	end
end

function render_sp()
	for i=1,num_sp do
		if sp_enabled[i] then
			--rectb(sp_box[i].bx,sp_box[i].by,sp_box[i].bw,sp_box[i].bh, 2)
			spr(6,sp_pos[i][1],sp_pos[i][2],0,1,0,0,1,1)
		end
	end 
end

function render_cl()
	for i=1,num_cl do
		if cl_enabled[i] then
			--rectb(cl_box[i].bx,cl_box[i].by,cl_box[i].bw,cl_box[i].bh, 2)
			spr(7,cl_pos[i][1],cl_pos[i][2],0,1,0,0,1,1)
		end
	end 
end

function render_tm()
	for i=1,num_tm do
		if tm_enabled[i] then
			--rectb(cl_box[i].bx,cl_box[i].by,cl_box[i].bw,cl_box[i].bh, 2)
			spr(8,tm_pos[i][1],tm_pos[i][2],0,1,0,0,1,1)
		end
	end 
end

function render_lf()
	for i=1,num_lf do
		if lf_enabled[i] then
			--rectb(cl_box[i].bx,cl_box[i].by,cl_box[i].bw,cl_box[i].bh, 2)
			spr(9,lf_pos[i][1],lf_pos[i][2],0,1,0,0,1,1)
		end
	end 
end

function render_col_big_gun()
	for i=1,sh_max do
		if shPosBig[i][1] > 0 then
			circ(shPosBig[i][1],shPosBig[i][2],5, 4)
			
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
      sfx (28,25,16,2,7,5) 
						gen_boost(j)
	 					ens_enabled[j] = false
						shPosBig[i] = {-1,-1}
						update_score_kill()
    				end 
			 		shPosBigBox[i]=bb
				end
			end

			for j=1,num_en_sh do
				if ens_sh_enabled[j] then
    				-- collision bullet enemies
    				if AABB(bb, en_sh_box[j]) then
      sfx (28,25,16,2,7,5)
						gen_boost_sh(j)
	 					ens_sh_enabled[j] = false
						shPosBig[i] = {-1,-1}
						update_score_kill()
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
				vx=-vx
				vy=-vy
			end
		end
	end	
end

function gen_random_map()
	if not map_gen then
		num_sp = 0
		sp_enabled ={}
 		sp_pos = {}
  		sp_box = {}
		  sh_max = 100
		  for i=1,sh_max do
		   dirShoot[i]={-1,-1}
		   shPos[i]={-1,-1}
		   dirShootBig[i]={-1,-1}
		   shPosBig[i]={-1,-1}
		  end
		en_sh_bullet_pos = {}
		en_sh_bullet_box = {}

   		num_cl = 0
   		cl_enabled ={}
   		cl_pos = {}
   		cl_box = {}

		gen_ob()
		gen_en()
		gen_en_sh()
		gen_jw()
		gen_wp()
		map_gen=true 
	end
end

function input_system()
	const_a = 0.05
	if key(23) or btn(0) then
		if ay == 0 then
			ay=ay-const_a
			num_ini_a_y = 0
		end
		--	sfx (28,12,-1,0,2,4)
 	end
	if key(19) or btn(1) then
		if ay == 0 then
			ay=ay+const_a
			num_ini_a_y = 0
		end
		--	sfx (28,12,-1,0,2,4)
 	end
	if key(01) or btn(2) then
		if ax == 0 then
	 		ax=ax-const_a
	 		num_ini_a_x = 0
		end
	--	sfx (28,12,-1,0,2,4)
 end
	if key(04) or btn(3) then
	if ax == 0 then
	 ax=ax+const_a
	 num_ini_a_x = 0
	end
	--	sfx (28,12,-1,0,2,4)
 end

 	if num_ini_a_x < num_max_a then
		num_ini_a_x = num_ini_a_x + 1
	else
		ax = 0
	end

	if num_ini_a_y < num_max_a then
		num_ini_a_y = num_ini_a_y + 1
	else
		ay = 0 
	end

 	vx = vx + ax
	vy = vy + ay
	
	if not (key(23) or btn(0))
		and not (key(19) or btn(1))
		and not (key(01) or btn(2))
		and not (key(04) or btn(3)) then 
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

	vx = clamp(vx, -max_real_speed_x, max_real_speed_x)
	vy = clamp(vy, -max_real_speed_y, max_real_speed_y)
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
	
	  local begin_pos = 190
	  local begin_y = 110
	  spr(289,begin_pos,begin_y,0,1,0,0,3,1)

 	  num5 = rest % 10;
 	  num4 = (rest // 10) % 10;
      num3 = (rest // 100) % 10;

	  begin_pos = begin_pos + 24
	  
      spr(get_id_number(num3),begin_pos,begin_y,0,1,0,0,1,1)
      spr(get_id_number(num4),begin_pos+8,begin_y,0,1,0,0,1,1)
      spr(get_id_number(num5),begin_pos+16,begin_y,0,1,0,0,1,1)
	  
	  --print("time: "..tostring(rest),200,5,0)
end

function render_payload_txt()
	if payload_picked then
		spr(288,225,35,0,1,0,0,1,1)
	end
end

function SCN(y)
	if taking_damage then
	 if cntTake < 500 then
		 prevSCN=math.random(-4,4)
	 	 poke(0x3FF9, prevSCN)
	  	cntTake = cntTake + 1
	 else
		 cntTake = 0
	  		poke(0x3FF9,0)
		 taking_damage = false
	 end
	end
end

function check_render_timer_fare()
	rest = 0
	if payload_picked then 
		timer_buffer_fare = time()
	
	  diff_time_fare = math.floor((timer_buffer_fare-timer_begin_fare)/1000)
	  rest = time_win_fare-diff_time_fare
	
	  if rest <= 0 then
		score = score - fare_score
		fare_score = 0
		type_goal = 1
		payload_picked = false
		fill_direction_goal()
		goal_enabled = false
	  end
	end

	  local begin_pos = 190
	  local begin_y = 120
	  spr(278,begin_pos,begin_y,0,1,0,0,3,1)
	  begin_pos = begin_pos + 26

	  num5 = rest % 10;
 	  num4 = (rest // 10) % 10;
      num3 = (rest // 100) % 10;
	  
      spr(get_id_number(num3),begin_pos,begin_y,0,1,0,0,1,1)
      spr(get_id_number(num4),begin_pos+8,begin_y,0,1,0,0,1,1)
      spr(get_id_number(num5),begin_pos+16,begin_y,0,1,0,0,1,1)

	  --print("time fare: "..tostring(rest),100,5,0)
end

function get_id_number(num)
	def = 440

	if num == 1 then
		def = 392
	elseif num == 2 then
		def = 393
	elseif num == 3 then
		def = 394
	elseif num == 4 then
		def = 408
	elseif num == 5 then
		def = 409
	elseif num == 6 then
		def = 410
	elseif num == 7 then
		def = 424
	elseif num == 8 then
		def = 425
	elseif num == 9 then
		def = 426
	end

	return def
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
			sfx (48,36,16,3,7,5)
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
			sfx (48,36,16,3,7,5)
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

function render_enemies_sh()
	-- render the enemies
	for i=1,num_en_sh do 
		if ens_sh_enabled[i] then
		 --rectb(en_box[i].bx,en_box[i].by,en_box[i].bw,en_box[i].bh,2)
		 spr(17,en_sh_pos[i][1],en_sh_pos[i][2],0,1,0,0,1,1)
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

function render_ob()
-- render obstacle
for j=1, num_os do
	if os_enabled[j] then
	   rect(bos[j].bx,bos[j].by,bos[j].bw,bos[j].bh,0)
	end
   end
end 

function render_payload()
	if payload_enabled then
		dist1 = magnitude(x-payload_pos_1[1], y-payload_pos_1[2])
		dist2 = magnitude(x-payload_pos_2[1], y-payload_pos_2[2])
		dist3 = magnitude(x-payload_pos_3[1], y-payload_pos_3[2])

		if dist1 < radius1 then
			payload_picked = true
			sfx (48,48,16,3,7,5)
			timer_begin_fare = time()
			time_win_fare = 90
			type_goal = 1
			fill_direction_goal()
			payload_enabled = false
		end

		if dist2 < radius2 then
			payload_picked = true
			sfx (48,48,16,3,7,5)
			timer_begin_fare = time()
			time_win_fare = 60
			type_goal = 2
			fill_direction_goal()
			payload_enabled = false
		end

		if dist3 < radius3 then
			payload_picked = true
			sfx (48,48,16,3,7,5)
			timer_begin_fare = time()
			time_win_fare = 30
			type_goal = 3
			fill_direction_goal()
			payload_enabled = false
		end

		circb(payload_pos_1[1], payload_pos_1[2], radius1, 5)
		circb(payload_pos_2[1], payload_pos_2[2], radius2, 3)
		circb(payload_pos_3[1], payload_pos_3[2], radius3, 2)
	end
end

function render_goal()
	if goal_enabled then
		dist = magnitude(x-goal_pos[1], y-goal_pos[2])
		radius = 10
		if dist < radius then
		
			num_goal = num_goal - 1
			
			if type_goal == 1 then
				fare_score = fare_score + 100
			elseif type_goal == 2 then
				fare_score = fare_score + 500
			elseif type_goal == 3 then
				fare_score = fare_score + 1000
			end
			
			sfx (48,60,16,3,7,5)

			score = score + fare_score 
			fare_score = 0
			timer_begin = timer_begin + 10000
			type_goal = 1
			payload_picked = false
			fill_direction_goal()
			goal_enabled = false
		end 
		circb(goal_pos[1], goal_pos[2], radius, 12)
	end
end

function collision_render_bullet()
	speed_bul=1
	for i=1,num_en do
	   if ens_sh_enabled[i] then
			for j=1,num_sh_bullet[i] do
			   if en_sh_bullet_enabled[i][j] then
				   en_sh_bullet_pos[i][j]= {en_sh_bullet_pos[i][j][1]+en_sh_bullet_dir[i][j][1]*speed_bul,
										   en_sh_bullet_pos[i][j][2]+en_sh_bullet_dir[i][j][2]*speed_bul}
				   en_sh_bullet_box[i][j]= {bx=en_sh_bullet_pos[i][j][1],by=en_sh_bullet_pos[i][j][2],bw=2,bh=2}
				   
				   if en_sh_bullet_pos[i][j][1]>240 or en_sh_bullet_pos[i][j][2]>136 or en_sh_bullet_pos[i][j][1]<0 or en_sh_bullet_pos[i][j][2]<0 then
					   en_sh_bullet_enabled[i][j] = false
				   end
   
				   pix(en_sh_bullet_pos[i][j][1], en_sh_bullet_pos[i][j][2], 4)
				   -- rectb(en_sh_bullet_box[i][j].bx, en_sh_bullet_box[i][j].by, en_sh_bullet_box[i][j].bw, en_sh_bullet_box[i][j].bh, 2)
   
				   if AABB(bp, en_sh_bullet_box[i][j]) then
						if not inv_frame then
					   		lifep = lifep-1
							sfx (28,25,16,2,7,5)
							taking_damage = true
							inv_frame = true
							inv_counter = 0
							mult_score = 1
						end
					   en_sh_bullet_enabled[i][j] = false
					   if lifep < 0 then
						   game_over = true
					   end
				   end
			   end
			end
	   end
   end
end

function update_inv_frame()
	if inv_frame then
		inv_counter = inv_counter + 1
		if inv_counter == inv_counter_max then
			inv_frame = false
			inv_counter = 0
		end
	end 
end

function render_mult_score()
	begin_x = 160
	begin_y = 0
   
	spr(273,begin_x,begin_y,0,1,0,0,4,1)

	num5 = mult_score % 10;
	num4 = (mult_score // 10) % 10;
	num3 = (mult_score // 100) % 10;
	--num1 = (score // 10000) % 10;
	begin_x = begin_x + 35
   
	spr(get_id_number(num3),begin_x, begin_y,0,1,0,0,1,1)
	spr(get_id_number(num4),begin_x + 8, begin_y,0,1,0,0,1,1)
	spr(get_id_number(num5),begin_x + 16, begin_y,0,1,0,0,1,1)
end

function render_fare_score()
	begin_x = 80
	begin_y = 0
   
	spr(278,begin_x,begin_y,0,1,0,0,4,1)

	num5 = fare_score % 10;
	num4 = (fare_score // 10) % 10;
	num3 = (fare_score // 100) % 10;
	num2 = (fare_score // 1000) % 10;
	--num1 = (score // 10000) % 10;
	begin_x = begin_x + 28
   
	spr(get_id_number(num2),begin_x, begin_y,0,1,0,0,1,1)
	spr(get_id_number(num3),begin_x + 8, begin_y,0,1,0,0,1,1)
	spr(get_id_number(num4),begin_x + 16, begin_y,0,1,0,0,1,1)
	spr(get_id_number(num5),begin_x + 24, begin_y,0,1,0,0,1,1)
end

function render_score()
	begin_x = 2
	begin_y = 0
   
	spr(261,begin_x,begin_y,0,1,0,0,4,1)
	num5 = score % 10;
	num4 = (score // 10) % 10;
	num3 = (score // 100) % 10;
	num2 = (score // 1000) % 10;
	--num1 = (score // 10000) % 10;
	begin_x = begin_x + 35
   
	spr(get_id_number(num2),begin_x, begin_y,0,1,0,0,1,1)
	spr(get_id_number(num3),begin_x + 8, begin_y,0,1,0,0,1,1)
	spr(get_id_number(num4),begin_x + 16, begin_y,0,1,0,0,1,1)
	spr(get_id_number(num5),begin_x + 24, begin_y,0,1,0,0,1,1)
end

function collision_en()
	for i=1,num_en_sh do
		if ens_sh_enabled[i] then
		   if en_sh_delay_shooting[i] < 100 then
			   en_sh_delay_shooting[i] = en_sh_delay_shooting[i] + 1
		   else -- shoot 
			   en_sh_delay_shooting[i] = 0
				dir = norm({x-en_sh_pos[i][1], y-en_sh_pos[i][2]})
			   num_sh_bullet[i] = num_sh_bullet[i] + 1
			   en_sh_bullet_enabled[i][num_sh_bullet[i]] = true
				en_sh_bullet_pos[i][num_sh_bullet[i]] = {en_sh_pos[i][1],en_sh_pos[i][2]} 
			   en_sh_bullet_dir[i][num_sh_bullet[i]] = {dir[1],dir[2]} 
				  en_sh_bullet_box[i][num_sh_bullet[i]] = {bx=en_sh_bullet_pos[i][num_sh_bullet[i]][1],by=en_sh_bullet_pos[i][num_sh_bullet[i]][2],bw=2,bh=2}
		   end
   
			  if AABB(bp, en_sh_box[i]) then
				if not inv_frame then
			   		lifep = lifep-2
					taking_damage = true
					mult_score = 1
					inv_frame = true
					inv_counter = 0
				end
			   if lifep < 0 then
				   game_over = true
			   end
		   end
	   end
	end
end

function collision_en_mv()
	speed_en = 0.2
	for i=1,num_en do
		if ens_enabled[i] then
			dir = norm({x-en_pos[i][1], y-en_pos[i][2]})
			en_pos[i]= {en_pos[i][1]+ dir[1]*speed_en,en_pos[i][2]+ dir[2]*speed_en} 
			  en_box[i].bx=en_pos[i][1]
			  en_box[i].by=en_pos[i][2]
	 
			  if AABB(bp, en_box[i]) then
			   if not inv_frame then
			   	lifep = lifep-1
				sfx (28,25,16,2,7,5)
				taking_damage = true
				inv_frame = true
				inv_counter = 0
				mult_score = 1
			   end
			   if lifep < 0 then
				   game_over = true
			   end
		   end
	   end
	end
end

function render_boost()
	local begin_x = 0
	local begin_y = 110
	spr(352,begin_x,begin_y,0,1,0,0,4,1)
	begin_x = begin_x + 35
	num5 = sh_auto_delay % 10;
	num4 = (sh_auto_delay // 10) % 10;
	spr(get_id_number(num4),begin_x, begin_y,0,1,0,0,1,1)
	spr(get_id_number(num5),begin_x+8, begin_y,0,1,0,0,1,1)
	--print("speed: "..tostring(max_speed_x),5,130, 0)
end

function render_speed()
	local begin_x = 0
	local begin_y = 120
	spr(357,begin_x,begin_y,0,1,0,0,4,1)
	begin_x = begin_x + 35
	num = math.floor(max_speed_x)
	dec = (max_speed_x*10)%10
	spr(get_id_number(num),begin_x, begin_y,0,1,0,0,1,1)
	spr(361,begin_x+8, begin_y,0,1,0,0,1,1)
	spr(get_id_number(dec),begin_x+16, begin_y,0,1,0,0,1,1)
	--print("speed: "..tostring(max_speed_x),5,130, 0)
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
cls(9)

if num_goal == 0 or game_win then
	game_win = true
	print("MISSION COMPLETE!",30,60, 12, false, 2)
	print("SCORE: "..tostring(score),70,90, 12, false, 2)
	return
end
if game_over then
	print("GAME OVER",70,60, 12, false, 2)
	return
end

if num_dir == index_goal and not goal_enabled and not payload_enabled then
	if payload_picked then
		goal_pos = {math.random(20, 220), math.random(20, 116)}
		goal_enabled = true
	else
		payload_enabled = true
		payload_pos_1 = {math.random(20, 220), math.random(20, 116)}
		payload_pos_2 = {math.random(20, 220), math.random(20, 116)}

		while (magnitude(payload_pos_2[1]-payload_pos_1[1], payload_pos_2[2]-payload_pos_1[2]) < (radius1+radius2)) do 
			payload_pos_2 = {math.random(20, 220), math.random(20, 116)}
		end

		payload_pos_3 = {math.random(20, 220), math.random(20, 116)}

		while (magnitude(payload_pos_3[1]-payload_pos_1[1], payload_pos_3[2]-payload_pos_1[2]) < (radius1+radius3) or magnitude(payload_pos_3[1]-payload_pos_2[1], payload_pos_3[2]-payload_pos_2[2]) < (radius2+radius3)) do 
			payload_pos_3 = {math.random(20, 220), math.random(20, 116)}
		end
	end
end

render_sky()

--print("life : "..tostring(lifep),84,84, 0)
--print("life : "..tostring(game_over),84,104, 0)
	--print("x, y : "..xmouse..", "..ymouse,84,50)
	--print("angle : "..angle,84,84)
	
	a,b,c,d,e,f,color = compute_sprite(math.pi + angleRad, x, y,10, 12)
	w=(x_max-x_min)/2
	h=(y_max-y_min)/2
	
	margin_col = 5
	square_x = clamp(w-margin_col, 7, 10)
	square_y = clamp(h-margin_col, 7, 10)
	bp = {
 		bx= x_min+margin_col, 
  		by= y_min+margin_col,
  		bw= square_x, 
  		bh= square_y 
 	}
 
 -- input system for the enemy moving
 collision_en_mv()

 -- input system for the enemhy shooting
 collision_en()

 -- update the bullets and render and collision with player
 collision_render_bullet()
 
 collision_jw()
 collision_sp()
 collision_cl()
 collision_tm()
 collision_lf()

 update_inv_frame()
	 
 --rectb(bp.bx, bp.by, bp.bw, bp.bh, 2)
	
	-- obstacles collision
	obstacle_collision()

	a,b,c,d,e,f,color = compute_sprite(math.pi + angleRad, x, y,10, 12)

	x_anim = a
	y_anim = b 
	
	x = x + vx
	y = y + vy
	 
	render_ob()
	render_col_small_gun()
	render_col_big_gun()
 
	render_jw()
	render_sp()
	render_cl()
	render_tm()
	render_lf()
	
 -- render the player
	tri(a,b,c,d,e,f,4)
 
 render_enemies()
 render_enemies_sh()

 wp1_collision()
 wp2_collision()

 render_payload()
 render_goal()

 -- UI DISPLAY

 -- display life
 rect(10,10,lifep//2,5,2)
 
 -- goal
 --print("goal : "..tostring(dir_goal_buffer[index_goal]),200,10)

 if not goal_enabled and not payload_enabled then
 	spr(5,220,10,0,2,0,dir_goal_buffer[index_goal],1,1)
 end

 -- display score
 render_score()
 render_fare_score()
 render_mult_score()
 --print(tostring(score),154,5, 12)
 --print("cooldown: "..tostring(sh_auto_delay),5,120, 0)

 render_anim()
 render_speed()
 render_boost()
 render_payload_txt()
	
 check_render_timer()
 check_render_timer_fare()

end

-- <TILES>
-- 001:eeeeeee0e4444ee0e4eee4e0e4444ee0e4ee4ee0e4eee4e0eeeeeee000000000
-- 002:eeeeeee0e4eee4e0e44e44e0e4e4e4e0e4eee4e0e4eee4e0eeeeeee000000000
-- 003:00ffff000f2222f0f22cc22ff2c22c2ff2c22c2ff22cc22f0f2222f000ffff00
-- 004:700000070606606000555500065cc560065cc560005555000606606070000007
-- 005:00ffff000ff56ff0ff5666fff5f56f6ffff66fff00f56f0000f66f0000ffff00
-- 006:eeeeeee0ee4444e0e4eeeee0ee444ee0eeeee4e0e4444ee0eeeeeee000000000
-- 007:eeeeeee0ee4444e0e4eeeee0e4eeeee0e4eeeee0ee4444e0eeeeeee000000000
-- 008:eeeeeee0e44444e0eee4eee0eee4eee0eee4eee0eee4eee0eeeeeee000000000
-- 009:eeeeeee0e4eeeee0e4eeeee0e4eeeee0e4eeeee0e44444e0eeeeeee000000000
-- 017:0020020000200200002ff2000f2cc2f00fc22cf00fc22cf0f22cc22ff222222f
-- </TILES>

-- <SPRITES>
-- 001:ccf00fccfcf00fcf0fc00cf000000000000000000fc00cf0fcf00fcfccf00fcc
-- 002:00fccf00000ff000f000000fcf0000fccf0000fcf000000f000ff00000fccf00
-- 005:ffffffff0ffccccf0fcfffff0ffcccff0fffffcf0fccccff0fffffff00000000
-- 006:fffffffffccccffccfffffcfcfffffcfcfffffcffccccffcffffffff00000000
-- 007:ffffffffccffccccffcfcfffffcfccccffcfcffcccffcfffffffffff00000000
-- 008:ffffffffffcccccfcfcfffffffcccccfffcfffffcfcccccfffffffff00000000
-- 009:ffffffff00000000000000000000000000000000000000000000000000000000
-- 010:0000000f0000000f0000000f0000000f0000000f0000000f0000000f0000000f
-- 011:00000000000000000000000000000000000000000000000000000000ffffffff
-- 012:f0000000f0000000f0000000f0000000f0000000f0000000f0000000f0000000
-- 013:fffffffffcfffffcfcfffffcfcfffffcfcfffffcfcccccfcffffffff00000000
-- 014:fffffffffcccccfcfcfffffcfcccccfcfcfffffcfcfffffcffffffff00000000
-- 015:fffff000ccccf000fffff000ccccf000fffff000ccccf000fffff00000000000
-- 017:ffffffff0fcfffcf0fccfccf0fcfcfcf0fcfffcf0fcfffcf0fffffff00000000
-- 018:ffffffffcfffcfcfcfffcfcfcfffcfcfcfffcfcffcccffccffffffff00000000
-- 019:ffffffffffffccccffffffcfffffffcfffffffcfcccfffcfffffffff00000000
-- 020:ffff0000cfcf0000ffcf0000ffcf0000ffcf0000ffcf0000ffff000000000000
-- 021:ffffffff0000000f0000000f0000000f0000000f0000000f0000000f00000000
-- 022:ffffffffcccccffccfffffcfcccccfcccfffffcfcfffffcfffffffff00000000
-- 023:ffffffffccffccccffcfcfffcccfccccffcfcffcffcfcfffffffffff00000000
-- 024:ffffffffffcccccfcfcfffffffcccccfffcfffffcfcccccfffffffff00000000
-- 025:0000000000030000000330000033333003333300000330000000300000000000
-- 027:0000000f0000000f0000000f0000000f0000000f0000000f0000000f00000000
-- 029:00000000f0000000f0000000f0000000f0000000f0000000f0000000f0000000
-- 030:00000000ffffffff0000000000000000000000000000000000000000ffffffff
-- 031:000000000000000f0000000f0000000f0000000f0000000f0000000f0000000f
-- 032:00fff0000f666f000f666f000f666f000f666f000f666f000f666f0000fff000
-- 033:fffffffffcccccfcfffcfffcfffcfffcfffcfffcfffcfffcffffffff00000000
-- 034:fffffffffcfffcfcfccfccfcfcfcfcfcfcfffcfcfcfffcfcffffffff00000000
-- 035:ffffffffccccf000fffff000ccccf000fffff000ccccf000fffff00000000000
-- 037:000000000000ffff0000fcff0000fccf0000fcfc0000fcff0000fcff0000ffff
-- 038:00000000fffffffffcffffccccfffcfffcfffcfffcfffcfffcfcffccffffffff
-- 039:00000000ffffffffccfcfffcfffcfffcccfcfffcfcfcfffcccffcccfffffffff
-- 040:00000000fffffff0fcfffcf0fccffcf0fcfcfcf0fcffccf0fcfffcf0fffffff0
-- 041:3000000303033030003003000303303003033030003003000303303030000003
-- 042:ffffffff000000000000000000000000000000000000000000000000ffffffff
-- 043:00000000ffffffffccccccccccccccccccccccccccccccccccccccccffffffff
-- 044:00000000ffffffffaa000000aa000000aa000000aa000000aa000000ffffffff
-- 045:00000000ffffffffaaaa0000aaaa0000aaaa0000aaaa0000aaaa0000ffffffff
-- 046:00000000ffffffffaaaaaa00aaaaaa00aaaaaa00aaaaaa00aaaaaa00ffffffff
-- 047:00000000ffffffffaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaffffffff
-- 048:ffffffffccffccccffcfcfffccffccccfcffcfffffcfccccffffffff00000000
-- 049:ffffffffcf0fccccff0fffcfcf0fffcfff0fffcfcf0fffcfff0fffff00000000
-- 050:ffffffffcfcfcfffffcfccfcffcfcfcfffcfcfffffcfcfffffffffff00000000
-- 051:ffffffffcfcccccfcfcfffffcfcccccfcfcfffffcfcccccfffffffff00000000
-- 053:000000000000ffff0000ffcc0000fcff0000ffcc0000ffff0000fccc0000ffff
-- 054:00000000ffffffffccffffccfffffcffcffffcfffcfffcffcffcffccffffffff
-- 055:00000000ffffffffccfcfffcfffcfffcccfcfffcfcfcfffcccffcccfffffffff
-- 056:00000000fffffff0fcfffcf0fccffcf0fcfcfcf0fcffccf0fcfffcf0fffffff0
-- 057:0003300003000030000000003000000330000003000000000300003000033000
-- 059:00000000ffffffffcccccc00cccccc00cccccc00cccccc00cccccc00ffffffff
-- 060:00000000ffffffff9900000099000000990000009900000099000000ffffffff
-- 061:00000000ffffffff999a000099990000999a000099990000999a0000ffffffff
-- 062:00000000ffffffff999a9a0099999900999a9a0099999900999a9a00ffffffff
-- 063:00000000ffffffff999a9a9a999999a9999a9a9a999999a9999a9a9affffffff
-- 064:fffffffffcccffcccfffcfcfcccccfcccfffcfcfcfffcfcfffffffff00000000
-- 065:f0000000c0000000f0000000c0000000f0000000f0000000f000000000000000
-- 068:0000000000ffffff00fccccf00fcfffc00fccccf00fcffcf00fcfffc00ffffff
-- 069:00000000ffffffffffcccffffcfffcfcfcfffcfcfcfffcfcffcccfffffffffff
-- 070:00000000ffffffffccccfcfffffffcfffffffcccfffffcffccccfcffffffffff
-- 071:00000000fffffffffcfccccccffcfffffffccccccffcfffffcfcccccffffffff
-- 072:00000000fffffff0fcccccf0fffcfff0fffcfff0fffcfff0fffcfff0fffffff0
-- 073:3000000300000000000000000003300000033000000000000000000030000003
-- 075:00000000ffffffffcccc0000cccc0000cccc0000cccc0000cccc0000ffffffff
-- 076:00000000ffffffff8800000088000000880000008800000088000000ffffffff
-- 077:00000000ffffffff8889000088880000888900008888000088890000ffffffff
-- 078:00000000ffffffff8889890088888800888989008888880088898900ffffffff
-- 079:00000000ffffffff8889898988888898888989898888889888898989ffffffff
-- 080:0fffffff0fcccccf0fcfffff0fcccccf0fcfffff0fcfffff0fffffff00000000
-- 086:0000000000ffffff00fccccf00fcfffc00fccccf00fcffcf00fcfffc00ffffff
-- 087:00000000ffffffffffcccffcfcfffcfcfcccccfcfcfffcfcfcfffcfcffffffff
-- 088:00000000fffffff0fcfffff0fcfffff0fcfffff0fcfffff0fcccccf0fffffff0
-- 091:00000000ffffffffcc000000cc000000cc000000cc000000cc000000ffffffff
-- 092:00000000ffffffff7700000077000000770000007700000077000000ffffffff
-- 093:00000000ffffffff7778000077770000777800007777000077780000ffffffff
-- 094:00000000ffffffff7778780077777700777878007777770077787800ffffffff
-- 095:00000000ffffffff7778787877777787777878787777778777787878ffffffff
-- 096:fffffffffccccffffcfffcfcfccccffcfcfffcfcfccccfffffffffff00000000
-- 097:ffffffffcccfffccfffcfcfffffcfcfffffcfcffcccfffccffffffff00000000
-- 098:ffffffffcfffccccfcfcfffffcffcccffcfffffccffcccccffffffff00000000
-- 099:fffffff0fcccccf0fffcfff0fffcfff0fffcfff0fffcfff0fffffff000000000
-- 101:fffffffffffccccfffcffffffffcccffffffffcfffccccffffffffff00000000
-- 102:ffffffffccccffcccfffcfcfccccffcccfffffcfcfffffccffffffff00000000
-- 103:ffffffffcccfccccffffcfffcccfccccffffcfffcccfccccffffffff00000000
-- 104:ffffffffcfccccffffcfffcfcfcfffcfffcfffcfcfccccffffffffff00000000
-- 105:fffffffffffffffffffffffffffffffffffffffffffccffffffccfffffffffff
-- 107:00000000000fffff00fccccc0fccccccfcccccccccccccccccccccccffffffff
-- 108:00000000ffffffff6600000066000000660000006600000066000000ffffffff
-- 109:00000000ffffffff6667000066660000666700006666000066670000ffffffff
-- 110:00000000ffffffff6667670066666600666767006666660066676700ffffffff
-- 111:00000000ffffffff6667676766666676666767676666667666676767ffffffff
-- 112:0000000000000ff00000f00f0000f00f0000f00f0000f00f00000ff000000000
-- 113:0000000000000ff00000f66f0000f66f0000f66f0000f66f00000ff000000000
-- 114:0000000000000ff00000f33f0000f33f0000f33f0000f33f00000ff000000000
-- 115:0000000000000ff00000f22f0000f22f0000f22f0000f22f00000ff000000000
-- 116:0000000000000ff00000f44f0000f44f0000f44f0000f44f00000ff000000000
-- 117:0000000000000ff00000fccf0000fccf0000fccf0000fccf00000ff000000000
-- 123:00000000000fffff00fccc000fcccc00fccccc00cccccc00cccccc00ffffffff
-- 124:00000000ffffffff5500000055000000550000005500000055000000ffffffff
-- 125:00000000ffffffff5556000055550000555600005555000055560000ffffffff
-- 126:00000000ffffffff5556560055555500555656005555550055565600ffffffff
-- 127:00000000ffffffff5556565655555565555656565555556555565656ffffffff
-- 128:000000000ff00ff0f66ff66ff66ff66f0ff00ff0000000000000000000000000
-- 129:000000000ff00ff0f44ff00ff44ff00f0ff00ff0000000000000000000000000
-- 130:000000000ff00ff0f00ff00ff00ff00ff00ff00ff00ff00f0ff00ff000000000
-- 132:000000000000000000000000000000000000c0c000000c000000c0c000000000
-- 133:0000000000440000004400000044000000440000004400000044000000000000
-- 134:0000000000444400000044000044440000444400004400000044440000000000
-- 135:0000000000444400000044000004440000004400000044000044440000000000
-- 136:ffffffffffccffffffccffffffccffffffccffffffccffffffccffffffffffff
-- 137:ffffffffffccccffffffccffffccccffffccccffffccffffffccccffffffffff
-- 138:ffffffffffccccffffffccfffffcccffffffccffffffccffffccccffffffffff
-- 139:000000000ff00ff0f66ff00ff66ff00ff66ff00ff66ff00f0ff00ff000000000
-- 140:00000000ffffffff4400000044000000440000004400000044000000ffffffff
-- 141:00000000ffffffff4445000044440000444500004444000044450000ffffffff
-- 142:00000000ffffffff4445450044444400444545004444440044454500ffffffff
-- 143:00000000ffffffff4445454544444454444545454444445444454545ffffffff
-- 144:000000000ff00ff0f66ff00ff66ff00f0ff00ff0000000000000000000000000
-- 145:000000000ff00ff0f44ff44ff44ff44f0ff00ff0000000000000000000000000
-- 146:000000000ff00ff0f44ff00ff44ff00ff44ff00ff44ff00f0ff00ff000000000
-- 148:0000000000000000000000000000000000004040000004000000404000000000
-- 149:0000000000404400004044000044440000004400000044000000440000000000
-- 150:0000000000444400004400000044440000444400000044000044440000000000
-- 151:0000000000444400004400000044440000440400004404000044440000000000
-- 152:ffffffffffcfccffffcfccffffccccffffffccffffffccffffffccffffffffff
-- 153:ffffffffffccccffffccffffffccccffffccccffffffccffffccccffffffffff
-- 154:ffffffffffccccffffccffffffccccffffccfcffffccfcffffccccffffffffff
-- 155:000000000ff00ff0f66ff00ff66ff00ff66ff00ff66ff00f0ff00ff000000000
-- 156:00000000ffffffff3300000033000000330000003300000033000000ffffffff
-- 157:00000000ffffffff3334000033330000333400003333000033340000ffffffff
-- 158:00000000ffffffff3334340033333300333434003333330033343400ffffffff
-- 159:00000000ffffffff3334343433333343333434343333334333343434ffffffff
-- 160:000000000ff00ff0f33ff33ff33ff33f0ff00ff0000000000000000000000000
-- 162:000000000ff00ff0f44ff44ff44ff44ff44ff44ff44ff44f0ff00ff000000000
-- 164:0000000000000000000000000000000000000c000000ccc000000c0000000000
-- 165:0000000000444400000044000000440000004400000044000000440000000000
-- 166:0000000000444400004044000044440000404400004044000044440000000000
-- 167:0000000000444400004044000044440000004400000044000000440000000000
-- 168:ffffffffffccccffffffccffffffccffffffccffffffccffffffccffffffffff
-- 169:ffffffffffccccffffcfccffffccccffffcfccffffcfccffffccccffffffffff
-- 170:ffffffffffccccffffcfccffffccccffffffccffffffccffffffccffffffffff
-- 171:000000000ff00ff0f66ff00ff66ff00ff66ff00ff66ff00f0ff00ff000000000
-- 172:00000000ffffffff2200000022000000220000002200000022000000ffffffff
-- 173:00000000ffffffff2223000022220000222300002222000022230000ffffffff
-- 174:00000000ffffffff2223230022222200222323002222220022232300ffffffff
-- 175:00000000ffffffff2223232322222232222323232222223222232323ffffffff
-- 176:000000000ff00ff0f33ff00ff33ff00f0ff00ff0000000000000000000000000
-- 178:000000000ff00ff0fccff44ffccff44ffccff44ffccff44f0ff00ff000000000
-- 180:0000000000000000000000000000000000000400000044400000040000000000
-- 181:0000000000444400004044000040440000404400004044000044440000000000
-- 184:ffffffffffccccffffcfccffffcfccffffcfccffffcfccffffccccffffffffff
-- 185:000000000ff00ff0f66ff00ff66ff00ffffffffff66ff00ff66ff00ff66ff00f
-- 186:000000000ff00ff0f00ff66ff00ff66ffffffffff66ff66ff66ff66ff66ff66f
-- 187:00000000000000000000000000000000000000000000000f0000000f0000000f
-- 188:00000000000fffff00f000000f000000f00000000000000000000000ffffffff
-- 189:00000000000fffff00f200000f110000f11200001111000011120000ffffffff
-- 190:00000000000fffff00f212000f111100f11212001111110011121200ffffffff
-- 191:00000000000fffff00f212120f111121f11212121111112111121212ffffffff
-- 192:000000000ff00ff0f22ff22ff22ff22f0ff00ff0000000000000000000000000
-- 194:000000000ff00ff0f44ffccff44ffccff44ffccff44ffccf0ff00ff000000000
-- 195:000000000ff00ff0fccffccffccffccffccffccffccffccf0ff00ff000000000
-- 201:000000000ff00ff0f00ff00ff00ff00ffffffffff66ff00ff66ff00ff66ff00f
-- 202:000000000ff00ff0f66ff00ff66ff00ffffffffff66ff66ff66ff66ff66ff66f
-- 203:00000000f0000000f0000000f0000000f0000000f0000000f000000000000000
-- 204:0000000000000fff00000fcf00000fcf00000fcf00000fcc00000fcfffffffff
-- 205:00000000ffffffffffcfccccffcfcfffcfcfccccfccfcfffffcfcfffffffffff
-- 206:00000000ffffffffffcfffcfcfccffcfffcfcfcfffcffccfffcfffcfffffffff
-- 208:000000000ff00ff0f22ff00ff22ff00f0ff00ff0000000000000000000000000
-- 210:0000000000000000000000000000000000000000000000000000000000000ff0
-- 211:000000000ff00ff0f00ff00ff00ff00ffffffffff00ff00ff00ff00ff00ff00f
-- 215:0000000000000000000000000000000000000000000000000000000000000ff0
-- 216:0000000000000000000000000000000000000000000000000000000000000ff0
-- 217:000000000ff00ff0f66ff00ff66ff00ffffffffff66ff00ff66ff00ff66ff00f
-- 218:000000000ff00ff0f66ff66ff66ff66ffffffffff66ff66ff66ff66ff66ff66f
-- 219:000000000000000000000000fffffff0ffccccf0fcfffff0ffcccff0fffffcf0
-- 220:00000000000000000000000000000000000000000fffffff0f6fff6f0f66f66f
-- 221:00000000000000000000000000000000000000000fffffff0f3fff3f0f33f33f
-- 222:00000000000000000000000000000000000000000fffffff0f2fff2f0f22f22f
-- 223:00000000ffffffffccccccccccccccccccccccccccccccccccccccccffffffff
-- 224:000000000ff00ff0f00ff00ff00ff00f0ff00ff0000000000000000000000000
-- 225:00000000000000000000000000000000000000000000000000000ff00000f00f
-- 226:0000f00f0000f00f0000f00f0ff0f00ff00ff00ff00ff00ff00ff00ff00ff00f
-- 227:f00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00f
-- 229:00000000000000000000000000000000000000000000000000000ff00000f00f
-- 230:00000000000000000000000000000000000000000000000000000ff00000f33f
-- 231:0000f00f0000f00f0000f00f0ff0f00ff33ff00ff33ff00ff33ff00ff33ff00f
-- 232:0000f33f0000f33f0000f33f0ff0f33ff33ff33ff33ff33ff33ff33ff33ff33f
-- 233:f66ff00ff66ff00ff66ff00ff66ff00ff66ff00ff66ff00ff66ff00ff66ff00f
-- 234:f66ff66ff66ff66ff66ff66ff66ff66ff66ff66ff66ff66ff66ff66ff66ff66f
-- 235:fccccff0fffffff0fccccff0fcfffcf0fccccff0fcfffff0fcfffff0fffffff0
-- 236:0f6f6f6f0f6fff6f0f6fff6f0fffffff0ff333ff0f3fff3f0f33333f0f3fff3f
-- 237:0f3f3f3f0f3fff3f0f3fff3f0fffffff0ff222ff0f2fff2f0f22222f0f2fff2f
-- 238:0f2f2f2f0f2fff2f0f2fff2f0fffffff0ff666ff0f6fff6f0f66666f0f6fff6f
-- 239:00000000ffffffffccccccccccccccccccccccccccccccccccccccccffffffff
-- 240:000000000ff00ff0f00ff00ff00ff00ff00ff00ff00ff00ff00ff00f0ff00ff0
-- 241:0ff0f00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00f0ff00ff0
-- 242:f00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00ff00f0ff00ff0
-- 243:000000000ff00ff0f22ff00ff22ff00ff22ff00ff22ff00ff22ff00f0ff00ff0
-- 244:000000000ff00ff0f22ff22ff22ff22ff22ff22ff22ff22ff22ff22f0ff00ff0
-- 245:0ff0f00ff33ff00ff33ff00ff33ff00ff33ff00ff33ff00ff33ff00f0ff00ff0
-- 246:0ff0f33ff33ff33ff33ff33ff33ff33ff33ff33ff33ff33ff33ff33f0ff00ff0
-- 247:f33ff00ff33ff00ff33ff00ff33ff00ff33ff00ff33ff00ff33ff00f0ff00ff0
-- 248:f33ff33ff33ff33ff33ff33ff33ff33ff33ff33ff33ff33ff33ff33f0ff00ff0
-- 249:f66ff00ff66ff00ff66ff00ff66ff00ff66ff00ff66ff00ff66ff00f0ff00ff0
-- 250:f66ff66ff66ff66ff66ff66ff66ff66ff66ff66ff66ff66ff66ff66f0ff00ff0
-- 251:fccccff0fcfffcf0fcfffcf0fcfffcf0fccccff0fffffff00000000000000000
-- 252:0f3fff3f0fffffff0f2fff2f0ff2f2ff0fff2fff0ff2f2ff0f2fff2f0fffffff
-- 253:0f2fff2f0fffffff0f6fff6f0ff6f6ff0fff6fff0ff6f6ff0f6fff6f0fffffff
-- 254:0f6fff6f0fffffff0f3fff3f0ff3f3ff0fff3fff0ff3f3ff0f3fff3f0fffffff
-- 255:00000000ffffffffccccccccccccccccccccccccccccccccccccccccffffffff
-- </SPRITES>

-- <MAP>
-- 000:000000000000000000000000000000000000b0b0b00000b0b0b0b0b0b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 001:bbfbfaf9f8f7f6f5f4f3f2d10000000000a0495900c0a08b88a8898a99c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 002:d0e0f02a2900000000000000000000000000901121314190909050607080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 003:00b0b0b000000000000000000000000000000000000000b0b0b0b0b0b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 004:a088988bc00000000000000000000000000000000000a08b8b9a99998bc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 005:1222329000000000000000000000000000000000000000a2a29051617181000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 006:00000000000000000000000000000000000000000000a0a899c000001700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 007:000000000000000000000000000000000000000000000090900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 012:292800009d3dbd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 013:00006e8e9e3ebe0000000000000000000000000000000000000000282a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 014:4f4f6f8f9f2fbf0000000000000000000000000000000000b0b0b0ccdcec000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 015:0c0c0a0a08090000000000000000000000000000000000a04454647484c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 016:061626361919000000000000000000000000000000000000909090909000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </MAP>

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
-- 021:81e081d081b081a0819081708170715071607170616061605160515041504150414041405130612071109100b100c100e100f100f100f100f100f100000000000e00
-- 022:8be08bd08bb08ba08b908b708b707b607b507b506b406b405b305b304b204b204b204b105b106b107b009b00bb00cb00eb00fb00fb00fb00fb00fb00105000000000
-- 023:8be08bd08bb08ba08b908b708b707b607b507b506b406b405b305b304b204b204b204b105b106b107b009b00bb00cb00eb00fb00fb00fb00fb00fb00105000000000
-- 028:0d07fd750dd7fdf60d26fd150d05fd040d03fd020d01fd00fd00fd00fd00fd00fd00fd00fd00fd00fd00fd00fd00fd00fd00fd00fd00fd00fd00fd00b900000c0700
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
-- 048:0500050005000500057005700570057005c005c005c005c005c005c005c005c0f500f500f500f500f500f500f500f500f500f500f500f500f500f500400000000000
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

