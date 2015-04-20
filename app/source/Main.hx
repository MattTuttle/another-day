import js.Browser;
import yaml.util.ObjectMap;

class Main
{

	public static function changeArea(area:String, overwrite:Bool=true)
	{
		var room = null;
		if (rooms.exists(area))
		{
			var flags = Data.flags;
			room = rooms.get(area);
			var condition = room.getCondition();
			Data.happiness += condition.happiness;
			if (condition.set != null) flags.set(condition.set, true);
			if (condition.unset != null) flags.set(condition.unset, false);
#if debug
			var f = Browser.document.getElementById("debug");
			var html = "";
			for (f in flags.keys())
			{
				if (flags.get(f))
				{
					html += "<li>" + f + "</li>";
				}
			}
			f.innerHTML = "<ul>" + html + "</ul>";
#end
			var desc = '<p>$room</p>';
			if (condition.to != null)
			{
				var link = new Link("Continue", condition.to);
				desc += '<p>$link</p>';
			}
			if (overwrite)
			{
				game.innerHTML = desc;
			}
			else
			{
				game.innerHTML += desc;
			}
		}
		else
		{
			game.innerHTML += '<p>Room "$area" does not exist!</p>';
		}
		return room;
	}

	private static function parseYaml(data)
	{
		var areas:ObjectMap<String, Array<Dynamic>> = data;
		for (name in areas.keys())
		{
			rooms.set(name, new Room(areas.get(name)));
			var area = areas.get(name);
		}
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
					parseYaml(yaml.Yaml.parse(data));
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