=======================================
ArmA 3 | Module Scanner
======================================
The A3MS Project was an initiative started by Ryan at PUBR to help increase the
security of the arma 3 engine. This extension is meant to protect the server from
certain game cheats & hacks.

=======================================
How to activate the extension in game: 
=======================================
use CallExtension (more info on wiki)

"Extension Name" callExtension "startscanner"

=======================================
Currently the scanner protects against: 
=======================================
	- Bad Window Titles (Programs referenced with cheating)
	- Bad Processes (Programs referenced with cheating & debugging)
	- Application Debugging (Attempts to debug ArmA 3)
	- Module Scanning (DLLs Injected that are fishy)

=======================================
What happens when it detects something?
=======================================
	- Module Scanner -
		[*] Attempts to remove the DLL from the game
		[*] IF it fails it terminates the game process
	- Debugger -
		[*] Fires Breakpoint
		[*] Terminates the game process
	- Bad Processes -
		[*] Attempts to close the process
		[*] IF it fails it terminates the game process
	- Bad Window Title -
		[*] Attempts to close the process with the title
		[*] IF it fails it terminates the game process
		
=======================================
  Why should this extension be used?
=======================================
BattlEye does a great job at detected cheaters and has one of the largest banlists
on record, however they do not catch them all. People using memory cheats often slide
under their radar and ruin the game for those who are trying to have some fun. This
extension adds features that BE has not implemented and will catch these cheaters off
guard. This will help further protect the game engine from memory cheats created and sold.

=======================================
Known Bugs / Issues with the extension
=======================================
1. No linux support
	- As of now the extension does not support the linux OS
2. Game Crashes
	- Most often this will be caused by unknown modules.
	- To aid in our development, use a program and send us
	- a list of DLLs that your ArmA 3 program uses!

=======================================
What we look forward to adding to this: 
=======================================
1. Close Open Process Handles
	- Prevent external memory cheats such as "Radar" cheats.
2. More Debugger Checks
	- Block debuggers created in C++/CLI (.NET)
3. Signature Scanning
	- Scanning loaded modules for "hack" signatures (similar to that of BE)
4. Self Protection & Automated Updates
	- Cross Check itself with a hive update server. If this extension is not "up to date"
	- then it will update itself.
	- If someone modifies the Extension it will notify the change has been detected and to
	- Redownload and try again!
	