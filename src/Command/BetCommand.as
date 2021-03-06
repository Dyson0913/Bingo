package Command 
{
	import com.adobe.images.JPGEncoder;
	import ConnectModule.websocket.WebSoketComponent;
	import ConnectModule.websocket.WebSoketInternalMsg;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLVariables;
	import Model.*;
	import Model.valueObject.StringObject;
	import util.DI;
	import util.utilFun;
	import View.GameView.*;
	import com.adobe.serialization.json.JSON
	/**
	 * user bet action
	 * @author hhg4092
	 */
	public class BetCommand 
	{
		[MessageDispatcher]
        public var dispatcher:Function;
		
		[Inject]
		public var _Actionmodel:ActionQueue;
		
		[Inject]
		public var _opration:DataOperation;
		
		[Inject]
		public var _model:Model;
		
		[Inject]
		public var _betDelayCommand:BetDelayCommand;
		
		[Inject]
		public var _socket:WebSoketComponent;
		
		public var _Bet_info:DI = new DI();
		
		public static var Table:String = "betType";
		public static var Bet_idx:String = "bet_idx";
		public static var TotalBet:String = "total_amount";
		
		public static const no_one_bet:int = 1;
		public static const self_bet:int = 2;
		public static const self_last_bet:int = 3;
		public static const someone_bet:int = 4;
		
		public function BetCommand() 
		{
			
		}
		
		public function bet_init():void
		{
			_model.putValue("coin_selectIdx", 0);
			
			var betzone:Array = [];
			for ( var i:int = 0; i < 100; i++)
			{
				betzone.push(i);			 
			}
			_model.putValue(modelName.BET_ZONE, betzone);
			
			_model.putValue("Bet_coin_List", [0, 100, 200, 300, 500, 1000]);			
			_model.putValue("last_bet_idx", -1);
			_model.putValue("bet_history", []);
			_Bet_info.putValue("self", [] ) ;
			
			_betDelayCommand.init();
		}
		
		
		public function sub_amount(e:Event, table:int):Boolean
		{			
			var find_idx:int = Find_Bet_type_idx(table);
			
			if ( find_idx != -1)
			{
				var bet_list:Array = _Bet_info.getValue("self");
				bet_list[find_idx][Bet_idx] -= 1;
				_Bet_info.putValue("self", bet_list);
			}
			
			return no_sign_bet(e, table);
			//return bet(e, table);
		}
		
		public function add_amount(e:Event, table:int):Boolean
		{			 
			
			var find_idx:int = Find_Bet_type_idx(table);
			
			if ( find_idx != -1)
			{
				var bet_list:Array = _Bet_info.getValue("self");
				
				//over bet limit
				var coin_list:Array  = _model.getValue("Bet_coin_List");
				var idx:int = parseInt(bet_list[find_idx][Bet_idx] ) + 1;
				if ( idx >= coin_list.length) return false
				var bet_amount:int = coin_list[idx] - coin_list[idx-1];
				//檢查餘額(加分)
				if (_model.getValue(modelName.CREDIT) < bet_amount) {
					//餘額不足訊息
					dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.NO_CREDIT));
					return false;
				}
				
				bet_list[find_idx][Bet_idx] += 1;				
				_Bet_info.putValue("self", bet_list);
			}else {
				//檢查餘額(買盤)
				if (_model.getValue(modelName.CREDIT) < 100) {
					//餘額不足訊息
					dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.NO_CREDIT));
					return false;
				}
			}
			
			return bet(e, table);
			
		}
		
		
		public function bet(e:Event, betType:int):Boolean
		{
			//if (_Actionmodel.length() != 0)
			//{
				//utilFun.Log("too quick forbiden");
				//return false;
			//}
			var betob:Object = betOb(betType);			
			//return true;
			dispatcher( new ActionEvent(betob, "bet_action"));
			
			dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BETRESULT));

			return true;
		}
		
		//add and sub have sign 
		//add 100, total = 100
		//add 100,  total = 200
		//sub -100,total =100
		public function betOb(BetType:int):Object
		{
			var coin_list:Array  = _model.getValue("Bet_coin_List");
			
			var bet:Object;
			var amount:int = get_amount_by_type(BetType);
			//utilFun.Log("=================== = "  );
			//utilFun.Log("BetType = " + BetType );
			//utilFun.Log("total_bet = " + total_bet(BetType));
			//utilFun.Log("add amount = " +  (amount - total_bet(BetType)) );			
			//utilFun.Log("coin_list.indexOf(amount) = " + coin_list.indexOf(amount));
			//utilFun.Log("betzone_totoal() = " + amount );
			//utilFun.Log("=================== = "  );
			
			bet = { "betType": BetType, 											
			                           "bet_amount":  amount - total_bet(BetType),		
									   "bet_idx":coin_list.indexOf(amount),
									   "total_amount":amount
									   };
									   
			return bet;
		}
		
		public function no_sign_bet(e:Event, betType:int):Boolean
		{
			var betob:Object = betOb_with_no_sign(betType);
			
			//return true;
			dispatcher( new ActionEvent(betob, "bet_action"));
			
			dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BETRESULT));

			return true;
		}
		
		//add and sub have no sign 
		//add 100, total = 100
		//add 100,  total = 200
		//sub 100,total =100
		public function betOb_with_no_sign(BetType:int):Object
		{
			var coin_list:Array  = _model.getValue("Bet_coin_List");
			
			var bet:Object;
			var amount:int = get_amount_by_type(BetType);
			utilFun.Log("=================== = "  );
			utilFun.Log("BetType = " + BetType );
			utilFun.Log("total_bet = " + total_bet(BetType));
			utilFun.Log("add amount = " +  Math.abs( (amount - total_bet(BetType)))  );			
			utilFun.Log("coin_list.indexOf(amount) = " + coin_list.indexOf(amount));
			utilFun.Log("betzone_totoal() = " + amount );
			utilFun.Log("=================== = "  );
			
			bet = { "betType": BetType, 											
			                           "bet_amount":  Math.abs( amount - total_bet(BetType) ),		
									   "bet_idx":coin_list.indexOf(amount),
									   "total_amount":amount
									   };
									   
			return bet;
		}
		
		public function get_amount_by_type(BetType:int ):int
		{			
			var betlist:Array =  _model.getValue("Bet_coin_List");
			
			var idx:int = Find_Bet_type_idx(BetType);			
			if ( idx !=-1)
			{
				var bet_idx_list:Array = get_my_bet_info(Bet_idx);
				return betlist[ bet_idx_list[idx]];
			}
			
			return betlist[1];
		}
		
		private function total_bet(BetType:int):int
		{
			var Total_bet:Array = get_my_bet_info(TotalBet);
			
			var idx:int = Find_Bet_type_idx(BetType);
			if ( idx !=-1) return Total_bet[idx];		
			return 0;
		}		
		
		public function Find_Bet_type_idx(BetType:int):int
		{
			var table:Array = get_my_bet_info(Table);			
			return table.indexOf(BetType) ;			
		}
		
		public function cancel_allbet(e:Event, idx:int):Boolean
		{
			if ( _Actionmodel.length() != 0)  
			{
				utilFun.Log("action queue return ");
				return false;			
			}
			
			var bet_list:Array = _Bet_info.getValue("self");			
			var n:int =  bet_list.length;
			if ( n == 0)
			{
				utilFun.Log("no bet  return ");
				return false;			
			}
			
			while(bet_list.length > 0)
			{
				var bet:Object = bet_list[0];				
				bet[Bet_idx] = 0 ;
				var sub_betob:Object   = betOb_with_no_sign(bet["betType"]);			
				
				dispatcher( new ActionEvent(sub_betob, "bet_action"));
				
				dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BETRESULT));
			}		
			//dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BET_NO_SIGN));
			
			return true;
		}		
		
		[MessageHandler(type = "ConnectModule.websocket.WebSoketInternalMsg", selector = "Betresult")]
		public function accept_bet():void
		{
			var bet_ob:Object = _Actionmodel.excutionMsg();		
			
			var bet_list:Array = _Bet_info.getValue("self");
			var idx:int = Find_Bet_type_idx(bet_ob["betType"]);
			
			var is_sub:Boolean = false;
			if (idx ==-1)
			{
				delete bet_ob["bet_amount"];
				bet_list.push(bet_ob);  
				_Bet_info.putValue("self", bet_list);
			}
			else
			{				
				delete bet_ob["bet_amount"];				
				bet_list[idx] = bet_ob;				
				//utilFun.Log("af bet_idx= "+bet_list[idx]["bet_idx"]);
				//utilFun.Log("af total_amount= " + bet_list[idx]["total_amount"]);
				
				if ( bet_list[idx]["total_amount"] == 0)
				{
					utilFun.Log("del item = ");
					bet_list.splice(idx, 1);	
					utilFun.Log("del item bet_list= "+bet_list.length);
					is_sub = true;
				}
			}
			
			if ( !is_sub) 
			{
				utilFun.Log("put in = "+ bet_ob[Table]);
				_model.putValue("last_bet_idx", bet_ob[Table]);
			}
			else
			{
			    //退注 把last idx預設	下注最後一筆
				if ( bet_list.length != 0)
				{
					var lastTable:int = bet_list[bet_list.length - 1][Table];
					utilFun.Log("lastTable = "+lastTable);				
					_model.putValue("last_bet_idx", lastTable);
				}
			}
			
			_Bet_info.putValue("self", bet_list);
			
			dispatcher(new ModelEvent(WebSoketInternalMsg.BET_UPDATE));
			
			//延遲送單
			_betDelayCommand.newDelayTask(bet_ob);
			
			//for bet test ,open ball need remove to sim bet action
			//utilFun.SetTime(simulat_upate, 0.1);
			//FOR TEXT
			_Actionmodel.dropMsg();
			
		}
		
		public function simulat_upate():void
		{
		
			if ( CONFIG::debug ) 
			{
				//utilFun.Log("simulat_upate ");
				//var bet_ob:Object = _Actionmodel.excutionMsg();
				//var is_bet:Array = _model.getValue("is_betarr");
				//var num:int  = is_bet.length;						
				//is_bet.splice(bet_ob["betType"], 0, 1);
				//
				//utilFun.Log("fake push is_bet ="+is_bet);
				//_model.putValue("is_betarr", is_bet);						
				//
				//dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BET_STATE_UPDATE));
				//utilFun.Log("send info =");
			}	
			
			//TODO test need to move to here 
			//_Actionmodel.dropMsg();
			if ( _Actionmodel.length() != 0) 
			{
				utilFun.Log("dropMsg ");
				dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BET_NO_SIGN));
			}
				
			
		}
		
		public function get_my_betlist():Array
		{			 
			return _Bet_info.getValue("self");		
		}
		
		public function get_my_bet_info(type:String):Array
		{
			var arr:Array = _Bet_info.getValue("self");			
			var data:Array = [];
			
			for ( var i:int = 0; i < arr.length ; i++)
			{
				var bet_ob:Object = arr[i];
				if ( type == Table) data.push(bet_ob["betType"]);
				if ( type == TotalBet) data.push(bet_ob["total_amount"]);								
				if ( type == Bet_idx) data.push(bet_ob["bet_idx"]);								
			}
			return data;
		}
		
		[MessageHandler(type = "ConnectModule.websocket.WebSoketInternalMsg", selector = "win_hint")]
		public function sort_betinfo():void
		{			
			//{ "bet_type": "11,1", "settle_amount": 0, "odds": 90, "win_state": "WSLost", "bet_amount": 100 }			
			
			var bet_list:Array = _Bet_info.getValue("self");
			
			if ( bet_list.length == 0 ) return;
			bet_list.length = 0;
			
			var result_list:Array = _model.getValue(modelName.ROUND_RESULT);						
			var history:Array = [];
			for (var i:int = 0; i < result_list.length; i++)
			{
				var betob:Object = result_list[i];
				var room_and_table:String = betob["bet_type"];
				var data:Array = room_and_table.split(",");
				history.push(data[1]);
				//var ob:Object  = { "betType": data[1], 											
			                           //"bet_amount":   betob["bet_amount"],		
									   //"bet_idx":coin_list.indexOf( betob["bet_amount"]),						   
									   //"total_amount":betob["bet_amount"]
									   //};
				//utilFun.Log("put ob = "+ data[1]);
				//utilFun.Log("put ob bet_amount]= "+ betob["bet_amount"]);
				//utilFun.Log("put ob conidx= "+ coin_list.indexOf( betob["bet_amount"]));
				//
				//bet_list.push(ob);
				
			}
			_model.putValue("bet_history", history);
			
			_Bet_info.putValue("self", bet_list);
			
			//記錄歷史記錄  TODO //目前只記錄一局,之後server傳真的過來
			//var round_code:int = _model.getValue("game_round");
			//_model.getValue("SomeOne_bet");  //賣出
			//_model.getValue("NoOne_bet"); //內盤
			//var tableNo:Array = _model.getValue(modelName.BINGO_TABLE); //--2,賓果盤號
		   	//_model.getValue("openBalllist"); //--5.球數
			//_model.getValue("Curball" );    //--6.賓果球
			//
			
			//var history_recode:Array = _model.getValue("history_opened_ball");
			//var history_ob:Object;
			//history_ob = { "round": _model.getValue("game_round"), 											
			            //"bingo_pan":  _model.getValue(modelName.BINGO_TABLE),		
						//"out_pan":_model.getValue("NoOne_bet"),
						//"in_pan":_model.getValue("SomeOne_bet"),
						//"total_openball": 	_model.getValue("openBalllist"),
						//"bingo_ball": 	_model.getValue("Curball" )
									   //};
									   //
			//history_recode.push(history_ob);
			//_model.putValue("history_opened_ball", history_recode);		
			
			
		}
		
		//"result_list": [{"bet_type": "5,5", "settle_amount": 9000, "odds": 90, "win_state": "WSBingo", "bet_amount": 100.0}]
		public function result_parse_win_table():Array
		{
			var result_list:Array = _model.getValue(modelName.ROUND_RESULT);						
			var history:Array = [];
			for (var i:int = 0; i < result_list.length; i++)
			{
				var betob:Object = result_list[i];
				var room_and_table:String = betob["bet_type"];
				var data:Array = room_and_table.split(",");
				history.push(data[1]);
			}			
			return history;
		}
		
		public function re_bet():void
		{			
			
			var bet_list:Array = _model.getValue("bet_history");
			
			for (var i:int = 0; i < bet_list.length; i++)
			{
				var tabNo:int  = bet_list[i];
				add_amount(new MouseEvent(MouseEvent.MOUSE_DOWN, true, false), tabNo);
			}
			
			
			
		}
		
		public function batch_rebet():void
		{
			var bet:Array = _model.getValue(modelName.SELF_BET);
			if ( bet.length == 0) return;
			
			
			var bet_list:Array = _Bet_info.getValue("self");
			utilFun.Log("batch_rebet = "+batch_rebet)
			for ( var i:int = 0; i < bet.length ; i++)
			{
				var bet_ob:Object = create_dir_ob(bet[i]["table_no"], bet[i]["total_bet_amount"]);
				bet_list.push(bet_ob);  
				_Bet_info.putValue("self", bet_list);
				
				utilFun.Log("put in = "+ bet_ob[Table]);
				_model.putValue("last_bet_idx", bet_ob[Table]);				
			}
			
			utilFun.Log("after batch_rebet = "+bet_list)
			
			dispatcher(new ModelEvent(WebSoketInternalMsg.BET_UPDATE));
		}
		
		private function create_dir_ob(BetType:int ,total_bet_amount:int):Object
		{
			var coin_list:Array  = _model.getValue("Bet_coin_List");
			var bet:Object;			
			bet = { "betType": BetType,			                           
									   "bet_idx":coin_list.indexOf(total_bet_amount),
									   "total_amount":total_bet_amount
									   };
			//utilFun.Log("=================== = "  );
			//utilFun.Log("BetType = " + BetType );
			//utilFun.Log("total_bet = " +total_bet_amount);
			//utilFun.Log("coin_list.indexOf(amount) = " +coin_list.indexOf(total_bet_amount));			
			//utilFun.Log("=================== = "  );
						
			 return bet;
		}
		
		public function get_bet_frame(table_no:int):int
		{
			var betstate:Array = _model.getValue("is_betarr");
			
			if ( betstate[table_no] == 0) return BetCommand.no_one_bet;
			
			var mybet:Array =  get_my_bet_info(BetCommand.Table);				
			if ( mybet.indexOf(table_no) == -1)  return BetCommand.someone_bet;
			else return BetCommand.self_bet;
			
			//TODO BetCommand.self_last_bet;			
		}
		
		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "clearn")]
		public function Clean_bet():void
		{			
			var bet_list:Array = _Bet_info.getValue("self");
			
			if ( bet_list.length == 0 ) return;			
		}
	}

}