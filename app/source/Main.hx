import js.Browser;
import yaml.util.ObjectMap;

class Main
{
	public static function main()
	{
		// get data and build structures
		Ajax.getYaml("data/objects.yaml", function(data) {
			var areas:ObjectMap<String, Array<Dynamic>> = data.get("areas");
			var rooms = new Map<String, Room>();
			for (name in areas.keys())
			{
				rooms.set(name, new Room(areas.get(name)));
				var area = areas.get(name);
			}
			var start:String = cast data.get("start");

			var game = Browser.document.getElementById("game");
			game.addEventListener("click", function(e) {
				if (e.target.className == "area-link")
				{
					game.innerHTML = rooms.get(e.target.getAttribute("data-area")).description;
				}
			});
			game.innerHTML = rooms.get(start).description;
		});
	}
}