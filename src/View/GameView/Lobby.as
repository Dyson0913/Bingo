package View.GameView
{
	import ConnectModule.websocket.WebSoketInternalMsg;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import Model.BetModel;
	import Model.LobbyModel;
	import Model.PlayerModel;
	import View.componentLib.util.MultiObject;
	import View.componentLib.util.SingleObject;
	import View.componentLib.ViewBase.ViewBase;
	
	import View.InterFace.IVew;
	import View.componentLib.util.utilFun;
	import View.componentLib.util.MouseBehavior;
	import caurina.transitions.Tweener
	
	/**
	 * ...
	 * @author hhg
	 */
	public class Lobby extends ViewBase //implements IVew
	{
		
		public var LobbView:MovieClip;
		
		[Inject]
		public var _PlayerInfo:PlayerModel;
		
		[Inject]
		public var _BetModel:BetModel;
		
		[Inject]
		public var _LobbyModel:LobbyModel;
		
		//選桌列表
		public var TableList:MultiObject;
		
		public var pageleft:SingleObject;
		public var pagerihgt:SingleObject;
		
		public function Lobby()  
		{
			utilFun.Log("LobbView");
		}
		
		[MessageHandler(selector="Enter")]
		override public function EnterView (View:ViewState):void
		{
			if (View._view != ViewState.Lobb) return;
			
			//載入新VIEW
			LobbView = utilFun.GetClassByString("LobbyView");
			addChild(LobbView);
			
			//元件事件及畫面更新
			_LobbyModel.UpDateModel();
			
			//增加選桌大廳
			TableList = new MultiObject();
			Tableinit();
			
			pageleft = new SingleObject()
			pageleft.MouseFrame = utilFun.Frametype(MouseBehavior.SencetiveBtn);
			pageleft.Create(LobbView["mc_left"]);
			pageleft.mousedown = prepage
			
			pagerihgt = new SingleObject()
			pagerihgt.MouseFrame = utilFun.Frametype(MouseBehavior.SencetiveBtn);
			pagerihgt.Create(LobbView["mc_right"]);
			pagerihgt.mousedown = nextpage
			
			//page num
			utilFun.SetText(LobbView["_Page"], _LobbyModel._pageModel.CurrentPage("/") );
		}
		
		private function choseroom(e:Event,idx:int):Boolean 
		{
			TableList.removeListen();
			var roomNo:int = _LobbyModel._pageModel.GetOneDate(idx)["roomNo"];
			utilFun.Log("enter room NO= " + roomNo);
			_LobbyModel._currentRoomNum = roomNo;
			
			dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.CHOOSE_ROOM));
			return true;
		}
		
		private function prepage(e:Event):Boolean
		{
			_LobbyModel._pageModel.PrePage();
			updatepage();
			return true;
		}
		
		private function nextpage(e:Event):Boolean
		{
			_LobbyModel._pageModel.NextPage();
			updatepage();
			return true;
		}
		
		public function TableInfoDisplay(mc:MovieClip, idx:int, RoomAndPlayer:Array):void
		{
			utilFun.SetText(mc["roomNum"], String( RoomAndPlayer[idx]["roomNo"]) );
			utilFun.SetText(mc["Playernum"], String(RoomAndPlayer[idx]["PlayerNum"]) );
		}
		
		private function Tableinit():void
		{
			TableList.CustomizedFun = TableInfoDisplay;
			TableList.CustomizedData = _LobbyModel._pageModel.GetPageDate();
			var PageAmount:int = _LobbyModel._pageModel.GetPageDate().length;
			
			TableList.MouseFrame = utilFun.Frametype(MouseBehavior.SencetiveBtn);
			TableList.Create(PageAmount, "box", 180.8, 271, Math.min(PageAmount,5), 254.4, 200.65, "Table_", LobbView);
			TableList.mousedown = choseroom
		}
		
		private function updatepage():void
		{
			TableList.CleanList();
			Tableinit();
			utilFun.SetText(LobbView["_Page"], _LobbyModel._pageModel.CurrentPage("/") );
		}
		
		[MessageHandler(selector="Leave")]
		override public function ExitView(View:ViewState):void
		{
			if (View._view != ViewState.Lobb) return;
			utilFun.ClearContainerChildren(LobbView);
			utilFun.Log("lobby ExitView");
		}
	}

}