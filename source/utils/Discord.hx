package utils;

import Sys.sleep;
import hxdiscord_rpc.Discord;
import hxdiscord_rpc.Types;

class DiscordClient
{
	public static var clientID:String = "1233843000283762739";
	public static var initalized:Bool;
	private static var presence:DiscordRichPresence = DiscordRichPresence.create();

	public static function init() {
		Application.current.window.onClose.add(() -> { if (initialized) shutdown(); });
		initializeClient();
	}

	private static function onReady(request:cpp.RawConstPointer<DiscordUser>):Void {
		if (Std.parseInt(cast(request[0].discriminator, String)) != 0)
			Sys.println('Discord: Connected to user (${cast(request[0].username, String)}#${cast(request[0].discriminator, String)})');
		else
			Sys.println('Discord: Connected to user (${cast(request[0].username, String)})');

		changePresence();
	}

	private static function onDisconnected(errorCode:Int, message:cpp.ConstCharStar):Void {
		Sys.println('Discord: Disconnected ($errorCode: ${cast(message, String)})');
	}

	private static function onError(errorCode:Int, message:cpp.ConstCharStar):Void {
		Sys.println('Discord: Error ($errorCode: ${cast(message, String)})');
	}

	public static function initializeClient() {
		var rpcHandler:DiscordEventrpcHandler = DiscordEventrpcHandler.create();
		rpcHandler.ready = cpp.Function.fromStaticFunction(onReady);
		rpcHandler.disconnected = cpp.Function.fromStaticFunction(onDisconnected);
		rpcHandler.errored = cpp.Function.fromStaticFunction(onError);
		Discord.Initialize(clientID, cpp.RawPointer.addressOf(rpcHandler), 1, null);

		sys.thread.Thread.create(() -> {
			while (true)
			{
				#if DISCORD_DISABLE_IO_THREAD
				Discord.UpdateConnection();
				#end
				Discord.RunCallbacks();

				// Wait 1 second until the next loop...
				Sys.sleep(1);
			}
		});
		
		initalized = true;
	}

	public static function changePresence(?state:String = '', ?details:String = '', ?smallImageKey:String = '') {
		presence.state = state;
		presence.details = details;
		presence.largeImageKey = 'logo';
		presence.largeImageText = "Funkin' Out Engine v" + Application.current.meta.get('version');
		presence.smallImageKey = smallImageKey;
		updatePresence();
	}

	public static function changePresenceLargeIcon(largeImageKey:String = '', ?largeImageText:String = null) {
		presence.largeImageKey = largeImageKey;
		if (largeImageText != null) presence.largeImageText = largeImageText;
		updatePresence();
	}

	public static function updatePresence() {
		Discord.UpdatePresence(cpp.RawConstPointer.addressOf(presence));
	}

	public static function setClientID(newID:String) {
		var changedID:Bool = (clientID != newID);
		clientID = newID;

		if (changedID && initialized) {
			shutdown();
			initializeClient();
			updatePresence();
		}
	}

	public static function shutdown() {
		if (initalized) {
			Discord.Shutdown();
			initalized = false;
		} else {
			trace('Discord RPC is already down!');
		}
	}
}
