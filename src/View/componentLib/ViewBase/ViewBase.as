package View.componentLib.ViewBase 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import View.GameView.ViewState;
	/**
	 * ...
	 * @author hhg
	 */
	
	
	//[ProcessSuperclass][ProcessInterfaces]
	public class ViewBase extends Sprite
	{
		[MessageDispatcher]
        public var dispatcher:Function;
		
		public var _View:MovieClip;
		
		public function ViewBase() 
		{
			
		}
		
		//[MessageHandler]
		public function EnterView (View:ViewState):void
		{
			
		}
		
		
		public function ExitView(View:ViewState):void
		{
			
		}
		
	}

}