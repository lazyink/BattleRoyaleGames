#include "SignatureScanner.h"


void initSignatures() {
	char* badPats[] = { "", "NOPAT" };
	char* badSigs[] = { "", "" };
	for (int i = 0; i < ARRAYSIZE(badPats); i++) {
		SIGNATURE sig;
		sig.pattern = badPats[i];
		sig.signature = badSigs[i];
		signatures[i] = sig;
	}
};
bool checkPattern(DWORD address, SIGNATURE sig) {
	char* pattern = sig.pattern;
	char* signature = sig.signature;
	//--- Scan For Pattern
	for (int i = 0; i < strlen(pattern); i++) {
		char check = pattern[i];
		char bytecheck = signature[i];
		//--- If pattern says we are checking this byte
		if (check == 'f') {
			DWORD* ptrToAddress = (DWORD*)address;
			//--- If we can read from memory at this address
			if (!IsBadReadPtr(ptrToAddress, sizeof(char))) {
				char byte = (char)*ptrToAddress;
				if (byte != bytecheck) {
					return false; //--- Byte at ADDRESS is not equal to what we are scanning for
				}
			}
			else
			{
				return false; //--- bad pointer so this can't be where we are looking
			}
		}
		address += 1; //--- Increase Address
	}
	return true;
}
void ScanModule(HMODULE hModule) {
	MODULEINFO info;
	GetModuleInformation(GetCurrentProcess(), hModule, &info, sizeof(MODULEINFO));
	DWORD startAddress = (DWORD)info.lpBaseOfDll;
	DWORD endAddress = startAddress + info.SizeOfImage;
	for (DWORD address = startAddress; address < endAddress; address++) {
		//--- Scan Address For Every Signature
		for each(SIGNATURE sig in signatures) {
			if (!strstr(sig.pattern, "NOPAT")) {
				//--- Check Signature
				if (checkPattern(address, sig)) {
					//--- Unload Module
					if (!FreeLibrary(hModule)) {
						ExitProcess(0); //--- Failed to Unload (Exit Game)
					}
				}
			}
			else 
			{
				break;
			}
		}
	}
}

//--- Process Debugger Scanner (This should never fire lol)
void DebuggerScanner() {
	if (IsDebuggerPresent()) {
		ExitProcess(0);
	}
}

//--- Module Scanner (~10s)
void SelfScanner() {
	char* allowedPaths[] = { "Teamspeak", "Bonjour", "Arma 3", "Steam", "NVIDIA", "AMD", "Intel", "Teamspeak", "Teamspeak", "Teamspeak", "Teamspeak", "Teamspeak", "Teamspeak" };

	HANDLE hProcess = GetCurrentProcess();
	DWORD cbNeeded;
	
	HMODULE hMods[1024];	//--- Module List Buffer

	if (EnumProcessModules(hProcess, hMods, sizeof(hMods), &cbNeeded)) {
		for (unsigned int i = 0; i < (cbNeeded / sizeof(HMODULE)); i++)
		{

			char fileName[1024];	//--- Module Path Buffer

			HMODULE currentModule = hMods[i]; //--- Module Handle

			GetModuleFileName(currentModule, fileName, 1024);


			bool isbad = true;

			//--- Check if file path is whitelisted
			for (char* path : allowedPaths) {
				if (strstr(fileName, path)) {
					isbad = false;
					break;
				}
			}
			

			//--- Bad module path, exit process
			if (isbad) {
				if (!FreeLibrary(currentModule)) {
					ExitProcess(0);
				}
			}
			else
			{
				//--- Scan For Signatures
				//ScanModule(currentModule);
				//--- Not Enabled Right Now
			}
			Sleep(50);
		}
	}
}

//--- Process Scanner (~10s)
void ProcessScanner() {
	char* badprocesses[] = { "reclass", "ollydbg", "idaq", "fiddler","wireshark","spyxx", "cheatengine" };


	PROCESSENTRY32 entry;
	entry.dwSize = sizeof(PROCESSENTRY32);

	HANDLE snapshot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, NULL);

	if (Process32First(snapshot, &entry) == TRUE)
	{
		while (Process32Next(snapshot, &entry) == TRUE)
		{
			for (char* name : badprocesses) {
				if (strstr(entry.szExeFile, name)) {
					
					HANDLE hProcess = OpenProcess(PROCESS_ALL_ACCESS, FALSE, entry.th32ProcessID);

					//--- Attempt to kill bad process (if all else fails kill myself)
					if (!TerminateProcess(hProcess, 0)) {
						ExitProcess(0);
					}
					CloseHandle(hProcess);
				}
			}
			Sleep(50);
		}
	}
}

//--- Window Title Scanner (~1s)
BOOL CALLBACK CheckWindow(HWND hWnd, LPARAM lParam) {
	char* badTitles[] = { "WinDbgFrameClass", "Fiddler", "WireShark", "Debug", "debug", "Cheat Engine", "EqualCheats", "VileGaming", "ArtificialAiming", "Virtual-Advantage", "MPGH", "UnKnoWnCheaTs", "Aimjunkies", "tmcheats", "Hack", "Cheat", "Radar" };

	char windowTitle[1024];
	GetWindowText(hWnd, windowTitle, 1024);

	for (char* check : badTitles) {

		//--- If the window title contains a bad string
		if (strstr(windowTitle, check)) {
			DWORD ProcessID;
			GetWindowThreadProcessId(hWnd, &ProcessID);
			HANDLE hProcess = OpenProcess(PROCESS_ALL_ACCESS, FALSE, ProcessID);

			//--- Attempt to kill bad process (if all else fails kill myself)
			if (!TerminateProcess(hProcess, 0)) {
				ExitProcess(0);
			}
			CloseHandle(hProcess);
		}
	}
	Sleep(100);
	return true;
}
void WindowScanner() {
	EnumWindows(CheckWindow, 0);
}

//--- Main Scanner Thread
void RunScanners() {
	//initSignatures();
	while (true) {
		DebuggerScanner();
		WindowScanner();
		SelfScanner();
		ProcessScanner();
		Sleep(60000); //--- delay scan for 60 seconds
	}
}

//--- Dll Entrypoint Code
BOOL APIENTRY DllMain(HMODULE hModule, DWORD  ul_reason_for_call, LPVOID lpReserved)
{
	switch (ul_reason_for_call)
	{
	case DLL_PROCESS_ATTACH:
	case DLL_THREAD_ATTACH:
	case DLL_THREAD_DETACH:
	case DLL_PROCESS_DETACH:
		break;
	}
	return TRUE;
}

//--- ArmA Extension code
extern "C"
{
	__declspec(dllexport) void __stdcall RVExtension(char *output, int outputSize, const char *function);
};

void __stdcall RVExtension(char *output, int outputSize, const char *function)
{
	outputSize -= 1;
	if (strstr(function, "startscanner"))
	{
		CreateThread(NULL, NULL, (LPTHREAD_START_ROUTINE)&RunScanners, NULL, NULL, NULL);
		strncpy(output, "scanner started", outputSize);
	}
	else {
		strncpy(output, "scanner running!", outputSize);
	}
}