import js.Browser;
import yaml.util.ObjectMap;

class Main
{

	public static var happiness(default, set):Int = 0;
	private static function set_happiness(value:Int):Int
	{
		var el = Browser.document.getElementById("happiness");
		el.innerHTML = Std.string(value);
		return happiness = value;
	}

	public static var flags = new Map<String,Bool>();

	public static function changeArea(area:String, overwrite:Bool=true)
	{
		var room = null;
		if (rooms.exists(area))
		{
			room = rooms.get(area);
			if (room.set != null) flags.set(room.set, true);
			if (room.unset != null) flags.set(room.unset, false);
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
			if (overwrite)
			{
				game.innerHTML = desc;
			}
			else
			{
				game.innerHTML += desc;
			}
			if (room.to != null)
			{
				return changeArea(room.to, false);
			}
		}
		else
		{
			game.innerHTML += '<p>Room "$area" does not exist!</p>';
		}
		return room;
	}

	public static function main()
	{
		// get data and build structures
		Ajax.getYaml("data/objects.yaml", function(data) {
			var areas:ObjectMap<String, Array<Dynamic>> = data.get("areas");
			rooms = new Map<String, Room>();
			for (name in areas.keys())
			{
				rooms.set(name, new Room(areas.get(name)));
				var area = areas.get(name);
			}

			game = Browser.document.getElementById("game");
			var currentRoom = changeArea(cast data.get("start"));
			game.addEventListener("click", function(e) {
				var target = e.target;
				if (target.className == "area-link")
				{
					if (target.hasAttribute("data-option"))
					{
						var option = currentRoom.getOption(target.getAttribute("data-option"));
						if (option != null)
						{
							happiness += option.happiness;
						}
					}
					else if (target.hasAttribute("data-link"))
					{
						Link.click(target.getAttribute("data-link"));
					}
					currentRoom = changeArea(target.getAttribute("data-area"));
				}
			});
		});
	}

	private static var game:js.html.DOMElement;
	private static var rooms:Map<String, Room>;
}