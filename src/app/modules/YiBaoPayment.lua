--
-- Author: rsma
-- Date: 2014-12-18 21:49:08
--
local payment = {}
payment.isbusy=false
--定时序号
local timerserial=0

-- 初始化监听
function payment.init()
	g_EventManager.addListener(MESSAGE_EVENT.YIBAO_EVENT_CREATE_BILL,payment.onBillCreated)
end

-- 移除监听
function payment.destroy()
	g_EventManager.removeListener(MESSAGE_EVENT.YIBAO_EVENT_CREATE_BILL,payment.onBillCreated)
end

---请求服务器生成账单信息
function payment.createBillInfo(i_Identifier,i_CardType,i_No,i_Pwd)
	if payment.isbusy then
		return
	end
	payment.isbusy = true

	--得到价格
	local info_ = g_Shop.getDiamondInfoByIndentifiers(i_Identifier)
	if info_ then
		local tradeno_ = string.format("%sX%d",g_User.userid,math.floor(g_Timer.SERVER_TIME))
		g_DB.addAndroidReceipt(tradeno_,i_Identifier,checknumber(info_.price),g_User.userid)
		g_Request.sendYiBaoPay(tradeno_,i_Identifier,i_CardType,i_No,i_Pwd)
		g_LayerManager:addPopUI(g_TipUI.new({descr="服务器正在确认您的付款信息，成功后钻石将自动到达您的账户。",tag=1}))
	end

	--如果有情况，5分钟后自动恢复
	timerserial = g_Timer.callAfter(payment.paymentEnd,60)
end

---创建订单完成
function payment.onBillCreated(i_EventName, i_BillInfo)
	if not i_BillInfo then
		payment.paymentEnd()
		return
	end
	-- 5秒后请求
	g_Timer.callAfter(g_Request.checkAndroidPay,5,i_BillInfo.outtradeno)
	-- --记录支付
	-- pcall(g_UA.onCharge,i_BillInfo.outtradeno,i_BillInfo.identifier,"Android-YiBao")
	--结束
	payment.paymentEnd()
end

---支付结束
function payment.paymentEnd(i_TradeNo)
	payment.isbusy = false
	g_Timer.delTimer(timerserial)
	if i_TradeNo then
		g_DB.updateAndroidReceipt(i_TradeNo,false,g_User.userid)
	end
end

payment.init()

return payment