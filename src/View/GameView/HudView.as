package View.GameView
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import View.componentLib.ViewBase.ViewBase;
	
	import View.InterFace.IVew;
	import View.componentLib.util.utilFun;
	
	/**
	 * ...
	 * @author hhg
	 */
	public class HudView extends ViewBase// implements IVew
	{
		
		public var _TopBar:MovieClip;
		public var _DownBar:MovieClip;
		
		public function HudView()  
		{
			utilFun.Log("HudView");
		}
		
		[MessageHandler(selector="add")] 
		override public function EnterView (View:ViewState):void
		{
			if (View._view != ViewState.Hud) return;
			
			_TopBar = utilFun.GetClassByString("TopBar");
			_DownBar  = utilFun.GetClassByString("ButtonBar");
			
			addChild( _TopBar);
			addChild( _DownBar );
			
		}
		
		override public function ExitView(View:ViewState):void
		{
			
		}
		
		
	}

}