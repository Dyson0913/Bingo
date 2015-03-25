package View.GameView
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import View.InterFace.IVew;
	import View.componentLib.util.utilFun;
	
	/**
	 * ...
	 * @author hhg
	 */
	public class HudView extends Sprite implements IVew
	{
		
		public var Hud:MovieClip;
		
		public function HudView()  
		{
			utilFun.Log("HudView");
		}
		
		public function EnterView (View:int):void
		{
			Hud = utilFun.GetClassByString("mc_transparent");
			addChild(Hud);
		}
		
		public function ExitView():void
		{
			
		}
		
		
	}

}