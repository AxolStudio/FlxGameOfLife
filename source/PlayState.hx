package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.tile.FlxBaseTilemap.FlxTilemapAutoTiling;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;

class PlayState extends FlxState
{
	// how big in tiles our map is
	public static inline var MAP_SIZE:Int = 28;

	// how big our tiles are
	public static inline var TILE_SIZE:Int = 8;

	// our map of life
	public var lifeMap:FlxTilemap;

	public var btnClear:FlxButton;

	override public function create()
	{
		createMap();
		createHUD();

		super.create();
	}

	// create our empy life map
	private function createMap():Void
	{
		var tiles:BitmapData = new BitmapData(Std.int(TILE_SIZE * 2), TILE_SIZE, false, FlxColor.BLACK);
		tiles.fillRect(new Rectangle(TILE_SIZE, 0, TILE_SIZE, TILE_SIZE), FlxColor.LIME);

		add(lifeMap = new FlxTilemap());
		lifeMap.loadMapFromArray([for (i in 0...(MAP_SIZE * MAP_SIZE)) 0], MAP_SIZE, MAP_SIZE, tiles, TILE_SIZE, TILE_SIZE, FlxTilemapAutoTiling.OFF, 0, 0, 0);

		lifeMap.x = 8;
		lifeMap.y = 8;
	}

	// create the hud with all our options and buttons, etc
	private function createHUD():Void
	{
		var startX:Int = Std.int(lifeMap.width + 16);

		add(btnClear = new FlxButton(startX, 8, "CLEAR", clearMap));
		btnClear.width = FlxG.width - startX - 16;
	}

	private function clearMap():Void {}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
