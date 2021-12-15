# rpi-shutdown
 Wrapps scruss's shutdown script in an installer because i'm lazy :)

## Button Behaviour

When a momentary switch is attached to GPIO pin 21 and shorted to ground the following behaviour is observed

< 2 seconds ==  nothing 

\> 2 && < 5 seconds == reboot 

\> 5 seconds == shutdown


## Installation

```
wget https://raw.githubusercontent.com/maz0r/rpi-shutdown/main/rpi-shutdown.sh
sudo chmod x rpi-shutdown.sh
sudo ./rpi-shutdown.sh
```
