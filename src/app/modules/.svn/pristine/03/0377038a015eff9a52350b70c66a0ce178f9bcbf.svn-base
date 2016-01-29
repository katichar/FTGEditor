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
	g_EventManager.addListener(MESSAGE_EVENT.ALIPAY_EVENT_CREATE_BILL,payment.onBillCreated)
end

-- 移除监听
function payment.destroy()
	g_EventManager.removeListener(MESSAGE_EVENT.ALIPAY_EVENT_CREATE_BILL,payment.onBillCreated)
end

---请求服务器生成账单信息
function payment.createBillInfo(i_Identifier)
	if payment.isbusy then
		return
	end
	
	payment.isbusy = true
	g_Request.sendAndroidPay(EnumPayChannel_pb.ALIPAY,i_Identifier)
	--如果有情况，5分钟后自动恢复
	timerserial = g_Timer.callAfter(payment.paymentEnd,300)
end

---创建订单完成
function payment.onBillCreated(i_EventName, i_BillInfo)
	if not i_BillInfo then
		payment.paymentEnd()
		return
	end

	--得到价格
	local info_ = g_Shop.getDiamondInfoByIndentifiers(i_BillInfo.identifier)
	local price_ = 0
	if info_ then
		price_ = info_.price
	end

	g_DB.addAndroidReceipt(i_BillInfo.outtradeno,i_BillInfo.identifier,price_,g_User.userid)
	payment.callAliPayActivity(i_BillInfo)
end

---支付结束
function payment.paymentEnd(i_TradeNo)
	payment.isbusy = false
	g_Timer.delTimer(timerserial)
	if i_TradeNo then
		g_DB.updateAndroidReceipt(i_TradeNo,false,g_User.userid)
	end
end

---激活ALiPay
function payment.callAliPayActivity(i_BillInfo)
	local function callback (i_Result)
		if type(i_Result) ~= "string" then
			payment.paymentEnd(i_BillInfo.outtradeno)
			return
		end
		 ---“1001”则代检测安装快捷支付
		 --"6001"操作已经取消
		 --"4000"支付失败
		 ---“9000”则代表支付成功 “8000”// 代表支付结果因为支付渠道原因或者系统原因还在等待支付结果确认，最终交易是否成功以服务端异步通知为准（小概率状态）
		if i_Result == "9000" or i_Result == "8000" then 
			g_Timer.callAfter(function()
					local info = {descr="服务器正在确认您的付款信息，成功后钻石将自动到达您的账户。",tag=1}
					g_LayerManager:addPopUI(g_TipUI.new(info))
				end,1)
			-- 5秒后请求
			g_Timer.callAfter(g_Request.checkAndroidPay,5,i_BillInfo.outtradeno)
			--记录支付
			pcall(g_UA.onCharge,i_BillInfo.outtradeno,i_BillInfo.identifier,"Android")
			--结束
			payment.paymentEnd()
		else
			payment.paymentEnd(i_BillInfo.outtradeno)
		end
    end
    local args = {i_BillInfo.alipay,callback}
    local sig = "(Ljava/lang/String;I)Z"
    local AliPayClass = "com/quick2dx/alipay/QLALiPay"
    local isvalid, ret = luaj.callStaticMethod(AliPayClass, "aliPay", args, sig) --没有返回默认nil
    if isvalid then
    else
        local info = {descr="您的充值有问题。",tag=1}
		g_LayerManager:addPopUI(g_TipUI.new(info))
       	payment.paymentEnd(i_BillInfo.outtradeno)
    end
end

payment.init()

return payment