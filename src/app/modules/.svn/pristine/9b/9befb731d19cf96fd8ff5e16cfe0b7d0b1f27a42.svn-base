-- 支付功能

local payment={}

function payment.init()
	if g_Platform.isThirdPartPay() then
		payment.channel = require("app.modules.ThirdPartPayment")
	else
		if device.platform == "ios" then
			payment.channel = require("app.modules.IOSPayment")
		else
			payment.channel = require("app.modules.ALiPayment")
			payment.yibao = require("app.modules.YiBaoPayment")
		end
	end
end

--发起订单
function payment.createBillInfo(i_ProductId)
	payment.channel.createBillInfo(i_ProductId)
end

--发起易宝订单
function payment.createYiBao(i_Identifier,i_CardType,i_No,i_Pwd)
	payment.yibao.createBillInfo(i_Identifier,i_CardType,i_No,i_Pwd)
end

-- 初始化
payment.init()

return payment