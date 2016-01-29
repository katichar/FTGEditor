--
-- Author: rsma
-- Date: 2014-12-18 21:49:08
--
local payment = {}
payment.isbusy=false
payment.currBillObj=nil
--定时序号
local timerserial

---请求服务器生成账单信息
function payment.createBillInfo(productId)
	if payment.isbusy then
		return
	end
	payment.isbusy = true

	g_MsgData.AddListener(MESSAGE_EVENT.THIRDPAY_EVENT_CREATE_BILL,payment.createBillFinished)
	g_MsgData.AddListener(MESSAGE_EVENT.THIRDPAY_EVENT_FINISHED,payment.payFinished)

	g_MsgData.Handler.sendCreateOrder(g_Platform.getPayChannel(),productId)
end

---创建订单完成
function payment.createBillFinished(eventname, billInfo)
	if not billInfo then
		payment.paymentEnd()
		return
	end
	payment.callPayActivity(billInfo)
end

---激活充值界面
function payment.callPayActivity(BillInfo)
	local diamondinfo=g_LogicUtil.getDiamodInfo(BillInfo.identifier)
	if diamondinfo then
		diamondinfo=diamondinfo.name
		if g_Platform.packageId==g_Platform.CHANNEL.oppo then
			diamondinfo="元商品"
		end
	else
		diamondinfo="购买钻石"
	end
	if BillInfo.channel== ProtoSDKPayBase_pb.PPHELP then
		local args={
			price=BillInfo.totalPrice,
			billNo=BillInfo.outTradeNo,
			billTitle=diamondinfo
		}
		luaoc.callStaticMethod("PPSDK", "ppRegisterScriptHandler", {listener_payment = payment.onPayCallBack})
		luaoc.callStaticMethod("PPSDK", "ppExchangeGoods",args)
	else
		local args = {diamondinfo,string.format("%s",BillInfo.outTradeNo),BillInfo.callback,BillInfo.totalPrice,payment.onPayCallBack}
    	local sig = "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;II)V"
		luaj.callStaticMethod("com/hytc/gkf/YiJie", "sendPay",args,sig)
	end
	payment.isbusy=false
end

--PP支付回调
function payment.onPayCallBack(PayInfo)
	local success_flag = false
	if g_Platform.getPayChannel()==ProtoSDKPayBase_pb.YISDK then
		success_flag=(PayInfo==g_Platform.PAYFLAG.SUCCESS)
	elseif g_Platform.getPayChannel()==ProtoSDKPayBase_pb.PPHELP then
		if g_CommonUtil.isTable(PayInfo) and PayInfo.payflag then
			success_flag=true
		end
	end

	if success_flag then
		--	向服务器定时请求
		if (timerserial==nil) then
			timerserial=g_Timer.addTimer(g_MsgData.Handler.sendEmpty,0,3)
		end
		-- g_ErrorUI.new("服务器正在确认您的付款信息，成功后钻石将自动到达您的账户。")
	else
		payment.paymentEnd()
	end
end

---订单交易完成
function payment.payFinished(eventname, msg)
	g_Timer.delTimer(timerserial)
	timerserial=nil
	payment.paymentEnd()
end

---支付结束
function payment.paymentEnd()
	payment.isbusy = false
	payment.currBillObj=nil
	g_MsgData.RemoveListener(MESSAGE_EVENT.THIRDPAY_EVENT_FINISHED,payment.payFinished)
	g_MsgData.RemoveListener(MESSAGE_EVENT.THIRDPAY_EVENT_CREATE_BILL,payment.createBillFinished)
end

return payment
