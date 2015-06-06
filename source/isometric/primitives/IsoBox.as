package isometric.primitives
{
	import starling.core.RenderSupport;

	public class IsoBox extends IsoPrimitive
	{
		protected var mRectangles:Vector.<IsoRectangle>;
		public function IsoBox()
		{
			var i:uint
			mRectangles = new Vector.<IsoRectangle>(6, true);
			for (i = 0; i<6; i++) {
				mRectangles[i] = new IsoRectangle();
			}

			super();

			for (i = 0; i<6; i++) {
				addChild(mRectangles[i]);
			}
		}

		override public function setBorder(thickness:Number, color:uint, alpha:Number):void
		{
			for (var i:uint = 0; i<6; i++) {
				mRectangles[i].setBorder(thickness, color, alpha);
			}
		}

		override public function setFill(color:uint, alpha:Number):void
		{
			for (var i:uint = 0; i<6; i++) {
				mRectangles[i].setFill(color, alpha);
			}
		}

		override public function render(support:RenderSupport, parentAlpha:Number):void
		{
			if (mInvalid) {
				updateRectangles();
			}
			super.render(support, parentAlpha);
		}

		private function updateRectangles():void
		{
			mRectangles[0].isoWidth = isoWidth;
			mRectangles[0].isoLength = isoLength;

			mRectangles[1].isoWidth = isoWidth;
			mRectangles[1].isoHeight = isoHeight;

			mRectangles[2].isoLength = isoLength;
			mRectangles[2].isoHeight = isoHeight;

			mRectangles[3].isoWidth = isoWidth;
			mRectangles[3].isoLength = isoLength;
			mRectangles[3].isoZ = isoHeight;

			mRectangles[4].isoWidth = isoWidth;
			mRectangles[4].isoHeight = isoHeight;
			mRectangles[4].isoY = isoLength;

			mRectangles[5].isoLength = isoLength;
			mRectangles[5].isoHeight = isoHeight;
			mRectangles[5].isoX = isoWidth;
		}
	}
}