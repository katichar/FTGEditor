--
-- Author: rsma
-- Date: 2015-12-08 17:14:43
--
require("app.items.BoneInfo")
require("app.items.AnimationInfo")
require("app.items.FrameEvent")
local parser = {}
function parser.parseXMLFile(PRoleID,PFileName,PFilePath)
	PFilePath = "C:\\WorkSpace\\Demo\\ftg\\res\\"
	local bone = BoneInfo.new()
	local xml = g_XML.newParser()
	local parsedXml = xml:loadFile(PFileName,PFilePath)
	bone.name = (parsedXml.dragonBones['@name'])
	bone.animations = {}
	local animations = parsedXml.dragonBones.armature.animation
	if not animations then
		animations = parsedXml.dragonBones.armature[1].animation
	end
	for i=1,#animations,1 do
		local animation = AnimationInfo.new()
		animation.name = animations[i]['@name']
		animation.loop = animations[i]['@loop']
		animation.events = {}
		local events=animations[i].frame
		if events then
			for m=1,#events,1 do
				if events[m]['@event'] then
					local event = FrameEvent.new()
					event.name = events[m]['@event']
					local prop = parser.getSkillConfig(PRoleID,animation,animation.name,event.name)
					event:parser(prop)
					table.insert(animation.events, event)
				end
			end
		end
		table.insert(bone.animations, animation)
	end
	return bone
end

function parser.getSkillConfig(RoleID,PAnimationInfo,actionName,frameEvent)
	local skillcfg=nil
	local currState
	if g_Items.excfg[RoleID] then
        for  state,acts in pairs(g_Items.excfg[RoleID]) do
            for _,actname in pairs(acts) do
                if actname == PAnimationInfo.name then
                    currState = state
                    break
                end
            end
        end
    end
    local i_info = clone(g_RoleConfig[RoleID])
    if i_info then
    	actiontype = i_info.actiontype or ACTION_TYPE.GONGJIA
    end
    local prop
    if ACTION_SHAPE[currState] and ACTION_SHAPE[currState][actionName] and ACTION_SHAPE[currState][actionName][frameEvent] then
        prop = ACTION_SHAPE[currState][actionName][frameEvent]
    elseif ACTION_SHAPE[actionName] and ACTION_SHAPE[actionName][actiontype] and ACTION_SHAPE[actionName][actiontype][frameEvent] then
        prop = ACTION_SHAPE[actionName][actiontype][frameEvent]
    elseif ACTION_SHAPE[actionName] and ACTION_SHAPE[actionName][frameEvent] then
        prop = ACTION_SHAPE[actionName][frameEvent]
    end
    return prop
end
return parser