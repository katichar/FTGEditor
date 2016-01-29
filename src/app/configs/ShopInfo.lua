--商城数据配置

local data={}
-- 装备
data.equip={
	[EQUIP_TYPE.QUANTAO] = {
			{id=1,attr={{1,20},{2,50}}},
			{id=2,attr={{2,20},{3,50}}},
			{id=3,attr={{1,20},{2,50}}},
			{id=4,attr={{2,20},{3,50}}},
			{id=5,attr={{1,20},{2,50}}},
			{id=6,attr={{2,20},{3,50}}},
		},
	[EQUIP_TYPE.DAOJIAN] = {
			{id=1,attr={{1,20},{2,50}}},
			{id=2,attr={{2,20},{3,50}}},
			{id=3,attr={{1,20},{2,50}}},
			{id=4,attr={{2,20},{3,50}}},
			{id=5,attr={{1,20},{2,50}}},
			{id=6,attr={{2,20},{3,50}}},
		},
	[EQUIP_TYPE.ZHUA] = {
			{id=1,attr={{1,20},{2,50}}},
			{id=2,attr={{2,20},{3,50}}},
			{id=3,attr={{1,20},{2,50}}},
			{id=4,attr={{2,20},{3,50}}},
			{id=5,attr={{1,20},{2,50}}},
			{id=6,attr={{2,20},{3,50}}},
		},
}

-- Filed Describtion : com.hytc.data.vo.packager.PVOGoldInfo
-- getCost → 价格
-- getCurrency → 
-- getIcon → 图标
-- getMaterialid → 材料id
-- getName → 名称
-- getTypeid → 
-- getTypename → 
-- Filed Describtion : com.hytc.data.vo.packager.PVODiamondInfo
-- getCost → 价格
-- getCurrency → 
-- getIcon → 图标
-- getLocalizedDescription → 商品描述
-- getLocalizedTitle → 商品名称 650钻石
-- getMaterialid → 材料id
-- getName → 名称
-- getPrice → 商品价格
-- getPriceLocale → 货币标志 zh_CN@currency=CNY
-- getProductIdentifier → 商品标识 DARKER_DIAMOND_60
-- getTypeid → 
-- getTypename → 

-------IOS平台的充值商品---------------------
if device.platform == "ios" then
	data.diamond={
		{price=6,currency=CURRENCY.RMB,type=CURRENCY.DIAMOND,image="icons_shop_diamond1.png",name="60钻石",num=60,typename="钻石",localizedDescription=nil,localizedTitle="60钻石",priceLocale=nil,productIdentifier="DARKER_DIAMOND_6",hostflag=false,cheapflag=false},
		{price=30,currency=CURRENCY.RMB,type=CURRENCY.DIAMOND,image="icons_shop_diamond2.png",name="315钻石",num=315,typename="钻石",localizedDescription=nil,localizedTitle="315钻石",priceLocale=nil,productIdentifier="DARKER_DIAMOND_30",hostflag=false,cheapflag=false},
		{price=98,currency=CURRENCY.RMB,type=CURRENCY.DIAMOND,image="icons_shop_diamond3.png",name="1080钻石",num=1080,typename="钻石",localizedDescription=nil,localizedTitle="1080钻石",priceLocale=nil,productIdentifier="DARKER_DIAMOND_098",hostflag=false,cheapflag=false},
		{price=198,currency=CURRENCY.RMB,type=CURRENCY.DIAMOND,image="icons_shop_diamond4.png",name="2280钻石",num=2280,typename="钻石",localizedDescription=nil,localizedTitle="2280钻石",priceLocale=nil,productIdentifier="DARKER_DIAMOND_198",hostflag=false,cheapflag=false},
		{price=328,currency=CURRENCY.RMB,type=CURRENCY.DIAMOND,image="icons_shop_diamond5.png",name="3880钻石",num=3880,typename="钻石",localizedDescription=nil,localizedTitle="3880钻石",priceLocale=nil,productIdentifier="DARKER_DIAMOND_328",hostflag=false,cheapflag=false},
		{price=648,currency=CURRENCY.RMB,type=CURRENCY.DIAMOND,image="icons_shop_diamond6.png",name="7999钻石",num=7999,typename="钻石",localizedDescription=nil,localizedTitle="7999钻石",priceLocale=nil,productIdentifier="DARKER_DIAMOND_648",hostflag=false,cheapflag=false},
	}
