import yaml.util.ObjectMap;

typedef Description = {
	flag: String,
	parts: Array<Dynamic>
};

class Room
{
	public var to(default, null):String;
	public var set(default, null):String;
	public var unset(default, null):String;
	public var happiness(default, null):Int;

	public function new(data:Dynamic)
	{
		_options = new Array<Option>();
		_when = new Array<Description>();

		to = data.get("to");
		happiness = data.exists("happiness") ? data.get("happiness") : 0;
		set = data.get("set");
		unset = data.get("unset");

		_defaultDescription = parseDescription(data.get("description"));
		if (data.exists("when"))
		{
			for (when in cast(data.get("when"), Array<Dynamic>))
			{
				_when.push({
					flag: when.get("flag"),
					parts: parseDescription(when.get("description"))
				});
			}
		}

		var options:Array<Dynamic> = data.get("options");
		if (options != null)
		{
			for (option in options)
			{
				_options.push(new Option(option));
			}
		}
	}

	private function parseDescription(description)
	{
		var result = new Array<Dynamic>();
		while (link_regex.match(description))
		{
			var link = link_regex.matched(1);
			var to = link_regex.matched(2);
			var times = link_regex.matched(3) == null ? -1 : Std.parseInt(link_regex.matched(3));
			if (to == null) to = link;
			result.push(link_regex.matchedLeft());
			result.push(new Link(link, to, times));
			description = link_regex.matchedRight();
		}
		if (description != "")
		{
			result.push(description);
		}
		return result;
	}

	private inline function toString():String
	{
		var result = "";
		var parts = _defaultDescription;
		for (when in _when)
		{
			if (Main.flags.exists(when.flag) && Main.flags.get(when.flag) == true)
			{
				parts = when.parts;
				break;
			}
		}
		for (part in parts)
		{
			result += Std.string(part); // calls toString on anything not a String
		}
		if (_options.length > 0)
		{
			result += '<ul>';
			for (option in _options)
			{
				result += '<li>${option.description}</li>';
			}
			result += '</ul>';
		}
		return result;
	}

	public function getOption(uuid:String):Option
	{
		for (option in _options)
		{
			if (option.uuid == uuid)
			{
				return option;
			}
		}
		return null;
	}

	private var _options:Array<Option>;
	private var _when:Array<Description>;
	private var _defaultDescription:Array<Dynamic>;

	private var link_regex = ~/\[\s*([a-zA-Z0-9 _]+)(?:\s*\|\s*([a-zA-Z0-9 _]+))?\s*\](?:\{([0-9]+)\})?/g;
}