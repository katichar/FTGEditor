--
-- Author: rsma
-- Date: 2015-12-08 18:15:10
--
local panel = class("FightPanel", function()
		return cc.Node:create()
	end)
function panel:ctor()
    self.playslow=false
	self.buildRole=false
	self.lvH = cc.ui.UIListView.new {
        bgColor = cc.c4b(0, 0, 255, 255),
        viewRect = cc.rect(0, 0, display.width-20, 80),
        direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL,
        scrollbarImgH = "ui/barH.png"}
        :onTouch(handler(self, self.touchListener))
        :align(display.BOTTOM_CENTER, -(display.width-20)*0.5, display.height-160-30)
        :addTo(self)
	local shape4 = display.newRect(cc.rect(-300, 0, 600, display.height-160-30-5),
        {fillColor = cc.c4f(1,0,0,0), borderColor = cc.c4f(1,0,0,1), borderWidth = 1})
    self:addChild(shape4, -1)
    self:reload()
    self.checkBoxButton1 = cc.ui.UICheckBoxButton.new(CHECKBOX_BUTTON_IMAGES)
        :setButtonLabel(cc.ui.UILabel.new({text = "慢放", size = 22,  color = cc.c3b(255, 0, 0)}))
        :setButtonLabelOffset(-120, 0)
        :setButtonLabelAlignment(display.CENTER)
        :onButtonStateChanged(function(event)
            self.playslow=(not self.playslow)
        end)
        :align(display.LEFT_CENTER, 300-180, display.height-160-30-5-25)
        :addTo(self)
end
function panel:touchListener(event)
    local listView = event.listView
    if "clicked" == event.name then
    elseif "moved" == event.name then
        self.bListViewMove = true
    elseif "ended" == event.name then
        self.bListViewMove = false
    end
end
function panel:reload()
	g_Items.reload()
	for i=1,#g_Items.data,1 do
		local item = self.lvH:newItem()
		item.data=g_Items.data[i]
        local content = cc.ui.UIPushButton.new("ui/GreenButton.png", {scale9 = true})
                :setButtonSize(100, 80)
                :setButtonLabel(cc.ui.UILabel.new({text = g_Items.data[i].name, size = 16, color = display.COLOR_BLUE}))
                :onButtonPressed(function(event)
                    event.target:getButtonLabel():setColor(display.COLOR_RED)
                end)
                :onButtonRelease(function(event)
                    event.target:getButtonLabel():setColor(display.COLOR_BLUE)
                end)
                :onButtonClicked(function(event)
                    self:addRole(item.data)
                end)
        item:addContent(content)
        item:setItemSize(120, 80)
        self.lvH:addItem(item)
	end
	self.lvH:reload()
end
function panel:addRole(RoleInfo)
	if self.buildRole==true then
		return
	end
	if self.role then
		self.role:removeSelf()
	end
    dump(RoleInfo)
	self.role=nil
	self.buildRole=true
	self.boneInfo = g_Parser.parseXMLFile(RoleInfo.id,RoleInfo.boneFile,RoleInfo.path)
	-- local factory = db.DBCCFactory:getInstance()
	-- factory:loadDragonBonesData('roles/' .. RoleInfo.boneFile, self.boneInfo.name);
 --    factory:loadTextureAtlas('roles/' .. RoleInfo.textureFile, self.boneInfo.name);
 --    self.animalObj = factory:buildArmatureNode(self.boneInfo.name) --DBCCArmatureNode
 --    self:addChild(self.animalObj)
    self.buildRole=false
    if self.changeFunc then
    	self.changeFunc()
    end
    if RoleInfo.type == "Role" then
    	self.role = g_RoleMgr.buildRole1(RoleInfo.id,self)
    elseif RoleInfo.type == "NPC" then
    	self.role = g_RoleMgr.buildNPC1(RoleInfo.id,self)
    end
end
function panel:changeAction(PAnimationInfo)
    self.role.currState=nil
    if g_Items.excfg[self.role.id] then
        for  state,acts in pairs(g_Items.excfg[self.role.id]) do
            for _,actname in pairs(acts) do
                if actname == PAnimationInfo.name then
                    self.role.currState = state
                    break
                end
            end
        end
    end
    self.role:playslow(self.playslow)
    -- self.role:changeAction(PAnimationInfo.name)
	self.role.animalObj:getAnimation():gotoAndPlay(PAnimationInfo.name)
end
return panel