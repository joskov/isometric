package isometric
{
	import flash.utils.Dictionary;

	import isometric.core.IsoDisplayObject;
	import isometric.core.IsoPoint;

	import starling.display.DisplayObject;

	public class IsoMath
	{
//		private static var cosTheta:Number = Math.cos(30 * Math.PI / 180);
//		private static var sinTheta:Number = Math.sin(30 * Math.PI / 180);
		private static var ratio:Number = 2;

		public static function screenToSpace(screenPt:IsoPoint, createNew:Boolean = true):IsoPoint
		{
//			var x:Number = screenPt.x / (2 * cosTheta) + screenPt.y + screenPt.z;
//			var y:Number = screenPt.y - screenPt.x / (2 * cosTheta) + screenPt.z;
//			var z:Number = screenPt.z;
			var x:Number = screenPt.x / ratio + screenPt.y + screenPt.z;
			var y:Number = screenPt.y - screenPt.x / ratio + screenPt.z;
			var z:Number = screenPt.z;

			var result:IsoPoint;
			if (createNew) {
				result = new IsoPoint(x, y, z);
			} else {
				result = screenPt;
				result.x = x;
				result.y = y;
				result.z = z;
			}

			return result;
		}

		public static function spaceToScreen(spacePt:IsoPoint, createNew:Boolean = true):IsoPoint
		{
//			var x:Number = (spacePt.x - spacePt.y) * cosTheta;
//			var y:Number = (spacePt.x + spacePt.y) * sinTheta - spacePt.z;
//			var z:Number = spacePt.z;
			var x:Number = spacePt.x - spacePt.y;
			var y:Number = (spacePt.x + spacePt.y) / ratio - spacePt.z;
			var z:Number = spacePt.z;

			var result:IsoPoint;
			if (createNew) {
				result = new IsoPoint(x, y, z);
			} else {
				result = spacePt;
				result.x = x;
				result.y = y;
				result.z = z;
			}

			return result;
		}

		private static var dependency:Dictionary;
		private static var depth:uint;
		private static var visited:Dictionary = new Dictionary();
		public static function depthSorting(container:IsoDisplayObject):void
		{
			dependency = new Dictionary();
			visited = new Dictionary();

			var i:uint;
			var j:uint;
			var length:uint = container.numChildren;
			var behind:Array;
			var childA:DisplayObject;
			var childB:DisplayObject;
			var allChildren:Vector.<DisplayObject> = container.children;

			for each (childA in allChildren) {
				if (!childA.visible) {
					continue;
				}
				behind = [];
				for each (childB in allChildren) {
					if (!childB.visible || childB == childA) {
						continue;
					}
					if (compareObjectIndex(childA, childB) > 0) {
						behind.push(childB);
					}
				}
				dependency[childA] = behind;
			}

			depth = 0;
			for each (childA in allChildren) {
				if (visited[childA] !== true) {
					place(container, childA);
				}
			}

			dependency = new Dictionary();
			visited = new Dictionary();
		}

		private static function place(container:IsoDisplayObject, obj:DisplayObject):void
		{
			var inner:DisplayObject;
			visited[obj] = true;

			for each (inner in dependency[obj]) {
				if	(visited[inner] !== true) {
					place(container, inner);
				}
			}

			if (depth != container.getChildIndex(obj)) {
				container.setChildIndex(obj, depth);
			}

			depth++;
		}

		private static function compareObjectIndex(a:DisplayObject, b:DisplayObject):int
		{
			var objA:IsoDisplayObject = a as IsoDisplayObject;
			var objB:IsoDisplayObject = b as IsoDisplayObject;
			if (!objA && !objB) {
				return 0;
			}
			if (!objA) {
				// have to check the actual values
				return -1;
			}
			if (!objB) {
				// have to check the actual values
				return 1;
			}

			var rightA:Number;
			var frontA:Number;
			var topA:Number;
			var rightB:Number;
			var frontB:Number;
			var topB:Number;

			rightA = objA.isoX + objA.isoWidth;
			frontA = objA.isoY + objA.isoLength;
			topA = objA.isoZ + objA.isoHeight;

			rightB = objB.isoX + objB.isoWidth;
			frontB = objB.isoY + objB.isoLength;
			topB = objB.isoZ + objB.isoHeight;
			if (rightA <= objB.isoX || frontA <= objB.isoY || topA <= objB.isoZ) {
				return -1;
				// do nothing the order is fine
			} else if (objA.isoX <= objB.isoX && objA.isoY <= objB.isoY && objA.isoZ <= objB.isoZ && rightA <= rightB && frontA <= frontB && topA <= topB) {
				return 0;
				// do nothing the order is somewhat fine, but collision occurs here
			} else {
				// swapping children
				return 1;
			}
			return 0;
		}
	}
}