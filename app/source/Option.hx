class Option
{
	public var option(default, null):String;
	public var goto(default, null):String;
	public var uuid(default, null):String;
	public var happiness(default, null):Int;

	public function new(data:Dynamic)
	{
		uuid = UUID.generate();
		option = data.get("option");
		goto = data.get("to");
		happiness = data.exists("happiness") ? data.get("happiness") : 0;
	}

	public var description(get, never):String;
	private inline function get_description():String
	{
		return '<a class="area-link" data-option="$uuid" data-area="$goto">$option</a>';
	}
}