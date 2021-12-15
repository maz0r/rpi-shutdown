#! /bin/bash
apt-get update # update packages 
apt-get install python3-gpiozero -y  # install gpiozero

raspi-config nonint get_i2c # return i2c port status

raspi-config nonint do_i2c 1 # enable i2c port for gpio

raspi-config nonint get_i2c # return i2c port status

sudo mkdir -p /usr/local/bin # ensure we have a dir for the files

## create the python shutdown script 
# < 2 seconds ==  nothing 
# > 2 && < 5 seconds == reboot 
# > 5 seconds == shutdown
cat > /usr/local/bin/shutdown_button.py << ENDOFFILE 
#!/usr/bin/python3
# -*- coding: utf-8 -*-
# example gpiozero code that could be used to have a reboot
#  and a shutdown function on one GPIO button
# scruss - 2017-10

use_button=21 # define the button to use

from gpiozero import Button
from signal import pause
from subprocess import check_call

held_for=0.0

def rls():
        global held_for
        if (held_for > 5.0):
                check_call(['/sbin/poweroff'])
        elif (held_for > 2.0):
                check_call(['/sbin/reboot'])
        else:
        	held_for = 0.0

def hld():
        # callback for when button is held
        #  is called every hold_time seconds
        global held_for
        # need to use max() as held_time resets to zero on last callback
        held_for = max(held_for, button.held_time + button.hold_time)

button=Button(use_button, hold_time=1.0, hold_repeat=True)
button.when_held = hld
button.when_released = rls

pause() # wait forever
ENDOFFILE

#chmod the file so it's executable
chmod +x /usr/local/bin/shutdown_button.py

#create a service
cat > /etc/systemd/system/shutdown_button.service << ENDOFFILE
[Unit]
Description=GPIO shutdown button
After=network.target

[Service]
Type=simple
Restart=always
RestartSec=1
User=root
ExecStart=/usr/bin/python3 /usr/local/bin/shutdown_button.py

[Install]
WantedBy=multi-user.target
ENDOFFILE


systemctl enable shutdown_button.service
systemctl start shutdown_button.service
systemctl status shutdown_button.service

