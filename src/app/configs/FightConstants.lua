--
-- Author: rsma
-- Date: 2015-05-22 10:05:55
--
DIRC={
	LEFT=-1,
	RIGHT=1
}
COMBO_ENABLE=true--连击开关
AI_ATTR={
	ACD="AwaitCD", --接近玩家间歇时间
	WCD="WanderCD", --攻击后徘徊时间
	NHATKPRO="NormalHurtAttackProb", --普通怪起身攻击机率
	EHATKPRO="EliteHurtAttackProb", --精英怪起身攻击机率
	BHATKPRO="BossHurtAttackProb", --Boss起身攻击机率
	IMMATKPRO="ImmCanAttackProb",--在攻击范围内无条件攻击的机率
	SPR="SpeedUpRange",--接近时加速的范围(>=200有效)
	HUNTDIST="HuntDist",--追踪时，玩家移动指定范围 后，重新追踪
}
AILV={
	[1]={AwaitCD=6,HuntDist=300,SpeedUpRange=-1,ImmCanAttackProb=0.2,NormalHurtAttackProb=0.2,EliteHurtAttackProb=0.2,BossHurtAttackProb=0.3},
	[2]={AwaitCD=5,HuntDist=300,SpeedUpRange=-1,ImmCanAttackProb=0.3,NormalHurtAttackProb=0.3,EliteHurtAttackProb=0.3,BossHurtAttackProb=0.5},
	[3]={AwaitCD=3,HuntDist=300,SpeedUpRange=250,ImmCanAttackProb=0.5,NormalHurtAttackProb=0.5,EliteHurtAttackProb=0.5,BossHurtAttackProb=0.8},
	[4]={AwaitCD=2,HuntDist=200,SpeedUpRange=300,ImmCanAttackProb=0.7,NormalHurtAttackProb=0.7,EliteHurtAttackProb=0.7,BossHurtAttackProb=1},
	[5]={AwaitCD=1,HuntDist=100,SpeedUpRange=300,ImmCanAttackProb=0.9,NormalHurtAttackProb=0.9,EliteHurtAttackProb=0.9,BossHurtAttackProb=1},
}
--纵向最大有效攻击范围
MAX_VALID_ATTACK_DIST=50

