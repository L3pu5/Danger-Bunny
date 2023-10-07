# Shared Object

If a process loads a shared object you can manipulate or tries to pull one in that does not exist and you can write in that directory, you can hijack the shared object and gain execution in the context of that process.

## Compile
```
gcc -fPIC -shared -o exploit.so exploit.c
```
If you face compile errors while building this, you may have to additionally include <unistd.h>.

## Utilise
```
Call your binary here.
```