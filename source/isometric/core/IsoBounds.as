package isometric.core
{
	public class IsoBounds
	{
		protected var mTarget:IsoDisplayObject;

		public function IsoBounds(target:IsoDisplayObject)
		{
			this.mTarget = target;
		}

		public function get volume():Number
		{
			return mTarget.isoWidth * mTarget.isoLength * mTarget.isoHeight;
		}

		public function get width():Number
		{
			return mTarget.isoWidth;
		}

		public function get length():Number
		{
			return mTarget.isoLength;
		}

		public function get height():Number
		{
			return mTarget.isoHeight;
		}

		public function get left():Number
		{
			return mTarget.isoX;
		}

		public function get right():Number
		{
			return mTarget.isoX + mTarget.isoWidth;
		}

		public function get back():Number
		{
			return mTarget.isoY;
		}

		public function get front():Number
		{
			return mTarget.isoY + mTarget.isoLength;
		}

		public function get bottom():Number
		{
			return mTarget.isoZ;
		}

		public function get top():Number
		{
			return mTarget.isoZ + mTarget.isoHeight;
		}

		public function get centerPt():IsoPoint
		{
			var pt:IsoPoint = new IsoPoint();
			pt.x = mTarget.isoX + mTarget.isoWidth / 2;
			pt.y = mTarget.isoY + mTarget.isoLength / 2;
			pt.z = mTarget.isoZ + mTarget.isoHeight / 2;
			return pt;
		}

		public function getPts():Array
		{
			var a:Array = [];

			a.push(new IsoPoint(left, back, bottom));
			a.push(new IsoPoint(right, back, bottom));
			a.push(new IsoPoint(right, front, bottom));
			a.push(new IsoPoint(left, front, bottom));

			a.push(new IsoPoint(left, back, top));
			a.push(new IsoPoint(right, back, top));
			a.push(new IsoPoint(right, front, top));
			a.push(new IsoPoint(left, front, top));

			return a;
		}

		public function intersects(bounds:IsoBounds):Boolean
		{
			var center:IsoPoint = centerPt;
			var otherCenter:IsoPoint = bounds.centerPt;

			if (Math.abs(center.x - otherCenter.x) <= mTarget.isoWidth / 2 + bounds.width / 2 &&
				Math.abs(center.y - otherCenter.y) <= mTarget.isoLength / 2 + bounds.length / 2 &&
				Math.abs(center.z - otherCenter.z) <= mTarget.isoHeight / 2 + bounds.height / 2) {
				return true;
			}
			return false;
		}

		public function collides(bounds:IsoBounds):Boolean
		{
			var center:IsoPoint = centerPt;
			var otherCenter:IsoPoint = bounds.centerPt;

			if (Math.abs(center.x - otherCenter.x) < mTarget.isoWidth / 2 + bounds.width / 2 &&
				Math.abs(center.y - otherCenter.y) < mTarget.isoLength / 2 + bounds.length / 2 &&
				Math.abs(center.z - otherCenter.z) < mTarget.isoHeight / 2 + bounds.height / 2) {
				return true;
			}
			return false;
		}

		public function containsPt(target:IsoPoint):Boolean
		{
			if ((left <= target.x && target.x <= right) &&
				(back <= target.y && target.y <= front) &&
				(bottom <= target.z && target.z <= top)) {
				return true;
			}

			return false;
		}
	}
}