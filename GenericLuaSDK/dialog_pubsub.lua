--
-- Created by IntelliJ IDEA.
-- User: sabareesan_08843
-- Date: 11/21/2017
-- Time: 11:20 AM
-- To change this template use File | Settings | File Templates.
--


--Edit this function("callback_function") according to your actions.you will receive a message(json format) something like below
--This message may contain upto 10 actions(eg: actionOne, aactionTwo ....,actionTen) from the server and it's decoded to Lua object named "lua_object"
--As an example you can access the value of parentMac by using "lua_object.param.parentMac"


--[[Eg : {
      "action":"actionOne",
      "param":{
      "ac1Value1":"1110" ,
      "parentMac":"6655591876092787",
      "ac1Value4":"port:03",
      "ac1Value5":"on",
      "mac":"6655591876092787",
      "ac1Value2":"2220",
      "ac1Value3":"567776"
      }
  }
  ]]

callback_function= function(data)
        lua_object= sjson.decode(data)
     --your actions
end

--call function named "dialog.mqtt.publish("Publish Topic", message)" whenever you want to publish the message you created to the MQTT server(back end)
--You should create a message format like below (upto 10 events can be included in a  message and each event can consist upto 25 values)
message = '{'
        ..'"mac":"6655591876092787",'
        ..'"eventName":"eventOne",'
        ..'"state":"none",'
        ..'"eventOne":{'
        ..'"ev1Value1":30'
        ..'"ev1Value2":230'
        ..'}'
        ..'"eventName":"eventTwo",'
        ..'"state":"none",'
        ..'"eventTwo":{'
        ..'"ev2Value1":21'
        ..'"ev2Value2":32'
        ..'}'
        ..'}'

--dialog.mqtt.publish("Publish Topic", message)



