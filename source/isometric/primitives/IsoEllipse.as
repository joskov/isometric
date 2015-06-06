package isometric.primitives
{
	import isometric.IsoMath;
	import isometric.core.IsoPoint;

	import starling.core.RenderSupport;
	import starling.display.Graphics;
	import starling.display.Shape;

	public class IsoEllipse extends IsoPrimitive
	{
		protected var mEllipse:Shape;
		public function IsoEllipse()
		{
			super();

			mEllipse = new Shape();
			addChild(mEllipse);
		}

		protected function updateEllipse():void
		{
			var pts:Vector.<IsoPoint> = new Vector.<IsoPoint>;
			if (isoHeight == 0) {
				// isoWidth x isoLength
				pts[0] = new IsoPoint(isoWidth * 0.5, 0, 0);
				pts[1] = new IsoPoint(isoWidth * 0.75, 0, 0);
				pts[2] = new IsoPoint(isoWidth, isoLength * 0.25, 0);

				pts[3] = new IsoPoint(isoWidth, isoLength * 0.5, 0);
				pts[4] = new IsoPoint(isoWidth, isoLength * 0.75, 0);
				pts[5] = new IsoPoint(isoWidth * 0.75, isoLength, 0);

				pts[6] = new IsoPoint(isoWidth * 0.5, isoLength, 0);
				pts[7] = new IsoPoint(isoWidth * 0.25, isoLength, 0);
				pts[8] = new IsoPoint(0, isoLength * 0.75, 0);

				pts[9] = new IsoPoint(0, isoLength * 0.5, 0);
				pts[10] = new IsoPoint(0, isoLength * 0.25, 0);
				pts[11] = new IsoPoint(isoWidth * 0.25, 0, 0);
			} else if (isoLength == 0) {
				// isoWidth x height
				throw new Error("Not Implemented!");
			} else if (isoWidth == 0) {
				//length x height
				throw new Error("Not Implemented!");
			} else {
				throw new Error("isoWidth, isoLength or isoHeight must equal to 0!");
			}

			var pt:IsoPoint;
			for each (pt in pts) {
				IsoMath.spaceToScreen(pt, false);
			}

			var graphics:Graphics = mEllipse.graphics;
			graphics.clear();

			graphics.beginFill(mFillColor, mFillAlpha);
			graphics.lineStyle(mBorderThickness, mBorderColor, mBorderAlpha);
			graphics.moveTo(pts[0].x, pts[0].y);
			graphics.cubicCurveTo(pts[1].x, pts[1].y, pts[2].x, pts[2].y, pts[3].x, pts[3].y);
			graphics.cubicCurveTo(pts[4].x, pts[4].y, pts[5].x, pts[5].y, pts[6].x, pts[6].y);
			graphics.cubicCurveTo(pts[7].x, pts[7].y, pts[8].x, pts[8].y, pts[9].x, pts[9].y);
			graphics.cubicCurveTo(pts[10].x, pts[10].y, pts[11].x, pts[11].y, pts[0].x, pts[0].y);
			graphics.endFill();
		}

		override public function render(support:RenderSupport, parentAlpha:Number):void
		{
			if (mInvalid) {
				updateEllipse();
			}
			super.render(support, parentAlpha);
		}
	}
}