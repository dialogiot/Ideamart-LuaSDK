--
-- Created by IntelliJ IDEA.
-- User: sabareesan_08843
-- Date: 11/21/2017
-- Time: 11:20 AM
-- To change this template use File | Settings | File Templates.

----------------No need to make any changes to this file-------------
dialog = {}
dialog.mqtt={}
dialog.mqtt.subscribe={}
dialog.mqtt.publish={}

dialog.cfg = {}

dialog.mqtt.server_ip = "52.221.141.22"
dialog.mqtt.server_port= "1883" --use 1884 if secure port is preferred (TLS)
SUB_TOPIC_STRING= "+/"..DEVICE_SERIAL.."/"..DEVICE_BRAND.."/"..DEVICE_TYPE.."/"..DEVICE_VERSION.."/sub"

dialog.init= function(DEVICE_SERIAL,SSID,PASSWORD,callback)
    dialog.wifi(DEVICE_SERIAL,SSID,PASSWORD)
end

--Setting Up the Broker--
dialog.mqtt.setup_broker= function()
    print("Setting up mqtt Broker")
    broker = mqtt.Client(DEVICE_SERIAL,3000,"rabbit","rabbit")

    --setting up MQTT callbacks
    broker:on("connect", function(client) print ("connected to broker") end)
    broker:on("offline", function(client)
        dialog.mqtt.subscribe(DEVICE_BRAND,DEVICE_SERIAL) end)
    broker:on("message", function(client, topic, data)
        if data ~= nil then
            print("MQTT Received...")
            print("Topic: " ..topic)
            print("Message: " ..data)
            callback_function(data)
        end
    end)
end

--SUBSCRIBE--
dialog.mqtt.subscribe= function(SUB_TOPIC_STRING)
    broker:connect(dialog.mqtt.server_ip,dialog.mqtt.server_port,1,function(client)
        print ("connected to broker")
        if(SUB_TOPIC_STRING~=nil) then
            print("Subscribing to " .. SUB_TOPIC_STRING)
            broker:subscribe(SUB_TOPIC_STRING,0,function(client) print("subscribe success") dofile("dialog_pubsub.lc") end)	-- subscribe
        end
    end, function(client, reason) print("subscribe fail code:"..reason) end)
end

--PUBLISH--
dialog.mqtt.publish= function(EVENT_TOPIC,message)
    if(wifi.sta.status()==wifi.STA_GOTIP ) then
        print("Publishing to ".. EVENT_TOPIC ..": ".. message)
        broker:publish(EVENT_TOPIC, message, 0,0,function(client) print("publish success") end)	-- publish
    else print("Could not Publish")
    end
end

--WiFi function--
dialog.wifi= function(DEVICE_SERIAL,SSID,PASSWORD)
    dialog.cfg.ssid=SSID
    dialog.cfg.pwd=PASSWORD
    print("Trying to connect "..dialog.cfg.ssid)
    wifi.setmode( wifi.STATION)
    wifi.sta.config(dialog.cfg)

    --setting up callbacks for WiFi--
    wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, function()
        print ("Disconnected from "..SSID)
        dialog.wifi(DEVICE_SERIAL,SSID,PASSWORD)
    end)

    wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, function()
        print("Connected to '"..SSID.."' with IP: "..wifi.sta.getip())
        dialog.mqtt.setup_broker()
        dialog.mqtt.subscribe(DEVICE_BRAND,DEVICE_SERIAL)
    end)
end

