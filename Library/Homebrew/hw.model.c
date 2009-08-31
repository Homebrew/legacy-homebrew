/*
   This software is in the public domain, furnished "as is", without technical
   support, and with no warranty, express or implied, as to its usefulness for
   any purpose.
*/
#include <sys/sysctl.h>
#include <stdio.h>

int main()
{
    char buf[32];
    size_t sz = sizeof(buf);
    int r = sysctlbyname("hw.model", buf, &sz, NULL, 0);
    if (r == 0) 
        printf("%.*s", sz, buf);
    return r;
}
