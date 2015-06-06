package isometric.primitives
{
	import isometric.IsoMath;
	import isometric.core.IsoDisplayObject;
	import isometric.core.IsoPoint;

	import starling.core.RenderSupport;
	import starling.display.Graphics;
	import starling.display.Shape;
	import starling.display.graphics.Fill;
	import starling.display.graphics.Stroke;
	import starling.utils.Color;

	public class IsoRectangle extends IsoPrimitive
	{
		protected var mRectangle:Shape;
		public function IsoRectangle()
		{
			super();

			mRectangle = new Shape();
			addChild(mRectangle);
		}

		override public function render(support:RenderSupport, parentAlpha:Number):void
		{
			if (mInvalid) {
				updateRectanglePoints();
			}
			super.render(support, parentAlpha);
		}

		private function updateRectanglePoints():void
		{
			var pts:Vector.<IsoPoint> = new Vector.<IsoPoint>(4, true);
			pts[0] = new IsoPoint(0, 0, 0);
			if (isoHeight == 0) {
				pts[1] = new IsoPoint(0, isoLength, 0);
				pts[2] = new IsoPoint(isoWidth, isoLength, 0);
				pts[3] = new IsoPoint(isoWidth, 0, 0);
			} else if (isoLength == 0) {
				pts[1] = new IsoPoint(isoWidth, 0, 0);
				pts[2] = new IsoPoint(isoWidth, 0, isoHeight);
				pts[3] = new IsoPoint(0, 0, isoHeight);
			} else if (isoWidth == 0) {
				pts[1] = new IsoPoint(0, isoLength, 0);
				pts[2] = new IsoPoint(0, isoLength, isoHeight);
				pts[3] = new IsoPoint(0, 0, isoHeight);
			} else {
				throw new Error("isoWidth, isoLength or isoHeight must be 0 for this class to work");
			}

			var graphics:Graphics = mRectangle.graphics;
			graphics.clear();
			var key:String;
			for (key in pts) {
				IsoMath.spaceToScreen(pts[key], false);
			}


			graphics.beginFill(mFillColor, mFillAlpha);
			graphics.lineStyle(mBorderThickness, mBorderColor, mBorderAlpha);
			graphics.moveTo(pts[3].x, pts[3].y);
			for (key in pts) {
				graphics.lineTo(pts[key].x, pts[key].y);
			}
			graphics.endFill();
		}
	}
}