

local ui = require("ui")
local storeMod = require("storeMod")

local screen = display.newGroup()

local background = display.newRect(0,0,display.contentWidth, display.contentHeight)
background:setFillColor(255,255,0)

screen:insert(background)

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

