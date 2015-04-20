class Data
{
	public static var happiness(default, set):Int = 0;
	private static function set_happiness(value:Int):Int
	{
		var el = js.Browser.document.getElementById("happiness");
		el.innerHTML = Std.string(value);
		return happiness = value;
	}

	public static var flags = new Map<String,Bool>();
}