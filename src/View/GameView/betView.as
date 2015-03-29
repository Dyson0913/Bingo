package View.GameView
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import Model.PlayerModel;
	import View.componentLib.ViewBase.ViewBase;
	
	import View.InterFace.IVew;
	import View.componentLib.util.utilFun;
	import caurina.transitions.Tweener;
	/**
	 * ...
	 * @author hhg
	 */
	public class betView extends ViewBase// implements IVew
	{
		public var bet:MovieClip;
		
		
		[Inject]
		public var _PlayerInfo:PlayerModel;
		
		public function betView()  
		{
			utilFun.Log("betView");
		}
		
		[MessageHandler]
		override public function EnterView (View:ViewState):void
		{
			if (View._view != ViewState.Bet) return;
			
			//清除前一畫面
			utilFun.Log("in to EnterBetview=");			
			
			//載入新VIEW
			bet = utilFun.GetClassByString("BetView");
			addChild(bet);
			
			//元件事件及畫面更新
			//Tableinfo.UpDateModel(TableNo, isBet, Ball);
			//betModel._credit = credit;
			//
			//
			//ToolsFunction.SetText(betView["roomNo"], LobbyInfo._currentRoomNum.toString());
			//
			//所押盤數更新
			//ToolsFunction.SetText(Hud.getChildByName("ButtonBar")["BetOrder"], String(0));			
			//押分
			//ToolsFunction.SetText(Hud.getChildByName("ButtonBar")["Bet"], String(0));
			//Credit
			//ToolsFunction.SetText(Hud.getChildByName("ButtonBar")["Credit"], betModel._credit.toString() );
			//
			//Hud.getChildByName("TopBar")
			//ToolsFunction.AddMouseListen(Hud.getChildByName("TopBar")["btn_fullscreen"], FullScreen);
			//btn_info 遊戲資訊
			//btn_mute
				//
			//_Marquee = new Marquee(Hud.getChildByName("TopBar")["Mcmarquee"]);
			//_Marquee.init();
			//_Marquee.SetPeriodMsg(["現在儲值賓果可獲500紅利點數", "儲值上限每人10000點", "活動期間1月20到3月底截止", "儲滿5000加送造形紀念品", "祝你再次中獎"]);
					//
			//ToolsFunction.SetText(betView["userId"], playerinfo.uuid.toString());
			//
			//外盤 (有人押叫外盤)
			//ToolsFunction.SetText(betView["outorder"], String(Tableinfo.GetBetCnt()));
			//
			//內盤 (沒人押叫內盤)
			//ToolsFunction.SetText(betView["selforder"], String(Tableinfo.GetNoOneBetCnt()));
			//
			//TODO
			//ToolsFunction.SetText(betView["bingoRecode"]["PanNumText"], //TODO);
			//
			//ToolsFunction.Log("betModel._credit.toString() = "+betModel._credit.toString());
			//
			//所有盤號BTN
			//BetList = new MultiObject();
			//BetList.CustomizedFun = BetListCustomizedFun;
			//BetList.CustomizedData = Tableinfo.GetisBet();
			//BetList.Create(100, "BetTableBtn", 106.55, 271.85, 10, 98, 66, "Bet_", betView);	
			//ToolsFunction.AddMultiMouseListen(BetList.ItemList, Bet);
			//
			//盤號
			//OrderList = new MultiObject();
			//OrderList.CustomizedFun = OrderListCustomizedFun;
			//OrderList.Create(12, "OrderBtn", 1219.30,131.75, 1, 0, 50.55, "BetNum_", betView);
			//ToolsFunction.AddMultiMouseListen(OrderList.ItemList, OrderBet);
			//
			//押分
			//BetPointList = new MultiObject();
			//BetPointList.CustomizedFun = BetPointListCustomizedFun;
			//BetPointList.Create(12, "OrderBtn",1397.35 ,131.75 , 1, 0, 50.55, "BetPoint_", betView);
			//ToolsFunction.AddMultiMouseListen(BetPointList.ItemList, BetPoint);
			//
			//剩於時間
			//_remainTime = remainTime;
			//ToolsFunction.Log("_remainTime = "+_remainTime);
			//ToolsFunction.SetText(betView["betTime"], _remainTime.toString());
			//Tweener.addCaller(this, { time:remainTime , count: remainTime, onUpdate:TimeCount , transition:"linear" } );
			//
			//default 載入第一桌			
			//LoadingPan(0);
			//
			//UpdatePanNumAndBet();
			//
			//ToolsFunction.AddMouseListen(betView["CancelBtn"], CencelAllBet);
			
		
			
		}
		
			
		
		override public function ExitView(View:ViewState):void
		{
			
		}
		
		
	}

}