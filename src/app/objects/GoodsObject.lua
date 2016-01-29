--
-- Author: rsma
-- Date: 2015-09-07 19:14:54
--
require("app.objects.BaseRole")
require("app.objects.controller.NPCActionController")
require("app.objects.controller.NPCFightController")
GoodsObject = class("GoodsObject", BaseRole)
function GoodsObject:ctor(i_RoleID)
	GoodsObject.super.ctor(self,i_RoleID)
	self.name="Goods"
  self.enable=true
end
function GoodsObject:buildAnimal(i_info)
	self.itemInfo=i_info
	-- self.roleinfo = i_info
 --    self.roleid=i_info.roleid
 --    self.roleType=i_info.type
 --    self.actiontype=i_info.actiontype or ACTION_TYPE.GONGJIA
 --    self.offSpeed=i_info.speed or 0
 --    self.isBoss = self.roleType==OBJ_TYPE.BOSS
 --    self.HP=i_info.hp or 0
 --    self.MaxHP=self.HP
 --    self.MP=i_info.mp or 0
 --    self.def=i_info.def or 0
 --    self.avoidinjury=i_info.avoidinjury or USER_DEFAULT.AVOIDINJURY
 --    self.atk=i_info.atk or 0
 --    i_info.size.raw = i_info.size.raw or 0
    self.size = {w=200,h=50,offX=0,offY=25,hw=-1}
    self.size.R=0
    self.size.RW=0
    self.size.S = 0
    self.colorinfo={[1]=cc.c3b(227, 227, 227),
    			    [2]=cc.c3b(0, 255, 7),
    			    [3]=cc.c3b(0, 141, 255),
    			    [4]=cc.c3b(219, 0, 255),
    				[5]=cc.c3b(255, 134, 0),}
    if i_info.name then
      self.lblName = self:createNameLable(i_info)
		  self.lblName:align(display.CENTER)
		  self:addChild(self.lblName,-1)
    end
	self.animalObj = display.newSprite("icons/" .. i_info.image)
	-- self.animalObj:align(display.CENTER_BOTTOM)
  self.animalObj:setPosition(0,self.size.h*0.5)
	-- self.animalObj:setScaleX(-1)
	self:addChild(self.animalObj)
end
function GoodsObject:createNameLable(i_info)
  local label=cc.ui.UILabel.new({
        UILabelType = 2,
        text = i_info.name,
        size = 14,
        color = self.colorinfo[i_info.quality], -- 使用纯红色
        align = cc.TEXT_ALIGNMENT_CENTER,
        valign = cc.VERTICAL_TEXT_ALIGNMENT_TOP,
    })
  local w,h = label:getComponent("components.ui.LayoutProtocol"):getLayoutSize()
  -- label:setPosition(-w*0.5, 50)
  w=w+10
  h=h+10
  label:align(display.CENTER, w*0.5, h*0.5)
  local lblBG = display.newScale9Sprite("common/c_item_name_bg.png", 0, 80, cc.size( w,h))
  lblBG:addChild(label)
  return lblBG
end
function GoodsObject:setShadow()
  if not self.lblName then
  	return
  end
  local vshStr = "attribute vec4 a_position;\n"
  vshStr = vshStr .. "attribute vec2 a_texCoord;\n"
  vshStr = vshStr .. "varying vec2 v_texCoord;\n"
  vshStr = vshStr .. "void main()\n"
  vshStr = vshStr .. "{\n" .. "gl_Position = CC_PMatrix * a_position;\n"
  vshStr = vshStr .. "v_texCoord = a_texCoord;\n}"
  local fshStr = "varying vec2 v_texCoord;\n"
  fshStr = fshStr .. "vec4 composite(vec4 over, vec4 under)\n"
  fshStr = fshStr .. "{\nreturn over + (1.0 - over.a)*under;\n}\n"
  fshStr = fshStr .. "void main(){\n"
  fshStr = fshStr .. "vec2 shadowOffset = vec2(0.06, 0.03);\n"
  fshStr = fshStr .. "vec4 textureColor = texture2D(CC_Texture0, v_texCoord + shadowOffset);\n"
  fshStr = fshStr .. "float shadowMask = texture2D(CC_Texture0, v_texCoord ).a;\n"
  fshStr = fshStr .. "const float shadowOpacity = 0.8;\n"
  fshStr = fshStr .. "vec4 shadowColor = vec4(0,0,0,shadowMask *shadowOpacity);\n"
  fshStr = fshStr .. "gl_FragColor = composite(textureColor, shadowColor);\n}"
  local pProgram = cc.GLProgram:createWithByteArrays(vshStr,fshStr)
  pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_POSITION, cc.VERTEX_ATTRIB_POSITION);
  pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_COLOR, cc.VERTEX_ATTRIB_COLOR);
  pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_TEX_COORD, cc.VERTEX_ATTRIB_TEX_COORDS);
  pProgram:link()
  pProgram:updateUniforms();
  self.animalObj:setGLProgram(pProgram)
  if not self.shadow then
    self.shadow = display.newSprite("roles/shadow.png")
    self.shadow:setScale(0.3)
    self:addChild(self.shadow,-1)
    self.shadow:setPosition(0,15)
  end
