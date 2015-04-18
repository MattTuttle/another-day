class Main
{
	public static function main()
	{
		// get data and build structures
		Ajax.getYaml("data/rooms.yaml", function(data) {
			trace(data);
		});
	}
}