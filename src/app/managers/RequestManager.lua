local requestmanager={}

--IOS充值提示
requestmanager.IOS_PAY_TIP_FLAG=false

--根据当前值返回Protobuf值
local function getEnumsInfo(i_CmdId,i_Key)
	if i_CmdId == MessageSingle_pb.RANK then
		if i_Key == GAME_MODE.EASY then
			i_Key = EnumRankType_pb.STORY
		elseif i_Key == GAME_MODE.NORMAL then
			i_Key = EnumRankType_pb.CHALLENGE
		elseif i_Key == GAME_MODE.HARD then
			i_Key = EnumRankType_pb.HELL
		elseif i_Key == GAME_MODE.PVP then
			i_Key = EnumRankType_pb.PVP
		end
	end
	return i_Key
end

function requestmanager.sendReg()
	local msg=MessageUtil.getMsgDTO()
	msg.cmdId=MessageSingle_pb.REG
	msg.cRegisterUp.deviceId=g_UA.getDeviceId()
	msg.cRegisterUp.idfa=g_UA.getIDFA()
	MessageUtil.doSendMsgs()
end

--session id登录
function requestmanager.sendLogin()
	local msg=MessageUtil.getMsgDTO()
	msg.cmdId=MessageSingle_pb.LOGIN
	msg.cLoginUp.diamond=g_User.getDiamond()
	msg.cLoginUp.money=g_User.getMoney()
	MessageUtil.doSendMsgs()
end

--向服务器发送苹果收据
function requestmanager.sendPayment(i_Serial,i_Quittance)
	-- 是否显示等待界面
	local showloading = true
	local msg=MessageUtil.getMsgDTO()
	msg.cmdId=MessageSingle_pb.IOSRECEIPT
	if i_Quittance then
		-- 第一次返回验证中时提示玩家
		requestmanager.IOS_PAY_TIP_FLAG = true
		msg.cIOSReceiptUp.receipt=i_Quittance
	else
		showloading = false
	end
	msg.cIOSReceiptUp.id=i_Serial
	MessageUtil.doSendMsgs(showloading)
end

--向服务器请求未验证的收据
function requestmanager.batchPayments()
	if device.platform == "ios" then
		local payments=g_DB.getUnCheckedIOSReceipt(g_User.userid)
		if #payments>0 then
			local msg
			for i,v in ipairs(payments) do
				msg=MessageUtil.getMsgDTO()
				msg.cmdId=MessageSingle_pb.IOSRECEIPT
				msg.cIOSReceiptUp.id=v.tid
			end
			MessageUtil.doSendMsgs(false)
		end
	else
		local payments=g_DB.getUnCheckedAndroidReceipt(g_User.userid)
		if #payments>0 then
			local msg
			for i,v in ipairs(payments) do
				msg=MessageUtil.getMsgDTO()
				msg.cmdId=MessageSingle_pb.PAYCHECK
				msg.cPayCheckUp.outTradeNo = v.tradeno
			end
			MessageUtil.doSendMsgs(false)
		end
	end
end

-- 上传关卡积分
-- @i_GLvlId 关卡ID
-- @i_Score 关卡积分
function requestmanager.sendScore(i_GLvlId,i_Score)
	local msg=MessageUtil.getMsgDTO()
	msg.cmdId=MessageSingle_pb.ROLESCORE
	-- 上传阵营
	msg.cRoleScoreUp.myCamp.type=g_User.camp
	msg.cRoleScoreUp.myCamp.score=i_Score or 1
	msg.cRoleScoreUp.gateid=i_GLvlId or 1
	MessageUtil.doSendMsgs(false)
end

-- 玩家起名
function requestmanager.sendUserName(i_Name)
	local msg=MessageUtil.getMsgDTO()
	msg.cmdId=MessageSingle_pb.RENAME
	msg.cRenameUp.name = i_Name
	MessageUtil.doSendMsgs()
end

-- 请求排行榜信息
-- @i_RankType
-- @I_GateId
-- @i_RankSubType
function requestmanager.getRankMsgs(i_RankType,I_GateId,i_RankSubType)
	local msg=MessageUtil.getMsgDTO()
	msg.cmdId=MessageSingle_pb.RANK
	msg.cRankUp.rankType = getEnumsInfo(MessageSingle_pb.RANK,i_RankType)
	msg.cRankUp.gateId = I_GateId
	if not i_RankSubType then
		i_RankSubType = EnumRankSubType_pb.WAVE
	end
	msg.cRankUp.rankSubType = i_RankSubType
	MessageUtil.doSendMsgs()
