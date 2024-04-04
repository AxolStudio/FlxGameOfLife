package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;
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

	// which mode the mouse is in
	public var mouseMode:MouseMode = MouseMode.NONE;

	// the speed of the simulation
	public var speed:Int = 0;

	// the different speeds we can use, in seconds
	public static var SPEEDS:Array<Float> = [1, .75, .5, .25];

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

		var txt:FlxText = new FlxText(startX, yPos, endX - startX, "SPEED");
		txt.color = FlxColor.WHITE;
		txt.alignment = FlxTextAlign.CENTER;
		txt.x = startX + midX - (txt.width / 2);
		add(txt);

		yPos += txt.height + 4;

		// speed down button
		var btn:FlxButton = new FlxButton(0, yPos, "<", speedDown);
		btn.x = startX + midX - (btn.width / 2);
		add(btn);

		yPos += btn.height + 4;

		// current speed
		txt = new FlxText(startX, yPos, endX - startX, ">");
		txt.color = FlxColor.WHITE;
		txt.alignment = FlxTextAlign.CENTER;
		txt.x = startX + midX - (txt.width / 2);
		add(txt);

		yPos += txt.height + 4;

		// speed up button
		btn = new FlxButton(startX, yPos, ">", speedUp);
		btn.x = startX + midX - (btn.width / 2);
		add(btn);

		yPos += btn.height + 4;

		// pause button
		btn = new FlxButton(startX, yPos, "PAUSE", pauseGame);
		btn.x = startX + midX - (btn.width / 2);
		add(btn);

		yPos += btn.height + 16;

		// preset 1 button
		btn = new FlxButton(startX, yPos, "PRESET 1", selectPreset.bind(0));
		btn.x = startX + midX - (btn.width / 2);
		add(btn);

		yPos += btn.height + 4;

		// preset 2 button
		btn = new FlxButton(startX, yPos, "PRESET 2", selectPreset.bind(1));
		btn.x = startX + midX - (btn.width / 2);
		add(btn);

		yPos += btn.height + 4;

		// preset 3 button

		btn = new FlxButton(startX, yPos, "PRESET 3", selectPreset.bind(2));
		btn.x = startX + midX - (btn.width / 2);
		add(btn);

		yPos += btn.height + 16;

		// clear button
		btn = new FlxButton(startX, yPos, "CLEAR", clearMap);
		btn.x = startX + midX - (btn.width / 2);
		add(btn);

		yPos += btn.height + 16;

		// show rules button
		btn = new FlxButton(startX, yPos, "RULES", showRules);
		btn.x = startX + midX - (btn.width / 2);
		add(btn);
	}

	private function clearMap():Void {}

	private function speedDown():Void {}

	private function speedUp():Void {}

	private function pauseGame():Void {}

	private function selectPreset(preset:Int):Void {}

	private function showRules():Void {}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		updateMouse();

		updateSimulation(elapsed);
	}

	private function updateSimulation(elapsed:Float):Void {}

	private function updateMouse():Void
	{
		final mPos:FlxPoint = FlxG.mouse.getWorldPosition();
		if (mPos.x >= lifeMap.x && mPos.y >= lifeMap.y && mPos.x < lifeMap.x + lifeMap.width && mPos.y < lifeMap.y + lifeMap.height)
		{
			var mPosOff:FlxPoint = new FlxPoint((mPos.x - lifeMap.x) / TILE_SIZE, (mPos.y - lifeMap.y) / TILE_SIZE);

			if (FlxG.mouse.justPressed)
			{
				mouseMode = lifeMap.getTile(Std.int(mPosOff.x), Std.int(mPosOff.y)) == 0 ? PAINT : ERASE;
			}
			else if (FlxG.mouse.pressed)
			{
				lifeMap.setTile(Std.int(mPosOff.x), Std.int(mPosOff.y), mouseMode == PAINT ? 1 : 0);
			}
			else if (FlxG.mouse.released)
				mouseMode = NONE;
		}
		else
			mouseMode = NONE;
	}
}

enum MouseMode
{
	NONE;
	PAINT;
	ERASE;
}
