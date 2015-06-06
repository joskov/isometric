package isometric.primitives
{
	import isometric.IsoMath;
	import isometric.Line;
	import isometric.core.IsoPoint;

	import starling.core.RenderSupport;

	public class IsoLine extends IsoPrimitive
	{
		private var mLine:Line;
		private var mTarget:IsoPoint;

		public function IsoLine(thickness:Number = 1)
		{
			super();

			mLine = new Line(0x000000, thickness);
			addChild(mLine);
		}

		public function set target(pt:IsoPoint):void
		{
			if (pt == null) {
				if (mTarget != null) {
					mInvalid = true;
				}
				mTarget = null;
				return;
			}

			if (!mTarget) {
				mTarget = pt;
			} else if (mTarget.x == pt.x && mTarget.y == pt.y) {
				return;
			}

			mTarget.x = pt.x;
			mTarget.y = pt.y;
			mTarget.z = 0;
			mInvalid = true;
		}

		protected function updateLine():void
		{
			mLine.color = mFillColor;
			mLine.alpha = mFillAlpha;

			if (mTarget == null) {
				return;
			}

			var ptOrigin:IsoPoint = new IsoPoint(isoWidth / 2, isoLength / 2, 0);
			var ptTarget:IsoPoint = mTarget.clone() as IsoPoint;

			IsoMath.spaceToScreen(ptOrigin, false);
			IsoMath.spaceToScreen(ptTarget, false);

			mLine.fromX = ptOrigin.x;
			mLine.fromY = ptOrigin.y;
			mLine.toX = ptTarget.x;
			mLine.toY = ptTarget.y;
		}

		public function get angle():Number
		{
			return IsoPoint.theta(new IsoPoint(isoWidth / 2, isoLength / 2, 0), mTarget);
		}

		override public function render(support:RenderSupport, parentAlpha:Number):void
		{
			if (mInvalid) {
				updateLine();
			}
			super.render(support, parentAlpha);
		}
	}
}