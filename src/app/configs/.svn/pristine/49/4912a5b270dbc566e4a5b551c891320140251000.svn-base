-- 数据字典配置文件

-- tag:标签
-- descr:中文描述
-- basevalue:基础值
local data = {
	hp={tag="hp",name="生命",descr="生命",basevalue="100",upvalue="1.1"},
	atk={tag="atk",name="攻击",descr="攻击",basevalue="100",upvalue="1.1"},
	def={tag="def",name="防御",descr="防御",basevalue="100",upvalue="1.1"},
	mp={tag="mp",name="精神",descr="精神",basevalue="100",upvalue="1.1"},
	luck={tag="luck",name="幸运",descr="幸运",basevalue="1",upvalue="1"},
	
	-- 特殊属性
	restoremp={tag="restoremp",name="魔法恢复",descr="魔法恢复",basevalue="1",upvalue="1"},
	critchance={tag="critchance",name="暴击几率",descr="暴击几率",basevalue="0.01",upvalue="0.01"},
	critdamage={tag="critdamage",name="暴击伤害",descr="暴击伤害",basevalue="0.01",upvalue="0.05"},
	atkp={tag="atkp",name="攻击",descr="攻击",basevalue="0.01",upvalue="0.05"},
	hpp={tag="hpp",name="生命",descr="生命",basevalue="0.01",upvalue="0.05"},
	mpp={tag="mpp",name="精神",descr="精神",basevalue="0.01",upvalue="0.05"},
	defp={tag="defp",name="防御",descr="防御",basevalue="0.01",upvalue="0.05"},


	lvl={tag="lvl",name="等级",descr="等级",basevalue="1",upvalue="1"},
	roletype={tag="roletype",name="职业",descr="职业",basevalue="1",upvalue="1"},
}

--货币单位
data.CURRENCY={
	[CURRENCY.DIAMOND]={tag=CURRENCY.DIAMOND,name="钻石",descr="钻石"},
	[CURRENCY.GOLD]={tag=CURRENCY.GOLD,name="金币",descr="金币"},
	[CURRENCY.RMB]={tag=CURRENCY.RMB,name="人民币",descr="人民币"},
}

--装备类型
data.EQUIP_TYPE={
	[EQUIP_TYPE.QUANTAO]={tag=EQUIP_TYPE.QUANTAO,name="拳套",descr="拳套"},
	[EQUIP_TYPE.DAOJIAN]={tag=EQUIP_TYPE.DAOJIAN,name="刀剑",descr="刀剑"},
	[EQUIP_TYPE.ZHUA]={tag=EQUIP_TYPE.ZHUA,name="爪",descr="爪"},
}

-- 品阶类型
data.EQUIP_QUALITY = {
	[EQUIP_QUALITY.D] = {tag=EQUIP_QUALITY.D,name="普通",descr="普通"},
	[EQUIP_QUALITY.C] = {tag=EQUIP_QUALITY.C,name="优秀",descr="优秀"},
	[EQUIP_QUALITY.B] = {tag=EQUIP_QUALITY.B,name="精良",descr="精良"},
	[EQUIP_QUALITY.A] = {tag=EQUIP_QUALITY.A,name="史诗",descr="史诗"},
	[EQUIP_QUALITY.S] = {tag=EQUIP_QUALITY.S,name="传说",descr="传说"},
}

--角色类型
data.OBJ_TYPE={
	[OBJ_TYPE.LUOFEI]={tag=OBJ_TYPE.LUOFEI,name="罗飞",descr="罗飞"},
	[OBJ_TYPE.JIANYUN]={tag=OBJ_TYPE.JIANYUN,name="剑云",descr="剑云"},
	[OBJ_TYPE.DARKER]={tag=OBJ_TYPE.DARKER,name="Darker",descr="Darker"},
}

--根据Tag，key值返回描述
function data.getDescrByKey(i_Tag,i_Key)
	local result = ""
	if i_Tag and i_Key then
		local tmpdata = data[string.upper(i_Tag)]
		if tmpdata then
			result = tmpdata[i_Key].descr or ""
		end
	end
	return result
end

--根据Tag，key值返所有字段信息
function data.getInfoByKey(i_Tag,i_Key)
	local result = {}
	if i_Tag and i_Key then
		local tmpdata = data[string.upper(i_Tag)]
		if tmpdata then
			result = tmpdata[i_Key]
		end
	end
	return result
end

-- 根据Tag,返回描述
function data.getDescr(i_Tag)
	local result=""
	if i_Tag then
		local tmpdata = data[i_Tag]
		if tmpdata then
			result = tmpdata.descr
		end
	end
	return result
end

return data