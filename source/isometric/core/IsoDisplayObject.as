package isometric.core
{
	import flash.geom.Point;
	import flash.utils.Dictionary;

	import isometric.IsoMath;

	import starling.core.RenderSupport;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;

	public class IsoDisplayObject extends DisplayObjectContainer
	{
		protected var mIsoX:Number;
		protected var mIsoY:Number;
		protected var mIsoZ:Number;
		protected var mIsoWidth:Number;
		protected var mIsoLength:Number;
		protected var mIsoHeight:Number;
		protected var mInvalid:Boolean;
		protected var mInvalidChildrenOrder:Boolean;
		protected var mDepthSorting:Boolean;
		protected var mAllowCustomCoordinates:Boolean;
		protected var mTouchChildren:Boolean;
		protected var mTouchEverywhere:Boolean;
		public var data:Object;

		public function IsoDisplayObject()
		{
			isoX = 0;
			isoY = 0;
			isoZ = 0;
			isoWidth = 0;
			isoLength = 0;
			isoHeight = 0;
			depthSorting = true;
			touchChildren = true;
			touchEverywhere = false;
			allowCustomCoordinates = false;
			addEventListener(IsoEvent.INVALIDATE_CHILDREN, invalidateChildrenOrder);
		}

		public function get touchEverywhere():Boolean
		{
			return mTouchEverywhere;
		}

		public function set touchEverywhere(value:Boolean):void
		{
			mTouchEverywhere = value;
		}

		public function get touchChildren():Boolean
		{
			return mTouchChildren;
		}

		public function set touchChildren(value:Boolean):void
		{
			mTouchChildren = value;
		}

		/**
		 * Sets if the setters "x", "y", "width" and "height" are enabled
		 */
		public function set allowCustomCoordinates(value:Boolean):void
		{
			mAllowCustomCoordinates = value;
		}

		/**
		 * Sets if depth sorting should be used for children
		 */
		public function set depthSorting(value:Boolean):void
		{
			mDepthSorting = value;
		}

		public function get isoChildren():Vector.<IsoDisplayObject>
		{
			var result:Vector.<IsoDisplayObject> = new Vector.<IsoDisplayObject>;
			var child:DisplayObject;
			var i:uint;
			var length:uint = numChildren;
			for (i = 0; i < length; i++) {
				child = getChildAt(i);
				if (child is IsoDisplayObject) {
					result.push(child as IsoDisplayObject);
				}
			}
			return result;
		}

		public function get children():Vector.<DisplayObject>
		{
			var result:Vector.<DisplayObject> = new Vector.<DisplayObject>;
			var i:uint;
			var length:uint = numChildren;
			for (i = 0; i < length; i++) {
				result.push(getChildAt(i));
			}
			return result;
		}

		public function get isoX():Number
		{
			return mIsoX;
		}

		public function set isoX(value:Number):void
		{
			if (mIsoX == value) {
				return;
			}
			mIsoX = value;
			invalidatePosition();
		}

		public function get isoY():Number
		{
			return mIsoY;
		}

		public function set isoY(value:Number):void
		{
			if (mIsoY == value) {
				return;
			}
			mIsoY = value;
			invalidatePosition();
		}

		public function get isoZ():Number
		{
			return mIsoZ;
		}

		public function set isoZ(value:Number):void
		{
			if (mIsoZ == value) {
				return;
			}
			mIsoZ = value;
			invalidatePosition();
		}

		public function get isoWidth():Number
		{
			return mIsoWidth;
		}

		public function set isoWidth(value:Number):void
		{
			if (mIsoWidth == value) {
				return;
			}
			mIsoWidth = value;
			invalidateSize();
		}

		public function get isoLength():Number
		{
			return mIsoLength;
		}

		public function set isoLength(value:Number):void
		{
			if (mIsoLength == value) {
				return;
			}
			mIsoLength = value;
			invalidateSize();
		}

		public function get isoHeight():Number
		{
			return mIsoHeight;
		}

		public function set isoHeight(value:Number):void
		{
			if (mIsoHeight == value) {
				return;
			}
			mIsoHeight = value;
			invalidateSize();
		}

		override public function set visible(value:Boolean):void
		{
			if (visible == value) {
				return;
			}

			super.visible = value;
			if (parent) {
				parent.dispatchEvent(new IsoEvent(IsoEvent.INVALIDATE_CHILDREN));
			}
		}

		private function invalidatePosition():void
		{
			recalculateXY();
			if (parent) {
				parent.dispatchEvent(new IsoEvent(IsoEvent.INVALIDATE_CHILDREN));
			}
		}

		private function recalculateXY():void
		{
			var currentPosition:IsoPoint = new IsoPoint(isoX, isoY, isoZ);
			IsoMath.spaceToScreen(currentPosition, false);
			super.x = currentPosition.x;
			super.y = currentPosition.y;
		}

		private function invalidateSize():void
		{
			mInvalid = true;
			recalculateSize();
			if (parent) {
				parent.dispatchEvent(new IsoEvent(IsoEvent.INVALIDATE_CHILDREN));
			}
		}

		private function recalculateSize():void
		{

		}

		override public function render(support:RenderSupport, parentAlpha:Number):void
		{
			if (mInvalidChildrenOrder && mDepthSorting) {
//				trace("sort children");
				IsoMath.depthSorting(this);
			}
			super.render(support, parentAlpha);
			mInvalidChildrenOrder = false;
			mInvalid = false;
		}

		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			if (child is IsoDisplayObject) {
				dispatchEvent(new IsoEvent(IsoEvent.INVALIDATE_CHILDREN));
			}
			return super.addChildAt(child, index);
		}

		protected function invalidateChildrenOrder(event:IsoEvent):void
		{
//			trace("invalidate children order");
			mInvalidChildrenOrder = true;
		}

		public function get isoBounds():IsoBounds
		{
			return new IsoBounds(this);
		}

		public function globalToSpace(pt:IsoPoint, createNew:Boolean = true):IsoPoint
		{
			var z:Number = pt.z;
			var local:IsoPoint;
			var helper:Point = new Point(pt.x, pt.y);
			globalToLocal(helper, helper);

			if (createNew) {
				local = new IsoPoint();
			} else {
				local = pt;
			}

			local.x = helper.x;
			local.y = helper.y;
			local.z = z;

			return localToSpace(local, createNew);
		}

		public function spaceToGlobal(pt:IsoPoint, createNew:Boolean = true):IsoPoint
		{
			var z:Number = pt.z;
			var local:IsoPoint = spaceToLocal(pt, createNew);
			var helper:Point = new Point(local.x, local.y);
			var global:IsoPoint;
			localToGlobal(helper, helper);

			if (createNew) {
				global = new IsoPoint();
			} else {
				global = pt;
			}

			global.x = helper.x
			global.y = helper.y
			global.z = z;

			return global;
		}

		public function localToSpace(pt:IsoPoint, createNew:Boolean = true):IsoPoint
		{
			return IsoMath.screenToSpace(pt, createNew);
		}

		public function spaceToLocal(pt:IsoPoint, createNew:Boolean = true):IsoPoint
		{
			return IsoMath.spaceToScreen(pt, createNew);
		}

		override public function hitTest(localPoint:Point, forTouch:Boolean=false):DisplayObject
		{
			if (forTouch && (!visible || !touchable)) {
				return null;
			}

			var pt:IsoPoint = new IsoPoint(localPoint.x, localPoint.y, isoZ);

			if (touchChildren) {
				var result:DisplayObject = super.hitTest(localPoint, forTouch);
				if (result) {
					return result;
				}
			}

			if (touchEverywhere) {
				return this;
			}

			localToSpace(pt, false);
			if (pt.x < 0 || pt.y < 0) {
				return null;
			}
			if (pt.x > isoWidth || pt.y > isoLength) {
				return null;
			}

			return this;
		}

		public function detectCollision():Boolean
		{
			for each (var child:IsoDisplayObject in isoChildren) {
				if (detectCollisionForChild(child)) {
					return true;
				}
			}
			return false;
		}

		public function detectCollisionForChild(child:IsoDisplayObject):Boolean
		{
			var bounds:IsoBounds = child.isoBounds;

			for each (var isoChild:IsoDisplayObject in isoChildren) {
				if (isoChild == child || isoChild.visible == false) {
					continue;
				}

				if (bounds.collides(isoChild.isoBounds)) {
					return true;
				}
			}

			return false;
		}

		// Forbidden Methods
		override public function set x(value:Number):void
		{
			if (!mAllowCustomCoordinates) {
				throw new Error("Forbidden, use isoX, isoY, isoZ instead");
			} else {
				super.x = value;
			}
		}

		override public function set y(value:Number):void
		{
			if (!mAllowCustomCoordinates) {
				throw new Error("Forbidden, use isoX, isoY, isoZ instead");
			} else {
				super.y = value;
			}
		}

		override public function set width(value:Number):void
		{
			if (!mAllowCustomCoordinates) {
				throw new Error("Forbidden, use isoWidth, isoLength, isoHeight instead");
			} else {
				super.width = value;
			}
		}

		override public function set height(value:Number):void
		{
			if (!mAllowCustomCoordinates) {
				throw new Error("Forbidden, use isoWidth, isoLength, isoHeight instead");
			} else {
				super.height = value;
			}
		}
	}
}