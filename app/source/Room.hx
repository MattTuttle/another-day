class Room
{
	public var description(default, null):String;

	public function new(data:Dynamic)
	{
		description = data.get("description");
		while (link_regex.match(description))
		{
			var link = link_regex.matched(1);
			var to = link_regex.matched(2);
			if (to == null) to = link;
			description = link_regex.matchedLeft() + '<a class="area-link" data-area="$to">$link</a>' + link_regex.matchedRight();
		}
	}

	private var link_regex = ~/\[\s*([a-zA-Z0-9 _]+)(?:\s*\|\s*([a-zA-Z0-9 _]+))?\s*\]/g;
}