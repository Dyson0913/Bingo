package View.GameView
{
	import ConnectModule.websocket.WebSoketInternalMsg;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import Model.valueObject.Intobject;
	import View.componentLib.util.SingleObject;
	
	import Model.BetModel;
	import Model.LobbyModel;
	import Model.PlayerModel;
	import Model.TableModel;
	import View.componentLib.util.MultiObject;
	import View.componentLib.ViewBase.ViewBase;
		
	import View.componentLib.util.utilFun;
	import View.componentLib.util.MouseBehavior;
	import caurina.transitions.Tweener;
	/**
	 * ...
	 * @author hhg
	 */
	public class betView extends ViewBase// implements IVew
	{
		public var bet:MovieClip;
		
		//每盤號碼matrix
		private var PanMatrixList:MultiObject;
		private var PanContainer:MovieClip;
		private var Panmatrix:MovieClip;
		
		[Inject]
		public var _LobbyModel:LobbyModel;
		
		[Inject]
		public var _TableModel:TableModel;
		
		[Inject]
		public var _PlayerModel:PlayerModel;
		
		[Inject]
		public var _BetModel:BetModel;
		
		//押注列表
		public var BetList:MultiObject;
		
		//盤號
		public var OrderList:MultiObject;
		
		//押分
		private var BetPointList:MultiObject;
		
		private var cancelbet:SingleObject;
		public var stophint:MovieClip;
		
		public function betView()  
		{
			utilFun.Log("betView");
		}
		
		[MessageHandler(selector="Enter")] 
		override public function EnterView (View:ViewState):void
		{
			if (View._view != ViewState.Bet) return;
			
			//清除前一畫面
			utilFun.Log("in to EnterBetview=");			
			
			//載入新VIEW
			bet = utilFun.GetClassByString("BetView");
			addChild(bet);
			
			//元件事件及畫面更新
			utilFun.SetText(bet["roomNo"], _LobbyModel._currentRoomNum.toString());
			
			utilFun.SetText(bet["userId"], _PlayerModel.uuid.toString());
			
			//外盤 (有人押叫外盤)
			utilFun.SetText(bet["outorder"], String(_TableModel.GetBetCnt()));
			
			//內盤 (沒人押叫內盤)
			utilFun.SetText(bet["selforder"], String(_TableModel.GetNoOneBetCnt()));
			//
			//TODO
			//ToolsFunction.SetText(betView["bingoRecode"]["PanNumText"], //TODO);
			
			
			//所有盤號BTN
			BetList = new MultiObject();
			BetList.CustomizedFun = BetListCustomizedFun;
			BetList.CustomizedData = _TableModel.GetisBet();
			BetList.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[0,0,1,0]);
			BetList.Create(100, "BetTableBtn", 106.55, 271.85, 10, 98, 66, "Bet_", bet);	
			BetList.mousedown = BetPan;
			
			//盤號
			OrderList = new MultiObject();
			OrderList.CustomizedFun = OrderListCustomizedFun;
			OrderList.MouseFrame = utilFun.Frametype(MouseBehavior.ClickBtn);
			OrderList.Create(12, "OrderBtn", 1219.30, 131.75, 1, 0, 50.55, "BetNum_", bet);
			OrderList.mousedown = OrderBet;
			
			//押分
			BetPointList = new MultiObject();
			BetPointList.CustomizedFun = BetPointListCustomizedFun;
			BetPointList.MouseFrame = utilFun.Frametype(MouseBehavior.ClickBtn);
			BetPointList.Create(12, "OrderBtn", 1397.35 , 131.75 , 1, 0, 50.55, "BetPoint_", bet);
			BetPointList.mousedown = BetPoint;
			//
			//剩於時間
			utilFun.SetText(bet["betTime"], _TableModel._remainTime.toString());
			Tweener.addCaller(this, { time:_TableModel._remainTime , count: _TableModel._remainTime, onUpdate:TimeCount , transition:"linear" } );
			//
			//default 載入第一桌			
			LoadingPan(0);
			//
			UpdatePanNumAndBet();
			
			cancelbet = new SingleObject()
			cancelbet.MouseFrame = utilFun.Frametype(MouseBehavior.ClickBtn);
			cancelbet.Create(bet["CancelBtn"]);
			cancelbet.mousedown = CencelAllBet;
		}
		
		private function CencelAllBet(e:Event):Boolean 
		{
			dispatcher(new Intobject(_BetModel.GetBetTableNo().length, "CleanAllBet"));
			if( _LobbyModel._CleanAllbet != 0 )
			{
					var arr:Array = _BetModel.GetBetTableNo();
					for (var i:int = 0; i < arr.length ; i++)
					{
					    _BetModel._BetTableid = arr[i];
					    _BetModel._Betcredit = 0;
						dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BET));
					}
			}
			return true;
		}
		
		private function UpdatePanNumAndBet():void
		{
			OrderList.CustomizedFun = CustomizedFun_ShowData;
			OrderList.CustomizedData =  _BetModel.GetBetTableNo();
			OrderList.FlushObject();
			
			BetPointList.CustomizedFun = CustomizedFun_ShowData;
			BetPointList.CustomizedData =  _BetModel.GetBetamount();
			BetPointList.FlushObject();
			
			dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.HUD_UPDATA));
		}
		
		public function CustomizedFun_ShowData(mc:MovieClip,idx:int,CustomizedData:Array):void
		{			
			var str:String = idx >= CustomizedData.length ? "" : CustomizedData[idx];
			utilFun.SetText( mc["_Text"],str );			
		}		
		
		private function TimeCount():void
		{
			_TableModel._remainTime--;
			if (  _TableModel._remainTime < 0) return;
			
			utilFun.SetText(bet["betTime"],  _TableModel._remainTime.toString());
		}
		
		private function LoadingPan(TableNo:int):void
		{
			utilFun.ClearContainerChildren( bet["Panmatrix"]);
			PanContainer =  bet["Panmatrix"];
			Panmatrix = utilFun.GetClassByString("Pan")			
			PanContainer.addChild(Panmatrix);
			utilFun.scaleXY(PanContainer,0.8, 0.8);
			
			//每盤的號碼
			PanMatrixList = new MultiObject();
			PanMatrixList.CustomizedFun = PanMatrixCustomizedFun;
			PanMatrixList.CustomizedData = _TableModel.GetBallByIdx(_TableModel.GetTableByIdx(TableNo));
			PanMatrixList.Create(25, "PanCell",32.65 ,9.65 , 5, 57.8, 57.55, "MatrixNum_", bet["Panmatrix"]);
		
			//押盤金額
			//Panmatrix["BetCredit"]
			
			//剩餘開球數
			//Panmatrix["RestBallNum"]
			
			
			//預設桌號
			utilFun.SetText( Panmatrix["PanNum"]["PanNumText"], utilFun.Format(_TableModel.GetTableByIdx(TableNo), 2) );
			Panmatrix["star"].visible = false;
		}
		
		public function PanMatrixCustomizedFun(mc:MovieClip,idx:int,CustomizedData:Array):void
		{			
			//ToolsFunction.Log("CustomizedData ="+CustomizedData.length);
			//12不顥示
			var str:String;
			var RowCnt:int = 5;
			var ColCnt:int = 5;
			
			var rowNum:int = idx  / RowCnt;			
			var colNum:int = idx  % ColCnt;			
			//ToolsFunction.Log("idx = "+ idx +" rowNum +"+ rowNum + " colNum "+ colNum);
			var myidx:int = rowNum + (colNum * ColCnt) ;			
			if( idx == 12) 
			{
				str = "";			
			}
			else
			{
				if ( rowNum >=3 && colNum == 2 )  myidx -= 1;
				if ( colNum >= 3)	 myidx -= 1;
				str = CustomizedData[myidx ];			
			}
			//ToolsFunction.Log("myidx = "+ myidx);
			utilFun.SetText( mc["theNum"], str);			
		}
		
		private function BetPan(e:Event,idx:int):Boolean 
		{
			//自己押注的盤會以紅色標示、別人押注的盤以黃色標示、無人押注的盤則以藍色標示。
			//1,無人 2為自己, 3自己最後一注,4,為他人
			var arr:Array = _BetModel.GetBetTableNo();
		   if ( arr.indexOf(idx) != -1)
		   {
			   utilFun.Log("already bet ");
				return false;
		   }
		   
			if ( _BetModel.GetBetTableNo().length > 11) 
			{
				e.currentTarget.gotoAndStop(1);
				utilFun.Log("Bet return");
				return false;
			}
			_BetModel._BetTableid = idx;
			_BetModel._Betcredit = 100;
			dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BET));
			return false;
		}
		
		private function OrderBet(e:Event,idx:int):Boolean 
		{
			//減少押注
			var Bet:int = _BetModel.request_for_Betamount_Reduce(idx);
			if (Bet == -1)
			{
				utilFun.Log("Bet reduce To  0");
				return true;
			}
			_BetModel._BetTableid = _BetModel.GetSelectTable()
			_BetModel._Betcredit = Bet;
			dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BET));
			return true;
		}
		
		public function BetListCustomizedFun(mc:MovieClip,idx:int,IsBetInfo:Array):void
		{			
			utilFun.SetText(mc["tableNo"], utilFun.Format(idx, 2));
			//1,無人 2為自己, 3自己最後一注,4,為他人
			var arr:Array = _BetModel.GetBetTableNo();
			var cnt:int =  arr.length;
			
			//先調回無人下注
			mc.gotoAndStop( 1 );
			//有人下非自己,變黃
			if ( IsBetInfo[idx] == 1)
			{
				var MyBet:int = arr.indexOf(idx)
				if ( MyBet != -1)
				{
					//紅
					if (  MyBet == (cnt - 1))  
					{
						mc.gotoAndStop( (IsBetInfo[idx] + 2) );
					}
					else mc.gotoAndStop( (IsBetInfo[idx] + 1) );
				}
				else
				{
					//黃
					mc.gotoAndStop( (IsBetInfo[idx] + 3) );
				}
			}
			
		}
		
		private function BetPoint(e:Event,idx:int):Boolean
		{
			//增加押注
			var Bet:int = _BetModel.request_for_Betamount_add(idx);
			if (Bet == 0 )
			{
				utilFun.Log("no more Bet ");
				return true;
			}
			
			_BetModel._BetTableid = _BetModel.GetSelectTable()
			_BetModel._Betcredit =Bet;
			dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BET));
			return true;
		}
		
		public function OrderListCustomizedFun(mc:MovieClip,idx:int,CustomizedData:Array):void
		{
			utilFun.SetText( mc["_Text"], "");
		}
		
		public function BetPointListCustomizedFun(mc:MovieClip,idx:int,CustomizedData:Array):void
		{
			utilFun.SetText( mc["_Text"], "");
		}
		
		[MessageHandler(type="ConnectModule.websocket.WebSoketInternalMsg",selector="Betresult")]
		public function BetResult( ):void
		{
			utilFun.Log("BetResult = "+_BetModel._Bet_result );
			if ( _BetModel._Bet_result )
			{
				//新增押注
				
				var betSuccess:Boolean = _BetModel.AddBetInfo(_BetModel._Bet_room_no);
				if (betSuccess)
				{
					//顥示新盤號
					UpdatePanNumAndBet();
					LoadingPan(_BetModel._Bet_room_no);
					
					//押注BTN更新
					BetList.CustomizedFun = BetListCustomizedFun;					
					BetList.CustomizedData = _TableModel.GetisBet();
					BetList.FlushObject();			
					
				}
			}
		}
		
		[MessageHandler(type = "ConnectModule.websocket.WebSoketInternalMsg", selector = "clearnAllbet")]
		public function cleanResult():void
		{
			//押注BTN 還原
			BetList.CustomizedFun = BTnBack;
			BetList.CustomizedData =  _BetModel.GetBetTableNo();
			BetList.FlushObject();
			
			_BetModel.CleanAll();						
			UpdatePanNumAndBet();		
		}
		
		public function BTnBack(mc:MovieClip, idx:int, BetTableNo:Array):void
		{
			for each(var i:int in BetTableNo)
			{				
				if ( BetTableNo.indexOf(idx) != -1) mc.gotoAndStop(1);				
			}
		}
		
		[MessageHandler(type="ConnectModule.websocket.WebSoketInternalMsg",selector="betstateupdate")]
		public function UpdataTableBetInfo():void
		{	
			//比自己押注結果更早收到
			//押注BTN更新
			BetList.CustomizedFun = BetListCustomizedFun;					
			BetList.CustomizedData = _TableModel.GetisBet();
			BetList.FlushObject();
			
			dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.HUD_UPDATA));
			
			//外盤 (有人押叫外盤)
			utilFun.SetText(bet["outorder"], String(_TableModel.GetBetCnt()));
			
			//內盤 (沒人押叫內盤)
			utilFun.SetText(bet["selforder"], String(_TableModel.GetNoOneBetCnt()));
			
		}
		
		[MessageHandler(type="ConnectModule.websocket.WebSoketInternalMsg",selector="betstopHint")]
		public function EnterStopBet():void
		{
			stophint = utilFun.GetClassByString("StopBet");
			stophint.x =  174.55;
			stophint.y = 431.7;
			bet.addChild(stophint);
			
			stophint.alpha = 0;
			Tweener.addTween(stophint, {alpha:1, time:2,onComplete:FadeIn});
		}		
		
		private function FadeIn():void
		{
			Tweener.addTween(stophint, {alpha:0, time:2});
		}
		
		[MessageHandler(selector="Leave")]
		override public function ExitView(View:ViewState):void
		{
			if (View._view != ViewState.Bet) return;
			utilFun.ClearContainerChildren(bet);
			utilFun.Log("bet ExitView");
		}
		
		
	}

}