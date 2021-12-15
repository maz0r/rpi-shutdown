# rpi-shutdown
 Wrapps scruss's shutdown script in an installer because i'm lazy :)

## Button Behaviour

When a momentary switch is attached to GPIO pin 21 and shorted to ground the following behaviour is observed

< 2 seconds ==  nothing 
> 2 && < 5 seconds == reboot 
> 5 seconds == shutdown


## Installation

```
wget https://github.com/maz0r/rpi-shutdown/rpi-shutdown.sh
sudo chmod rpi-shutdown.sh
sudo ./rpi-shutdown.sh
```