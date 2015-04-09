package View.componentLib.util 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author hhg
	 */
	public class SingleObject 
	{
		private var _item:MovieClip;
		
		public var MouseFrame:Array = [];
		
		//各事件接口
		public var rollout:Function;
		public var rollover:Function;
		public var mousedown:Function;
		public var mouseup:Function;
		
		public function SingleObject() 
		{
			
		}
		
		public function Create(mc:MovieClip):void
		{		
		   _item = mc;
		   Listen();
		}
		
		private function Listen():void
		{
			if ( MouseFrame[0] != 0) _item.addEventListener(MouseEvent.ROLL_OUT,eventListen);
			if ( MouseFrame[1] != 0) _item.addEventListener(MouseEvent.ROLL_OVER, eventListen);
			if ( MouseFrame[2] != 0) _item.addEventListener(MouseEvent.MOUSE_DOWN, eventListen);
			if ( MouseFrame[3] != 0) _item.addEventListener(MouseEvent.MOUSE_UP,eventListen);
		}
		
		public function removeListen():void
		{
			if ( MouseFrame[0] != 0) _item.removeEventListener(MouseEvent.ROLL_OUT,eventListen);
			if ( MouseFrame[1] != 0) _item.removeEventListener(MouseEvent.ROLL_OVER, eventListen);
			if ( MouseFrame[2] != 0) _item.removeEventListener(MouseEvent.MOUSE_DOWN, eventListen);
			if ( MouseFrame[3] != 0) _item.removeEventListener(MouseEvent.MOUSE_UP,eventListen);
		}
		
		public function eventListen(e:Event):void
		{
			switch (e.type)
			{
				case MouseEvent.ROLL_OUT:
				{					
					if ( rollout != null) rollout(e);
					utilFun.GotoAndStop(e,MouseFrame[0]);
				}
				break;
				case MouseEvent.ROLL_OVER:
				{					
					if ( rollover != null) rollover(e);
					utilFun.GotoAndStop(e,MouseFrame[1]);
				}
				break;
				case MouseEvent.MOUSE_DOWN:
				{
					if ( mousedown != null) mousedown(e);
					utilFun.GotoAndStop(e,MouseFrame[2]);
				}
				break;
				case MouseEvent.MOUSE_UP:
				{
					if ( mouseup != null) mouseup(e);
					utilFun.GotoAndStop(e,MouseFrame[3]);
				}
				break;
			}
		}
	}

}