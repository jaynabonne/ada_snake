# Steps to build:

Note that this is what I did. I can't be sure this is the sane way to do this, but I got it to work for me, after a bit of struggle. So, I'm going to record it here. I'm using Ubuntu 2024, under WSL2.

$ sudo apt install -y build-essential pkg-config libncurses-dev

(Can verify if you want)  
$ pkg-config --cflags ncursesw  
$ pkg-config --libs ncursesw  

$ alr toolchain --select  
- Choose gnat 14.2.1
- Choose gprbuild <highest supported>

$ eval "$(alr printenv)"

The following allowed ncurses to build. Only using CC=gcc prefix wasn't enough. I think mapping CXX made it all consistent. Not sure about the need for the flags.

$ export CC=/usr/bin/gcc  
$ export CXX=/usr/bin/g++  
$ export CPPFLAGS="$(pkg-config --cflags ncursesw)"  
$ export LDFLAGS="$(pkg-config --libs ncursesw)"  


$ alr -v build    # may take a while first time, to do the native build of ncurses  
$ alr run  
