package isometric.core
{
	import flash.geom.Point;

	public class IsoPoint extends Point
	{
		static public function distance(ptA:IsoPoint, ptB:IsoPoint):Number
		{
			var tx:Number = ptB.x - ptA.x;
			var ty:Number = ptB.y - ptA.y;
			var tz:Number = ptB.z - ptA.z;

			return Math.sqrt(tx * tx + ty * ty + tz * tz);
		}

		static public function theta(ptA:IsoPoint, ptB:IsoPoint):Number
		{
			var tx:Number = ptB.x - ptA.x;
			var ty:Number = ptB.y - ptA.y;

			var radians:Number = Math.atan(ty / tx);
			if (tx < 0)
				radians += Math.PI;

			if (tx >= 0 && ty < 0)
				radians += Math.PI * 2;

			return radians;
		}

		static public function angle(ptA:IsoPoint, ptB:IsoPoint):Number
		{
			return theta(ptA, ptB) * 180 / Math.PI;
		}

		static public function polar(originPt:IsoPoint, radius:Number, theta:Number = 0):IsoPoint
		{
			var tx:Number = originPt.x + Math.cos(theta) * radius;
			var ty:Number = originPt.y + Math.sin(theta) * radius;
			var tz:Number = originPt.z

			return new IsoPoint(tx, ty, tz);
		}

		static public function interpolate(ptA:IsoPoint, ptB:IsoPoint, f:Number):IsoPoint
		{
			if (f <= 0)
				return ptA;

			if (f >= 1)
				return ptB;

			var nx:Number = (ptB.x - ptA.x) * f + ptA.x;
			var ny:Number = (ptB.y - ptA.y) * f + ptA.y;
			var nz:Number = (ptB.z - ptA.z) * f + ptA.z;

			return new IsoPoint(nx, ny, nz);
		}

		public var z:Number = 0;

		override public function get length ():Number
		{
			return Math.sqrt(x * x + y * y + z * z);
		}

		override public function clone():Point
		{
			return new IsoPoint(x, y, z);
		}

		public function IsoPoint(x:Number = 0, y:Number = 0, z:Number = 0)
		{
			super();

			this.x = x;
			this.y = y;
			this.z = z;
		}

		override public function toString ():String
		{
			return "x:" + x + " y:" + y + " z:" + z;
		}
	}
}