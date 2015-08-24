package View.ViewComponent 
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	import caurina.transitions.Tweener;
	
	/**
	 * playerinfo present way
	 * @author ...
	 */
	public class Visual_ticket  extends VisualHandler
	{
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _Actionmodel:ActionQueue;
		
		public function Visual_ticket() 
		{
			
		}
		
		public function init():void
		{			
			if ( _betCommand.get_my_betlist().length == 0) return;			
			
			var ball_pan:MultiObject = prepare("ball_pan", new MultiObject()  , GetSingleItem("_view").parent.parent);		  
		   ball_pan.Create_by_list(1, [ResName.Myticket], 0, 0, 1, 0, 0, "time_");
		   ball_pan.container.x = 443.9;
		   ball_pan.container.y = 537;	
			
		   var table:Array = _betCommand.get_my_bet_info("table");		 
		   var totalshow:int = Math.min(table.length, 3);		   
			var ticket:MultiObject = prepare("ticket", new MultiObject(), ball_pan.container);	
			ticket.CustomizedFun = info_initFun;
			ticket.CustomizedData =  table;			
			ticket.container.x = 27;
			ticket.container.y = 73;
			ticket.Create_by_list(totalshow, [ResName.bingo_pan], 0, 0, 3, 470, 0, "time_");
			
			//utilFun.SetText( bingo_pan.ItemList[0]["_panNum"]["tableNo"], "2");
			//bet_amountFun( bingo_pan.ItemList[0]["_pan_amount"], 0);
			//bingo_pan.ItemList[0]["_pan_amount"].CustomizedFun = bet_amountFun;			
			//bingo_pan.ItemList[0]["_pan_amount"].CustomizedData = [0];
			
			//_tool.SetControlMc(bingo_pan.container);
			//add(_tool);
			_model.putValue("openBalllist", []);
		}
		
		public function info_initFun(mc:MovieClip, idx:int, tableid:Array):void
		{		
			mc["_start"].visible = false;
			
			var balls:Array = _model.getValue("ballarr");
			//utilFun.Log("idx = " + idx);
			//utilFun.Log("balls = " + balls.length);
			//utilFun.Log(" balls[idx] = " +  balls[idx]);
			
			//cell
			var pan:MultiObject = prepare("select_pan"+idx, new MultiObject(), mc);	
			pan.CustomizedFun = PanMatrixCustomizedFun;
			pan.CustomizedData = balls[idx]; // select pan_num
			pan.container.x = 60;
			pan.container.y = 30;
			pan.Create_by_list(25, [ResName.bingo_pancell_new], 0, 0, 5, 63, 63, "time_");
			
			utilFun.SetText( mc["_panNum"]["tableNo"], String( tableid[idx]));			
			
			
			var amount:Array = _betCommand.get_my_bet_info("amount");
			//utilFun.Log("idx = " + idx);
			//utilFun.Log("amount = " + amount);
			//utilFun.Log(" amount[idx] = " +  amount[idx]);
			
			//amount
			bet_amountFun(  mc["_pan_amount"], amount[idx]);		
		}
		
		public function bet_amountFun(mc:MovieClip, amount:int):void
		{	
			var arr:Array = String(amount).split("");
			var re:Array = arr.reverse();
			//utilFun.Log("reverse = "+re);			
			for ( var i:int = 0; i < 4; i++)
			{
				if ( re[i] != undefined)
				{
					if ( re[i] == "0" ) re[i] = "10";
					mc["_num_" + i].gotoAndStop( parseInt(re[i]));
				}
				else mc["_num_" + i].gotoAndStop(11);
			}			
		}
		
		public function PanMatrixCustomizedFun(mc:MovieClip,idx:int,CustomizedData:Array):void
		{			
			var str:String;
			var RowCnt:int = 5;
			var ColCnt:int = 5;
			
			var rowNum:int = idx  / RowCnt;			
			var colNum:int = idx  % ColCnt;			
			
			var myidx:int = rowNum + (colNum * ColCnt) ;
			var color:uint = _model.getValue("bingo_color")[idx % 5];
			
			if( idx == 12) 
			{
				str = "";		
				mc.gotoAndStop(4);
			}
			else
			{
				if ( rowNum >=3 && colNum == 2 )  myidx -= 1;
				if ( colNum >= 3)	 myidx -= 1;
				str = CustomizedData[myidx];
				mc["_text"].textColor = color;
				utilFun.SetText( mc["_text"], str);	
			}
		}
		
		[MessageHandler(type="ConnectModule.websocket.WebSoketInternalMsg",selector="ballupdate")]
		public function select_pan():void
		{			
			if ( _betCommand.get_my_betlist().length == 0) return;	
			
			var BallNum:int = _model.getValue("Curball");			
			var len:int = Get("ticket").ItemList.length;
			var openballist:Array = _model.getValue("openBalllist");
			openballist.push(BallNum);		
			//_model.putValue("openBalllist",openballist);
			
			//open ball ani			
			//TODO show min start
			for ( var i:int = 0; i < len ; i++)
			{				
				Get("select_pan" + i).CustomizedFun = SelfPanBallAni;				
				Get("select_pan" + i).FlushObject();				
				
				var arr:Array = Get("select_pan" + i).CustomizedData;			
				var count:int = 24;
				for (  var k:int = 0; k < openballist.length ; k++)
				{
					if ( arr.indexOf(openballist[k] ) != -1) count--;
				}				
				utilFun.SetText( Get("ticket").ItemList[i]["_rest_ball"], count.toString());
				
			}			
			
			
		}
		
		public function SelfPanBallAni(mc:MovieClip, idx:int, CustomizedData:Array):void
		{			
			var OpenBallList:Array = _model.getValue("openBalllist");			
			var Ball:int = OpenBallList[OpenBallList.length - 1];
			
			var tableNo:TextField = mc["_text"];			
			if (  tableNo.text ==  Ball.toString() )
			{
				mc.gotoAndStop(2);
				Tweener.addTween(mc["_mask"], {height:63, time:1});
			}
		}
	}

}