HURT_POS={
	run={offX=0,offY=0.8},
	stand={offX=0,offY=0.8},
	attack={offX=0,offY=0.8},

	hurtBack1={offX=0.1,offY=0.8},
	hurtBack2={offX=0.1,offY=0.6},

	hurtBounceUp1={offX=0.2,offY=0.8},
	hurtBounceUp2={offX=0.2,offY=0.8},
	hurtFallDown={x=0,y=0},
	dead={x=0,y=0},
}
--人物动作配置
ROLE_ACTION={
	stand="zhanli",
	run="pao",
	walk="zou",
	attack="gongji",
	attack1="gongji1",
	attack1="gongji1",
	attack2="gongji2",
	attack3="gongji3",
	attack4="gongji4",
	attack5="gongji5",
	skill1 = "jineng1",
	skill2 = "jineng2",
	skill3 = "jineng3",
	skill4 = "jineng4",
	hurtBack1 = "A_attack_back1",
	hurtBack2 = "A_attack_back2",
	hurtVFly1 = "A_fly_vertical",
	hurtBounceUp1 = "fukong1",
	hurtBounceUp2 = "fukong2",
	hurtBounceUp3 = "fukong3",
	hurtBounceUp4 = "fukong4",
	hurtFallDown = "daodi",
	dead = "siwang",
	standup = "qishen",
	xianjie = "xianjie",
}
--shape
--type: Circle,r=50,x,y
--type: Box ,w,h,x,y
--module with-hurt,exclusive
ACTION_SHAPE={
	gongji = {
		E_attack_gun ={shape={type="Box",w=300,h=50,x=0,y=50}, hurtProp={effect="hurtBack", action="hurtBack1", action2="hurtBack2", effectName="HEF4", pause=1, fx=0, frames=2}},
		E_attack_gun2 ={shape={type="Box",w=400,h=50,x=350,y=50}, hurtProp={effect="hurtBack", action="hurtBack1", action2="hurtBack2", effectName="HEF4", pause=1, fx=0, frames=2}},
		-- E_attack_gun2 ={shape={type="Box",w=150,h=50,x=150,y=50}, hurtProp={effect="hurtBack", action="hurtBack1", action2="hurtBack2", effectName="HEF4", pause=1, fx=0, frames=2}},
		E_attack_10103 = {shape={type="Box",w=100,h=50,x=0,y=50},attackProp={effect="forward", fx=100, frames=1}, hurtProp={effect="hurtBack", action="hurtBack1", action2="hurtBack2", effectName="HEF4", pause=1, fx=0, frames=2}},
		a_1 = {shape={type="Box",w=100,h=50,x=0,y=50}, hurtProp={effect="hurtBack", action="hurtBack1", action2="hurtBack2", effectName="HEF4", pause=1, fx=0, frames=2}},
		E_attack_back = {shape={type="Box",w=100,h=50,x=0,y=50},attackProp={effect="forward", fx=15, frames=2},hurtProp={effect="hurtBack", action="hurtBack1", effectName="HEF4", pause=1, fx=5, fy=160, frames=2}},
	},
	gongji1 = {
		move = {shape={type="Box",w=0,h=0,x=0,y=0},attackProp={effect="moveToPlayer", fx=200, frames=4}},
		E_attack_back = {shape={type="Box",w=100,h=50,x=0,y=50},attackProp={effect="forward", fx=15, frames=2},hurtProp={effect="hurtBack", action="hurtBack1", effectName="HEF4", pause=1, fx=5, fy=160, frames=2}},
		[ACTION_TYPE.LUOFEI]={
			--luosir
			E_attack_back = {shape={type="Box",w=150,h=200,x=0,y=100},attackProp={effect="forward", fx=10, frames=2},hurtProp={effect="hurtBack", action="hurtBack1", effectName="HEF1", pause=1, fx=10, fy=20, frames=2}},
		},
		[ACTION_TYPE.GONGJI10001]={
			--luosir
			E_attack_back = {shape={type="Box",w=150,h=200,x=0,y=100},attackProp={effect="forward", fx=10, frames=2},hurtProp={effect="hurtBack", action="hurtBack1", effectName="HEF1", pause=1, fx=5, fy=160, frames=2}},
		},
		[ACTION_TYPE.JIANYUN]={
			--jianyun
			E_attack_back = {shape={type="Box",w=260,h=200,x=0,y=100},attackProp={effect="forward", fx=10, frames=2},hurtProp={effect="hurtBack", action="hurtBack1", effectName="HEF2", pause=1, fx=15, frames=2}},
		},
		[ACTION_TYPE.GONGJI10002]={
			--jianyun
			E_attack_back = {shape={type="Box",w=260,h=200,x=0,y=100},attackProp={effect="forward", fx=10, frames=2},hurtProp={effect="hurtBack", action="hurtBack1", effectName="HEF2", pause=1, fx=15, frames=2}},
		},
		[ACTION_TYPE.DARKER]={
			--darker
			E_attack_back1 = {shape={type="Box",w=260,h=200,x=0,y=100},attackProp={effect="forward", fx=30, frames=1},hurtProp={effect="hurtBack", action="hurtBack1", action2="hurtBack2", effectName="HEF3", pause=1, fx=5, fy=160, frames=2,IgFH=1}},
			E_attack_back = {shape={type="Box",w=260,h=200,x=0,y=100},hurtProp={effect="hurtBack", action="hurtBack1", action2="hurtBack2", effectName="HEF3", pause=1, fx=5, fy=160, frames=2}},
		},
		[ACTION_TYPE.GONGJI10003]={
			--darker
			E_attack_back1 = {shape={type="Box",w=260,h=200,x=0,y=100},attackProp={effect="forward", fx=30, frames=1},hurtProp={effect="hurtBack", action="hurtBack1", action2="hurtBack2", effectName="HEF3", pause=1, fx=5, fy=160, frames=2,IgFH=1}},
			E_attack_back = {shape={type="Box",w=260,h=200,x=0,y=100},hurtProp={effect="hurtBack", action="hurtBack1", action2="hurtBack2", effectName="HEF3", pause=1, fx=5, fy=160, frames=2}},
		},
		[ACTION_TYPE.GONGJI103013]={
			E_attack_back = {shape={type="Box",w=400,h=50,x=0,y=50},attackProp={effect="forward", fx=15, frames=2},hurtProp={effect="hurtBack", action="hurtBack1", effectName="HEF4", pause=1, fx=5, fy=160, frames=2}},
			E_fly_horizontal = {shape={type="Box",w=400,h=300,x=0,y=150},hurtProp={effect="hurtBounceOff", action="hurtBack2", action2="hurtBack1", effectName="HEF3", pause=1, fx=60,fy=130, frames=2}},
		},
		[ACTION_TYPE.GONGJI102014]={
			E_attack_back = {shape={type="Box",w=300,h=50,x=0,y=50},attackProp={effect="forward", fx=15, frames=2},hurtProp={effect="hurtBack", action="hurtBack1", effectName="HEF4", pause=1, fx=5, fy=160, frames=2}},
		},
	},
	gongji_1 = {
		[ACTION_TYPE.GONGJI10205]={
			E_attack_back = {shape={type="Box",w=100,h=50,x=0,y=50},attackProp={effect="forward", fx=15, frames=2},hurtProp={effect="hurtBack", action="hurtBack1", effectName="HEF4", pause=1, fx=5, fy=160, frames=2}},
			E_fly_horizontal = {shape={type="Box",w=50,h=50,x=0,y=50},hurtProp={effect="hurtBounceOff", action="hurtBack2", action2="hurtBack1", effectName="HEF3", pause=1, fx=150,fy=130, frames=2}},
		},
		[ACTION_TYPE.GONGJI102012]={
			E_attack_back = {shape={type="Box",w=100,h=50,x=0,y=50},attackProp={effect="forward", fx=15, frames=2},hurtProp={effect="hurtBack", action="hurtBack1", effectName="HEF4", pause=1, fx=5, fy=160, frames=2}},
		},
	},
	gongji_2 = {
		[ACTION_TYPE.GONGJI102012]={
			E_attack_back = {shape={type="Box",w=100,h=50,x=0,y=50},attackProp={effect="forward", fx=15, frames=2},hurtProp={effect="hurtBack", action="hurtBack1", effectName="HEF4", pause=1, fx=5, fy=160, frames=2}},
		},
	},
	gongji_3 = {
		[ACTION_TYPE.GONGJI10207]={
			E_fly_horizontal = {shape={type="Box",w=100,h=50,x=0,y=50},hurtProp={effect="hurtBounceOff", action="hurtBack2", action2="hurtBack1", effectName="HEF4", pause=1, fx=150,fy=130, frames=2}},
		},
		[ACTION_TYPE.GONGJI102012]={
			E_fly_vertical = {shape={type="Box",w=500,h=250,x=-250,y=100},hurtProp={effect="hurtBounceUp", action="hurtBounceUp2", effectName="HEF4", pause=1, fx=1, fy=160, frames=9}},
		},
	},
	gongji_4 = {
		[ACTION_TYPE.GONGJI102012]={
			E_fly_horizontal = {shape={type="Box",w=500,h=350,x=-290,y=150},hurtProp={effect="hurtFallDown", action="hurtBounceUp2", effectName="HEF1", pause=1, fx=150,fy=1, frames=2, pause=1, pauseFrame=3}},
		},
	},
	gongji1_3 = {
		[ACTION_TYPE.GONGJI10304]={
			E_attack_back = {shape={type="Box",w=100,h=200,x=0,y=100},attackProp={effect="forward", fx=15, frames=2},hurtProp={effect="hurtBack", action="hurtBack1", effectName="HEF4", pause=1, fx=20, fy=160, frames=2}},
		},
		[ACTION_TYPE.GONGJI10309]={
			E_attack_back = {shape={type="Box",w=500,h=50,x=0,y=50},hurtProp={effect="hurtBack", action="hurtBack1", effectName="HEF4", pause=1, fx=5, fy=160, frames=2}},
		},
		[ACTION_TYPE.GONGJI103010]={
			E_fly_horizontal = {shape={type="Box",w=10,h=50,x=0,y=50},hurtProp={effect="hurtBounceOff", action="hurtBack2", action2="hurtBack1", effectName="HEF3", pause=1, fx=150,fy=130, frames=2}},
		},
		[ACTION_TYPE.GONGJI103011]={
			xue1 = {shape={type="Box",w=100,h=50,x=0,y=50},attackProp={effect="forward", fx=15, frames=2},hurtProp={effect="hurtBack", action="hurtBack1", effectName="HEF4", pause=1, fx=5, fy=160, frames=2}},
		},
	},
	gongji2_2 = {
		[ACTION_TYPE.GONGJI10206]={
			E_fly_horizontal = {shape={type="Box",w=50,h=50,x=0,y=50},hurtProp={effect="hurtBounceOff", action="hurtBack2", action2="hurtBack1", effectName="HEF3", pause=1, fx=150,fy=130, frames=2}},
		},
		[ACTION_TYPE.GONGJI10207]={
			move = {shape={type="Box",w=0,h=0,x=0,y=0},attackProp={effect="moveToPlayer", fx=200, frames=6}},
			E_fly_horizontal = {shape={type="Box",w=100,h=50,x=0,y=50},hurtProp={effect="hurtBounceOff", action="hurtBack2", action2="hurtBack1", effectName="HEF3", pause=1, fx=150,fy=130, frames=2}},
		},
		[ACTION_TYPE.GONGJI10205]={
			move = {shape={type="Box",w=0,h=0,x=0,y=0},attackProp={effect="moveToPlayer", fx=200, frames=6}},
			E_fly_horizontal = {shape={type="Box",w=50,h=50,x=0,y=50},hurtProp={effect="hurtBounceOff", action="hurtBack2", action2="hurtBack1", effectName="HEF3", pause=1, fx=150,fy=130, frames=2}},
		},
	},
	gongji2_3 = {
		[ACTION_TYPE.GONGJI10304]={
			E_shake_fly = {shape={type="Circle",r=150,x=0,y=0},attackProp={atkDist=300,effect="groundShake",target="ALL"}, hurtProp={effect="hurtBounceOff", action="hurtBack1", action2="hurtBack2", effectName="HEF4", pause=1, fx=30,fy=160, frames=2}},
			move = {shape={type="Box",w=0,h=0,x=0,y=0},attackProp={effect="moveToPlayer", fx=200, frames=5}},
		},
		[ACTION_TYPE.GONGJI10309]={
			E_attack_back = {shape={type="Box",w=100,h=50,x=0,y=50},attackProp={effect="forward", fx=15, frames=2},hurtProp={effect="hurtBack", action="hurtBack1", effectName="HEF4", pause=1, fx=5, fy=160, frames=2}},
		},
		[ACTION_TYPE.GONGJI103010]={
			move = {shape={type="Box",w=0,h=0,x=0,y=0},attackProp={effect="moveToPlayer", fx=200, frames=4}},
			E_attack_back = {shape={type="Box",w=10,h=50,x=0,y=50},hurtProp={effect="hurtBounceOff", action="hurtBack2", action2="hurtBack1", effectName="HEF3", pause=1, fx=150,fy=130, frames=2}},
		},
		[ACTION_TYPE.GONGJI103011]={
			xue2 = {shape={type="Box",w=100,h=50,x=0,y=50},attackProp={effect="forward", fx=15, frames=2},hurtProp={effect="hurtBack", action="hurtBack1", effectName="HEF4", pause=1, fx=5, fy=160, frames=2}},
		},
	},
	gongji2 = {
		move = {shape={type="Box",w=0,h=0,x=0,y=0},attackProp={effect="moveToPlayer", fx=200, frames=4}},
		E_attack_back = {shape={type="Box",w=100,h=50,x=0,y=50},attackProp={effect="forward", fx=15, frames=2},hurtProp={effect="hurtBack", action="hurtBack1", effectName="HEF4", pause=1, fx=5, fy=160, frames=2}},
		E_shake_fly = {shape={type="Box",w=300,h=150,x=0,y=50},attackProp={effect="groundShake",target="ALL"}, hurtProp={effect="hurtBounceOff", action="hurtBack1", action2="hurtBack2", effectName="HEF4", pause=1, fx=60,fy=40, frames=2}},
		[ACTION_TYPE.LUOFEI]={
			--luosir
			E_attack_back = {shape={type="Box",w=120,h=200,x=0,y=100},attackProp={effect="forward", fx=20, frames=2},hurtProp={effect="hurtBack", action="hurtBack2", effectName="HEF1", pause=1, fx=20, fy=20, frames=2}},
			E_shake_fly = {shape={type="Box",w=200,h=200,x=0,y=100},attackProp={effect="groundShake",target="ALL"}, hurtProp={effect="hurtBounceOff", action="hurtBack1", action2="hurtBack2", effectName="HEF1", pause=1, fx=60,fy=40, frames=2}},
		},
		[ACTION_TYPE.GONGJI10001]={
			--luosir
			E_attack_back = {shape={type="Box",w=120,h=150,x=0,y=50},attackProp={effect="forward", fx=20, frames=2},hurtProp={effect="hurtBack", action="hurtBack2", effectName="HEF1", pause=1, fx=10, fy=160, frames=2}},
			E_shake_fly = {shape={type="Box",w=200,h=150,x=0,y=50},attackProp={effect="groundShake",target="ALL"}, hurtProp={effect="hurtBounceOff", action="hurtBack1", action2="hurtBack2", effectName="HEF1", pause=1, fx=60,fy=40, frames=2}},
		},
		[ACTION_TYPE.JIANYUN]={
			--jianyun
			E_attack_back = {shape={type="Box",w=288,h=200,x=0,y=100},attackProp={effect="forward", fx=20, frames=2},hurtProp={effect="hurtBack", action="hurtBack2", effectName="HEF2", pause=1, fx=20, frames=2,IgFH=1}},
		},
		[ACTION_TYPE.GONGJI10002]={
			--jianyun
			E_attack_back = {shape={type="Box",w=288,h=200,x=0,y=100},attackProp={effect="forward", fx=20, frames=2},hurtProp={effect="hurtBack", action="hurtBack2", effectName="HEF2", pause=1, fx=20, frames=2,IgFH=1}},
		},
		[ACTION_TYPE.DARKER]={
			--darker
			E_attack_back = {shape={type="Box",w=330,h=260,x=0,y=130},attackProp={effect="forward", fx=15, frames=2},hurtProp={effect="hurtBack", action="hurtBack1", action2="hurtBack2", effectName="HEF3", pause=1, fx=5, fy=160, frames=2,IgFH=1}},
		},
		[ACTION_TYPE.GONGJI10003]={
			--darker
			E_attack_back = {shape={type="Box",w=330,h=260,x=0,y=130},attackProp={effect="forward", fx=15, frames=2},hurtProp={effect="hurtBack", action="hurtBack1", action2="hurtBack2", effectName="HEF3", pause=1, fx=5, fy=160, frames=2,IgFH=1}},
		},
		[ACTION_TYPE.GONGJI103013]={
			E_fly_horizontal = {shape={type="Box",w=200,h=300,x=0,y=150},hurtProp={effect="hurtBounceOff", action="hurtBack2", action2="hurtBack1", effectName="HEF3", pause=1, fx=10,fy=130, frames=9}},
		},
		[ACTION_TYPE.GONGJI102014]={
			E_fly_vertical = {shape={type="Box",w=300,h=50,x=0,y=50},attackProp={effect="forward", fx=15, frames=2},hurtProp={effect="hurtBounceOff", action="hurtBack1", effectName="HEF4", pause=1, fx=30, fy=130, frames=2}},
		},
	},
	gongji3 = {
		[ACTION_TYPE.LUOFEI]={
			--luosir
			E_attack_back = {shape={type="Box",w=150,h=300,x=0,y=150},attackProp={effect="forward", fx=25, frames=2},hurtProp={effect="hurtBack", action="hurtBack1", action2="hurtBack2", effectName="HEF1", pause=1, fx=25, fy=20, frames=2}},
		},
		[ACTION_TYPE.GONGJI10001]={
			--luosir
			E_attack_back = {shape={type="Box",w=150,h=300,x=0,y=150},attackProp={effect="forward", fx=25, frames=2},hurtProp={effect="hurtBack", action="hurtBack1", action2="hurtBack2", effectName="HEF1", pause=1, fx=25, fy=160, frames=2}},
		},
		[ACTION_TYPE.JIANYUN]={
			--jianyun
			E_attack_back = {shape={type="Box",w=260,h=200,x=0,y=100},attackProp={effect="forward", fx=25, frames=2},hurtProp={effect="hurtBack", action="hurtBack1", action2="hurtBack2", effectName="HEF2", pause=1, fx=25, frames=2,IgFH=1}},
		},
		[ACTION_TYPE.GONGJI10002]={
			--jianyun
			E_attack_back = {shape={type="Box",w=260,h=200,x=0,y=100},attackProp={effect="forward", fx=25, frames=2},hurtProp={effect="hurtBack", action="hurtBack1", action2="hurtBack2", effectName="HEF2", pause=1, fx=25, frames=2}},
		},
		[ACTION_TYPE.DARKER]={
			--darker
			E_attack_back = {shape={type="Box",w=220,h=200,x=0,y=100},hurtProp={effect="hurtBack", action="hurtBack1", action2="hurtBack2", effectName="HEF3", pause=1, fx=5, fy=160, frames=2}},
			E_fly_horizontal = {shape={type="Circle",r=300,x=0,y=0},hurtProp={effect="hurtBounceOff", action="hurtBack2", action2="hurtBack1", effectName="HEF3", pause=1, fx=(COMBO_ENABLE==false and 120 or 60),fy=160, frames=2,IgFH=1}},
		},
		[ACTION_TYPE.GONGJI10003]={
			--darker
			E_attack_back = {shape={type="Box",w=220,h=200,x=0,y=100},hurtProp={effect="hurtBack", action="hurtBack1", action2="hurtBack2", effectName="HEF3", pause=1, fx=5, fy=160, frames=2}},
			E_fly_horizontal = {shape={type="Circle",r=300,x=0,y=0},hurtProp={effect="hurtBounceOff", action="hurtBack2", action2="hurtBack1", effectName="HEF3", pause=1, fx=150,fy=130, frames=2,IgFH=1}},
		},
		[ACTION_TYPE.GONGJI103013]={
			E_fly_vertical = {shape={type="Box",w=900,h=300,x=0,y=150},hurtProp={effect="hurtBounceUp", action="hurtBounceUp2", effectName="HEF4", pause=1, fx=1,fy=50, frames=2}},
			E_fly_horizontal = {shape={type="Box",w=900,h=300,x=0,y=150},hurtProp={effect="hurtBounceUp", action="hurtBounceUp2", effectName="HEF3", pause=1, fx=30,fy=60, frames=2}},
		},
		[ACTION_TYPE.GONGJI102014]={
			E_fly_horizontal = {shape={type="Box",w=300,h=50,x=0,y=50},attackProp={effect="forward", fx=150, frames=2},hurtProp={effect="hurtBounceOff", action="hurtBack1", effectName="HEF4", pause=1, fx=30, fy=130, frames=2}},
		},
	},
	gongji3_3 = {
		[ACTION_TYPE.GONGJI103011]={
			xue3={shape={type="Box",w=500,h=50,x=-250,y=50},hurtProp={effect="hurtBounceUp", action="hurtBack1", effectName="HEF4", pause=1, fx=5, fy=150, frames=2}},
		},
	},
	gongji3_4 = {
		[ACTION_TYPE.GONGJI103011]={
			xue4 = {shape={type="Box",w=500,h=250,x=-250,y=100},hurtProp={effect="hurtBounceUp", action="hurtBounceUp2", effectName="HEF4", pause=1, fx=1, fy=60, frames=1}},
			xue5 = {shape={type="Box",w=500,h=250,x=-250,y=100},hurtProp={effect="hurtBounceUp", action="hurtBounceUp2", effectName="HEF4", pause=1, fx=1, fy=60, frames=1}},
			xue6 = {shape={type="Box",w=500,h=350,x=-290,y=150},hurtProp={effect="hurtFallDown", action="hurtBounceUp2", effectName="HEF1", pause=1, fx=150,fy=1, frames=2, pause=1, pauseFrame=3}},
		},
	},
	gongji4 = {
		[ACTION_TYPE.LUOFEI]={
			--luosir
			E_fly_horizontal = {shape={type="Box",w=300,h=220,x=0,y=110},attackProp={effect="forward", fx=40, frames=2},hurtProp={effect="hurtBounceOff", action="hurtBack2", effectName="HEF1", pause=1, fx=(COMBO_ENABLE==false and 120 or 60),fy=(COMBO_ENABLE==false and 130 or 160), frames=2,IgFH=1}},
		},
		[ACTION_TYPE.GONGJI10001]={
			--luosir
			E_fly_horizontal = {shape={type="Box",w=300,h=220,x=0,y=110},attackProp={effect="forward", fx=40, frames=2},hurtProp={effect="hurtBounceOff", action="hurtBack2", effectName="HEF1", pause=1, fx=(COMBO_ENABLE==false and 120 or 60),fy=(COMBO_ENABLE==false and 130 or 160), frames=2,IgFH=1}},
		},
		[ACTION_TYPE.JIANYUN]={
			--jianyun
			-- E_fly_horizontal1 = {shape={type="Box",w=200,h=50,x=0,y=50},   hurtProp={effect="hurtBounceUp", frames=1, action="hurtBounceUp2",effectName="hurt1", fx=10, fy=160}},
			-- E_fly_horizontal2 = {shape={type="Box",w=200,h=250,x=0,y=100}, hurtProp={effect="hurtFallDown", action="hurtBounceUp2", effectName="hurt1",fx=150,fy=0, pause=1}},
			E_fly_horizontal1 = {shape={type="Box",w=450,h=250,x=-200,y=125},attackProp={effect="forward", fx=40, frames=2},hurtProp={effect="hurtBounceOff", action="hurtBack2", action2="hurtBack1", effectName="HEF2", pause=1, fx=(COMBO_ENABLE==false and 120 or 60),fy=(COMBO_ENABLE==false and 130 or 160), frames=2,IgFH=1}},
			E_fly_horizontal2 = {shape={type="Box",w=450,h=250,x=-200,y=125},attackProp={effect="forward", fx=40, frames=2},hurtProp={effect="hurtBounceOff", action="hurtBack2", action2="hurtBack1", effectName="HEF2", pause=1, fx=(COMBO_ENABLE==false and 120 or 60),fy=(COMBO_ENABLE==false and 130 or 160), frames=2,IgFH=1}},
		},
		[ACTION_TYPE.GONGJI10002]={
			--jianyun
			-- E_fly_horizontal1 = {shape={type="Box",w=200,h=50,x=0,y=50},   hurtProp={effect="hurtBounceUp", frames=1, action="hurtBounceUp2",effectName="hurt1", fx=10, fy=160}},
			-- E_fly_horizontal2 = {shape={type="Box",w=200,h=250,x=0,y=100}, hurtProp={effect="hurtFallDown", action="hurtBounceUp2", effectName="hurt1",fx=150,fy=0, pause=1}},
			E_fly_horizontal2 = {shape={type="Box",w=500,h=250,x=-250,y=125},attackProp={effect="forward", fx=40, frames=2},hurtProp={effect="hurtBounceOff", action="hurtBack2", action2="hurtBack1", effectName="HEF2", pause=1, fx=(COMBO_ENABLE==false and 120 or 60),fy=(COMBO_ENABLE==false and 130 or 160), frames=2}},
		},
		[ACTION_TYPE.GONGJI103013]={
			E_fly_vertical = {shape={type="Box",w=900,h=300,x=0,y=150},hurtProp={effect="hurtBounceUp", action="hurtBounceUp2", effectName="HEF4", pause=1, fx=1,fy=50, frames=2}},
			-- E_fly_horizontal = {shape={type="Box",w=900,h=300,x=0,y=150},hurtProp={effect="hurtBounceUp", action="hurtBounceUp2", effectName="HEF3", pause=1, fx=30,fy=60, frames=2}},
		},
	},
	skill2 = {
		jineng1 = {
			E_attack_back   = {shape={type="Circle",r=200,x=0,y=0}, attackProp={effect="groundShake",target="ALL"},hurtProp={effect="hurtBounceUp", frames=3, action="hurtBack1", effectName="HEF1",fx=0,fy=200, pause=1, pauseFrame=10,sound="90024.mp3",IgFH=1}},
			E_attack_stick  = {shape={type="Circle",r=230,x=0,y=300},hurtProp={effect="hurtBounceUp", frames=2, action="hurtBounceUp2", effectName="HEF1", fx=1,fy=60, pause=1, pauseFrame=1,IgFH=1}},
			E_attack_stick2 = {shape={type="Circle",r=230,x=0,y=260},hurtProp={effect="hurtBounceUp", frames=2, action="hurtBounceUp2", effectName="HEF1", fx=1,fy=-100, pause=1, pauseFrame=1,IgFH=1}},
			E_shake_fly     = {shape={type="Circle",r=230,x=0,y=300},attackProp={effect="groundShake",target="ALL"},hurtProp={effect="hurtFallDown",action="hurtBounceUp2", effectName="HEF1",fx=30,fy=0, pauseFrame=5,pause=1,sound="90024.mp3",IgFH=1}},
		},
	},
	skill1 = {
		jineng2 = {
			E_attack_stick1= {shape={type="Box",w=120,h=260,x=0,y=130},attackProp={effect="forward", fx=120, frames=8, pause=1},hurtProp={effect="hurtBounceUp", frames=6, action="hurtBack1",effectName="HEF1", fx=120, fy=90,sound="90024.mp3"}},
			E_attack_stick = {shape={type="Box",w=200,h=260,x=0,y=130},attackProp={effect="forward", fx=120, frames=8, pause=1},hurtProp={effect="hurtBounceUp", frames=6, action="hurtBounceUp2",effectName="HEF1", fx=120, fy=60, pause=1, pauseFrame=1}},
			-- E_attack_stick = {shape={type="Box",w=120,h=50,x=120,y=160},attackProp={effect="forward", fx=40, frames=16, pause=1},hurtProp={effect="hurtBack", action="hurtBack1", effectName="hurt1", pause=1, fx=40,fy=10, frames=3}},
			E_shake_fly    = {shape={type="Box",w=220,h=260,x=0,y=130},attackProp={effect="forward", fx=50, frames=6, pause=1},hurtProp={effect="hurtFallDown",action="hurtBounceUp2",effectName="HEF1", fx=150,fy=0, pause=1, pauseFrame=1,sound="90024.mp3"}},
		},
	},
	skill3 = {
		jineng3_1 = {
			E_attack_stick={shape={type="Box",w=120,h=200,x=0,y=100},hurtProp={effect="hurtBack", action="hurtBack1", action2="hurtBack2", effectName="HEF1", pause=1, fx=3, frames=2, pause=1, pauseFrame=1}},
		},
		jineng3_2 = {
			E_fly_bounce={shape={type="Box",w=400,h=200,x=0,y=100},hurtProp={effect="hurtBounceOff", action="hurtBack1", effectName="HEF1", pause=1, fx=60,fy=100, frames=2, pause=1, pauseFrame=3,IgFH=1}},
		},
	},
	skill4 = {
		jineng4_1 = {
			--luosir
			E_attack_back = {shape={type="Box",w=100,h=200,x=0,y=100},attackProp={effect="forward", fx=15, frames=2},hurtProp={effect="hurtBack", action="hurtBack1", effectName="HEF1", pause=1, fx=15, frames=2,sound="90024.mp3"}},
		},
		jineng4_2 = {
			--luosir
			E_attack_back = {shape={type="Box",w=150,h=200,x=0,y=100},attackProp={effect="forward", fx=15, frames=2},hurtProp={effect="hurtBack", action="hurtBack2", effectName="HEF1", pause=1, fx=15, frames=2}},
		},
		jineng4_3 = {
			--luosir
			E_attack_back = {shape={type="Box",w=160,h=300,x=0,y=150},attackProp={effect="forward", fx=15, frames=2},hurtProp={effect="hurtBack", action="hurtBack1", effectName="HEF1", pause=1, fx=15, frames=2,sound="90024.mp3"}},
		},
		jineng4_4 = {
			--luosir
			E_attack_back = {shape={type="Box",w=150,h=260,x=0,y=130},attackProp={effect="forward", fx=15, frames=2},hurtProp={effect="hurtBack", action="hurtBack2", effectName="HEF1", pause=1, fx=15, frames=2,IgFH=1}},
		},
		jineng4_5 = {
			--luosir
			E_attack_stick = {shape={type="Box",w=160,h=240,x=0,y=120},attackProp={effect="forward", fx=15, frames=2},hurtProp={effect="hurtBack", action="hurtBack1", action2="hurtBack2", effectName="HEF1", pause=1, fx=15, frames=2,IgFH=1}},
			-- E_attack_stick = {shape={type="Box",w=100,h=50,x=0,y=50},attackProp={effect="forward", fx=15, frames=2},hurtProp={effect="hurtBack", action="hurtBack1", effectName="hurt1", pause=1, fx=15, frames=2}},
		},
		jineng4_ = {
			E_attack_back  = {shape={type="Box",w=120,h=320,x=0,y=160},attackProp={effect="forward", fx=15, frames=2},hurtProp={effect="hurtBack", action="hurtBack1", action2="hurtBack2", effectName="HEF1", pause=1, fx=15, frames=2,sound="90024.mp3"}},
			E_shake_fly    = {shape={type="Box",w=120,h=320,x=0,y=160},attackProp={effect="groundShake",target="ALL"},hurtProp={effect="hartDown",action="hurtBack1", effectName="HEF1",fx=20,fy=120, pause=1, frames=5}},
			E_attack_stick = {shape={type="Box",w=200,h=300,x=0,y=150},attackProp={effect="forward", fx=15, frames=2},hurtProp={effect="hartDown", effectName="HEF1", fx=20,fy=30, frames=2,IgFH=1}, sound={attack="900226.mp3"}},
			E_shake_fly1   = {shape={type="Circle",r=200,x=0,y=0},attackProp={effect="groundShake",target="ALL"},hurtProp={effect="hurtBounceOff",action="hurtBounceUp2", effectName="HEF1",fx=150,fy=100, pause=1, pauseFrame=10,sound="90024.mp3",IgFH=1}, sound={attack="900233.mp3"}},
		},
	},
	skill5 = {
		jineng1_2 = {
			E_attack_stick1= {shape={type="Box",w=200,h=200,x=0,y=100},hurtProp={effect="hurtBounceUp", frames=3, action="hurtBack1",effectName="HEF2", fx=120, fy=60, sound="900224.mp3"}},
			E_attack_stick = {shape={type="Box",w=200,h=200,x=0,y=100},hurtProp={effect="hurtBounceUp", frames=3, action="hurtBounceUp2",effectName="HEF2", fx=120, fy=60, pause=1, pauseFrame=1}},
			E_fly_horizontal = {shape={type="Box",w=200,h=200,x=0,y=100},hurtProp={effect="hurtBounceOff", action="hurtBack2", action2="hurtBack1", effectName="HEF2", pause=1, fx=150,fy=130, frames=2, sound="900224.mp3"}},
		},
	},
	skill6 = {
		jineng2 = {
			E_attack_back1 = {shape={type="Box",w=120,h=200,x=0,y=100},hurtProp={effect="hurtBack", action="hurtBack1", action2="hurtBack2", effectName="HEF2", pause=1, fx=60, frames=2, sound="900224.mp3",IgFH=1}},
			E_attack_back2 = {shape={type="Box",w=300,h=200,x=0,y=100},hurtProp={effect="hurtBack", action="hurtBack1", action2="hurtBack2", effectName="HEF2", pause=1, fx=60, frames=2,IgFH=1}},
			E_attack_back3 = {shape={type="Box",w=600,h=300,x=0,y=150},hurtProp={effect="hurtBack", action="hurtBack1", action2="hurtBack2", effectName="HEF2", pause=1, fx=60, frames=2, sound="900224.mp3",IgFH=1}},
			E_attack_back4 = {shape={type="Box",w=220,h=200,x=0,y=100},hurtProp={effect="hurtBack", action="hurtBack1", action2="hurtBack2", effectName="HEF2", pause=1, fx=60, frames=2,IgFH=1}},
			E_fly_horizontal = {shape={type="Box",w=500,h=200,x=0,y=100},hurtProp={effect="hurtBounceOff", action="hurtBack2", action2="hurtBack1", effectName="HEF2", pause=1, fx=150,fy=130, frames=2, sound="900224.mp3",IgFH=1}},
		},
	},
	skill7 = {
		jineng3_1 = {
			E_fly_vertical = {shape={type="Box",w=160,h=500,x=0,y=250},hurtProp={effect="hurtBounceUp", frames=3, action="hurtBounceUp2",effectName="HEF2", fx=10, fy=210, pause=1, pauseFrame=1, sound="900224.mp3",IgFH=1}},
			E_attack_stick = {shape={type="Box",w=300,h=200,x=0,y=300},hurtProp={effect="hurtBounceUp", frames=3, action="hurtBounceUp2",effectName="HEF2", fx=1, fy=10, pause=1, pauseFrame=1}},
		},
		jineng3_2 = {
			E_attack_stick = {shape={type="Box",w=300,h=200,x=0,y=260},hurtProp={effect="hurtBounceUp", frames=3, action="hurtBounceUp2",effectName="HEF2", fx=1, fy=10, pause=1, pauseFrame=1, sound="900224.mp3"}},
		},
		jineng3_3 = {
			E_fly_horizontal = {shape={type="Box",w=300,h=300,x=0,y=150},hurtProp={effect="hurtFallDown",action="hurtBounceUp2", effectName="HEF2",fx=150,fy=0, pause=1, sound="900224.mp3",IgFH=1}},
		},
	},
	skill8 = {
		jineng4_1 = {
			E_attack_back = {shape={type="Box",w=260,h=200,x=0,y=100},attackProp={effect="forward", fx=15, frames=2},hurtProp={effect="hurtBack", action="hurtBack1", action2="hurtBack2", effectName="HEF2", pause=1, fx=30, frames=2, sound="900224.mp3",IgFH=1}},
		},
		jineng4_2 = {
			E_attack_back = {shape={type="Box",w=240,h=200,x=0,y=100},attackProp={effect="forward", fx=15, frames=2},hurtProp={effect="hurtBack", action="hurtBack1", action2="hurtBack2", effectName="HEF2", pause=1, fx=30, frames=2,IgFH=1}},
		},
		jineng4_3 = {
			E_attack_back = {shape={type="Box",w=260,h=200,x=0,y=100},attackProp={effect="forward", fx=15, frames=2},hurtProp={effect="hurtBack", action="hurtBack1", action2="hurtBack2", effectName="HEF2", pause=1, fx=30, frames=2, sound="900224.mp3",IgFH=1}},
		},
		jineng4_4 = {
			E_fly_vertical = {shape={type="Box",w=1000,h=200,x=-500,y=100},hurtProp={effect="hurtBounceUp", frames=3, action="hurtBounceUp2",effectName="HEF2", fx=0, fy=180, pause=1, pauseFrame=1,IgFH=1}},
			E_attack_stick = {shape={type="Box",w=1000,h=200,x=-500,y=300},hurtProp={effect="hurtBounceUp", frames=3, action="hurtBounceUp2",effectName="HEF2", fx=0, fy=10, pause=1, pauseFrame=1, sound="900224.mp3"}},
			E_fly_vertical1 = {shape={type="Box",w=1000,h=300,x=-500,y=300},hurtProp={effect="hurtFallDown",action="hurtBounceUp2", effectName="HEF2",fx=150,fy=0, pause=1,IgFH=1}},
			E_fly_vertical2 = {shape={type="Box",w=1000,h=50,x=-500,y=50},hurtProp={effect="hurtBounceUp", frames=1, action="hurtBounceUp2",effectName="HEF2", fx=30, fy=60, sound="900224.mp3",IgFH=1}},
		},
	},
	skill9 = {
		jineng1_1 = {
			E_attack_back = {shape={type="Box",w=380,h=200,x=0,y=100},hurtProp={effect="hurtBack", action="hurtBack1", action2="hurtBack2", effectName="HEF3", pause=1, fx=60, frames=2, sound="900215.mp3",IgFH=1}},
		},
		jineng1_2 = {
			E_fly_vertical = {shape={type="Box",w=120,h=200,x=0,y=100},hurtProp={effect="hurtBounceUp", frames=6, action="hurtBounceUp2",effectName="HEF3", fx=80, fy=100, pause=1, pauseFrame=1,IgFH=1}},
		},
		jineng1_3 = {
			E_attack_stick = {shape={type="Box",w=300,h=300,x=0,y=150},hurtProp={effect="hurtBounceUp", frames=1, action="hurtBounceUp2",effectName="HEF3", fx=10, fy=30, pause=0, pauseFrame=0, sound="900215.mp3",IgFH=1}},
		},
	},
	skill10 = {
		jineng2_1 = {
			E_attack_back = {shape={type="Box",w=200,h=50,x=0,y=50},hurtProp={effect="hurtBack", action="hurtBack1", action2="hurtBack2", effectName="HEF3", pause=1, fx=10, frames=2, sound="900215.mp3",IgFH=1}},
			E_fly_vertical = {shape={type="Box",w=300,h=300,x=0,y=150},hurtProp={effect="hurtBounceUp", frames=3, action="hurtBounceUp2",effectName="HEF3", fx=10, fy=260, pause=1, pauseFrame=1,IgFH=1}},
		},
		jineng2_2 = {
			E_attack_stick = {shape={type="Box",w=300,h=200,x=0,y=100},hurtProp={effect="hurtBounceUp", frames=3, action="hurtBounceUp2",effectName="HEF3", fx=0, fy=80, pause=0, pauseFrame=0}},
		},
		jineng2_3 = {
			E_attack_stick = {shape={type="Box",w=300,h=260,x=0,y=130},hurtProp={effect="hurtBounceUp", frames=1, action="hurtBounceUp2",effectName="HEF3", fx=0, fy=80, pause=0, pauseFrame=0, sound="900215.mp3"}},
		},
	},
	skill11 = {
		jineng3_1 = {
			E_attack_back = {shape={type="Box",w=200,h=200,x=0,y=100},hurtProp={effect="hurtBack", action="hurtBack1", action2="hurtBack2", effectName="HEF3", pause=1, fx=10, frames=2, sound="900215.mp3",IgFH=1}},
			E_fly_vertical1 = {shape={type="Box",w=800,h=200,x=-400,y=100},hurtProp={effect="hurtBounceUp", frames=3, action="hurtBounceUp2",effectName="HEF3", fx=10, fy=260, pause=1, pauseFrame=1,IgFH=1}},
			E_fly_vertical2 = {shape={type="Box",w=2000,h=200,x=-1000,y=100},hurtProp={effect="hurtBounceUp", frames=3, action="hurtBounceUp2",effectName="HEF3", fx=10, fy=260, pause=1, pauseFrame=1,IgFH=1}},
		},
		jineng3_2 = {
			E_attack_stick = {shape={type="Box",w=2000,h=500,x=-1000,y=50},hurtProp={effect="hurtBounceUp", frames=3, action="hurtBounceUp2",effectName="HEF3", fx=20, fy=80, pause=1, pauseFrame=1, sound="900215.mp3",IgFH=1}},
		},
		jineng3_3 = {
			E_fall_down = {shape={type="Box",w=2000,h=500,x=-1000,y=350},attackProp={effect="groundShake",target="ALL"},hurtProp={effect="hurtFallDown",action="hurtBounceUp2", effectName="HEF3",fx=150,fy=0, pause=1,IgFH=1}},
			E_shake_fly = {shape={type="Circle",r=2000,x=0,y=0},attackProp={effect="groundShake",target="ALL"},hurtProp={effect="hurtBounceOff",action="hurtBounceUp2", effectName="HEF3",fx=150,fy=100, pause=1, pauseFrame=10, sound="900215.mp3",IgFH=1}},
		},
	},
	skill12 = {
		jineng4_2 = {
			E_attack_stick = {shape={type="Box",w=2000,h=500,x=-1000,y=50,addEF="SEF1"},hurtProp={atkDist=300,effect="hurtBounceUp", frames=3, action="hurtBounceUp2",effectName="HEF3", fx=20, fy=80, pause=1, pauseFrame=1, sound="900215.mp3",IgFH=1}},
		},
		jineng4_3 = {
			E_attack_stick = {shape={type="Box",w=2000,h=500,x=-1000,y=50,delEF="SEF1"},hurtProp={atkDist=300,effect="hurtBounceUp", frames=3, action="hurtBounceUp2",effectName="hurt1", fx=0, fy=80, pause=1, pauseFrame=1, sound="900215.mp3",IgFH=1}},
			E_fly_horizontal = {shape={type="Circle",r=2000,x=0,y=0},attackProp={atkDist=300,effect="groundShake",target="ALL"},hurtProp={effect="hurtBounceOff",action="hurtBounceUp2", effectName="hurt1",fx=150,fy=100, pause=1, pauseFrame=10, sound="900215.mp3",IgFH=1}},
		},
	},
}

