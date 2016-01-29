-- 属性配置文件

local data={}

data[EQUIP_INDEX.WEAPONS] = {
	[1]={attrid=1,type="atk",basevalue="20",upvalue="85",formula="+",version=2},
	[2]={attrid=2,type="hp",basevalue="10",upvalue="4",formula="+",version=2},
	[3]={attrid=3,type="mp",basevalue="10",upvalue="5",formula="+"},
	[4]={attrid=4,type="luck",basevalue="1",upvalue="1",formula="+"},

	[5]={attrid=5,type="atkp",basevalue="2",upvalue="1",formula="+",version=2},
	[6]={attrid=6,type="hpp",basevalue="1",upvalue="1",formula="+",version=2},
	[7]={attrid=7,type="mpp",basevalue="2",upvalue="2",formula="+"},

	[8]={attrid=8,type="critchance",basevalue="1",upvalue="0.2",formula="+",version=2},
	[9]={attrid=9,type="critdamage",basevalue="5",upvalue="3.5",formula="+"},
}

data[EQUIP_INDEX.BODY] = {
	[1]={attrid=1,type="def",basevalue="20",upvalue="50",formula="+"},
	[2]={attrid=2,type="hp",basevalue="10",upvalue="4",formula="+",version=2},
	[3]={attrid=3,type="mp",basevalue="10",upvalue="5",formula="+"},
	[4]={attrid=4,type="hpp",basevalue="1",upvalue="1",formula="+",version=2},
	[5]={attrid=5,type="mpp",basevalue="2",upvalue="2",formula="+"},
	[6]={attrid=6,type="defp",basevalue="2",upvalue="2",formula="+"},
	[7]={attrid=7,type="critchance",basevalue="1",upvalue="0.5",formula="+",version=2},
}

data[EQUIP_INDEX.HEAD] = {
	[1]={attrid=1,type="hp",basevalue="20",upvalue="110",formula="+",version=2},
	[2]={attrid=2,type="def",basevalue="10",upvalue="5",formula="+"},
	[3]={attrid=3,type="mp",basevalue="10",upvalue="5",formula="+"},
	[4]={attrid=4,type="hpp",basevalue="1",upvalue="1",formula="+",version=2},
	[5]={attrid=5,type="mpp",basevalue="2",upvalue="2",formula="+"},
	[6]={attrid=6,type="defp",basevalue="2",upvalue="2",formula="+"},
	[7]={attrid=7,type="critchance",basevalue="1",upvalue="0.5",formula="+",version=2},
}

data[EQUIP_INDEX.BELT] = {
	[1]={attrid=1,type="mp",basevalue="20",upvalue="50",formula="+"},
	[2]={attrid=2,type="hp",basevalue="10",upvalue="4",formula="+",version=2},
	[3]={attrid=3,type="def",basevalue="10",upvalue="5",formula="+"},
	[4]={attrid=4,type="hpp",basevalue="1",upvalue="1",formula="+",version=2},
	[5]={attrid=5,type="mpp",basevalue="2",upvalue="2",formula="+"},
	[6]={attrid=6,type="defp",basevalue="2",upvalue="2",formula="+"},
	[7]={attrid=7,type="critchance",basevalue="1",upvalue="0.2",formula="+",version=2},
	[8]={attrid=8,type="restoremp",basevalue="1",upvalue="1",formula="+"},
}

data[EQUIP_INDEX.FOOT] = {
	[1]={attrid=1,type="luck",basevalue="5",upvalue="1",formula="+"},
	[2]={attrid=2,type="hp",basevalue="10",upvalue="4",formula="+",version=2},
	[3]={attrid=3,type="mp",basevalue="10",upvalue="5",formula="+"},
	[4]={attrid=4,type="def",basevalue="10",upvalue="5",formula="+"},
	[5]={attrid=5,type="hpp",basevalue="1",upvalue="1",formula="+",version=2},
	[6]={attrid=6,type="mpp",basevalue="2",upvalue="2",formula="+"},
	[7]={attrid=7,type="defp",basevalue="2",upvalue="2",formula="+"},
	[8]={attrid=8,type="critchance",basevalue="1",upvalue="0.5",formula="+",version=2},
}

data[EQUIP_INDEX.DECORATIONS] = {
	[1]={attrid=1,type="hp",basevalue="10",upvalue="18",formula="+",version=2},
	[2]={attrid=2,type="mp",basevalue="20",upvalue="20",formula="+"},
	[3]={attrid=3,type="luck",basevalue="5",upvalue="1",formula="+"},
	[4]={attrid=4,type="atk",basevalue="10",upvalue="14",formula="+",version=2},
	[5]={attrid=5,type="atkp",basevalue="2",upvalue="1",formula="+",version=2},
	[6]={attrid=6,type="hpp",basevalue="1",upvalue="1",formula="+",version=2},
	[7]={attrid=7,type="mpp",basevalue="2",upvalue="2",formula="+"},
	[8]={attrid=8,type="critchance",basevalue="1",upvalue="0.5",formula="+",version=2},
	[9]={attrid=9,type="critdamage",basevalue="5",upvalue="3",formula="+"},
}

return data