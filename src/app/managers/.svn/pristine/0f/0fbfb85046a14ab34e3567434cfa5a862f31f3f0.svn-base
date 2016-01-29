-- 剧情对话管理
-- 剧情对话具体函数管理
g_PlotFunc = require("app.managers.PlotFuncManager")

local plot = {}
plot.func = {
	[1] = {
		before = g_PlotFunc.before_subg_1,
		after = g_PlotFunc.after_subg_1,
		[1] = nil,
		[2] = nil,
		[3] = g_PlotFunc.after_subg_2,
		},
}

-- 显示剧情对话
-- 子关卡ID
function plot.showPlot(i_Subglvl,i_Segment,i_Func,i_Obj,...)
	plot.canShow = true
	plot.subglvl = i_Subglvl
	plot.segment=i_Segment
	plot.info=nil
	if g_Task.plot[i_Subglvl] then
		plot.info = g_Task.plot[i_Subglvl][i_Segment]
	end
	if plot.info and not g_User.getGameLvl()[i_Subglvl] then
		plot.index = 1
		plot.ui = require("app.ui.plot.PlotUI1").new(plot.info,i_Func,i_Obj,...)
		plot.info=plot.ui.info
		g_LayerManager:addPopUI(plot.ui)
	else 
		if i_Func then
			if type(i_Func) == "function" then
				local params = {...}
				if i_Obj then
					table.insert(params,1,i_Obj)
				end
				i_Func(unpack(params))
			end
		end
		return 
	end
	plot.showDialog(true)
end

function plot.isShow(i_Show)
	plot.canShow = i_Show
end

-- @是否调用before
function plot.showDialog(i_IsBefore)
	
	if i_IsBefore and plot.func[plot.subglvl] and plot.func[plot.subglvl].before and plot.index == 1 and type(plot.func[plot.subglvl].before) == "function" then
		plot.isShow(false)
		plot.func[plot.subglvl].before()
	else 
		plot.ui:showDialog(plot.index)
		plot.callFunc()
	end
end

function plot.showNext(i_Index)
	if not plot.ui then return end
	if not plot.canShow then return end 
	
	

	if i_Index == plot.index then
		if not plot.info[plot.index+1] then 
			-- 结束剧情 判断是否还有需要完成的动画
			if plot.func[plot.subglvl] and type(plot.func[plot.subglvl].after) == "function" then
				plot.func[plot.subglvl].after()
			else 
				if plot.segment==2 then
					plot.ui:hide()
					g_UI.bossEndEffect(plot.destroyPlot)
				else
					plot.destroyPlot()
				end
				
			end
		else 
			plot.index = plot.index + 1 
			plot.showDialog(false)
		end
	end
end

function plot.callFunc()
	if plot.func[plot.subglvl] and plot.func[plot.subglvl][plot.index] and type(plot.func[plot.subglvl][plot.index]) == "function" then
		plot.isShow(false)
		plot.func[plot.subglvl][plot.index]()
	else 
		plot.isShow(true)
	end
end

function plot.endFunc()
	plot.isShow(true)
	--plot.showDialog(false)
end

function plot.destroyPlot()
	if plot.ui then
		plot.ui:removeSelf()
		plot.ui=nil
	end
	g_fight.istory=false
end

return plot