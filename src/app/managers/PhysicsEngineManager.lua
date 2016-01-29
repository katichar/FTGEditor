--
-- Author: rsma
-- Date: 2015-05-20 10:25:15
--
local engine = {}
engine.GRAVITY    = 0---200
engine.MASS       = 0--100
engine.FRICTION   = 0--0.8
engine.ELASTICITY = 0--0.8
engine.WALL_THICKNESS  = 0--64
engine.WALL_FRICTION   = 0--1.0
engine.WALL_ELASTICITY = 0--0.5

engine.initFlag = false

engine.ROLE_GROUP = 0
engine.NPC_GROUP  = 0
engine.ShapeType={
    none=-1,
	Hunt = 1,
	Attack = 2,
	Hurt = 3,
    Remote = 4,
}
engine.Category={
    Role=2, -- 0x1<<1
    NPC=4,  -- 0x1<<2
}

function engine.init(i_Scene)
    if engine.initFlag then
        return
    end
    engine.initFlag=true
	engine.world = i_Scene:getPhysicsWorld()
	engine.scene = i_Scene
	engine.world:setGravity(cc.p(0, g_engine.GRAVITY))
	engine.world:setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL)
    -- engine.addWallBody()
	engine.setupEvent()
end
function engine.destroy()
    engine.unsetupEvent()
    engine.initFlag=false
    engine.world=nil
    engine.scene=nil

end
function engine.addWallBody()
    local wallBox = display.newNode()
    wallBox:setAnchorPoint(cc.p(0.5, 0.5))
    wallBox:setPosition(display.cx,90)
    local body = cc.PhysicsBody:createEdgeBox(cc.size(display.width-100, 180))
    -- wallBox:setPhysicsBody(body)
    g_LayerManager.childs.objslayer:addChild(wallBox)
end
function engine.removeShape(RoleA,RoleB)
    RoleA:removeShape()
    RoleB:removeShape()
end
function engine.setupEvent()
	engine.listener  = cc.EventListenerPhysicsContact:create()
    engine.listener:registerScriptHandler(function(contact)
        local objA = g_engine.getRoleByShape(contact:getShapeA())
        local objB = g_engine.getRoleByShape(contact:getShapeB())
        if g_fight.gameOver == true then
            if objA and objA.name == "Goods" then
                objA:beginCollision(contact:getShapeA(),contact:getShapeB())
            elseif objB and objB.name == "Goods" then
                objB:beginCollision(contact:getShapeB(),contact:getShapeA())
            end
            return
        end
        -- print("Begin Contace",objA.name,objB.name,g_engine.getShapeType(contact:getShapeA()),g_engine.getShapeType(contact:getShapeB()))
        -- if objA and objB and objA:checkDead()==false and objB:checkDead()==false then
        if objA and objB then
            objA:beginCollision(contact:getShapeA(),contact:getShapeB())
            objB:beginCollision(contact:getShapeB(),contact:getShapeA())
        end
        return true
    end, cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)

    engine.listener:registerScriptHandler(function(contact, solve)
        -- print("contactPresolve", "-----------", type(contact), type(solve))
        return true
    end, cc.Handler.EVENT_PHYSICS_CONTACT_PRESOLVE)

    engine.listener:registerScriptHandler(function(contact, solve)
        -- print("contactPostsolve", "-----------", type(contact), type(solve))
        return true
    end, cc.Handler.EVENT_PHYSICS_CONTACT_POSTSOLVE)

    engine.listener:registerScriptHandler(function(contact)
        -- if g_fight.gameOver == true then
        --     return
        -- end
        local objA = g_engine.getRoleByShape(contact:getShapeA())
        local objB = g_engine.getRoleByShape(contact:getShapeB())
        -- print("End Contace",objA.name,objB.name,g_engine.getShapeType(contact:getShapeA()),g_engine.getShapeType(contact:getShapeB()))
        -- if objA and objB and objA:checkDead()==false and objB:checkDead()==false then
        if objA and objB then
            objA:endCollision(contact:getShapeA(),contact:getShapeB())
            objB:endCollision(contact:getShapeB(),contact:getShapeA())
        end
    end, cc.Handler.EVENT_PHYSICS_CONTACT_SEPERATE)
    engine.scene:getEventDispatcher():addEventListenerWithSceneGraphPriority(engine.listener, engine.scene)
    -- engine.scene:getEventDispatcher():addEventListenerWithFixedPriority(engine.listener, 1)
end

function engine.unsetupEvent()
    if not tolua.isnull(engine.scene) then
        engine.scene:getEventDispatcher():removeEventListener(engine.listener)
    end
end

function engine.getRoleByShape(i_Shape)
	return i_Shape:getBody():getNode():getParent()
end

function engine.getShapeType(i_Shape)
	return i_Shape:getTag()
end

return engine