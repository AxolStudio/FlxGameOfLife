package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tile.FlxBaseTilemap.FlxTilemapAutoTiling;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;

class PlayState extends FlxState
{
	public static inline var COLOR_BACK:FlxColor = 0xff000000;
	public static inline var COLOR_GRID:FlxColor = 0xff333333;
	public static inline var COLOR_ALIVE:FlxColor = 0xff33ff99;

	// how big in tiles our map is
	public static inline var MAP_SIZE:Int = 28;

	// how big our tiles are
	public static inline var TILE_SIZE:Int = 16;

	// our map of life
	public var lifeMap:FlxTilemap;

	override public function create()
	{
		bgColor = COLOR_BACK;

		createMap();
		createHUD();
		makeGrid();

		super.create();
	}

	// create our empy life map
	private function createMap():Void
	{
		var tiles:BitmapData = new BitmapData(Std.int(TILE_SIZE * 2), TILE_SIZE, false, COLOR_BACK);
		tiles.fillRect(new Rectangle(TILE_SIZE, 0, TILE_SIZE, TILE_SIZE), COLOR_ALIVE);

		add(lifeMap = new FlxTilemap());
		lifeMap.loadMapFromArray([for (i in 0...(MAP_SIZE * MAP_SIZE)) 0], MAP_SIZE, MAP_SIZE, tiles, TILE_SIZE, TILE_SIZE, FlxTilemapAutoTiling.OFF, 0, 0, 0);

		lifeMap.x = 8;
		lifeMap.y = 8;
	}

	// this function just draws gridlines for our tilemap
	private function makeGrid():Void
	{
		var bmpGrid:BitmapData = new BitmapData(MAP_SIZE * TILE_SIZE + 4, MAP_SIZE * TILE_SIZE + 4, true, 0x0);

		bmpGrid.lock();

		var fRect:Rectangle = new Rectangle(0, 0, bmpGrid.width, 1);

		bmpGrid.fillRect(fRect, COLOR_GRID);

		fRect = new Rectangle(0, 0, 1, bmpGrid.height);

		bmpGrid.fillRect(fRect, COLOR_GRID);

		fRect = new Rectangle(0, bmpGrid.height - 1, bmpGrid.width, 1);

		bmpGrid.fillRect(fRect, COLOR_GRID);

		fRect = new Rectangle(bmpGrid.width - 1, 0, 1, bmpGrid.height);

		bmpGrid.fillRect(fRect, COLOR_GRID);

		for (x in 0...MAP_SIZE + 1)
		{
			// draw horizontal line

			fRect = new Rectangle(0, 1 + (TILE_SIZE * x), bmpGrid.width, 2);
			bmpGrid.fillRect(fRect, COLOR_GRID);
			// draw vertical line
			fRect = new Rectangle(1 + (TILE_SIZE * x), 0, 2, bmpGrid.height);
			bmpGrid.fillRect(fRect, COLOR_GRID);
		}

		bmpGrid.unlock();

		var gridLines:FlxSprite = new FlxSprite(6, 6, bmpGrid);

		add(gridLines);
	}

	// create the hud with all our options and buttons, etc
	private function createHUD():Void
	{
		var startX:Int = Std.int(lifeMap.width + 16);
		var endX:Int = Std.int(FlxG.width - 8);
		var midX:Int = Std.int((endX - startX) / 2);
		var yPos:Float = 8;

		// speed down button
		var btn:FlxButton = new FlxButton(0, yPos, "-", speedDown);
		btn.x = startX + midX - (btn.width / 2);
		add(btn);

		yPos += btn.height + 2;

		// current speed
		var txt:FlxText = new FlxText(startX, yPos, endX - startX, "1");
		txt.color = FlxColor.WHITE;
		txt.alignment = FlxTextAlign.CENTER;
		txt.x = startX + midX - (txt.width / 2);
		add(txt);

		yPos += txt.height + 2;

		// speed up button
		btn = new FlxButton(startX, yPos, "+", speedUp);
		btn.x = startX + midX - (btn.width / 2);
		add(btn);

		yPos += btn.height + 4;

		// pause button
		btn = new FlxButton(startX, yPos, "PAUSE", pauseGame);
		btn.x = startX + midX - (btn.width / 2);
		add(btn);

		// preset 1 button
		// preset 2 button
		// preset 3 button

		yPos += btn.height + 4;

		btn = new FlxButton(startX, yPos, "CLEAR", clearMap);
		btn.x = startX + midX - (btn.width / 2);
		add(btn);

		// show rules button
	}

	private function clearMap():Void {}

	private function speedDown():Void {}

	private function speedUp():Void {}

	private function pauseGame():Void {}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