end

-- 上传排行信息
function requestmanager.sendRankInfo(i_RankType,I_GateId,i_Score,i_Time,i_RankSubType)
	local msg=MessageUtil.getMsgDTO()
	msg.cmdId=MessageSingle_pb.UPRANK
	msg.cUploadRankUp.rankType = getEnumsInfo(MessageSingle_pb.RANK,i_RankType)
	msg.cUploadRankUp.gateId = I_GateId
	if not i_RankSubType then
		i_RankSubType = EnumRankSubType_pb.WAVE
	end
	msg.cUploadRankUp.rankSubType = i_RankSubType
	msg.cUploadRankUp.roleLvl = g_User.roleinfo.lvl
	msg.cUploadRankUp.roleType = g_User.roleinfo.type
	msg.cUploadRankUp.value = i_Score
	msg.cUploadRankUp.value2 = i_Time

	MessageUtil.doSendMsgs(false)
end

--向服务器发送Android订单
function requestmanager.sendAndroidPay(i_Channel,i_Identifier)
	local msg=MessageUtil.getMsgDTO()
	msg.cmdId=MessageSingle_pb.PAYCREATE
	msg.cPayCreateUp.channel = i_Channel
	msg.cPayCreateUp.identifier = i_Identifier
	MessageUtil.doSendMsgs()
end

--检查Android订单状态
function requestmanager.checkAndroidPay(i_TradeNo)
	local msg=MessageUtil.getMsgDTO()
	msg.cmdId=MessageSingle_pb.PAYCHECK
	msg.cPayCheckUp.outTradeNo = i_TradeNo
	MessageUtil.doSendMsgs(false)
end

--向服务器发送易宝订单
-- @i_Identifier  商品标识(DARKER_DIAMOND_6)
-- @i_CardType	EnumPayChannel_pb.UNICOM(联通)、EnumPayChannel_pb.SZX
-- @i_No  卡号
-- @i_Pwd 密码
function requestmanager.sendYiBaoPay(i_TradeNo,i_Identifier,i_CardType,i_No,i_Pwd)
	local msg=MessageUtil.getMsgDTO()
	msg.cmdId=MessageSingle_pb.PAYCREATE
	msg.cPayCreateUp.channel = EnumPayChannel_pb.YEEPAY
	msg.cPayCreateUp.identifier = i_Identifier
	msg.cPayCreateUp.cardTradeNo = i_TradeNo
	msg.cPayCreateUp.cardType = i_CardType
	msg.cPayCreateUp.cardNo = i_No
	msg.cPayCreateUp.cardPass = i_Pwd
	MessageUtil.doSendMsgs()
end

--读取邮件
function requestmanager.getMails()
	local msg=MessageUtil.getMsgDTO()
	msg.cmdId=MessageSingle_pb.MAILREAD
	msg.cMailReadUp.num = 20
	MessageUtil.doSendMsgs(false)
end

--同步邮件
function requestmanager.syncMail(i_Info)
	if g_CommonUtil.isEmpty(i_Info) then
		return
	end
	msg=MessageUtil.getMsgDTO()
	msg.cmdId=MessageSingle_pb.MAILSYNC
	for i,v in ipairs(i_Info) do
		local mailUids_ =  msg.cMailSyncUp.mailUids:add();
		mailUids_.id = v.uid
	end
	MessageUtil.doSendMsgs(false)
end

--发送邮件
function requestmanager.sendMail(i_Content)
	if g_CommonUtil.isEmpty(i_Content) then
		return
	end
	msg=MessageUtil.getMsgDTO()
	msg.cmdId=MessageSingle_pb.MAILSEND
	msg.cMailSendUp.content = i_Content
	MessageUtil.doSendMsgs()
end

--上传IDFA
function requestmanager.sendIOSAD()
	local msg=MessageUtil.getMsgDTO()
	msg.cmdId=MessageSingle_pb.IOSAD
	MessageUtil.doSendMsgs(false)
end

return requestmanager
