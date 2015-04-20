package View.GameView
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.StageDisplayState;	
	import View.componentLib.util.SingleObject;
	
	import Model.BetModel;
	import View.component.Marquee.Marquee;
	import View.componentLib.ViewBase.ViewBase;
	
	import View.componentLib.util.*;
	
	/**
	 * ...
	 * @author hhg
	 */
	public class HudView extends ViewBase
	{
		
		public var _TopBar:MovieClip;
		public var _DownBar:MovieClip;
		
		private var _Marquee:Marquee
		
		[Inject]
		public var _BetModel:BetModel;
		
		public var  _ScreenBtn:SingleObject;
		
		public function HudView()  
		{
			utilFun.Log("HudView");
		}
		
		[MessageHandler(selector="add")] 
		override public function EnterView (View:ViewState):void
		{
			utilFun.Log("in to hud=");			
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
			
			_ScreenBtn = new SingleObject();
			_ScreenBtn.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[1,2,2,1]);
			_ScreenBtn.Create(_TopBar["btn_fullscreen"]);
			_ScreenBtn.mousedown = FullScreen;
			//btn_info 遊戲資訊
			//btn_mute
			
			_Marquee = new Marquee(_TopBar["Mcmarquee"]);
			_Marquee.init();
			_Marquee.SetPeriodMsg(["現在儲值賓果可獲500紅利點數", "儲值上限每人10000點", "活動期間1月20到3月底截止", "儲滿5000加送造形紀念品", "祝你再次中獎"]);
			
			utilFun.Log("in to hud=2");			
		}
		
		private function FullScreen(e:Event):Boolean 
		{
			if ( stage.displayState == StageDisplayState.NORMAL)
			{
				stage.displayState = StageDisplayState.FULL_SCREEN; 
			}
			else
			{
				stage.displayState = StageDisplayState.NORMAL; 
			}
			return true;
		}
		
		
		[MessageHandler(type = "ConnectModule.websocket.WebSoketInternalMsg", selector = "hudupdata")]
		public function hudupdate():void
		{			
			//所押盤數更新
			utilFun.SetText(_DownBar["BetOrder"], _BetModel.GetBetTableNo().length.toString());
			
			//押分
			utilFun.SetText(_DownBar["Bet"], _BetModel.GetBetTotal().toString());
			//
			//Credits
			utilFun.SetText(_DownBar["Credit"], _BetModel._credit.toString() );
		}
		
		[MessageHandler(selector="Leave")]
		override public function ExitView(View:ViewState):void
		{
			if (View._view != ViewState.Hud) return;
			
		}
		
		
	}

}