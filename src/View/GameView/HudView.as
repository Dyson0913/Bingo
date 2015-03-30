package View.GameView
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.StageDisplayState;
	
	import Model.BetModel;
	import View.component.Marquee.Marquee;
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
		
		private var _Marquee:Marquee
		
		[Inject]
		public var _BetModel:BetModel;
		
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
			
			//所押盤數更新
			utilFun.SetText(_DownBar["BetOrder"], String(0));			
			//押分
			utilFun.SetText(_DownBar["Bet"], String(0));
			//Credit
			utilFun.SetText(_DownBar["Credit"], _BetModel._credit.toString() );
			//
			
			utilFun.AddMouseListen(_TopBar["btn_fullscreen"], FullScreen);
			//btn_info 遊戲資訊
			//btn_mute
			
			_Marquee = new Marquee(_TopBar["Mcmarquee"]);
			_Marquee.init();
			_Marquee.SetPeriodMsg(["現在儲值賓果可獲500紅利點數", "儲值上限每人10000點", "活動期間1月20到3月底截止", "儲滿5000加送造形紀念品", "祝你再次中獎"]);
			
			
		}
		
		private function FullScreen(e:Event):void
		{
			switch (e.type)
			{			
				case "mouseDown":
				{
					if ( stage.displayState == StageDisplayState.NORMAL)
					{
						stage.displayState = StageDisplayState.FULL_SCREEN; 
					}
					else
					{
						stage.displayState = StageDisplayState.NORMAL; 
					}
					
					e.currentTarget.gotoAndStop(2)	
				}
				break;
				case "mouseUp":
				{
					e.currentTarget.gotoAndStop(1)	
				}
				break;
				case "rollOut":
				{
					e.currentTarget.gotoAndStop(1)	
				}
				break;
				
			}
		}
		
		override public function ExitView(View:ViewState):void
		{
			
		}
		
		
	}

}