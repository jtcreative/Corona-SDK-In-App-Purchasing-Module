-----------------------------------------------------------------------------------------
-- created by James Timberlake
--Store Module
-- This can be used for making in app purchases and getting product information of your
-- itunes in app store
-- How to use:
---   local storeMod = require("storeMod")

--[[
--local products = {
  "com.tst.testItem",
  "com.tst.testItem2"
}
storeMod.setTransactionEvent(function(state, transaction)
  if state == 'purchased' then
    0--do something
  elseif state == "cancelled" then
     print("error buying item")
  end
end)

storeMod.startStore(products,function(validProducts, invalidProducts)
     --now you can poplate your information to make in app purchasing
end)
--- ]]
---
-----------------------------------------------------------------------------------------



------------------------------------------------
--product objects can contain
  --title
  --description
   -- productIdentifier
  --price
------------------------------------------------

local store = require("store")
local storeMod = {}

---here  are the variables we will be needing for the transactions
---DO NOT load these using the variable names
storeMod.productList = {}
storeMod.validProducts  = nil
storeMod.invalidProducts = nil
storeMod.onTransactionEvent = nil

--this clears all previous data for the store
--tobe used when leaving a page
storeMod.resetStore = function()
  storeMod.productList = {}
  storeMod.validProducts  = nil
  storeMod.invalidProducts = nil
  storeMod.onTransactionEvent = nil
end

storeMod.setProductList = function(array)
  storeMod.productList = array
end

--set transaction event does not set anything for storeMod.transactionEvent
--storeMOd.transactionEvent is something separate
storeMod.setTransactionEvent = function(transactionFunc)
   storeMod.onTransactionEvent = transactionFunc
end

--here is where the any purchase events take place
--this is never called programatically but regularly updated in each event
storeMod.transactionEvent = function(event)

  local state = event.transaction.state  --states can be "purchased", "restored", "cancelled", "failed"
  local transaction = event.transaction
  storeMod.onTransactionEvent(state, transaction)
  store.finishTransaction( event.transaction )

end

--used to initialize the store and get the product information
--should only be called after setting the transaction event
storeMod.startStore = function(productList , productReturnFunc)

  storeMod.setProductList(productList)
  if storeMod.productList and storeMod.transactionEvent and storeMod.onTransactionEvent then
    store.init(storeMod.transactionEvent)
    timer.performWithDelay(500,function()
      store.loadProducts(storeMod.productList, function(event)
         storeMod.validProducts = event.products
         storeMod.invalidProducts = event.invalidProducts
         productReturnFunc(storeMod.validProducts, storeMod.invalidProducts)
      end)
    end)
  else
    print('please make sure you have set the variable storeMod.productList and storeMod.transactionEvent')
  end

end

storeMod.purchaseItem = function(productIdentifier)
    if store.canMakePurchases then
      store.purchase({productIdentifier})
    else
      native.showAlert("Store purchases are not available",
                  { "BACK" } )
    end
end

storeMod.restore = function()
    store.restore()
end

return storeMod