FIGHT_STATE={
	idle     = "idle",
	run      = "run",
	stand    = "stand",
	attack   = "attack",
	attack1  = "attack1",
	attack2  = "attack2",
	attack3  = "attack3",
	attack4  = "attack4",
	attack5  = "attack5",
	skill1   = "skill1",
	skill2   = "skill2",
	skill3   = "skill3",
	skill4   = "skill4",
	skill5   = "skill5",
	skill6   = "skill6",
	skill7   = "skill7",
	skill8   = "skill8",
	skill9   = "skill9",
	skill10  = "skill10",
	skill11  = "skill11",
	skill12  = "skill12",
	hurtBack1  = "hurtBack1",
	hurtBack2  = "hurtBack2",
	dead   = "dead",
	hurtBounceUp1 = "hurtBounceUp1",
	hurtBounceUp2 = "hurtBounceUp2",
	hurtBounceUp3 = "hurtBounceUp3",
	hurtBounceUp4 = "hurtBounceUp4",
	hurtFallDown = "hurtFallDown",
	hurtVFly1 = "hurtVFly1",
	xianjie = "xianjie",
	standup = "standup",
}
--人物动作类型配置
ACTION_TYPE_CONFIG={
	[ACTION_TYPE.LUOFEI]={
		{name = "dead", from = "*", to = ROLE_ACTION.dead, sound="900232.mp3"},
		{name = "run",  from = "*", to = ROLE_ACTION.run},
		{name = "standup",  from = {ROLE_ACTION.hurtFallDown,ROLE_ACTION.dead},       to = ROLE_ACTION.standup  },
		{name = "attack", from = {ROLE_ACTION.stand,ROLE_ACTION.run},  to = ROLE_ACTION.attack1, ap=5, demage={0.3}, sound={attack="90021.mp3",hit="90024.mp3"}},
        {name = "attack", from = {ROLE_ACTION.attack1},  to = ROLE_ACTION.attack2, ap=5, demage={0.3}, handler="onFinishedAttack",sound={attack="90022.mp3",hit="90024.mp3"}},
        {name = "attack", from = {ROLE_ACTION.attack2},  to = ROLE_ACTION.attack3, ap=5, demage={0.4}, handler="onFinishedAttack",sound={attack="90023.mp3",hit="90024.mp3"}},
        {name = "attack", from = {ROLE_ACTION.attack3},  to = ROLE_ACTION.attack4, ap=5, demage={0.5}, handler="onFinishedAttack",sound={attack="900227.mp3",hit="90024.mp3"}},
        {name = "attack", from = {ROLE_ACTION.attack4},  to = ROLE_ACTION.attack1, ap=5, demage={0.3}, sound={attack="90021.mp3",hit="90024.mp3"}, handler="onFinishedAttack"},
	},
	[ACTION_TYPE.JIANYUN]={
		{name = "dead",   from = "*", to = ROLE_ACTION.dead, sound="900225.mp3"},
		{name = "run",  from = "*",       to = ROLE_ACTION.run  },
		{name = "standup",  from = {ROLE_ACTION.hurtFallDown,ROLE_ACTION.dead},       to = ROLE_ACTION.standup  },
		{name = "attack", from = {ROLE_ACTION.stand,ROLE_ACTION.run},  to = ROLE_ACTION.attack1, demage={0.15}, ap=5, sound={attack="900219.mp3",hit="900224.mp3"}},
        {name = "attack", from = {ROLE_ACTION.attack1},  to = ROLE_ACTION.attack2, ap=5, demage={0.15}, handler="onFinishedAttack",sound={attack="900222.mp3",hit="900224.mp3"}},
        {name = "attack", from = {ROLE_ACTION.attack2},  to = ROLE_ACTION.attack3, ap=5, demage={0.3,0.3}, handler="onFinishedAttack",sound={attack="900223.mp3",hit="900224.mp3"}},
        {name = "attack", from = {ROLE_ACTION.attack3},  to = ROLE_ACTION.attack4, ap=5, demage={0.6,0.6}, handler="onFinishedAttack",sound={attack="900220.mp3",hit="900224.mp3"}},
        {name = "attack", from = {ROLE_ACTION.attack4},  to = ROLE_ACTION.attack1, ap=5, demage={0.15}, sound={attack="900219.mp3",hit="900224.mp3"},handler="onFinishedAttack"},
	},
	[ACTION_TYPE.DARKER]={
		{name = "dead",   from = "*", to = ROLE_ACTION.dead},
		{name = "run",  from = "*",       to = ROLE_ACTION.run  },
		{name = "standup",  from = {ROLE_ACTION.hurtFallDown,ROLE_ACTION.dead},       to = ROLE_ACTION.standup  },
		{name = "attack", from = {ROLE_ACTION.stand,ROLE_ACTION.run},  to = ROLE_ACTION.attack1, ap=5, demage={0.2,0.2}, sound={attack="900214.mp3",hit="900215.mp3"}},
        {name = "attack", from = {ROLE_ACTION.attack1},  to = ROLE_ACTION.attack2, ap=5, demage={0.2,0.2}, handler="onFinishedAttack", sound={attack="900216.mp3",hit="900215.mp3"}},
        {name = "attack", from = {ROLE_ACTION.attack2},  to = ROLE_ACTION.attack3, ap=5, demage={0.3,0.3,0.3,0.3}, handler="onFinishedAttack", sound={attack="900217.mp3",hit="900215.mp3"}},
        {name = "attack", from = {ROLE_ACTION.attack3},  to = ROLE_ACTION.attack1, ap=5, demage={0.2,0.2},handler="onFinishedAttack", sound={attack="900214.mp3",hit="900215.mp3"}},
	},
	[ACTION_TYPE.GONGJIA]={
		{name = "dead",   from = "*", to = ROLE_ACTION.dead },
		{name = "run",  from = "*",       to = ROLE_ACTION.walk  },
		{name = "standup",  from = ROLE_ACTION.hurtFallDown,       to = ROLE_ACTION.stand  },
		{name = "attack", from = {ROLE_ACTION.stand,ROLE_ACTION.walk},  to = ROLE_ACTION.attack, demage={}, handler="onFinishedAttack"},
	},
	--彪哥
	[ACTION_TYPE.GONGJI10304]={
		{name = "dead",   from = "*", to = ROLE_ACTION.dead},
		{name = "run",  from = "*",       to = ROLE_ACTION.walk  },
		{name = "standup",  from = ROLE_ACTION.hurtFallDown,       to = ROLE_ACTION.stand  },
		{name = "attack1", from = {ROLE_ACTION.stand,ROLE_ACTION.walk},  to = "gongji1_1", ap=5, demage={}, gotoEvent="attack1", handler="onFinishedAttack"},
		{name = "attack1", from = "gongji1_1",  to = "gongji1_2", demage={}, ap=5, gotoEvent="attack1", handler="onFinishedAttack", count=2},
		{name = "attack1", from = "gongji1_2",  to = "gongji1_3", demage={0.4,0.4,0.4}, ap=5, handler="onFinishedAttack", count=3},
        {name = "attack2", from = {ROLE_ACTION.stand,ROLE_ACTION.walk},  to = "gongji2_1", ap=5, demage={}, gotoEvent="attack2", handler="onFinishedAttack", remPos=1},
        {name = "attack2", from = "gongji2_1",  to = "gongji2_2", demage={}, ap=5, gotoEvent="attack2", handler="onFinishedAttack", count=2},
        {name = "attack2", from = "gongji2_2",  to = "gongji2_3", demage={}, ap=9, handler="onFinishedAttack",remPosName="gongji2_2"},
	},
	--丧尸
	[ACTION_TYPE.GONGJI10205]={
		{name = "dead",   from = "*", to = ROLE_ACTION.dead },
		{name = "run",  from = "*",       to = ROLE_ACTION.walk  },
		{name = "standup",  from = ROLE_ACTION.hurtFallDown,       to = ROLE_ACTION.stand  },
		{name = "attack1", from = {ROLE_ACTION.stand,ROLE_ACTION.walk},  to = "gongji_1", ap=6, handler="onFinishedAttack"},
		{name = "attack2", from = {ROLE_ACTION.stand,ROLE_ACTION.walk},  to = "gongji2_1", ap=9, gotoEvent="attack2", handler="onFinishedAttack", count=1},
		{name = "attack2", from = "gongji2_1",  to = "gongji2_2", ap=9, handler="onFinishedAttack"},
	},
	--大胖
	[ACTION_TYPE.GONGJI10206]={
		{name = "dead",   from = "*", to = ROLE_ACTION.dead },
		{name = "run",  from = "*",       to = ROLE_ACTION.walk  },
		{name = "standup",  from = ROLE_ACTION.hurtFallDown,       to = ROLE_ACTION.stand  },
		{name = "attack1", from = {ROLE_ACTION.stand,ROLE_ACTION.walk},  to = ROLE_ACTION.attack1, ap=1, handler="onFinishedAttack", count=3},
		{name = "attack2", from = {ROLE_ACTION.stand,ROLE_ACTION.walk},  to = "gongji2_1", ap=5, gotoEvent="attack2", handler="onFinishedAttack" , count=5},
		{name = "attack2", from = "gongji2_1",  to = "gongji2_2", ap=5, isRemoteAttack=true, move=-999},
	},
	--叉子
	[ACTION_TYPE.GONGJI10207]={
		{name = "dead",   from = "*", to = ROLE_ACTION.dead },
		{name = "run",  from = "*",       to = ROLE_ACTION.walk  },
		{name = "standup",  from = ROLE_ACTION.hurtFallDown,       to = ROLE_ACTION.stand  },
		{name = "attack1", from = {ROLE_ACTION.stand,ROLE_ACTION.walk},  to = "gongji_1", ap=8, gotoEvent="attack1", handler="onFinishedAttack"},
		{name = "attack1", from = "gongji_1",  to = "gongji_2", AP=8, gotoEvent="attack1", handler="onFinishedAttack" , count=0},
		{name = "attack1", from = "gongji_2",  to = "gongji_3", AP=8, handler="onFinishedAttack"},
		{name = "attack2", from = {ROLE_ACTION.stand,ROLE_ACTION.walk},  to = "gongji2_1", ap=8, gotoEvent="attack2", handler="onFinishedAttack"},
		{name = "attack2", from = "gongji2_1",  to = "gongji2_2", AP=8, handler="onFinishedAttack"},
	},
	--贾雄起（校长）
	[ACTION_TYPE.GONGJI103010]={
		{name = "dead",   from = "*", to = ROLE_ACTION.dead },
		{name = "run",  from = "*",       to = ROLE_ACTION.walk  },
		{name = "standup",  from = ROLE_ACTION.hurtFallDown,       to = ROLE_ACTION.stand  },
		{name = "attack1", from = {ROLE_ACTION.stand,ROLE_ACTION.walk},  to = "gongji1_1", ap=5, demage={}, gotoEvent="attack1", handler="onFinishedAttack"},
		{name = "attack1", from = "gongji1_1",  to = "gongji1_2", ap=5, gotoEvent="attack1", handler="onFinishedAttack", count=3},
		{name = "attack1", from = "gongji1_2",  to = "gongji1_3", ap=5, isRemoteAttack=true, move=-999},
        {name = "attack2", from = {ROLE_ACTION.stand,ROLE_ACTION.walk},  to = "gongji2_1", ap=5, demage={}, gotoEvent="attack2", handler="onFinishedAttack", remPos=1},
        {name = "attack2", from = "gongji2_1",  to = "gongji2_2", ap=5, gotoEvent="attack2", handler="onFinishedAttack", count=6},
        {name = "attack2", from = "gongji2_2",  to = "gongji2_3", ap=9, handler="onFinishedAttack",remPosName="gongji2_2"},
	},
	--怪医生
	[ACTION_TYPE.GONGJI10309]={
		{name = "dead",   from = "*", to = ROLE_ACTION.dead },
		{name = "run",  from = "*",       to = ROLE_ACTION.walk  },
		{name = "standup",  from = ROLE_ACTION.hurtFallDown,       to = ROLE_ACTION.stand  },
		{name = "attack1", from = {ROLE_ACTION.stand,ROLE_ACTION.walk},  to = "gongji1_1", ap=1, demage={}, gotoEvent="attack1", handler="onFinishedAttack"},
		{name = "attack1", from = "gongji1_1",  to = "gongji1_2", ap=1, gotoEvent="attack1", handler="onFinishedAttack", count=5},
		{name = "attack1", from = "gongji1_2",  to = "gongji1_3", ap=1,handler="onFinishedAttack"},
        {name = "attack2", from = {ROLE_ACTION.stand,ROLE_ACTION.walk},  to = "gongji2_1", ap=5, demage={}, gotoEvent="attack2", handler="onFinishedAttack"},
        {name = "attack2", from = "gongji2_1",  to = "gongji2_2", ap=5, gotoEvent="attack2", handler="onFinishedAttack", count=3},
        {name = "attack2", from = "gongji2_2",  to = "gongji2_3", ap=9,handler="onFinishedAttack"},
	},
	--假darker
	[ACTION_TYPE.GONGJI103011]={
		{name = "dead",   from = "*", to = ROLE_ACTION.dead },
		{name = "run",  from = "*",       to = ROLE_ACTION.run  },
		{name = "standup",  from = ROLE_ACTION.hurtFallDown,       to = ROLE_ACTION.stand  },
		{name = "attack1", from = {ROLE_ACTION.stand,ROLE_ACTION.run},  to = "gongji1_1", ap=5, gotoEvent="attack1", handler="onFinishedAttack", count=3},
		{name = "attack1", from = "gongji1_1",  to = "gongji1_2", ap=5, gotoEvent="attack1", handler="onFinishedAttack", count=3},
		{name = "attack1", from = "gongji1_2",  to = "gongji1_3", ap=5, gotoEvent="attack1", handler="onFinishedAttack"},

        {name = "attack1", from = "gongji1_3",  to = "gongji2_1", ap=5, gotoEvent="attack1", handler="onFinishedAttack", count=3},
        {name = "attack1", from = "gongji2_1",  to = "gongji2_2", ap=5, gotoEvent="attack1", handler="onFinishedAttack", count=3},
        {name = "attack1", from = "gongji2_2",  to = "gongji2_3", ap=5, handler="onFinishedAttack"},

        {name = "attack2", from = {ROLE_ACTION.stand,ROLE_ACTION.run},  to = "gongji3_1", ap=9, gotoEvent="attack2", handler="onFinishedAttack"},
        {name = "attack2", from = "gongji3_1",  to = "gongji3_2", ap=9, gotoEvent="attack2", handler="onFinishedAttack", count=3},
        {name = "attack2", from = "gongji3_2",  to = "gongji3_3", ap=9, gotoEvent="attack2", handler="onFinishedAttack"},
        {name = "attack2", from = "gongji3_3",  to = "gongji3_4", ap=9, handler="onFinishedAttack"},
	},
	--十三妹
	[ACTION_TYPE.GONGJI102012]={
		{name = "dead",   from = "*", to = ROLE_ACTION.dead },
		{name = "run",  from = "*",       to = ROLE_ACTION.walk  },
		{name = "standup",  from = ROLE_ACTION.hurtFallDown,       to = ROLE_ACTION.stand  },
		{name = "attack", from = {ROLE_ACTION.stand,ROLE_ACTION.run},  to = "gongji_1", ap=5, gotoEvent="attack", handler="onFinishedAttack"},
		{name = "attack", from = "gongji_1",  to = "gongji_2", ap=5, gotoEvent="attack", handler="onFinishedAttack"},
		{name = "attack", from = "gongji_2",  to = "gongji_3", ap=5, gotoEvent="attack", handler="onFinishedAttack"},
        {name = "attack", from = "gongji_3",  to = "gongji_4", ap=5, handler="onFinishedAttack"},
	},
	--梦瑶
	[ACTION_TYPE.GONGJI103013]={
		{name = "dead",   from = "*", to = ROLE_ACTION.dead },
		{name = "run",  from = "*",       to = ROLE_ACTION.walk  },
		{name = "standup",  from = ROLE_ACTION.hurtFallDown,       to = ROLE_ACTION.stand  },
		{name = "attack1", from = {ROLE_ACTION.stand,ROLE_ACTION.run},  to = "gongji1", ap=5,demage={0.1,0.1}, handler="onFinishedAttack"},
		{name = "attack2", from = {ROLE_ACTION.stand,ROLE_ACTION.run},  to = "gongji2", ap=5, handler="onFinishedAttack"},
		{name = "attack3", from = {ROLE_ACTION.stand,ROLE_ACTION.run},  to = "gongji3", ap=5, demage={0.1,0.1,0.1,0.1,0.1,0.1},handler="onFinishedAttack"},
        {name = "attack4", from = {ROLE_ACTION.stand,ROLE_ACTION.run},  to = "gongji4", ap=5, demage={0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1},handler="onFinishedAttack"},
	},
	--蛮狱屠夫
	[ACTION_TYPE.GONGJI102014]={
		{name = "dead",   from = "*", to = ROLE_ACTION.dead },
		{name = "run",  from = "*",       to = ROLE_ACTION.walk  },
		{name = "standup",  from = ROLE_ACTION.hurtFallDown,       to = ROLE_ACTION.stand  },
		{name = "attack1", from = {ROLE_ACTION.stand,ROLE_ACTION.walk},  to = "gongji1", ap=6, gotoEvent="attack1", handler="onFinishedAttack"},
		{name = "attack1", from = "gongji1",  to = "gongji2", ap=6, handler="onFinishedAttack"},
		{name = "attack2", from = {ROLE_ACTION.stand,ROLE_ACTION.walk},  to = "gongji3", ap=9, handler="onFinishedAttack"},
	},
	[ACTION_TYPE.GONGJI10001]={
		{name = "dead", from = "*", to = ROLE_ACTION.dead, sound="900233.mp3"},
		{name = "run",  from = "*", to = ROLE_ACTION.run},
		{name = "standup",  from = {ROLE_ACTION.hurtFallDown,ROLE_ACTION.dead},       to = ROLE_ACTION.standup  },
		{name = "attack1", from = {ROLE_ACTION.stand,ROLE_ACTION.run},  to = ROLE_ACTION.attack1, ap=5, gotoEvent="attack1", demage={0.3}, sound={attack="90021.mp3",hit="90024.mp3"}, handler="onFinishedAttack"},
        {name = "attack1", from = {ROLE_ACTION.attack1},  to = ROLE_ACTION.attack2, ap=5, gotoEvent="attack1", demage={0.3}, handler="onFinishedAttack"},
        {name = "attack1", from = {ROLE_ACTION.attack2},  to = ROLE_ACTION.attack3, ap=5, gotoEvent="attack1", demage={0.4}, handler="onFinishedAttack"},
        {name = "attack1", from = {ROLE_ACTION.attack3},  to = ROLE_ACTION.attack4, ap=5, demage={0.5}, handler="onFinishedAttack"},

        {name = "skill1", from = {ROLE_ACTION.stand,ROLE_ACTION.run}, to = "jineng2", ap=9, demage={0.3,0.3,0.4}, handler="onFinishedAttack"},

        {name = "skill3", from = {ROLE_ACTION.stand,ROLE_ACTION.run}, to = ROLE_ACTION.xianjie, ap=9, move=200, gotoEvent="skill3"},
		{name = "skill3", from = {ROLE_ACTION.xianjie}, to = "jineng3_1", ap=9, demage={0.1}, count=3, gotoEvent="skill3", handler="onFinishedAttack"},
		{name = "skill3", from = "jineng3_1", to = "jineng3_2", ap=9, sound={attack="900226.mp3",hit="90024.mp3"}, demage={0.5}, handler="onFinishedAttack"},

        {name = "skill2", from = {ROLE_ACTION.xianjie}, to = "jineng1", ap=10, demage={0.15,0.15,0.15,0.15,0.4}, handler="onFinishedAttack"},
	 	{name = "skill2", from = {ROLE_ACTION.stand,ROLE_ACTION.run}, to = ROLE_ACTION.xianjie, ap=9, move=200, gotoEvent="skill2"},

        {name = "skill4", from = {ROLE_ACTION.stand,ROLE_ACTION.run}, to = "jineng4_1", ap=9, gotoEvent="skill4", demage={0.05}, handler="onFinishedAttack"},
		{name = "skill4", from = "jineng4_1", to = "jineng4_2", ap=9, gotoEvent="skill4", demage={0.05}, handler="onFinishedAttack"},
		{name = "skill4", from = "jineng4_2", to = "jineng4_3", ap=9, gotoEvent="skill4", demage={0.05}, handler="onFinishedAttack"},
		{name = "skill4", from = "jineng4_3", to = "jineng4_4", ap=9, gotoEvent="skill4", demage={0.05}, handler="onFinishedAttack"},
		{name = "skill4", from = "jineng4_4", to = "jineng4_5", ap=9, gotoEvent="skill4", demage={0.03,0.03}, handler="onFinishedAttack", count=3},
		{name = "skill4", from = "jineng4_5", to = "jineng4_", ap=10, demage={0.05,0.05,0.05,0.05,0.05,0.05,0.3}, handler="onFinishedAttack"},
	},
	[ACTION_TYPE.GONGJI10002]={
		{name = "dead",   from = "*", to = ROLE_ACTION.dead, sound="900225.mp3"},
		{name = "run",  from = "*",       to = ROLE_ACTION.run  },
		{name = "standup",  from = {ROLE_ACTION.hurtFallDown,ROLE_ACTION.dead},       to = ROLE_ACTION.standup  },
		{name = "attack1", from = {ROLE_ACTION.stand,ROLE_ACTION.run},  to = ROLE_ACTION.attack1, ap=5, gotoEvent="attack1", demage={0.2}, handler="onFinishedAttack"},
        {name = "attack1", from = {ROLE_ACTION.attack1},  			    to = ROLE_ACTION.attack2, ap=5, gotoEvent="attack1", demage={0.2}, handler="onFinishedAttack"},
        {name = "attack1", from = {ROLE_ACTION.attack2},  				to = ROLE_ACTION.attack3, ap=5, gotoEvent="attack1", demage={0.3,0.3}, handler="onFinishedAttack"},
        {name = "attack1", from = {ROLE_ACTION.attack3},  				to = ROLE_ACTION.attack4, ap=5, demage={0.4,0.6}, handler="onFinishedAttack"},

        {name = "skill5", from = {ROLE_ACTION.stand,ROLE_ACTION.run}, to = "jineng1_1", ap=9, gotoEvent="skill5", move=-1, count=10},
		{name = "skill5", from = "jineng1_1", to = "jineng1_2", ap=9, demage={0.3,0.3,0.4}, sound={attack="900221.mp3",hit="900224.mp3"},  move=300, handler="onFinishedAttack"},

        {name = "skill6", from = {ROLE_ACTION.stand,ROLE_ACTION.run}, to = "jineng2", ap=9, demage={0.3,0.3,0.4}, handler="onFinishedAttack"},

        {name = "skill7", from = {ROLE_ACTION.stand,ROLE_ACTION.run}, to = "jineng3_1", ap=10, demage={0.4}, gotoEvent="skill7", handler="onFinishedAttack"},
		{name = "skill7", from = "jineng3_1", to = "jineng3_2", ap=10, demage={0.3}, gotoEvent="skill7", handler="onFinishedAttack"},
		{name = "skill7", from = "jineng3_2", to = "jineng3_3", ap=10, demage={0.3}, handler="onFinishedAttack"},

		{name = "skill8", from = {ROLE_ACTION.stand,ROLE_ACTION.run}, to = "jineng4_1", ap=9, demage={0.2}, gotoEvent="skill8", handler="onFinishedAttack"},
		{name = "skill8", from = "jineng4_1", to = "jineng4_2", ap=9, demage={0.2}, gotoEvent="skill8", handler="onFinishedAttack"},
		{name = "skill8", from = "jineng4_2", to = "jineng4_3", ap=9, demage={0.2}, gotoEvent="skill8", handler="onFinishedAttack"},
		{name = "skill8", from = "jineng4_3", to = "jineng4_4", ap=10, demage={0.2,0.2}, handler="onFinishedAttack"},
	},
	[ACTION_TYPE.GONGJI10003]={
		{name = "dead",   from = "*", to = ROLE_ACTION.dead},
		{name = "run",  from = "*",       to = ROLE_ACTION.run  },
		{name = "standup",  from = {ROLE_ACTION.hurtFallDown,ROLE_ACTION.dead},       to = ROLE_ACTION.standup  },
		{name = "attack1", from = {ROLE_ACTION.stand,ROLE_ACTION.run},  to = ROLE_ACTION.attack1, ap=5, gotoEvent="attack1", demage={0.2,0.2}, handler="onFinishedAttack"},
        {name = "attack1", from = {ROLE_ACTION.attack1},  to = ROLE_ACTION.attack2, ap=5, gotoEvent="attack1", demage={0.2,0.2}, handler="onFinishedAttack"},
        {name = "attack1", from = {ROLE_ACTION.attack2},  to = ROLE_ACTION.attack3, ap=5, demage={0.3,0.3,0.3,0.3}, handler="onFinishedAttack"},

        {name = "skill9", from = {ROLE_ACTION.stand,ROLE_ACTION.run}, to = "jineng1_1", ap=9, demage={0.2,0.2}, gotoEvent="skill9", handler="onFinishedAttack"},
		{name = "skill9", from = "jineng1_1", to = "jineng1_2", ap=9, demage={0.2}, move=200, gotoEvent="skill9"},
		{name = "skill9", from = "jineng1_2", to = "jineng1_3", ap=9, demage={0.1,0.1,0.1}, count=3, handler="onFinishedAttack"},

		{name = "skill10", from = {ROLE_ACTION.stand,ROLE_ACTION.run}, to = "jineng2_1", ap=9, demage={0.2,0.2}, gotoEvent="skill10", handler="onFinishedAttack"},
		{name = "skill10", from = "jineng2_1", to = "jineng2_2", ap=9, demage={0.2,0.2}, gotoEvent="skill10", count=1, handler="onFinishedAttack"},
		{name = "skill10", from = "jineng2_2", to = "jineng2_3", ap=9, demage={0.1,0.1,0.1}, count=3, handler="onFinishedAttack"},

		{name = "skill11", from = {ROLE_ACTION.stand,ROLE_ACTION.run}, to = "jineng3_1", ap=10, demage={0.3,0.3,0.3}, gotoEvent="skill11", handler="onFinishedAttack"},
		{name = "skill11", from = "jineng3_1", to = "jineng3_2", ap=10, demage={0.1,0.1,0.1}, count=1, gotoEvent="skill11", handler="onFinishedAttack"},
		{name = "skill11", from = "jineng3_2", to = "jineng3_3", ap=10, demage={0.3,0.3}, handler="onFinishedAttack"},

		{name = "skill12", from = {ROLE_ACTION.stand,ROLE_ACTION.run}, to = "jineng4_1", ap=9, gotoEvent="skill12", handler="onFinishedAttack"},
		{name = "skill12", from = "jineng4_1", to = "jineng4_2", ap=9, demage={0.1,0.1,0.1,0.1}, count=3, gotoEvent="skill12", handler="onFinishedAttack"},
		{name = "skill12", from = "jineng4_2", to = "jineng4_3", ap=9, demage={0.3,0.3,0.3}, handler="onFinishedAttack"},
	},
}
--战斗状态配置
--IgCollde :前冲时是否忽略撞击 0:false 1: true
SKILL_ACTION_CONFIG={
	[3]={
		{name = "skill3", from = {ROLE_ACTION.stand,ROLE_ACTION.run}, to = ROLE_ACTION.xianjie, ap=9, move=200, IgCollde=0, gotoEvent="skill3"},
		{name = "skill3", from = {ROLE_ACTION.xianjie}, to = "jineng3_1", ap=9, demage={0.1}, count=3, gotoEvent="skill3", handler="onFinishedSkill"},
		{name = "skill3", from = "jineng3_1", to = "jineng3_2", ap=9, sound={attack="900226.mp3",hit="90024.mp3"}, demage={0.5}, handler="onFinishedSkill"},
	},
	[1]={{name = "skill1", from = {ROLE_ACTION.stand,ROLE_ACTION.run}, to = "jineng2", ap=9, demage={0.3,0.3,0.4}, handler="onFinishedSkill"},},
	[2]={
	    {name = "skill2", from = {ROLE_ACTION.xianjie}, to = "jineng1", ap=10, demage={0.15,0.15,0.15,0.15,0.4}, handler="onFinishedSkill"},
	 	{name = "skill2", from = {ROLE_ACTION.stand,ROLE_ACTION.run}, to = ROLE_ACTION.xianjie, ap=9, move=200, IgCollde=0, gotoEvent="skill2"},
	},
	[4]={{name = "skill4", from = {ROLE_ACTION.stand,ROLE_ACTION.run}, to = "jineng4_1", ap=9, demage={0.05}, gotoEvent="skill4", handler="onFinishedSkill"},
		 {name = "skill4", from = "jineng4_1", to = "jineng4_2", ap=9, demage={0.05}, gotoEvent="skill4", handler="onFinishedSkill"},
		 {name = "skill4", from = "jineng4_2", to = "jineng4_3", ap=9, demage={0.05}, gotoEvent="skill4", handler="onFinishedSkill"},
		 {name = "skill4", from = "jineng4_3", to = "jineng4_4", ap=9, demage={0.05}, gotoEvent="skill4", handler="onFinishedSkill"},
		 {name = "skill4", from = "jineng4_4", to = "jineng4_5", ap=9, demage={0.03,0.03}, gotoEvent="skill4", handler="onFinishedSkill", count=3},
		 {name = "skill4", from = "jineng4_5", to = "jineng4_", ap=10, demage={0.05,0.05,0.05,0.05,0.05,0.05,0.3}, handler="onFinishedSkill"},
	},

	[5]={{name = "skill5", from = {ROLE_ACTION.stand,ROLE_ACTION.run}, to = "jineng1_1", ap=9, gotoEvent="skill5", move=-1, IgCollde=1, count=10},
		 {name = "skill5", from = "jineng1_1", to = "jineng1_2", ap=9, demage={0.3,0.3,0.4}, sound={attack="900221.mp3",hit="900224.mp3"},  move=300, IgCollde=1, handler="onFinishedSkill"},
	},
	[6]={{name = "skill6", from = {ROLE_ACTION.stand,ROLE_ACTION.run}, to = "jineng2", ap=9, demage={0.2,0.2,0.2,0.2,0.2}, handler="onFinishedSkill"},},
	[7]={{name = "skill7", from = {ROLE_ACTION.stand,ROLE_ACTION.run}, to = "jineng3_1", ap=10, demage={0.1,0.1,0.1,0.1}, gotoEvent="skill7", handler="onFinishedSkill"},
		 {name = "skill7", from = "jineng3_1", to = "jineng3_2", ap=10, demage={0.15,0.15}, gotoEvent="skill7", handler="onFinishedSkill"},
		 {name = "skill7", from = "jineng3_2", to = "jineng3_3", ap=10, demage={0.3}, handler="onFinishedSkill"},
	},
	[8]={{name = "skill8", from = {ROLE_ACTION.stand,ROLE_ACTION.run}, to = "jineng4_1", ap=9, demage={0.05}, gotoEvent="skill8", handler="onFinishedSkill"},
		 {name = "skill8", from = "jineng4_1", to = "jineng4_2", ap=9, demage={0.05}, gotoEvent="skill8", handler="onFinishedSkill"},
		 {name = "skill8", from = "jineng4_2", to = "jineng4_3", ap=9, demage={0.05}, gotoEvent="skill8", handler="onFinishedSkill"},
		 {name = "skill8", from = "jineng4_3", to = "jineng4_4", ap=10, demage={0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.1,0.1,}, handler="onFinishedSkill"},
	},

	[9]={{name = "skill9", from = {ROLE_ACTION.stand,ROLE_ACTION.run}, to = "jineng1_1", ap=9, demage={0.2,0.2}, gotoEvent="skill9", handler="onFinishedSkill"},
		 {name = "skill9", from = "jineng1_1", to = "jineng1_2", ap=9, demage={0.2}, move=200, IgCollde=1, gotoEvent="skill9"},
		 {name = "skill9", from = "jineng1_2", to = "jineng1_3", ap=9, demage={0.1,0.1,0.1}, count=3, handler="onFinishedSkill"},
	},
	[10]={{name = "skill10", from = {ROLE_ACTION.stand,ROLE_ACTION.run}, to = "jineng2_1", ap=9, demage={0.2,0.2}, gotoEvent="skill10", handler="onFinishedSkill"},
		  {name = "skill10", from = "jineng2_1", to = "jineng2_2", ap=9, demage={0.2,0.2}, gotoEvent="skill10", count=1, handler="onFinishedSkill"},
		  {name = "skill10", from = "jineng2_2", to = "jineng2_3", ap=9, demage={0.1,0.1,0.1}, count=3, handler="onFinishedSkill"},
	},
	[11]={{name = "skill11", from = {ROLE_ACTION.stand,ROLE_ACTION.run}, to = "jineng3_1", ap=10, demage={0.3,0.3,0.3}, gotoEvent="skill11", handler="onFinishedSkill"},
		  {name = "skill11", from = "jineng3_1", to = "jineng3_2", ap=10, demage={0.1,0.1,0.1}, count=1, gotoEvent="skill11", handler="onFinishedSkill"},
		  {name = "skill11", from = "jineng3_2", to = "jineng3_3", ap=10, demage={0.3,0.3}, handler="onFinishedSkill"},
	},
	[12]={{name = "skill12", from = {ROLE_ACTION.stand,ROLE_ACTION.run}, to = "jineng4_1", ap=9, gotoEvent="skill12", handler="onFinishedSkill"},
		  {name = "skill12", from = "jineng4_1", to = "jineng4_2", ap=9, demage={0.1,0.1,0.1,0.1}, count=3, gotoEvent="skill12", handler="onFinishedSkill"},
		  {name = "skill12", from = "jineng4_2", to = "jineng4_3", ap=9, demage={0.3,0.3,0.3}, handler="onFinishedSkill"},
	},
}
ACTION_SOUND={
	[ACTION_TYPE.LUOFEI]={},
}