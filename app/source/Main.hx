import js.Browser;
import yaml.util.ObjectMap;

class Main
{

	public static function changeArea(area:String)
	{
		var room = null;
		if (rooms.exists(area))
		{
			var flags = Data.flags;
			room = rooms.get(area);
			var desc = '<p>$room</p>';
			var condition = room.getCondition();
			Data.happiness += condition.happiness;
			if (condition.set != null) flags.set(condition.set, true);
			if (condition.unset != null) flags.set(condition.unset, false);
			debug(flags.toString());
			game.innerHTML = desc;
		}
		else
		{
			game.innerHTML += '<p>Room "$area" does not exist!</p>';
		}
		return room;
	}

	public static function start()
	{
		game = Browser.document.getElementById("game");
		var currentRoom = changeArea(startRoom);
		game.addEventListener("click", function(e) {
			var target = e.target;
			if (target.className == "area-link")
			{
				if (target.hasAttribute("data-option"))
				{
					var option = currentRoom.getOption(target.getAttribute("data-option"));
					if (option != null)
					{
						Data.happiness += option.happiness;
					}
				}
				else if (target.hasAttribute("data-link"))
				{
					Link.click(target.getAttribute("data-link"));
				}
				currentRoom = changeArea(target.getAttribute("data-area"));
			}
		});
	}

	public static function debug(msg:String):Void
	{
		#if debug
		trace(msg);
		#end
	}

	public static function main()
	{
		// get data and build structures
		Ajax.get("data/main.json", function(data) {
			rooms = new Map<String, Room>();
			var json = haxe.Json.parse(data);
			startRoom = json.start;

			var includes:Array<Dynamic> = json.includes;
			var toLoad = includes.length;
			for (include in includes)
			{
				Ajax.get(include, function(data) {
					var areas:ObjectMap<String, Array<Dynamic>> = yaml.Yaml.parse(data);
					// TODO: lock rooms object during concurrent write operations...
					for (name in areas.keys())
					{
						if (rooms.exists(name))
						{
							debug('Room $name exists more than once.');
						}
						rooms.set(name, new Room(areas.get(name)));
					}
					// if all include files are loaded we can start the game
					if (--toLoad == 0)
					{
						start();
					}
				});
			}
		});
	}

	private static var game:js.html.DOMElement;
	private static var rooms:Map<String, Room>;
	private static var startRoom:String;

}
