--
-- Author: rsma
-- Date: 2015-12-08 16:00:11
--
local items={}
items.data={
}
items.excfg={
	[1]={
		skill1={"jineng2"},
		skill2={"jineng1"},
		skill3={"jineng3_1","jineng3_2"},
		skill4={"jineng4_1","jineng4_2","jineng4_3","jineng4_4","jineng4_5","jineng4_"},
	},
	[2]={
		skill5={"jineng1_2"},
		skill6={"jineng2"},
		skill7={"jineng3_1","jineng3_2","jineng3_3"},
		skill8={"jineng4_1","jineng4_2","jineng4_3","jineng4_4"},
	},
	[3]={
		skill9={"jineng1_1","jineng1_2","jineng1_3"},
		skill10={"jineng2_1","jineng2_2","jineng2_3"},
		skill11={"jineng3_1","jineng3_2","jineng3_3"},
		skill12={"jineng4_2","jineng4_3"},
	},
}
function items.reload()
	items.data={}
	for vid,vobj in pairs(g_RoleConfig) do
		local role={id=vid,type="Role",pic=vobj.pic,name=vobj.animalData.armature,boneFile=vobj.animalData.bone,textureFile=vobj.animalData.texture}
		table.insert(items.data, role)
	end
	for vid,vobj in pairs(g_NPC) do
		if vobj.animalData then
			local role={id=vid,type="NPC",pic=vobj.pic,name=vobj.name,boneFile=vobj.animalData.bone,textureFile=vobj.animalData.texture}
			table.insert(items.data, role)
		end
	end
end
return items