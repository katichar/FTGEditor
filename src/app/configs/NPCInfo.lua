
-- 怪的配置信息
-- 注:remote={r=远程攻击半径判定范围值,atk1={T=(0:近身攻击,1:远程攻击),P=发生机率,CD=攻击频率}}
-- npc={
-- 	[怪ID]={id=怪ID,hp=基础生命,atk=基础伤害,type=怪类型（普通、精英、boss）,speed=移动速度,skills={},pic="头像资源",size={w=100,h=210,offX=0,offY=105,hw=120,ActOffX=65,ActOffY=75},animalData={bone="roles/101011_s.xml",texture="roles/101011_t.xml",armature="101011"}},
-- 	[怪ID]={id=怪ID,hp=基础生命,atk=基础伤害,type=怪类型（普通、精英、boss）,speed=移动速度,skills={},pic="头像资源",size={w=100,h=210,offX=0,offY=105,hw=120,ActOffX=65,ActOffY=75},animalData={bone="roles/101011_s.xml",texture="roles/101011_t.xml",armature="101011"}},
-- 	[怪ID]={id=怪ID,hp=基础生命,atk=基础伤害,type=怪类型（普通、精英、boss）,speed=移动速度,skills={},pic="头像资源",size={w=100,h=210,offX=0,offY=105,hw=120,ActOffX=65,ActOffY=75},animalData={bone="roles/101011_s.xml",texture="roles/101011_t.xml",armature="101011"}},
-- 	[怪ID]={id=怪ID,hp=基础生命,atk=基础伤害,type=怪类型（普通、精英、boss）,speed=移动速度,skills={},pic="头像资源",size={w=100,h=210,offX=0,offY=105,hw=120,ActOffX=65,ActOffY=75},animalData={bone="roles/101011_s.xml",texture="roles/101011_t.xml",armature="101011"}},
-- 	[怪ID]={id=怪ID,hp=基础生命,atk=基础伤害,type=怪类型（普通、精英、boss）,speed=移动速度,skills={},pic="头像资源",size={w=100,h=210,offX=0,offY=105,hw=120,ActOffX=65,ActOffY=75},animalData={bone="roles/101011_s.xml",texture="roles/101011_t.xml",armature="101011"}},
-- }
local npc={
	--阿斌（打手）
	[1]={id=1,basehp=100,grouphp=1,attrhp=1,baseatk=5,groupatk=5,attratk=1,def=1,speed=-1,skills={},pic="20101.png",name="阿斌",scale=1,size={w=100,h=210,offX=0,offY=105,hw=170},CD=3,AP=1,PFlee=0.05,animalData={bone="roles/10101_s.xml",texture="roles/10101_t.xml",armature="10101"}},
	-- 十三狼（钢管男）
	[2]={id=2,basehp=100,grouphp=2,attrhp=1,baseatk=5,groupatk=6,attratk=1,def=1,speed=0,skills={},pic="20102.png",name="十三狼",scale=1,size={w=100,h=210,offX=0,offY=105,hw=220},CD=2,AP=1,PFlee=0.05,animalData={bone="roles/10102_s.xml",texture="roles/10102_t.xml",armature="10102"}},
	-- 包仔（小胖）
	[3]={id=3,basehp=100,grouphp=1.2,attrhp=1,baseatk=4,groupatk=5,attratk=1,def=1,speed=1,skills={},pic="20103.png",name="包仔",scale=1,size={w=100,h=170,offX=0,offY=85,hw=280},CD=1.5,AP=1,PFlee=1,animalData={bone="roles/10103_s.xml",texture="roles/10103_t.xml",armature="10103"}},
	-- 金彪（彪哥）
	[4]={id=4,basehp=200,grouphp=3,attrhp=2,baseatk=6,groupatk=7,attratk=1,def=2,speed=-2,skills={},pic="20304.png",name="金彪",scale=1,size={w=200,h=270,offX=0,offY=135,hw=320},remote={s=350,atk1={T=0,P=0.5,CD=2},atk2={T=1,P=0.5,CD=2,handler="jump"}},animalData={bone="roles/10304_s.xml",texture="roles/10304_t.xml",armature="10304"},actiontype=ACTION_TYPE.GONGJI10304},
	-- 食脑者（丧尸）
	[5]={id=5,basehp=150,grouphp=2,attrhp=1,baseatk=5,groupatk=3,attratk=2,def=2,speed=-2,skills={},pic="20205.png",name="食脑者",scale=1.05,size={w=100,h=200,offX=0,offY=85,hw=300},CD=1,AP=5,remote={s=300,atk1={T=0,P=0.5,CD=2},atk2={T=1,P=0.5,CD=2,handler="jump"}},animalData={bone="roles/10205_s.xml",texture="roles/10205_t.xml",armature="10205"},actiontype=ACTION_TYPE.GONGJI10205},
	-- 笑面虎（大胖）
	[6]={id=6,basehp=155,grouphp=1,attrhp=4,baseatk=3,groupatk=3,attratk=2,def=1.5,speed=-1,skills={},pic="20206.png",name="笑面虎",scale=1,size={w=100,h=190,offX=0,offY=85,hw=150},remote={s=500,atk1={T=0,P=0.5,CD=2},atk2={T=1,P=0.5,CD=3,handler="onrush"}},animalData={bone="roles/10206_s.xml",texture="roles/10206_t.xml",armature="10206"},actiontype=ACTION_TYPE.GONGJI10206},
	-- 猎杀者（叉子）
	[7]={id=7,basehp=160,grouphp=4,attrhp=1,baseatk=5,groupatk=4,attratk=2,def=1,speed=0,skills={},pic="20207.png",name="猎杀者",scale=1,size={w=100,h=210,offX=0,offY=85,hw=360},CD=2,remote={w=300,atk1={T=0,P=0.5,CD=2},atk2={T=1,P=0.5,CD=3,handler="hdist"}},animalData={bone="roles/10207_s.xml",texture="roles/10207_t.xml",armature="10207"},actiontype=ACTION_TYPE.GONGJI10207},
	-- 大飞哥（枪手）
	[8]={id=8,basehp=150,grouphp=3,attrhp=1,baseatk=5,groupatk=3,attratk=2,def=0.5,speed=0,skills={},pic="20108.png",name="大飞哥",scale=1.05,size={w=100,h=200,offX=-300,offY=85,hw=-1},remote={w=0.5,atk={T=1,P=1,CD=5,AP=6,handler="hdist"}},animalData={bone="roles/10108_s.xml",texture="roles/10108_t.xml",armature="10108"}},
	-- 钱浩博（怪医生）
	[9]={id=9,basehp=220,grouphp=6,attrhp=2,baseatk=6,groupatk=3,attratk=3,def=2,speed=1,skills={},pic="20309.png",name="钱浩博",scale=1,size={w=120,h=260,offX=0,offY=85,hw=150},remote={w=300,atk1={T=1,P=0.5,CD=2,handler="hdist"},atk2={T=0,P=0.5,CD=1}},animalData={bone="roles/10309_s.xml",texture="roles/10309_t.xml",armature="10309"},actiontype=ACTION_TYPE.GONGJI10309},
	-- 贾雄起（校长）
	[10]={id=10,basehp=220,grouphp=3,attrhp=3,baseatk=6,groupatk=2,attratk=2,def=2,speed=-1,skills={},pic="203010.png",name="贾雄起",scale=1,size={w=150,h=230,offX=0,offY=85,hw=-1},remote={s=500,atk1={T=1,P=0.5,CD=2,handler="onrush|closeDist"},atk2={T=1,P=0.5,CD=3,handler="jump|closeDist"}},animalData={bone="roles/103010_s.xml",texture="roles/103010_t.xml",armature="103010"},actiontype=ACTION_TYPE.GONGJI103010},

	-- 新加NPC，未设定数值
	-- 巢皮（打手1）
	[11]={id=11,basehp=100,grouphp=1.5,attrhp=1,baseatk=6,groupatk=5,attratk=1,def=1.2,speed=0,skills={},pic="201011.png",name="巢皮",scale=1.03,size={w=100,h=210,offX=0,offY=105,hw=170},CD=2,AP=1,PFlee=0.05,animalData={bone="roles/10101_s.xml",texture="roles/10101_t.xml",armature="10101",skinId=1}},
	-- 山鸡（打手2）
	[12]={id=12,basehp=120,grouphp=2,attrhp=1,baseatk=7,groupatk=6,attratk=1,def=1.5,speed=1,skills={},pic="201012.png",name="山鸡",scale=1.05,size={w=100,h=210,offX=0,offY=105,hw=170},CD=1.5,AP=1,PFlee=0.3,animalData={bone="roles/10101_s.xml",texture="roles/10101_t.xml",armature="10101",skinId=2}},
	-- 乌鸦 (钢管男1)
	[13]={id=13,basehp=180,grouphp=2,attrhp=1,baseatk=6,groupatk=7,attratk=1,def=2,speed=1,skills={},pic="201013.png",name="乌鸦",scale=1.1,size={w=100,h=210,offX=0,offY=105,hw=220},CD=1.5,AP=1,PFlee=0.05,animalData={bone="roles/10102_s.xml",texture="roles/10102_t.xml",armature="10102",skinId=1}},
	-- 苍鹰 (钢管男2)
	[14]={id=14,basehp=220,grouphp=1,attrhp=1.5,baseatk=8,groupatk=6,attratk=1,def=2,speed=0,skills={},pic="201014.png",name="苍鹰",scale=1.1,size={w=100,h=210,offX=0,offY=105,hw=220},CD=2,AP=1,PFlee=0.05,animalData={bone="roles/10102_s.xml",texture="roles/10102_t.xml",armature="10102",skinId=2}},
	-- 假darker
	[15]={id=15,basehp=260,grouphp=6,attrhp=2,baseatk=4,groupatk=3,attratk=5,def=2,speed=1,skills={},pic="203015.png",name="假Darker",scale=1,size={w=100,h=210,offX=0,offY=105,hw=220},CD=5,AP=1,PFlee=0.05,remote={w=210,atk1={T=0,P=0.4,CD=2},atk2={T=1,P=0.6,CD=2,handler="hdist"}},animalData={bone="roles/103011_s.xml",texture="roles/103011_t.xml",armature="103011"},actiontype=ACTION_TYPE.GONGJI103011},
	-- 罗飞
	[16]={id=16,basehp=230,grouphp=6,attrhp=3,baseatk=10,groupatk=6,attratk=6,def=3,speed=1,skills={},pic="20001.png",name="罗飞",scale=1,size={w=100,h=220,offX=0,offY=110,hw=120,},CD=5,AP=1,remote={w=200,atk1={T=0,P=0.6,CD=2},atk2={T=0,P=0.1,CD=5,Alias="skill1"},atk3={T=1,P=0.1,CD=5,Alias="skill2",handler="onrush"},atk4={T=1,P=0.1,CD=5,Alias="skill3",handler="onrush"},atk5={T=0,P=0.1,CD=5,Alias="skill4"}},animalData={bone="roles/10001_s.xml",texture="roles/10001_t.xml",armature="luosir"},actiontype=ACTION_TYPE.GONGJI10001},
	-- 剑云
	[17]={id=17,basehp=230,grouphp=5,attrhp=3,baseatk=4,groupatk=3,attratk=6,def=3,speed=1,skills={},pic="20002.png",name="剑云",scale=1,size={w=100,h=220,offX=0,offY=110,hw=120,},CD=5,AP=1,remote={w=200,atk1={T=0,P=0.6,CD=2},atk2={T=1,P=0.1,CD=5,Alias="skill5",handler="onrush"},atk3={T=1,P=0.1,CD=5,Alias="skill6",handler="onrush"},atk4={T=0,P=0.1,CD=5,Alias="skill7"},atk5={T=0,P=0.1,CD=5,Alias="skill8"}},animalData={bone="roles/10002_s.xml",texture="roles/10002_t.xml",armature="jianyun"},actiontype=ACTION_TYPE.GONGJI10002},
	-- Darker
	[18]={id=18,basehp=310,grouphp=6,attrhp=2,baseatk=4,groupatk=4,attratk=4,def=3,speed=1,skills={},pic="20003.png",name="Darker",scale=1,size={w=100,h=220,offX=0,offY=110,hw=220,},CD=5,AP=1,remote={s=500,atk1={T=0,P=0.6,CD=2},atk2={T=0,P=0.1,CD=5,Alias="skill9"},atk3={T=0,P=0.1,CD=5,Alias="skill10"},atk4={T=1,P=0.1,CD=5,Alias="skill11",handler="onrush"},atk5={T=1,P=0.1,CD=5,Alias="skill12",handler="onrush"}},animalData={bone="roles/10003_s.xml",texture="roles/10003_t.xml",armature="darker"},actiontype=ACTION_TYPE.GONGJI10003},

	-- 坦克（大胖）
	[19]={id=19,basehp=210,grouphp=3,attrhp=1,baseatk=6,groupatk=2,attratk=4,def=2,speed=0,skills={},pic="202018.png",name="坦克",scale=1,size={w=100,h=190,offX=0,offY=85,hw=150},remote={s=500,atk1={T=0,P=0.5,CD=2},atk2={T=1,P=0.5,CD=3,handler="onrush"}},animalData={bone="roles/10206_s.xml",texture="roles/10206_t.xml",armature="10206",skinId=1},actiontype=ACTION_TYPE.GONGJI10206},
	-- Joker
	[20]={id=20,basehp=900,grouphp=6,attrhp=1,baseatk=13,groupatk=2,attratk=3,def=2,speed=1,skills={},pic="203020.png",name="Joker",scale=1,size={w=120,h=260,offX=0,offY=85,hw=150},remote={w=300,atk1={T=1,P=0.5,CD=2,handler="hdist"},atk2={T=0,P=0.5,CD=1}},animalData={bone="roles/10309_s.xml",texture="roles/10309_t.xml",armature="10309",skinId=1},actiontype=ACTION_TYPE.GONGJI10309},
	-- 疯狂的麦克斯
	[21]={id=21,basehp=700,grouphp=6,attrhp=1,baseatk=12,groupatk=2,attratk=3,def=2,speed=2,skills={},pic="203021.png",name="疯狂的麦克斯",scale=1,size={w=150,h=230,offX=0,offY=85,hw=-1},remote={s=500,atk1={T=1,P=0.5,CD=2,handler="onrush|closeDist"},atk2={T=1,P=0.5,CD=3,handler="jump|closeDist"}},animalData={bone="roles/103010_s.xml",texture="roles/103010_t.xml",armature="103010",skinId=1},actiontype=ACTION_TYPE.GONGJI103010},
	-- 企业战士（枪手）
	[22]={id=22,basehp=130,grouphp=3,attrhp=1,baseatk=8,groupatk=3,attratk=2,def=1.2,speed=1,skills={},pic="201022.png",name="企业战士",scale=1.05,size={w=100,h=200,offX=-300,offY=85,hw=-1},remote={w=0.5,atk={T=1,P=1,CD=5,AP=6,handler="hdist"}},animalData={bone="roles/10108_s.xml",texture="roles/10108_t.xml",armature="10108",skinId=1}},
	-- 偷袭者
	[23]={id=23,basehp=130,grouphp=3,attrhp=1,baseatk=6,groupatk=3,attratk=2,def=1.2,speed=2,skills={},pic="201023.png",name="偷袭者",scale=1,size={w=100,h=170,offX=0,offY=85,hw=280},CD=1.5,AP=1,PFlee=1,animalData={bone="roles/10103_s.xml",texture="roles/10103_t.xml",armature="10103",skinId=1}},
	-- 骸骨僵尸
	[24]={id=24,basehp=138,grouphp=5,attrhp=1,baseatk=8,groupatk=3,attratk=2,def=1.5,speed=0,skills={},pic="202024.png",name="骸骨僵尸",scale=1.05,size={w=100,h=200,offX=0,offY=85,hw=300},CD=1,AP=5,remote={s=300,atk1={T=0,P=0.5,CD=2},atk2={T=1,P=0.5,CD=2,handler="jump"}},animalData={bone="roles/10205_s.xml",texture="roles/10205_t.xml",armature="10205",skinId=1},actiontype=ACTION_TYPE.GONGJI10205},
	-- 不灭男爵
	[25]={id=25,basehp=140,grouphp=5,attrhp=1.3,baseatk=7.8,groupatk=3,attratk=2.6,def=1.5,speed=1,skills={},pic="202025.png",name="不灭男爵",scale=1,size={w=100,h=230,offX=0,offY=85,hw=360},CD=2,remote={w=300,atk1={T=0,P=0.5,CD=2},atk2={T=1,P=0.5,CD=3,handler="hdist"}},animalData={bone="roles/10207_s.xml",texture="roles/10207_t.xml",armature="10207",skinId=1},actiontype=ACTION_TYPE.GONGJI10207},
	--新人物待调整数值
	-- 十三妹
	[26]={id=26,basehp=220,grouphp=6,attrhp=1,baseatk=11,groupatk=2,attratk=3,def=1.5,speed=2,skills={},pic="202016.png",name="十三妹",scale=1,size={w=100,h=215,offX=0,offY=85,hw=170},CD=2,animalData={bone="roles/102012_s.xml",texture="roles/102012_t.xml",armature="102012"},actiontype=ACTION_TYPE.GONGJI102012},
	-- 梦瑶
	[27]={id=27,basehp=1000,grouphp=6,attrhp=1,baseatk=10,groupatk=7,attratk=6,def=2,speed=2,skills={},pic="203017.png",name="梦瑶",scale=1,size={w=100,h=215,offX=0,offY=85,hw=300},CD=2,remote={s=400,atk1={T=1,P=0.25,CD=2,handler="hvdist"},atk2={T=0,P=0.25,CD=2},atk3={T=1,P=0,CD=0.25,handler="hdist"},atk4={T=1,P=0.25,CD=5,handler="hdist"}},animalData={bone="roles/103013_s.xml",texture="roles/103013_t.xml",armature="103013"},actiontype=ACTION_TYPE.GONGJI103013},
	-- 蛮狱屠夫
	[28]={id=28,basehp=230,grouphp=6,attrhp=1,baseatk=12,groupatk=2,attratk=3,def=1.5,speed=0,skills={},pic="202019.png",name="蛮狱屠夫",scale=1,size={w=100,h=215,offX=0,offY=85,hw=300},CD=2,remote={s=300,atk1={T=0,P=0.5,CD=2,handler="hdist"},atk2={T=1,P=0.5,CD=2,handler="jump"}},animalData={bone="roles/102014_s.xml",texture="roles/102014_t.xml",armature="102014"},actiontype=ACTION_TYPE.GONGJI102014},
	-- 补给道具
	--垃圾桶
	[50115]={id=50115,basehp=100,grouphp=1,attrhp=1,baseatk=0,groupatk=0,attratk=0,def=1,speed=0,skills={},name="roadblock",size={w=90,h=136,offX=0,offY=105,hw=120},img="block/50115.png",type=OBJ_TYPE.ITEM},
	--轮胎
	[50116]={id=50116,basehp=100,grouphp=1,attrhp=1,baseatk=0,groupatk=0,attratk=0,def=1,speed=0,skills={},name="roadblock",size={w=130,h=201,offX=0,offY=105,hw=120},img="block/50116.png",type=OBJ_TYPE.ITEM},
	--汽油桶
	[50117]={id=50117,basehp=100,grouphp=1,attrhp=1,baseatk=0,groupatk=0,attratk=0,def=1,speed=0,skills={},name="roadblock",size={w=125,h=169,offX=0,offY=105,hw=120},img="block/50117.png",type=OBJ_TYPE.ITEM},
}

return npc