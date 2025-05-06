-- создает баннер в котором можно ввести текст

--[[ данные, отправляемые в функцию
header - заголовок ( можно ввести либо строку, либо число - это айди элемента из массива app.words ) ,
funEditingEnd - вызывает функцию когдда человек закончил ввод. необязательный параметр ( nil ) ,
yes - заменить "да" на другое слово. необязательный параметр ( nil ) ,
no - заменить "отмена" на другое слово. необязательный параметр ( nil )
]]
local dH = display.actualContentHeight*2
app.stimor.newBannerQuestion = function(header, funEditingEnd, no, yes)
	if (yes==nil) then
		yes = app.words[56]
		no = app.words[55]
	end

	local CENTER_X = CENTER_X
	local CENTER_Y = CENTER_Y
	if (app.scene=="visual_position") then
	    local settings = plugins.json.decode(funsP["получить сохранение"](app.idProject.."/options"))
		if utils.isSim or utils.isWin then
			settings.orientation = "vertical"
		end
	    if (settings.orientation=="horizontal") then
	        CENTER_X, CENTER_Y = CENTER_Y, CENTER_X
	    end
	    settings=nil
	end

	local backgroundBlackAlpha = display.newRect(CENTER_X, CENTER_Y, dH, dH)
	backgroundBlackAlpha:setFillColor(0,0,0,0.6)
	app.scenes[app.scene][(app.scene=="scripts" and 1 or #app.scenes[app.scene])]:insert(backgroundBlackAlpha)
	local group = display.newGroup()
	app.scenes[app.scene][(app.scene=="scripts" and 1 or #app.scenes[app.scene])]:insert(group)
	local rect = display.newRoundedRect(CENTER_X, CENTER_Y, display.contentWidth/1.16, 0, app.roundedRect)
	rect.anchorY=0,
	rect:setFillColor(66/255, 66/255, 66/255)
	group:insert(rect)

	backgroundBlackAlpha.alpha = 0
	group.alpha = 0
	transition.to(backgroundBlackAlpha, {time=150, alpha=1})
	transition.to(group, {time=150, alpha=1})

	local textHeader = display.newText({
		text=header,
		x=CENTER_X,
		y=CENTER_Y+display.contentWidth/15,
		width=rect.width-display.contentWidth/7.5,
		font=nil,
		fontSize=app.fontSize1,
	})
	textHeader.anchorY=0
	group:insert(textHeader)


	local textButtonOk = display.newText(yes, 0, 0, nil, app.fontSize1)
	textButtonOk:setFillColor(171/255, 219/255, 241/255)
	local rectButtonOk = display.newRoundedRect(CENTER_X+textHeader.width/2, textHeader.y+textHeader.height+display.contentWidth/7.5, textButtonOk.width+display.contentWidth/10, textButtonOk.height+display.contentWidth/30, app.roundedRect)
	rectButtonOk.anchorX, rectButtonOk.anchorY = 1, 0
	textButtonOk.x, textButtonOk.y = rectButtonOk.x-rectButtonOk.width/2, rectButtonOk.y+rectButtonOk.height/2
	rectButtonOk:setFillColor(66/255,66/255, 66/255)
	group:insert(rectButtonOk)
	group:insert(textButtonOk)
	local textButtonCancel = display.newText(no, 0, 0, nil, app.fontSize1)
	textButtonCancel:setFillColor(171/255, 219/255, 241/255)
	local rectButtonCancel = display.newRoundedRect(rectButtonOk.x-rectButtonOk.width-display.contentWidth/40, rectButtonOk.y, textButtonCancel.width+display.contentWidth/20, textButtonCancel.height+display.contentWidth/30, app.roundedRect)
	rectButtonCancel.anchorX, rectButtonCancel.anchorY = 1, 0
	textButtonCancel.x, textButtonCancel.y = rectButtonCancel.x-rectButtonCancel.width/2, rectButtonCancel.y+rectButtonCancel.height/2
	rectButtonCancel:setFillColor(66/255,66/255, 66/255)
	group:insert(rectButtonCancel)
	group:insert(textButtonCancel)

	rect.height=group.height+display.contentWidth/30
	group.y = -group.height/2

	
	local touchNoTouch = nil
	local function touchEditingEnd(event)
		if (event.phase=="began") then
			event.target:setFillColor(99/255, 99/255, 99/255)
		elseif (event.phase=="moved") then
			event.target:setFillColor(66/255, 66/255, 66/255)
		else
			event.target:setFillColor(66/255, 66/255, 66/255)
			rectButtonOk:removeEventListener("touch", touchEditingEnd)
			rectButtonCancel:removeEventListener("touch", touchEditingEnd)
			backgroundBlackAlpha:removeEventListener("touch",touchNoTouch)
			rect:removeEventListener("touch",touchNoTouch)

			transition.to(backgroundBlackAlpha, {time=200, alpha=0, inComplete=function()
				display.remove(backgroundBlackAlpha)
			end})
			transition.to(group, {time=200, alpha=0, inComplete=function()
				display.remove(group)
			end})

			if (funEditingEnd~=nil) then
				funEditingEnd({["isOk"]=(event.target==rectButtonOk)})
			end
		end
		return(true)
	end
	rectButtonOk:addEventListener("touch", touchEditingEnd)
	rectButtonCancel:addEventListener("touch", touchEditingEnd)

	touchNoTouch = function(event)
		return(true)
	end
	backgroundBlackAlpha:addEventListener("touch",touchNoTouch)
	rect:addEventListener("touch",touchNoTouch)
end

bannerPremium = function ()
	--funsP["вызвать уведомление"]('У вас нету уровня поддержки LunUP and Cat.')
	local rect = display.newRect(CENTER_X, CENTER_Y, display.contentWidth, display.contentHeight)
	rect:addEventListener('tap', function ()
		
	end)
	timer.performWithDelay(100, function ()
		rect:addEventListener('tap', function ()
			system.openURL('https://boosty.to/maxdil/purchase/3014811?ssource=DIRECT&share=subscription_link')
		end)
	end)
	rect:setFillColor({
		type = "gradient",
		color1 = { 1, 0, 0.4 },
		color2 = {1, 172/255, 8/255, 0.75},
		direction = -50
	})

	local text = display.newText(app.words[617], CENTER_X, CENTER_Y, display.contentWidth-70, display.contentHeight-200, 'fonts/font_1.ttf', app.fontSize1)
	text.text = app.words[617].."\n\nРеклама дилтся 6 секунд."
	timer.performWithDelay(6000, function ()
		display.remove(rect)
		display.remove(text)
		rect = nil
		text = nil
	end)
end