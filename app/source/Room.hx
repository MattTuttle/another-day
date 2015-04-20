import yaml.util.ObjectMap;

using StringTools;

typedef Condition = {
	set: String,
	?unset: String,
	to:String,
	views: Int,
	happiness: Int,
	parts: Array<Dynamic>
};

class Room
{

	public function new(data:Dynamic)
	{
		_options = new Array<Option>();
		_conditions = new Array<Condition>();

		_defaultCondition = {
			to: data.get("to"),
			set: data.get("set"),
			unset: data.get("unset"),
			views: 0,
			parts: parseDescription(data.get("description")),
			happiness: data.exists("happiness") ? data.get("happiness") : 0
		};

		if (data.exists("when"))
		{
			for (when in cast(data.get("when"), Array<Dynamic>))
			{
				_conditions.push({
					set: when.get("flag"),
					to: when.exists("to") ? when.get("to") : _defaultCondition.to,
					views: when.get("views"),
					happiness: when.exists("happiness") ? when.get("happiness") : _defaultCondition.happiness,
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

	private function parseDescription(description:Dynamic)
	{
		var result = new Array<Dynamic>();
		var lines = if (Std.is(description, Array))
		{
			cast(description, Array<Dynamic>);
		}
		else
		{
			description.split("\n");
		}

		for (i in 0...lines.length)
		{
			var line:String = lines[i];
			if (line.trim() == "") continue;

			while (link_regex.match(line))
			{
				var link = link_regex.matched(1);
				var to = link_regex.matched(2);
				var times = link_regex.matched(3) == null ? -1 : Std.parseInt(link_regex.matched(3));
				if (to == null) to = link;
				result.push(link_regex.matchedLeft());
				result.push(new Link(link, to, times));
				line = link_regex.matchedRight();
			}
			if (line != "")
			{
				result.push(line);
			}
			result.push(new LineBreak());
		}
		if (result.length > 0 && Std.is(result[result.length-1], LineBreak))
		{
			result.pop();
		}

		return result;
	}

	public function getCondition():Condition
	{
		var flags = Data.flags;
		// check through when conditions for a better description
		for (condition in _conditions)
		{
			if ((condition.set != null && flags.exists(condition.set) && flags.get(condition.set) == true) ||
				condition.views == _viewTimes)
			{
				return condition;
				break;
			}
		}
		return _defaultCondition;
	}

	private inline function toString():String
	{
		_viewTimes += 1;

		var result = "";
		for (part in getCondition().parts)
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

	private var _viewTimes:Int = 0;
	private var _options:Array<Option>;
	private var _conditions:Array<Condition>;
	private var _defaultCondition:Condition;
	private var _defaultDescription:Array<Dynamic>;

	private var link_regex = ~/\[\s*([a-zA-Z0-9 _'"]+)(?:\s*\|\s*([a-zA-Z0-9 _"']+))?\s*\](?:\{([0-9]+)\})?/g;
}