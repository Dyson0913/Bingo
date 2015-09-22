package View.ViewComponent 
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import Interface.CollectionsInterface;
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
		
		private var _best_len:int = 0;
		
		private var _first_table:int = -1;
		private var _first_rest:int = 0;
		
		public function Visual_ticket() 
		{
			
		}
		
		public function init():void
		{			
			if ( _betCommand.get_my_betlist().length == 0) return;
			
			var ball_pan:MultiObject = prepare("ball_pan", new MultiObject()  , GetSingleItem("_view").parent.parent);		  
		   ball_pan.Create_by_list(1, [ResName.empty], 0, 0, 1, 0, 0, "time_");
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
			
			var openballist:Array = _model.getValue("openBalllist");
			openballist.push(BallNum);		
			//_model.putValue("openBalllist",openballist);
			
			//pick best 3
			var best:Array = best3_pan(openballist);
			var best3:Array = [];
			if ( best.length >= 3)
			{
				best3.push(best[1]);
				best3.push(best[0]);
				best3.push(best[2]);
			}
			else if(best.length ==2)
			{
				best3.push(best[1]);
				best3.push(best[0]);
			}
			else if(best.length ==1)
			{				
				best3.push(best[0]);
			}
			_best_len = best.length;
			
			//open ball ani			
			//TODO show min start
			var tableNo:Array = [];
			var openball:Array = openballist.concat();
			var balls:Array = _model.getValue("ballarr");
			var len:int = Get("ticket").ItemList.length;
			var totalshow:int = Math.min(best3.length, len);	
			
			openball.pop();
			//utilFun.Log("openball = "+openballist);
			//utilFun.Log("openball pop= "+openball);
			for ( var i:int = 0; i < totalshow ; i++)
			{				
				//change pan number
				Get("select_pan" + i).CustomizedData  = balls[best3[i]["tableNo"]];
				Get("select_pan" + i).CustomizedFun = PanMatrixCustomizedFun;	
				Get("select_pan" + i).FlushObject();
				
				//open num mark
				
				Get("select_pan" + i).CustomizedData  = openball;
				Get("select_pan" + i).CustomizedFun = PanBallcolor;	
				Get("select_pan" + i).FlushObject();
				
				//new num mark
				Get("select_pan" + i).CustomizedFun = SelfPanBallAni;
				Get("select_pan" + i).FlushObject();				
				
				
				//var arr:Array = Get("select_pan" + i).CustomizedData;			
				//var count:int = 24;
				//for (  var k:int = 0; k < openballist.length ; k++)
				//{
					//if ( arr.indexOf(openballist[k] ) != -1) count--;
				//}				
				utilFun.SetText( Get("ticket").ItemList[i]["_rest_ball"], best3[i]["rest"]);
				tableNo.push( best3[i]["tableNo"]);
			}			
			
			//pan amount and tableno
			utilFun.Log("new table = "+ tableNo);
			Get("ticket").CustomizedFun = update_paninfo;
			Get("ticket").CustomizedData =  tableNo;			
			Get("ticket").FlushObject();
		}
		
		public function update_paninfo(mc:MovieClip, idx:int, tableid:Array):void
		{		
			if( _best_len >=2) 
			{
				if ( idx == 1) mc["_start"].visible = true;			
				else mc["_start"].visible = false;			
			}
			else if( _best_len ==1) 
			{
				if ( idx == 0) mc["_start"].visible = true;
			}
			
			utilFun.SetText( mc["_panNum"]["tableNo"], String( tableid[idx]));
			var amount:Array = _betCommand.get_my_bet_info("amount");
			
			//amount
			bet_amountFun(  mc["_pan_amount"], amount[idx]);		
		}
		
		public function best3_pan(openballist:Array):Array
		{
			var tableNo:Array =  _betCommand.get_my_bet_info("table");			
			var Table_len:int = tableNo.length;
			//utilFun.Log("Table_len = "+ Table_len);
			//utilFun.Log("openballist = "+ openballist);
			var balls:Array = _model.getValue("ballarr");
			var myticket_restball_num:Array = [];
			for ( var i:int = 0; i < Table_len ; i++)
			{			
				var count:int = 24;
				var ticket_ball:Array = balls[tableNo[i]] ;
				//utilFun.Log("ticket_ball = "+ ticket_ball);
				for (  var k:int = 0; k < openballist.length ; k++)
				{
					if ( ticket_ball.indexOf(openballist[k] ) != -1) count--;
				}				
				
				//
				if ( _first_table != tableNo[i]  ) 
				{
					var table_and_rest:Object;			
					table_and_rest = { "tableNo": tableNo[i], 											
												 "rest":  count										 
											   };
					
					myticket_restball_num.push(table_and_rest);
				}
				else 
				{
					//更新候選球數
					if ( _first_table != -1)
					{
						_first_rest = count;
					}
				}
			
			}			
			//utilFun.Log("myticket_restball_num = "+ myticket_restball_num);
			myticket_restball_num.sort(order);			
			
			for (var k:int = 0; k < myticket_restball_num.length; k++)
			{
				utilFun.Log("after sort rest = " + myticket_restball_num[k]["rest"]  +" table =" + myticket_restball_num[k]["tableNo"]);				
			}
				utilFun.Log("=========== ");
			
			//記下第一個桌號,下次排序,排除在外
			if ( _first_table == -1) 
			{
				_first_table = myticket_restball_num[0]["tableNo"];
				_first_rest = myticket_restball_num[0]["rest"];
				utilFun.Log("_first Tb="+_first_table + " rest = "+ _first_rest);
			}
			else	if (_first_table != -1)
			{
				//與第一個差二球,才做交換
				utilFun.Log("check _first_rest="+_first_rest + " sort first = "+ myticket_restball_num[0]["rest"] );
				if (  (_first_rest -2) == myticket_restball_num[0]["rest"] )
				{
					_first_table = myticket_restball_num[0]["tableNo"];
					_first_rest = myticket_restball_num[0]["rest"];
					utilFun.Log("new  Tb="+_first_table + " rest = "+ _first_rest);
				}
				else 
				{
					//沒有就把目前最少球數的放回第一個
					var table_and_rest:Object;			
					table_and_rest = { "tableNo": _first_table, 											
												 "rest":  _first_rest										 
											   };
					
					myticket_restball_num.unshift(table_and_rest);
					utilFun.Log("nochange put back  Tb="+_first_table + " rest = "+ _first_rest);
				}
			}
			
			return myticket_restball_num;
		}
		
		//傳回值 -1 表示第一個參數 a 是在第二個參數 b 之前。
		//傳回值 1 表示第二個參數 b 是在第一個參數 a 之前。
		//傳回值 0 指出元素都具有相同的排序優先順序。
		private function order(a, b):int 
		{
			if ( a["rest"] < b["rest"]) return -1;
			else if ( a["rest"] > b["rest"]) return 1;
			else return 0;			
		}
		
		public function SelfPanBallAni(mc:MovieClip, idx:int, CustomizedData:Array):void
		{			
			var OpenBallList:Array = _model.getValue("openBalllist");			
			var Ball:int = OpenBallList[OpenBallList.length - 1];
			
			var tableNo:TextField = mc["_text"];			
			if (  tableNo.text ==  Ball.toString() )
			{
				mc.gotoAndStop(2);
				//tx.textColor = 0xD2D2D2;
				//63
				Tweener.addTween(mc["_mask"], {height:51, time:1,delay:1, onStartParams:[tableNo,0xD2D2D2],onStart:this.open_handle});
			}			
		}
		
		public function open_handle(tx:TextField,color:uint):void
		{
			tx.textColor = color;
		}
		
		public function PanBallcolor(mc:MovieClip, idx:int, openlist:Array):void
		{			
			
			var tableNo:TextField = mc["_text"];			
			if (  openlist.indexOf( parseInt( tableNo.text)) != -1)
			{
				//utilFun.Log("open ed");
				mc.gotoAndStop(2);
				tableNo.textColor = 0x666666;
				mc["_mask"].height = 51;
			}
			else {
				if ( idx == 12) return;
				mc.gotoAndStop(2);
				mc["_mask"].height = 0;
				mc.gotoAndStop(1);
			}
		
		}
	}

}