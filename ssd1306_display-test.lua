-- Variables
MQTT_SERVER = "192.168.1.1"
MQTT_PORT   = "1883"
MQTT_TOPIC1 = "in"
MQTT_TOPIC2 = "out"

WIFI_SSID   = "myssid"
WIFI_PSK    = "mysecretwifipassword"

HEADLINE    = "Termperatur"
FOOTLINE    = "--the cake is a lie--"

-- setup I2c and connect display
function init_i2c_display()
     -- SDA and SCL can be assigned freely to available GPIOs
     sda = 5 -- GPIO14
     scl = 6 -- GPIO12
     sla = 0x3c
     i2c.setup(0, sda, scl, i2c.SLOW)
     disp = u8g.ssd1306_128x64_i2c(sla) --replace with your U8G Driver
end

-- Display 4 lines: 2 small, 1 big, 1 small
function xbm_picture(head1, head2, big, foot)
     disp:setFont(u8g.font_6x10)
     disp:drawStr( 0, 10, head1)
     disp:setFont(u8g.font_6x10)
     disp:drawStr( 0, 20, head2)
     disp:setFont(u8g.font_fub17)
     disp:drawStr( 0, 50, big)
     disp:setFont(u8g.font_6x10)
     disp:drawStr( 0, 64, foot)
end

-- render Display
function bitmap_test(head1, head2, big, foot)
      disp:firstPage()
      repeat
           xbm_picture(head1, head2, big, foot)
      until disp:nextPage() == false
      tmr.wdclr()
end

-- main
-- init Display
init_i2c_display()

--connect wifi
wifi.setmode(wifi.STATION)
bitmap_test("Connecting to Wifi"," ", " ", " ")
wifi.sta.config(WIFI_SSID,WIFI_PSK)
wifi.sta.connect()
tmr.alarm(1, 1000, 1, function()
if wifi.sta.getip()== nil then
bitmap_test("","Waiting for IP", "", "")
else
tmr.stop(1)
bitmap_test("Wifi Connected", wifi.sta.getip(),"", "")
end
end)

-- Initialise mqtt client
m = mqtt.Client(wifi.sta.getmac(), 120, "", "")

m:on("offline", function(con)
     bitmap_test("MQTT offline ", "connecting","---","")
     tmr.alarm(1, 10000, 0, function()
          m:connect(MQTT_SERVER, MQTT_PORT, 0)
     end)
end)

m:on("message", function(conn, topic, data)
     bitmap_test(HEADLINE,topic,data,FOOTLINE)
end)

-- Display MQTT Topics on Display
m:connect(MQTT_SERVER, MQTT_PORT, 0, function(conn)
          bitmap_test("MQTT connected","","","")
          m:subscribe({[MQTT_TOPIC1]=0,[MQTT_TOPIC2]=0}, function(conn) bitmap_test("MQTT subscribed","","","") end)
end)
