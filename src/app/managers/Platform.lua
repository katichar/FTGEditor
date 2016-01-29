-- 游戏的平台管理
--

local platform={}

--渠道信息
platform.CHANNEL={
	--应用宝
	yinyongbao=101,
	--免费上传
	freecp=102,
	-- --飓丰
	-- jufeng=103,
	-- --移动基地
	-- yidong=104,
	
	--360搜索
	qihuss=105,
	--搜狗搜索
	sougouss=106,
	--百度搜索
	baiduss=107,
	--安智免费
	anzhifree=108,

	-- --PP助手
	-- pphelp=10001,
	-- --易接接入的SDK从20000--30000
	-- vivo=20001,
	-- oppo=20002,
	-- --华为
	-- huawei=20003,
	-- --豌豆荚
	-- wdj=20004,
	-- --小米
	-- xiaomi=20005,
	-- --百度
	-- baidu=20006,
	-- --安智
	-- anzhi=20007,
	-- --联想
	-- lianxiang=20008,
	-- --奇虎360
	-- qihu360=20009,
	-- --金立
	-- jinli=20010,
	-- --卓易
	-- zhuoyi=20011,
	-- --PPS
	-- pps=20012,
	-- --海马
	-- haima=20013,
	-- --UC
	-- uc=20014,
	-- --电信爱游戏
	-- dianxin=20015,
	-- --酷派
	-- kupai=20016,
}

--支付标志
platform.PAYFLAG={
	SUCCESS="Success",
	FAILED="Failed"
}

--第三方计数开始值
platform.THIRD_BEGIN=10000
--当前运营商ID
platform.packageId=0

--返回当前的支付渠道
function platform.getPayChannel()
	if device.platform=="ios" then
		if platform.packageId==platform.CHANNEL.pphelp then
			return ProtoSDKPayBase_pb.PPHELP
		end
	else
		if platform.packageId<=platform.THIRD_BEGIN then
			return ProtoSDKPayBase_pb.ALIPAY
		else
			return ProtoSDKPayBase_pb.YISDK
		end
	end
	return -1
end

--返回当前的渠道
function platform.getChannel()
	if device.platform=="ios" then
		if platform.packageId==platform.CHANNEL.pphelp then
			return ProtoLoginBase_pb.L_PPHELP
		end
	else
		if platform.packageId>platform.THIRD_BEGIN then
			return ProtoLoginBase_pb.L_YISDK
		end
	end
	return -1
end

--是否为第三方登录
function platform.isThirdPartLogin()
	if device.platform == "windows" then
		return false
	end
	if platform.packageId==platform.CHANNEL.zhuoyi then
		return false
	end
	if platform.packageId>platform.THIRD_BEGIN then
		return true
	end
	return false
end

--是否第三方支付
function platform.isThirdPartPay()
	if platform.packageId>platform.THIRD_BEGIN then
		return true
	end
	return false
end

--是否第三方退出
function platform.isThirdPartLogout()
	if platform.packageId==platform.CHANNEL.qihu360 or platform.packageId==platform.CHANNEL.lianxiang or platform.packageId==platform.CHANNEL.pps or platform.packageId==platform.CHANNEL.uc or platform.packageId==platform.CHANNEL.dianxin then
		return true
	end
	return false
end

return platform
