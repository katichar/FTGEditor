-- 主角配置信息

-- roleinfo={
-- 	[玩家类型]={type=玩家类型（罗飞、剑云、Darker）,speed=移动速度,pic="头像资源",{w=100,h=220,offX=0,offY=110,hw=120,ActOffX=65,ActOffY=75},animalData={bone="roles/luofei_s.xml",texture="roles/luofei_t.xml",armature="luosir"}},
-- 	[玩家类型]={type=玩家类型（罗飞、剑云、Darker）,speed=移动速度,pic="头像资源",{w=100,h=220,offX=0,offY=110,hw=120,ActOffX=65,ActOffY=75},animalData={bone="roles/luofei_s.xml",texture="roles/luofei_t.xml",armature="luosir"}},
-- 	[玩家类型]={type=玩家类型（罗飞、剑云、Darker）,speed=移动速度,pic="头像资源",{w=100,h=220,offX=0,offY=110,hw=120,ActOffX=65,ActOffY=75},animalData={bone="roles/luofei_s.xml",texture="roles/luofei_t.xml",armature="luosir"}},
-- }
local roleinfo={
	[OBJ_TYPE.LUOFEI]={
						type=OBJ_TYPE.LUOFEI,
						speed=3,
						pic="20001.png",
						basehp=150,
						grouphp=0.2,
						basemp=120,
						groupmp=0.2,
						baseatk=90,
						groupatk=0.6,
						restoremp=3,
						-- 特殊属性
						-- 暴击几率 /100
						critchance=0,
						-- 暴击伤害 /100
						critdamage=150,
						atkp=0,
						hpp=0,
						mpp=0,
						defp=0,

						size={w=100,h=220,offX=0,offY=110,hw=120,ActOffX=65,ActOffY=75},
						animalData={bone="roles/10001_s.xml",texture="roles/10001_t.xml",armature="luosir"},
						actiontype=ACTION_TYPE.LUOFEI
					},
	[OBJ_TYPE.JIANYUN]={
						type=OBJ_TYPE.JIANYUN,
						speed=3,
						pic="20002.png",
						basehp=100,
						grouphp=0.12,
						basemp=120,
						groupmp=0.2,
						baseatk=110,
						groupatk=0.6,
						restoremp=3,
						-- 暴击几率 /100
						critchance=0,
						-- 暴击伤害 /100
						critdamage=150,
						atkp=0,
						hpp=0,
						mpp=0,
						defp=0,

						size={w=100,h=220,offX=0,offY=110,hw=120,ActOffX=65,ActOffY=75},
						animalData={bone="roles/10002_s.xml",texture="roles/10002_t.xml",armature="jianyun"},
						actiontype=ACTION_TYPE.JIANYUN
					},
	[OBJ_TYPE.DARKER]={
						type=OBJ_TYPE.DARKER,
						speed=3,
						pic="20003.png",
						basehp=120,
						grouphp=0.2,
						basemp=120,
						groupmp=0.2,
						baseatk=100,
						groupatk=0.6,
						restoremp=3,
						-- 暴击几率 /100
						critchance=0,
						-- 暴击伤害 /100
						critdamage=150,
						atkp=0,
						hpp=0,
						mpp=0,
						defp=0,

						size={w=100,h=220,offX=0,offY=110,hw=120,ActOffX=65,ActOffY=75},
						animalData={bone="roles/10003_s.xml",texture="roles/10003_t.xml",armature="darker"},
						actiontype=ACTION_TYPE.DARKER
					},
}

return roleinfo