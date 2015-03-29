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
	import View.componentLib.ViewBase.ViewBase;
	
	import View.InterFace.IVew;
	import View.componentLib.util.utilFun;
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
			TableList.CustomizedFun = TableInfoDisplay;
			TableList.CustomizedData = _LobbyModel._pageModel.GetPageDate();
			var PageAmount:int = _LobbyModel._pageModel.GetPageDate().length;
			
			TableList.Create(PageAmount, "box", 180.8, 271, Math.min(PageAmount,5), 254.4, 200.65, "Table_", LobbView);
			utilFun.AddMultiMouseListen(TableList._ItemList, CheckIN);
			
			utilFun.AddMouseListen( LobbView["mc_left"], pageLeft);
			utilFun.AddMouseListen( LobbView["mc_right"], pageright);			
			
			//page num
			utilFun.SetText(LobbView["_Page"], _LobbyModel._pageModel.CurrentPage("/") );
		}
		
		public function TableInfoDisplay(mc:MovieClip, idx:int, RoomAndPlayer:Array):void
		{
			utilFun.SetText(mc["roomNum"], String( RoomAndPlayer[idx]["roomNo"]) );
			utilFun.SetText(mc["Playernum"], String(RoomAndPlayer[idx]["PlayerNum"]) );
		}
		
		private function CheckIN(e:Event):void 
		{			
			var sName:String = utilFun.Regex_CutPatten(e.currentTarget.name, new RegExp("Table_", "i"));		
			switch (e.type)
			{
				case "click":
					
					utilFun.ReMoveMultiMouseListen(TableList._ItemList, CheckIN);
					var roomNo:int = _LobbyModel._pageModel.GetOneDate(parseInt(sName))["roomNo"];
					utilFun.Log("enter room NO= " + roomNo);
					_LobbyModel._currentRoomNum = roomNo;
					
					dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.CHOOSE_ROOM));
					//websocket.enterRoom(roomNo);
					e.currentTarget.gotoAndStop(2);
					
				case "rollOut":
					e.currentTarget.gotoAndStop(1);
					break;
				case "rollOver":
					e.currentTarget.gotoAndStop(2);
				break;
			}
		}
		
		private function pageLeft(e:Event):void 
		{
			switch (e.type)
			{
				case "mouseDown":
				{
					utilFun.ReMoveMultiMouseListen(TableList._ItemList, CheckIN);
					_LobbyModel._pageModel.PrePage();
					updatepage();
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
		
		private function pageright(e:Event):void 
		{
			switch (e.type)
			{
				case "mouseDown":
				{
					utilFun.ReMoveMultiMouseListen(TableList._ItemList, CheckIN);
					_LobbyModel._pageModel.NextPage();
					updatepage();
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
		
		private function updatepage():void
		{
			//utilFun.Log("lover ="+LobbView.numChildren);
			TableList.CleanList();
			TableList.CustomizedData = _LobbyModel._pageModel.GetPageDate();
			var PageAmount:int = _LobbyModel._pageModel.GetPageDate().length;
			TableList.Create(PageAmount, "box", 180.8, 271, Math.min(PageAmount,5), 254.4, 200.65, "Table_", LobbView);
			utilFun.AddMultiMouseListen(TableList._ItemList, CheckIN);
			utilFun.SetText(LobbView["_Page"], _LobbyModel._pageModel.CurrentPage("/") );		
			//utilFun.Log("lover ="+LobbView.numChildren);
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