RegisterServerEvent("salarm:alertDispatch");

AddEventHandler('salarm:alertDispatch', function(webhook, title, location)
	PerformHttpRequest(webhook, process, "POST", "content=Silent Alarm Activated at " .. title .. " (LOCATION: ".. location ..")&tts=true")
end)

function process(statusCode, text, headers)
	--done
end