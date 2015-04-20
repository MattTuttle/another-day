import js.html.*;

class Data
{

	public static inline var maxHappiness = 10;

	public static var happiness(default, set):Int = 0;
	private static function set_happiness(value:Int):Int
	{
		// cap happiness values
		if (Math.abs(happiness) > maxHappiness) happiness = (happiness < 0 ? -1 : 1) * maxHappiness;

		var percent = ((value + maxHappiness) / maxHappiness / 2);

		if (_path == null)
		{
			_path = js.Browser.document.getElementById("happiness").getElementsByTagName("path")[0];
			// setup initial style properties
			untyped {
				_path.style.strokeDasharray = _path.getTotalLength();
				_path.style.strokeDashoffset = _path.style.strokeDasharray * 0.5;
				_path.style.strokeWidth = 5;
				// delay to prevent initial transition...
				haxe.Timer.delay(function () {
					_path.style.transition = _path.style.webkitTransition = "stroke-dashoffset 0.3s, stroke 0.3s";
				}, 500);
			}
		}

		// Set face and stroke color based on percent of happiness
		var color = "#4DAF33";
		var face = "face-wink";
		if (percent < 0.2)
		{
			color = "#AF0025";
			face = "face-angry";
		}
		else if (percent < 0.4)
		{
			color = "#AF0025";
			face = "face-sad";
		}
		else if (percent < 0.5)
		{
			color = "#DDC41D";
			face = "face-shocked";
		}
		else if (percent < 0.6)
		{
			color = "#DDC41D";
			face = "face-neutral";
		}
		else if (percent < 0.8)
		{
			color = "#4DAF33";
			face = "face-smile";
		}
		js.Browser.document.getElementById("face").setAttribute("xlink:href", "#" + face);
		untyped {
			var len = _path.style.strokeDasharray = _path.getTotalLength();
			_path.style.strokeDashoffset = len * (1 - percent);
			_path.style.stroke = color;
		}
		return happiness = value;
	}

	public static var flags = new Map<String,Bool>();

	private static var _path:DOMElement;
}