end
function GoodsObject:show()
	self:setLocalZOrder(g_Map.getMapZorderY()-self.pos.y)
	self.standLine = self.pos.y
	self:setVisible(false)
	local mox=60*math.random(-1,1)
	if self.pos.x+mox>=g_Map.getMapRight()-display.width*0.1 then
            mox = -math.abs(g_Map.getMapRight()-display.width*0.1-self.pos.x)
    elseif self.pos.x+mox<=g_Map.getMapLeft() then
            mox = 100
    end
	local i_FightAttr = FightAttribute.new({effect="dropGoods", fx=mox, fy=120})
	local effhandler = g_fight.buildEffectHandler(i_FightAttr)
	self.inApplyForce = true
	effhandler(self,function()
			self.collider:enable()
			self.inApplyForce = false
		end)
end
function GoodsObject:pickup(i_Picker)
  if not tolua.isnull(self.lblName) then
    self.lblName:setVisible(false)
  end
  local mxx=0
  if i_Picker.pos.x>self.pos.x then
    mxx=50
  elseif i_Picker.pos.x<self.pos.x then
    mxx=-50
  end
  local i_FightAttr = FightAttribute.new({effect="pickupGoods", fx=mxx, fy=90})
  local effhandler = g_fight.buildEffectHandler(i_FightAttr)
  self.inApplyForce = true
  effhandler(self,function()
      if self.itemInfo.type == nil then
        i_Picker:showEquip(self:createNameLable(self.itemInfo))
      end
      self.inApplyForce = false
      self:dead()
    end)
end
function GoodsObject:addController()
	self.action = NPCActionController.new(self)
	self.fight  = NPCFightController.new(self)
	self.collider  = ColliderController.new(self,self.group)
end
---开始碰撞
function GoodsObject:beginCollision(i_myShape,i_targetShape)
  if self.enable==false then
    return
  end
	if g_engine.getShapeType(i_myShape) == g_engine.ShapeType.Hurt and g_engine.getShapeType(i_targetShape) == g_engine.ShapeType.Hunt then
		local role = g_engine.getRoleByShape(i_targetShape)
		-- if role and role:isFighting()==false and role.currState~=FIGHT_STATE.attack and (role.currState == FIGHT_STATE.stand or role.currState == FIGHT_STATE.run) then
    if role and not tolua.isnull(role) and role:checkDead()==false then
			local item = g_engine.getRoleByShape(i_myShape)
			if item.itemInfo.type and item.itemInfo.type == ITEM_TYPE.FOOD then
        local hp,mp=g_User.roleinfo.hp*item.itemInfo.hp,g_User.roleinfo.mp*item.itemInfo.mp
        g_RoleManager.addHealth(hp,mp)
      else
        g_DB.addEquip(item.itemInfo,g_User.userid)
      end
      self.enable=false
      self:pickup(role)
		end
	end
end
function GoodsObject:gotoFightState(i_State)end
function GoodsObject:addListener()end
function GoodsObject:removeListener()end
function GoodsObject:changeAction(PActionName)end
function GoodsObject:canBeAttacked(i_tarRole)
	return false
end
function GoodsObject:isFighting()
    return false
end
function GoodsObject:canApplyFroce()
	return false
end
function GoodsObject:playslow(i_flag)end
function GoodsObject:pauseAction()
    self.isPause=true
end

function GoodsObject:resumeAction()
    self.isPause=false
end

function GoodsObject:changeDirc(PDirc)
    if self.dirc == PDirc then
        return
    end
    self.dirc = PDirc
end

function GoodsObject:dead()
	GoodsObject.super.dead(self)
	g_Timer.callAfter(function()
			self:cleanSelf(false)
		end,0.1)
end