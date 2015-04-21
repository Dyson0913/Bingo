package View.ViewBase
{
	import Command.DataOperation;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import Model.Model;
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
		
		[Inject]
		public var _model:Model;
		
		[Inject]
		public var _opration:DataOperation;
		
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