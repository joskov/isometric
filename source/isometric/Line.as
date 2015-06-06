package isometric 
{
	import starling.display.Quad;

	public class Line extends Quad
	{
		private var mFromX:Number;
		private var mFromY:Number;
		private var mToX:Number;
		private var mToY:Number;
		private var mColor:uint;
		private var mWeight:Number;
		private var mInitialized:Boolean;

		public function Line(color:uint = 0x000000, weight:Number = 1.0, alpha:Number = 1.0)
		{
			super(1, weight, color);
			super.alignPivot();

			mColor = color;
			mWeight = weight;
			this.alpha = alpha;
		}

		public function set fromX(value:Number):void
		{
			mFromX = value;
			update();
		}

		public function get fromX():Number
		{
			return mFromX;
		}

		public function set fromY(value:Number):void
		{
			mFromY = value;
			update();
		}

		public function get fromY():Number
		{
			return mFromY;
		}

		public function get toX():Number
		{
			return mToX;
		}

		public function set toX(value:Number):void
		{
			mToX = value;
			update();
		}

		public function get toY():Number
		{
			return mToY;
		}

		public function set toY(value:Number):void
		{
			mToY = value;
			update();
		}

		private function update():void
		{
			rotation = Math.atan2(mToY - mFromY, mToX - mFromX);
			scaleX = Math.sqrt(Math.pow(mToX - mFromX, 2) + Math.pow(mToY - mFromY, 2));
			super.x = (toX + fromX) / 2;
			super.y = (toY + fromY) / 2;
		}
	}
}