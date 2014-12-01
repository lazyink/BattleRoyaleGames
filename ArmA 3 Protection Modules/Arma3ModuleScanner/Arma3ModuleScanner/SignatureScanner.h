#define WIN32_LEAN_AND_MEAN

#include <windows.h>
#include <psapi.h>
#include <tlhelp32.h>

typedef struct {
	char* pattern;
	char* signature;
}SIGNATURE;

SIGNATURE signatures[1024];