else
	data.diamond={
		{price=6,currency=CURRENCY.RMB,type=CURRENCY.DIAMOND,image="icons_shop_diamond1.png",name="60钻石",num=60,typename="钻石",localizedDescription=nil,localizedTitle="60钻石",priceLocale=nil,productIdentifier="DARKER_DIAMOND_6",hostflag=false,cheapflag=false},
		{price=30,currency=CURRENCY.RMB,type=CURRENCY.DIAMOND,image="icons_shop_diamond2.png",name="315钻石",num=315,typename="钻石",localizedDescription=nil,localizedTitle="315钻石",priceLocale=nil,productIdentifier="DARKER_DIAMOND_30",hostflag=true,cheapflag=false},
		{price=50,currency=CURRENCY.RMB,type=CURRENCY.DIAMOND,image="icons_shop_diamond3.png",name="530钻石",num=530,typename="钻石",localizedDescription=nil,localizedTitle="530钻石",priceLocale=nil,productIdentifier="DARKER_DIAMOND_50",hostflag=false,cheapflag=false},
		{price=100,currency=CURRENCY.RMB,type=CURRENCY.DIAMOND,image="icons_shop_diamond3.png",name="1100钻石",num=1100,typename="钻石",localizedDescription=nil,localizedTitle="1100钻石",priceLocale=nil,productIdentifier="DARKER_DIAMOND_100",hostflag=false,cheapflag=false},
		{price=198,currency=CURRENCY.RMB,type=CURRENCY.DIAMOND,image="icons_shop_diamond4.png",name="2280钻石",num=2280,typename="钻石",localizedDescription=nil,localizedTitle="2280钻石",priceLocale=nil,productIdentifier="DARKER_DIAMOND_198",hostflag=false,cheapflag=false},
		{price=328,currency=CURRENCY.RMB,type=CURRENCY.DIAMOND,image="icons_shop_diamond5.png",name="3880钻石",num=3880,typename="钻石",localizedDescription=nil,localizedTitle="3880钻石",priceLocale=nil,productIdentifier="DARKER_DIAMOND_328",hostflag=false,cheapflag=true},
	}
end

data.gold={
	{price=50,currency=CURRENCY.DIAMOND,type=CURRENCY.GOLD,image="icons_shop_gold1.png",name="5000金币",num=5000,typename="金币"},
	{price=100,currency=CURRENCY.DIAMOND,type=CURRENCY.GOLD,image="icons_shop_gold2.png",name="10500金币",num=10500,typename="金币"},
	{price=200,currency=CURRENCY.DIAMOND,type=CURRENCY.GOLD,image="icons_shop_gold3.png",name="22000金币",num=22000,typename="金币"},
	{price=400,currency=CURRENCY.DIAMOND,type=CURRENCY.GOLD,image="icons_shop_gold4.png",name="46000金币",num=46000,typename="金币"},
	{price=800,currency=CURRENCY.DIAMOND,type=CURRENCY.GOLD,image="icons_shop_gold5.png",name="96000金币",num=96000,typename="金币"},
	{price=1600,currency=CURRENCY.DIAMOND,type=CURRENCY.GOLD,image="icons_shop_gold6.png",name="196000金币",num=196000,typename="金币"},
}

--仅IOS使用
data.diamondIndentifiers={
	"DARKER_DIAMOND_6",
	"DARKER_DIAMOND_30",
	"DARKER_DIAMOND_098",
	"DARKER_DIAMOND_198",
	"DARKER_DIAMOND_328",
	"DARKER_DIAMOND_648",
	"DARKER_DIAMOND_12",
}

data.exp = {
	gold={price=3000,currency=CURRENCY.GOLD,exp=100},
	diamond={price=30,currency=CURRENCY.DIAMOND,exp=300},
}

-- 根据Indentifier返回钻石数量
function data.getDiamondByIndentifiers(i_Indentifier)
	local result=0
	if i_Indentifier then
		for i,v in ipairs(data.diamond) do
			if v.productIdentifier == i_Indentifier then
				result = v.num
				break
			end
		end
	end
	return result
end

-- 根据Indentifier返回钻石信息
function data.getDiamondInfoByIndentifiers(i_Indentifier)
	if i_Indentifier then
		if i_Indentifier == "DARKER_DIAMOND_12" then
			return {price=12,currency=CURRENCY.RMB,type=CURRENCY.DIAMOND,name="新手礼包",num=1,typename="新手礼包",localizedTitle="新手礼包",productIdentifier="DARKER_DIAMOND_12"}
		end
		for i,v in ipairs(data.diamond) do
			if v.productIdentifier == i_Indentifier then
				return clone(v)
			end
		end
	end
	return nil
end

return data