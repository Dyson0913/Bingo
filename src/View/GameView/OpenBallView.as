package View.GameView
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import Model.*;
	import View.componentLib.util.MultiObject;
	import View.componentLib.util.SingleObject;
	import View.componentLib.ViewBase.ViewBase;
	
	import caurina.transitions.Tweener;
	import View.componentLib.util.*;
	
	/**
	 * ...
	 * @author hhg
	 */
	public class OpenBallView extends ViewBase 
	{
		
		public var WinHint:MovieClip;
		
		public var SwitchBtn:SingleObject;
		
		public var OpenBallList:Array = [];
		public var Open3BallList:Array = [];
		
		public var DynamicArea:MovieClip;
		public var BestPanContainer:MovieClip;
		
		public var BallPan:MovieClip;
		public var Panarr:Array = [];
		public var Best3Pan:MultiObject;
		
		//最佳盤與次佳盤
		public var BestPan:MultiObject;
		public var SecondPan:MultiObject;
		
		[Inject]
		public var _BallModel:BallModel;
		
		[Inject]
		public var _BetModel:BetModel;
		
		[Inject]
		public var _TableModel:TableModel;
		
		public function OpenBallView()  
		{
			
		}
		
		[MessageHandler(selector="Enter")] 
		override public function EnterView(View:ViewState):void
		{
			if (View._view != ViewState.openball) return;
			//清除前一畫面
			utilFun.Log("in to openballview=");			
			OpenBallList.length = 0;
			Open3BallList.length = 0;
			
			//載入新VIEW
			_View = utilFun.GetClassByString("BallView");
			addChild(_View);
			
			WinHint = _View["BingCongratulation"];
			WinHint.visible = false;
			
			var mc:MovieClip = _View["CurrentOpenBall"];
			mc.visible = false;
			
			//動態區畫面
			DynamicArea = _View["DynamicArea"];
			BallPan = utilFun.GetClassByString("AllBallPan");
			DynamicArea.addChild(BallPan);
			
			BestPanContainer = _View["BestPan"];
			utilFun.ClearContainerChildren(BestPanContainer);
			
			//存入betmodel,好處理
			var arr:Array = _BetModel.GetBetTableNo();
			for (var i:int = 0; i < arr.length; i++)
			{
				var tableBall:Array = _TableModel.GetBallByIdx(arr[i]);				
				_BetModel.CommfirmAdd(tableBall);
			}			
			
			//各盤勢一開始就new出,只是hide,全移除再切回很麻煩
			if ( _BetModel.GetBetTableNo().length != 0)
			{
				DynamicArea.visible = false;
				BestPanContainer.visible = true;
				
				PanProcess( -1, 24);				
			}
			else
			{
				DynamicArea.visible = true;
				BestPanContainer.visible = false;
			}
			
			//換盤BTN
			
			SwitchBtn = new SingleObject()
			SwitchBtn.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[0,0,1,0]);
			SwitchBtn.Create(_View["switchPan"]);
			SwitchBtn.mousedown = SwitchPanEvent
		}
		
		private function SwitchPanEvent(e:Event):Boolean
		{
			var idx:int = utilFun.cycleFrame(  e.currentTarget.currentFrame, 2);					
			if (  _BetModel.GetBetTableNo().length == 0)  false;
			
			DynamicArea.visible = !DynamicArea.visible;
			BestPanContainer.visible = !BestPanContainer.visible;
			
			SwitchBtn.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[0,0,idx,0]);
			//SwitchPan.gotoAndStop(idx)
			return true;
		}
		
		[MessageHandler(type = "ConnectModule.websocket.WebSoketInternalMsg", selector = "ball_update")]
		public function update_Ball_state():void
		{
			utilFun.Log("update_Ball_state =");
			//目前開球
			var CurrentBallNum:TextField = _View["CurrentOpenBall"]["ballNum"] ;
			CurrentBallNum.text = _BallModel.CurrentBallNum.toString();
			
			var BallNum:int = _BallModel.CurrentBallNum;
			
			OpenBallList.push( BallNum);
			Open3BallList.unshift( BallNum);
			if ( Open3BallList.length > 3)
			{
				Open3BallList.pop();
			}
			
			//server 傳1 base
			var BallIdx:int =BallNum-1;
			var BallDisPlayIdx:int = BallNum;
			
			//左方小球
			for (var i:int = Open3BallList.length; i >0 ; i--)
			{
				utilFun.SetText(_View["sBall_" + i ]["ballNum"], utilFun.Format(Open3BallList[i-1], 2) );
				var mc:MovieClip = _View["sBall_" + i];
				//mc.visible = true;
				mc.gotoAndStop( Math.ceil( Open3BallList[i-1] / 15) ) ;
			}
			
			//左方大球
			var mc:MovieClip = _View["CurrentOpenBall"];	
			mc.visible = true;
			mc.gotoAndStop( Math.ceil( BallDisPlayIdx / 15) ) ;
			utilFun.SetText(mc["ballNum"], utilFun.Format( BallDisPlayIdx, 2 ));	
			
			//開球動畫 TODO暫時作法 理想作法,放到multiOb裡,拿出來播,			
			mc = utilFun.GetClassByString("DynamicBall");
			BallPan.addChild(mc);
			mc.x =  488.8;
			mc.y =  101.05;
			
			var xPos:int = (( BallIdx  % 15 )) *  76;
			var yPos:int  = Math.floor( BallIdx / 15 )* 72;
			
			utilFun.SetText( mc["ballNum"], utilFun.Format( BallDisPlayIdx, 2 ));
			
			mc.gotoAndStop( Math.ceil( BallDisPlayIdx / 15 ) );
			
			Tweener.addTween(mc, { scaleX:0.4, scaleY:0.4, x:80.05 + xPos, y:1.95 + yPos, time:1 } );
			
			//最佳盤剩幾球
			utilFun.SetText( _View["bestBall"],  _BallModel.best_remain.toString());
			
			//次佳盤剩幾球
			utilFun.SetText( _View["secondBall"], _BallModel.second_remain.toString());
			
			PanProcess(BallNum,_BallModel.best_remain);			
			
			//最佳盤
			BestPan = new MultiObject();
			SecondPan = new MultiObject();
			
			var TableNo:Array = [];
			var BallList:Array = [];
			var N:int  = _BallModel.best_list.length;
			for (var i:int = 0; i < N; i++)
			{
				//動態最佳盤
				TableNo.push( _BallModel.best_list[i].table_no);
				BallList.push( _BallModel.best_list[i].ball_list);
			}
			
			SortSelfBet(TableNo, BallList);
			
			Dynamicpan(TableNo, BallList, BestPan, PanCustomizedFun, _View["BestPanArea"]);
			TableNo.length = 0;
			BallList.length = 0;
			
			//次佳盤
			N = _BallModel.second_list.length;
			for (var i:int = 0; i <N; i++)
			{
				//動態最佳盤
				TableNo.push(_BallModel.second_list[i].table_no);
				BallList.push(_BallModel.second_list[i].ball_list);
			}
			
			SortSelfBet(TableNo, BallList);
			Dynamicpan(TableNo, BallList, SecondPan, PanCustomizedFun, _View["SecondPanArea"]);
			
			//最佳盤剩幾盤
			utilFun.SetText( _View["bestPan"], _BallModel.best_list.length.toString());
			
			//次佳盤剩幾盤
			utilFun.SetText( _View["secondPan"], _BallModel.second_list.length.toString());			
			
			//SoundSuccess.play();
			utilFun.SetText( _View["ballCount"], _BallModel.opened_ball_num.toString() );
			utilFun.Log("update_Ball_state =2");
		}
		
		public function SortSelfBet(TableNo:Array, BallList:Array):void
		{
			var arr:Array = _BetModel.GetBetTableNo();			
			var table:Array = [];
			var balllist:Array = [];						
			
			//挑選
			for (var i:int = 0; i < arr.length; i++)
			{			
				var Tableidx:int = arr[i];
				
				var idx:int  = TableNo.indexOf(Tableidx)
				if (  idx!= -1)
				{					
					table.push(Tableidx);
					balllist.push(BallList[idx]);
					TableNo.splice(idx, 1);
					BallList.splice(idx,1);
				}				
			}
			
			if ( table.length != 0)
			{												
				for (var i:int = 0; i < table.length; i++)
				{					
					TableNo.unshift(table[i]);
					BallList.unshift(balllist[i]);
				}								
			}
		}
		
		public function SelfPanBallAni(mc:MovieClip, idx:int, CustomizedData:Array):void
		{
			var Ball:int = OpenBallList[OpenBallList.length - 1];
			
			var tableNo:TextField = mc["theNum"];			
			if ( tableNo.text ==  Ball.toString())
			{
				mc.gotoAndStop(2);
				Tweener.addTween(mc["_mask"], {height:56, time:1});
			}
			
		}
		
		public function PanProcess(newBall:int, bestRemain:int):void
		{
			//沒押注
			if ( _BetModel.GetBetTableNo().length == 0) return;
			
			//各桌剩球CEHCK
			_BetModel.CheckBallremain(newBall);
			
			//列出前三桌剩最少
			var Best3TableList:Array = _BetModel.GetBest3BallList(OpenBallList.length);
			//ToolsFunction.Log("best3 = " + Best3TableList);
			utilFun.SetText( _View["BestLeft"], String (_BetModel.GetRemain(0) - bestRemain ));
				
			Panarr.length = 0;
			
			Best3Pan = new MultiObject();
			Best3Pan.CleanList();
			
			var MaxDisplay:int = Math.min(3, _BetModel.GetBetTableNo().length);
			Best3Pan.CustomizedFun = PanInfo;			
			Best3Pan.Create(MaxDisplay, "Pan",0 ,0 , MaxDisplay, 427.1, 0, "BetPoint_", BestPanContainer);
			
			
			//最後一球動畫顥示			
			for ( var i:int = 0 ; i < Panarr.length ; i++)
			{
				var myPan:MultiObject = Panarr[i];
				myPan.CustomizedFun = SelfPanBallAni;
				myPan.FlushObject();
			}
		}
		
			public function PanMatrixCustomizedFun(mc:MovieClip,idx:int,CustomizedData:Array):void
		{			
			//ToolsFunction.Log("CustomizedData ="+CustomizedData.length);
			//12不顥示
			var str:String;
			var RowCnt:int = 5;
			var ColCnt:int = 5;
			var str:String;
			
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
		
		public function PanInfo(mc:MovieClip, idx:int, CustomizedData:Array):void
		{			
			//桌號
			utilFun.SetText( mc["PanNum"]["PanNumText"], utilFun.Format(_BetModel.GetTable(idx), 2).toString() );
			
			//BetCredit
			utilFun.SetText(mc["BetCredit"],  _BetModel.Betamount(idx).toString() );
			
			//剩餘球數	RestBallNum
			utilFun.SetText(mc["RestBallNum"], _BetModel.GetRemain(idx).toString() );
			
			//盤號
			var ballarr: Array = _BetModel.GetBallList(idx);
			//ToolsFunction.Log("ball = "+ballarr);
			var BuyPan:MultiObject = new MultiObject();
			BuyPan.CustomizedFun = PanMatrixCustomizedFun;
			BuyPan.CustomizedData = ballarr;
			BuyPan.Create(25, "PanCell",32.65 ,9.65 , 5, 57.8, 57.55, "MatrixNum_", mc);
			Panarr.push( BuyPan);			
			
			//己開球畫面處理
			BuyPan.CustomizedFun = AlreadyOpenAni;
			BuyPan.FlushObject();
			
			//最佳盤星星							
			mc["star"].visible = _BetModel.ShowStart(idx);
		}
		
		public function AlreadyOpenAni(mc:MovieClip, idx:int, CustomizedData:Array):void
		{
			for ( var i:int = 0; i < OpenBallList.length-1 ; i++)
			{
				var Ball:String = OpenBallList[i];
				var tableNo:TextField = mc["theNum"];			
				
				if ( tableNo.text ==  Ball)
				{
					//ToolsFunction.Log("Ball = " + Ball + " TableNo =" +tableNo.text );
					mc.gotoAndStop(2);					
					mc["_mask"].height = 56;
				}
			}			
		}
		
		private function Dynamicpan(TableNo:Array,BallList:Array,Pan:MultiObject ,cutFun:Function,Container:MovieClip):void
		{
			//最大顯示組數
			var MaxDataLen:int = 0;
			//一行的T最大顥示組數			
			var RowMaxNum:int = 0;
			var remainBallLen:int = BallList[0].length;
			var Scale:Number = 1;
			var Ydiff:Number = 70;
			var Distance:int = 1240;
			
			//隨球數 間隔加大
			if ( remainBallLen == 4 )
			{
				RowMaxNum = 3;
				MaxDataLen = 6;
				Ydiff = 100;
				Distance = 1240;
			}
			else if ( remainBallLen == 3)
			{
				RowMaxNum = 3;
				MaxDataLen = 6;
				Ydiff = 100;
				Distance = 1300;
			}
			else if ( remainBallLen == 2)
			{
				RowMaxNum = 4;
				MaxDataLen = 8;
				Ydiff = 100;
				Distance = 1270;
			}
			else if ( remainBallLen == 1)
			{
				RowMaxNum = 5;
				MaxDataLen = 10;
				Ydiff = 100;
				Distance = 1270;
			}
			else
			{
				RowMaxNum = 10;
				MaxDataLen = 20;
				Distance = 1220;
			}
				
			utilFun.ClearContainerChildren(Container);
			
			Pan.CustomizedFun = cutFun;
			Pan.CustomizedData = TableNo;
			
			//一列的數量,和位置,動態變動 沒球10個, 一個球再算距離 1169 4:1240
			var Xdiff:Number = utilFun.NPointInterpolateDistance(RowMaxNum, 0, Distance);
			var RowCnt:int = (int)( Math.min(MaxDataLen, TableNo.length) );
			
			Pan.Create(RowCnt, "PanTableNum", 0 , 0 , RowMaxNum, Xdiff, Ydiff, "BestTable_",  Container);
			//ToolsFunction.Log("22");
			
			//每桌顥示球
			for ( var i:int = 0 ; i <  Pan.ItemList.length ; i++)
			{
				var Best3Ball:MultiObject = new MultiObject();
				Best3Ball.CustomizedFun =Best3BallCustomizedFun;
				Best3Ball.CustomizedData = BallList[i];
				
				Xdiff = 70;
				Ydiff = 0;
				Best3Ball.Create(BallList[i].length, "PanTableBall", 95 , -10 , BallList[i].length, Xdiff, Ydiff, "BestTableBall_",  Pan.ItemList[i]);
			}
			
			//是否有方法放到multiObject()裡
			for (var i:int = 0 ; i < Pan.ItemList.length ; i++)
			{
				utilFun.scaleXY(Pan.ItemList[i], Scale, Scale);
			}
			
		}
		
		public function PanCustomizedFun(mc:MovieClip,idx:int,SortTableNo:Array):void
		{
			var tableNo:TextField = mc["PanNumText"];			
			tableNo.text = utilFun.Format(SortTableNo[idx], 2);
			
			var arr:Array = _BetModel.GetBetTableNo()
			mc.gotoAndStop(1);
			
			//if( betstate
			//自己
			if ( arr.indexOf(SortTableNo[idx] )!= -1)
			{
				mc.gotoAndStop(2);
			}
			else
			{
				//他人或無人
				var betstate:Array = _TableModel.GetisBet();
				if (betstate[ SortTableNo[idx] ] ==0 )
				{
					//tableNo
					tableNo.textColor = 0xFFFFFF;
					mc.gotoAndStop(3);
				}
			}
		}
		
		public function Best3BallCustomizedFun(mc:MovieClip,idx:int,CustomizedData:Array):void
		{
			var tableNo:TextField = mc["ballNum"];
			tableNo.text = utilFun.Format(CustomizedData[idx], 2);
			mc.gotoAndStop( Math.ceil( CustomizedData[idx] / 15) ) ;			
		}
		
		[MessageHandler(type="ConnectModule.websocket.WebSoketInternalMsg",selector="bingo")]
		private function BingoHint():void
		{
			WinHint.visible = true;
		}
		
		private function HalfEnterInit(Credit:int,openHistory:Array):void
		{
			
			
			//移到hud
			//utilFun.ClearContainerChildren(Hud);
			//Hud.addChild( ToolsFunction.GetClassByString("TopBar") );
			//Hud.addChild( ToolsFunction.GetClassByString("ButtonBar") );
			//所押盤數更新
			//ToolsFunction.SetText(Hud.getChildByName("ButtonBar")["BetOrder"], String(0));			
			//押分
			//ToolsFunction.SetText(Hud.getChildByName("ButtonBar")["Bet"], String(0));
			//Credit
			//ToolsFunction.SetText(Hud.getChildByName("ButtonBar")["Credit"], betModel._credit.toString() );
			//離最佳剩幾球
			//ToolsFunction.SetText( OpenBallView["BestLeft"], String(0));
			
			
			
			//己開球補齊			
			var Cnt:int = _BallModel.opened_history.length;
			for ( var i:int = 0; i < Cnt; i++)
			{
				//server 傳1 base
				var CurrentBallNum:int = _BallModel.opened_history[i];
				var BallIdx:int = CurrentBallNum-1;
				var BallDisPlayIdx:int = CurrentBallNum;
				var mc:MovieClip = utilFun.GetClassByString("DynamicBall");
				BallPan.addChild(mc);
				
				var xPos:int = (( BallIdx  % 15 )) *  76;
				var yPos:int  = Math.floor( BallIdx / 15 )* 72;
				
				utilFun.SetText( mc["ballNum"], utilFun.Format( BallDisPlayIdx, 2 ));
				
				mc.gotoAndStop( Math.ceil( BallDisPlayIdx / 15 ) );
				utilFun.scaleXY(mc, 0.4, 0.4);
				mc.x =  80.05+xPos;
				mc.y = 1.95+yPos;
			}
		}
		
		[MessageHandler(selector="Leave")]
		override public function ExitView(View:ViewState):void
		{
			if (View._view != ViewState.openball) return;
			utilFun.ClearContainerChildren(_View);
			utilFun.Log("open ExitView");
		}
		
		
	}

}