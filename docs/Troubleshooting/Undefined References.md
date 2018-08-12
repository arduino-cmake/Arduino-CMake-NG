This page lists all known issues regarding the `undefined references` issue which occurs during project linkage.

### undefined reference to '`__cxa_pure_virtual`'

An easy fix is to add the following to your firmware source code:

```c
extern "C" void __cxa_pure_virtual(void);
void __cxa_pure_virtual(void) { while(1); }
```

The contents of the `__cxa_pure_virtual` function can be any error handling code. 
This function will be called whenever a pure virtual function is called.

Also see [What is the purpose of cxa_pure_virtual](http://stackoverflow.com/questions/920500/what-is-the-purpose-of-cxa-pure-virtual)

