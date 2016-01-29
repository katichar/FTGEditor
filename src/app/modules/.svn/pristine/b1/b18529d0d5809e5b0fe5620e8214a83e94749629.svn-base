---
--充值处理类
---

local payment={}

payment.LOAD_PRODUCTS_FINISHED    = "LOAD_PRODUCTS_FINISHED"
payment.TRANSACTION_PURCHASED     = "TRANSACTION_PURCHASED"
payment.TRANSACTION_RESTORED      = "TRANSACTION_RESTORED"
payment.TRANSACTION_FAILED        = "TRANSACTION_FAILED"
payment.TRANSACTION_CANCELLED        = "TRANSACTION_CANCELLED"
payment.TRANSACTION_UNKNOWN_ERROR = "TRANSACTION_UNKNOWN_ERROR"

--需要在加载完成商品列表后去购买的钻石
payment.tobuyid=""
--当前可购买的商品数量
payment.productnum=0

function payment.ctor()
	payment.isbusy = false
	cc(payment):addComponent("components.behavior.EventProtocol"):exportMethods()
	payment.provider = require("framework.cc.sdk.Store")
	payment.provider.init(payment.transactionCallback)
	--	产品信息
	payment.products = {}

	payment:addEventListener(payment.LOAD_PRODUCTS_FINISHED, payment.onLoadProductsFinished)
	payment:addEventListener(payment.TRANSACTION_PURCHASED,payment.onTransactionPurchased)
	payment:addEventListener(payment.TRANSACTION_FAILED,payment.onTransactionFailed)
	payment:addEventListener(payment.TRANSACTION_UNKNOWN_ERROR,payment.onTransactionUnknownError)
	payment:addEventListener(payment.TRANSACTION_CANCELLED,payment.onTransactionCancelled)
end

--	加载所有的购买物品
function payment.loadAllProducts()
	payment.loadProducts(g_Shop.diamondIndentifiers)
end

--是否可以购买的检查
function payment.canMakePurchases()
	return payment.provider.canMakePurchases()
end

--读取商品列表信息
function payment.loadProducts(productsId)
	if payment.isbusy then return end

	payment.isbusy = true

	payment.provider.loadProducts(productsId, function(event)
		payment.products = {}
		payment.productnum=0

		if (not event.products) then
			payment.isbusy = false
			device.hideActivityIndicator()
			local info = {descr="无法连接到苹果服务器，请检查您的网络是否正常并稍后再试。",tag=1}
			g_LayerManager:addPopUI(g_TipUI.new(info))
			return
		end

		for _, product in ipairs(event.products) do
			payment.products[product.productIdentifier] = clone(product)
			payment.productnum=payment.productnum+1
		end

		payment:dispatchEvent({
			name = payment.LOAD_PRODUCTS_FINISHED,
			products = event.products,
			invalidProducts = event.invalidProducts
		})
	end)

	device.showActivityIndicator()
end

--根据商品ID获取商品信息
function payment.getProductDetails(productId)
	local product = payment.products[productId]
	if product then
		return clone(product)
	else
		return nil
	end
end

--取消所有加载的商品
function payment.cancelLoadProducts()
	payment.provider.cancelLoadProducts()
end

--检查是否已经加载过商品
function payment.isProductLoaded(productId)
	return payment.provider.isProductLoaded(productId)
end

--购买商品
function payment.createBillInfo(i_ProductId)
	if payment.isbusy then return end

	if not payment.canMakePurchases() then
		device.hideActivityIndicator()
		device.showAlert("支付失败", "canMakePurchases() == false", {"请检查商品配置"})
		payment.isbusy = false
		return
	end

	--	如果商品没有加载过
	if  payment.productnum<1 then
		--		加载完成后需要购买的商品
		payment.tobuyid=i_ProductId
		payment.loadAllProducts()
		return;
	else
		--		清空已经记住的上次购买ID
		payment.tobuyid=""
	end

	payment.isbusy = true
	payment.provider.purchase(i_ProductId)
	device.showActivityIndicator()
end

function payment.transactionCallback(event)
	local transaction = event.transaction

	if transaction.state == "purchased" then
		payment:dispatchEvent({
			name = payment.TRANSACTION_PURCHASED,
			transaction = transaction,
		})
	elseif  transaction.state == "restored" then
		payment:dispatchEvent({
			name = payment.TRANSACTION_RESTORED,
			transaction = transaction,
		})
	elseif transaction.state == "failed" then
		payment:dispatchEvent({
			name = payment.TRANSACTION_FAILED,
			transaction = transaction,
		})
	elseif transaction.state == "cancelled" then
		payment:dispatchEvent({
			name = payment.TRANSACTION_CANCELLED,
			transaction = transaction,
		})
	else
		payment:dispatchEvent({
			name = payment.TRANSACTION_UNKNOWN_ERROR,
			transaction = transaction,
		})
	end

	-- Once we are done with a transaction, call this to tell the store
	-- we are done with the transaction.
	-- If you are providing downloadable content, wait to call this until
	-- after the download completes.
	payment.provider.finishTransaction(transaction)
end

--购买成功
function payment.onTransactionPurchased(event)
	local transaction = event.transaction
	local productId = transaction.productIdentifier
	-- local product = payment.getProductDetails(productId)
	-- local msg
	-- if product then
	-- 	msg = string.format("productId = %s\nquantity = %s\ntitle = %s\nprice = %s %s", productId, tostring(transaction.quantity), product.localizedTitle, product.price, product.priceLocale)
	-- else
	-- 	-- prev unfinished transaction
	-- 	msg = string.format("productId = %s\nquantity = %s", productId, tostring(transaction.quantity))
	-- end
	
	--得到价格
	local info_ = g_Shop.getDiamondInfoByIndentifiers(productId)
	local price_ = 0
	if info_ then
		price_ = info_.price
	end

	device.hideActivityIndicator()
	payment.isbusy = false
	--	先保存到玩家数据库
	local serial=g_DB.addIosReceipt(transaction.receipt,price_,g_User.userid)
	if serial then
		--	向服务器发送消息验证
		g_Request.sendPayment(serial,transaction.receipt)
	end
end

--购买失败
function payment.onTransactionFailed(event)
	local transaction = event.transaction
	local msg = string.format("errorCode = %s\nerrorString = %s",
		tostring(transaction.errorCode),
		tostring(transaction.errorString))
	device.hideActivityIndicator()
	payment.isbusy = false
	device.showAlert("IAP Failed", msg, {"OK"})
end

--加载商品列表完成
function payment.onLoadProductsFinished(event)
	device.hideActivityIndicator()
	payment.isbusy = false
	--	如果有未购买的，购买
	if not g_CommonUtil.isEmpty(payment.tobuyid) then
		payment.createBillInfo(payment.tobuyid)
	end
end

--未知错误
function payment.onTransactionUnknownError(event)
	device.hideActivityIndicator()
	payment.isbusy = false
	device.showAlert("支付失败", "您的支付未成功，请稍后再试", {"OK"})
	payment.tobuyid=""
end

--交易取消
function payment.onTransactionCancelled(event)
	device.hideActivityIndicator()
	payment.isbusy = false
end

payment.ctor()

return payment
