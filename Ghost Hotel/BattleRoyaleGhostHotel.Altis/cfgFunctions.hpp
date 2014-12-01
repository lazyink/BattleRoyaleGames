
class cfgFunctions {
	class BRGH {
		class Server {
			//Root Server
			class serverStart {
				file = "Server\start.sqf";
			};
			class serverSetup {
				file = "Server\setup.sqf";
			};
			class serverReset {
				file = "Server\reset.sqf";
			};
			class serverConfig {
				file = "Server\config.sqf";
			};
			//players
			class playerConfig {
				file = "Server\Players\player_config.sqf";
			};
			class deathMessages {
				file = "Server\Players\deathMessages.sqf";
			};
			class waitForPlayers {
				file = "Server\Players\waitForPlayers.sqf";
			};
			//map
			class mapSetup {
				file = "Server\Map\setup_map.sqf";
			};
			class mapCleanup {
				file = "Server\Map\cleanup_map.sqf";
			};
			class startZoning {
				file = "Server\Map\start_zoning.sqf";
			};
			class vehicleHandler {
				file = "Server\Map\vehicle_handler.sqf";
			};
			//weather
			class simpleFog {
				file = "Server\Weather\fn_simpleFog.sqf";
			};
			class startWeather {
				file = "Server\Weather\start_weather.sqf";
			};
			//loot
			class spawnLoot {
				file = "Server\Loot\spawn_loot.sqf";
			};
			class lootConfig {
				file = "Server\Loot\loot_config.sqf";
			};
		};
		class Client {
			//Root Client
			class clientStart {
				file = "Clients\start.sqf";
			};	
			class clientSetup {
				file = "Clients\setup.sqf";
			};
			class clientReset {
				file = "Clients\reset.sqf";
			};
			//player
			class playerSetup {
				file = "Clients\Player\setup_player.sqf";
			};
			class playerEvents {
				file = "Clients\Player\Player_EventHandlers.sqf";
			};
			class afkTimer {
				file = "Clients\Player\AFK_timer.sqf";
			};
			//map
			class clientWeather {
				file = "Clients\Map\setup_weather.sqf";
			};
			class clientFog {
				file = "Clients\Map\clientFog.sqf";
			};
			//spectating
			class spectate {
				file = "Clients\Spectating\spectate.sqf";
			};
			class endSpectate {
				file = "Clients\Spectating\kill_spectate.sqf";
			};
			//VON
			class startVON {
				file = "Clients\VON\start_von.sqf";
			};
			class endVON {
				file = "Clients\VON\end_von.sqf";
			};
			//GUI
			class createInGameGUI {
				file = "Clients\GUI\inGame_create.sqf";
			};
			class updateInGameGUI {
				file = "Clients\GUI\inGame_update.sqf";
			};
			class deleteInGameGUI {
				file = "Clients\GUI\inGame_cleanup.sqf";
			};
			class startSpectatorGUI {
				file = "Clients\GUI\spectator_start.sqf";
			};
			class deleteSpectatorGUI {
				file = "Clients\GUI\spectator_stop.sqf";
			};
			class setupGUI {
				file = "Clients\GUI\setup_GUI.sqf";
			};
		};
		class FSMs {
			class AntiTP {
				file = "FSMs\antitp.fsm";
				ext = ".fsm";
			};
		};
	};
};