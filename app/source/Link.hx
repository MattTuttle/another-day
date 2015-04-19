class Link
{

	public var link(default, null):String;
	public var to(default, null):String;
	public var times(default, null):Int;

	public function new(link:String, to:String, times:Int)
	{
		this.link = link;
		this.to = to;
		this.times = times;
		this.uuid = UUID.generate();
		_links.set(uuid, this);
	}

	public static function click(uuid:String):Void
	{
		var link = _links.get(uuid);
		if (link.times > 0) link.times -= 1;
	}

	public function toString():String
	{
		if (times == 0)
		{
			return link;
		}
		else
		{
			return '<a class="area-link" data-link="$uuid" data-area="$to">$link</a>';
		}
	}

	private var uuid:String;
	private static var _links = new Map<String, Link>();

}