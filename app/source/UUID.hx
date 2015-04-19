using StringTools;

class UUID
{
	public static function generate():String
	{
		return hex(8) + "-" + hex(4) + "-4" + hex(3) + "-" + (Std.int(Math.random() * 16) & 0x3 | 0x8).hex() + hex(3) + "-" + hex(12);
	}

	public static function hex(length:Int=8)
	{
		var s = "";
		for (i in 0...length)
		{
			s += Std.int(Math.random() * 16).hex();
		}
		return s;
	}
}
