package isometric.core
{
	import starling.events.Event;

	public class IsoEvent extends Event
	{
		public static var INVALIDATE_CHILDREN:String = "iso_invalidate_children";

		public function IsoEvent(type:String, bubbles:Boolean=false, data:Object=null)
		{
			super(type, bubbles, data);
		}
	}
}