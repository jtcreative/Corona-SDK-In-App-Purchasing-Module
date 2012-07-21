

local ui = require("ui")
local storeMod = require("storeMod")

----@start interface features here we are making some interface features to get the storemod working
local screen = display.newGroup()

local background = display.newRect(0,0,display.contentWidth, display.contentHeight)
background:setFillColor(255,255,0)

screen:insert(background)

---we can use this to restore the store connection
 local button = ui.newButton({
   default= "button.png",
   over="button.png",
   text = "Test Reset",
   onRelease = function(event)
       storeMod.restore()
   end
 })
 button.xScale = 2.0
 button.yScale = 2.0
 button:translate(display.contentWidth*0.8,display.contentHeight*0.8)
 screen:insert(button)

---@end interface features


--- below is all the code you need to activate the storeMod
---this function sets the transaction event callback for making purchases in the app
----NOTE, if you need to download your in-app purchases, you may need to alter the transaction event function in storeMod
---to work like that
storeMod.setTransactionEvent(function(state, transaction)
  if state == 'purchased' then
    print("success buying item "..transaction.productIdentifier)
    print("bought on: "..transaction.date)
  elseif state == "cancelled" then
     print("error buying item")
  end
end)

local products = {
	"com.anscamobile.NewExampleInAppPurchase.ConsumableTier1",
	"com.anscamobile.NewExampleInAppPurchase.NonConsumableTier1",
}

---this gives you all the information you need form your products
---pressing this activates the store and gives you the product information
storeMod.startStore(products,function(validProducts, invalidProducts)
     --now you can poplate your info to make in app purchasing
  for k,v in ipairs(validProducts) do
     local button = ui.newButton({
       default= "button.png",
       over="button.png",
       text=v.title.." - "..v.price,
       onRelease = function(event)
          local productIdentifier = event.target.product.productIdentifier
          storeMod.purchaseItem(productIdentifier)
       end
     })
     button.product = v
     button.xScale = 2.0
     button.yScale = 2.0
     button:translate(display.contentWidth*0.5,100*k)
     screen:insert(button)
  end
end)

