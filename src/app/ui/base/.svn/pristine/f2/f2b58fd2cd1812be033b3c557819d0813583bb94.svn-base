-- 通讯加载动画

local loadingmanager={}

loadingmanager.isbusy = false

-- 初始化
local function init()
	g_EventManager.addListener(MESSAGE_EVENT.NETWORK_ERROR,loadingmanager.onRemove)
	g_EventManager.addListener(MESSAGE_EVENT.LOADING_REMOVE,loadingmanager.onRemove)
end

-- 移除
function loadingmanager.onRemove()
	if loadingmanager.loading then
		if loadingmanager.loading.animalObj then
			loadingmanager.loading.animalObj:getAnimation():stop()
		end
		if not tolua.isnull(loadingmanager.loading) then
			loadingmanager.loading:removeSelf()
		end
	end
	loadingmanager.loading = nil
	loadingmanager.isbusy = false
end

-- 显示loading界面
function loadingmanager.showLoading()
	if loadingmanager.isbusy then
		return
	end
	loadingmanager.isbusy = true

	loadingmanager.loading = g_BasePopUI.new()
	local factory = db.DBCCFactory:getInstance()
    factory:loadDragonBonesData("effects/600110_s.xml", "600110");
    factory:loadTextureAtlas("effects/600110_t.xml", "600110");
    loadingmanager.loading.animalObj = factory:buildArmatureNode("600110_loading")
    loadingmanager.loading:addChild(loadingmanager.loading.animalObj)
    loadingmanager.loading.animalObj:setPosition(display.cx,display.cy)
    loadingmanager.loading.animalObj:getAnimation():gotoAndPlay("600110_loading")
    loadingmanager.loading.animalObj:hide()
    --	显示的层
    local target=display.getRunningScene()
    if type(g_LayerManager.getLayerByName) == "function" then
    	target=g_LayerManager:getLayerByName("uieffect")
    end
	target:addChild(loadingmanager.loading)

	--	3秒后显示动画
	loadingmanager.loading.animalObj:performWithDelay(handler(loadingmanager.loading.animalObj,loadingmanager.loading.animalObj.show), 3)

	--	30秒后自动消失
	loadingmanager.loading:performWithDelay(loadingmanager.onRemove, 30)
end

init()

return loadingmanager