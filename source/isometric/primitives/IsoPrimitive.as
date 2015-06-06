package isometric.primitives
{
	import isometric.core.IsoDisplayObject;

	public class IsoPrimitive extends IsoDisplayObject
	{
		protected var mBorderThickness:Number;
		protected var mBorderColor:uint;
		protected var mBorderAlpha:Number;
		protected var mFillColor:uint;
		protected var mFillAlpha:Number;
		public function IsoPrimitive()
		{
			super();

			depthSorting = false;
			setFill(0x000000, 0);
			setBorder(0, 0x000000, 0);
		}

		public function setBorder(thickness:Number, color:uint, alpha:Number):void
		{
			if (mBorderThickness == thickness && mBorderColor == color && mBorderAlpha == alpha) {
				return;
			}

			mBorderThickness = thickness;
			mBorderColor = color;
			mBorderAlpha = alpha;
			mInvalid = true;
		}

		public function setFill(color:uint, alpha:Number):void
		{
			if (mFillColor == color && mFillAlpha == alpha) {
				return;
			}

			mFillColor = color;
			mFillAlpha = alpha;
			mInvalid = true;
		}
	}
}