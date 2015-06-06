package isometric.primitives
{
	import isometric.IsoMath;
	import isometric.Line;
	import isometric.core.IsoDisplayObject;
	import isometric.core.IsoPoint;

	import starling.core.RenderSupport;
	import starling.display.Sprite;

	/**
	 * IsoGrid provides a display grid in the X-Y plane.
	 */
	public class IsoGrid extends IsoDisplayObject
	{
		private var mRows:uint;
		private var mColumns:uint;
		private var mCellSize:Number;
		private var mColor:uint;
		private var mLines:Vector.<Line>;
		private var mWeight:Number;

		public function IsoGrid()
		{
			super();

			mLines = new Vector.<Line>;
		}

		private function updateSize():void
		{
			isoWidth = columns * cellSize;
			isoLength = rows * cellSize;
		}

		public function get weight():Number
		{
			return mWeight;
		}

		public function set weight(value:Number):void
		{
			if (mWeight == value) {
				return;
			}
			mWeight = value;
			mInvalid = true;
		}

		public function get color():uint
		{
			return mColor;
		}

		public function set color(value:uint):void
		{
			if (mColor == value) {
				return;
			}
			mColor = value;

			for each (var line:Line in mLines) {
				line.color = mColor;
			}
		}

		public function get rows():uint
		{
			return mRows;
		}

		public function set rows(value:uint):void
		{
			if (mRows == value) {
				return;
			}
			mRows = value;
			mInvalid = true;
			updateSize();
		}

		public function get columns():uint
		{
			return mColumns;
		}

		public function set columns(value:uint):void
		{
			if (mColumns == value) {
				return;
			}
			mColumns = value;
			mInvalid = true;
			updateSize();
		}

		public function get cellSize():Number
		{
			return mCellSize;
		}

		public function set cellSize(value:Number):void
		{
			if (value < 2) {
				throw new Error("cellSize must be a positive value greater than or equal to 2");
			}

			mCellSize = value;
			updateSize();
		}

		protected function createGrid():void
		{
			var line:Line;
			for each (line in mLines) {
				removeChild(line);
			}
			mLines.length = 0;

			var i:uint;
			var point1:IsoPoint;
			var point2:IsoPoint;

			for (i=0; i<=rows; i++) {
				line = createLine(new IsoPoint(0, i * cellSize, 0), new IsoPoint(columns * cellSize, i * cellSize, 0));
				mLines.push(line);
				addChild(line);
			}
			for (i=0; i<=columns; i++) {
				line = createLine(new IsoPoint(i * cellSize, 0, 0), new IsoPoint(i * cellSize, rows * cellSize, 0));
				mLines.push(line);
				addChild(line);
			}
		}

		public function createLine(point1:IsoPoint, point2:IsoPoint):Line
		{
			var result:Line = new Line(color, weight);
			IsoMath.spaceToScreen(point1, false);
			IsoMath.spaceToScreen(point2, false);
			result.fromX = point1.x;
			result.fromY = point1.y;
			result.toX = point2.x;
			result.toY = point2.y;
			return result;
		}

		override public function render(support:RenderSupport, parentAlpha:Number):void
		{
			if (mInvalid) {
				createGrid();
			}
			super.render(support, parentAlpha);
		}
	}
}