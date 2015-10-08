# esp8266_nodemcu_i2C_display-mqtt
Simple LUA Script, that displays Data from MQTT on an I2C OLED Display

This Tool will LOG into a MQTT-Server and listen for 2 Topics. Subscribed Messages will then be displayen on an OLED Display (U8G). I use an Display that runs with the Driver u8g.ssd1306_128x64_i2c, but this Script might as well work with other Dispplays.

This Script requires a recent NodeMCU-Firmware with Support for:
  * node
  * file
  * GPIO
  * WiFi
  * net
  * I²C
  * timer
  * UART
  * bit
  * MQTT
  * U8G

and it uses the U8G-Fonts __6x10__ and __fub17__. In built the NodeMCU Environment on http://frightanic.com/nodemcu-custom-build/

