# Reverse TCP Shell

Useful for pentesters and redteamers.

Simple reverse shell written in FreePascal, tested on Windows and Linux x64.

# Using
Set your ip and port in the source and compile

Set up a netcat listener, for example `nc -lvp <your port here>` on your host machine.

When executed on a Windows target it gives you a CMD commandline over TCP and on Linux you get /bin/bash

# Compiling
Compiled on Windows and Linux using FreePascal 3.2.0 and Lazarus 2.0.10

# Testing
It worked for what I needed :)

# Warranty
Hahaha, no

# Disclaimer
Use this only for good. I'm not responsible for anything bad happening when using this code.