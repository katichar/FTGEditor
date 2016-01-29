-- 剧情对话具体动画实现
local func = {}

-- 记录临时NPC
func.subg1={}
func.subg2={}
func.subg3={}
func.subg4={}
func.subg5={}

-- 1—— 开始
function func.before_subg_1()
	g_fight.istory=true

	func.subg1.role = g_RoleManager.addPlayer(300,100)
	g_RoleManager.addNPC({npcid=1,lvl=1,time=0,x=-20,y=200})
	g_RoleManager.addNPC({npcid=1,lvl=1,time=0,x=-20,y=200})
	g_RoleManager.addNPC({npcid=1,lvl=1,time=0,x=10,y=200})
	g_RoleManager.addNPC({npcid=1,lvl=1,time=0,x=10,y=200})
	
	func.subg1.boss = g_RoleManager.addNPC({npcid=4,lvl=1,time=0,x=10,y=100})
	func.subg1.boss.action:pauseAction()
	func.subg1.boss:stand()
	
	local function next()
		g_Plot.endFunc()
		-- 只有before需要调用
		g_Plot.showDialog(false)
	end

	g_Timer.callAfter(next,3)
end

-- 1-2
function func.after_subg_2()

	func.subg1.boss.action.huntObj=nil
	func.subg1.boss.action:moveTo(1500,200)

	local function next()
		func.subg1.boss:cleanSelf()
		func.subg1.boss = nil
		g_Plot.endFunc()
	end

	g_Timer.callAfter(next,4)

end

-- 1 - 结束
function func.after_subg_1()
	g_Plot.ui:hide()
	local sec = 0
	--增加玩家在剧情中需要的技能
	if g_User.roleinfo.type == OBJ_TYPE.LUOFEI then
		func.subg1.role:addSkill(2) 
		func.subg1.role:updateSkillConfig()
		func.subg1.role:skill(2)
		sec = 3
	elseif g_User.roleinfo.type == OBJ_TYPE.DARKER then
		func.subg1.role:addSkill(12) 
		func.subg1.role:updateSkillConfig()
		func.subg1.role:skill(12)
		sec = 6
	end

	local function next()
		g_Plot.destroyPlot()
	end

	g_Timer.callAfter(next,sec)
end

return func