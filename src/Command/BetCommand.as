package Command 
{
	import ConnectModule.websocket.WebSoketInternalMsg;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLVariables;
	import Model.*;
	import util.DI;
	import util.utilFun;
	import View.GameView.*;
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
		
		public var _Bet_info:DI = new DI();
		
		public static var Table:String = "betType";
		public static var Bet_idx:String = "bet_idx";
		public static var TotalBet:String = "total_amount";
		
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
			return bet(e, table);
		}
		
		public function add_amount(e:Event, table:int):Boolean
		{			
			var find_idx:int = Find_Bet_type_idx(table);
			
			if ( find_idx != -1)
			{
				var bet_list:Array = _Bet_info.getValue("self");
				
				//over bet limit
				var coin_list:Array  = _model.getValue("Bet_coin_List");
				if ( bet_list[find_idx][Bet_idx] +1 >= coin_list.length) return false
				
				bet_list[find_idx][Bet_idx] += 1;				
				_Bet_info.putValue("self", bet_list);
			}
			
			return bet(e, table);
			
		}
		
		public function bet(e:Event, betType:int):Boolean
		{
			var betob:Object = betOb(betType);
			
			//return true;
			dispatcher( new ActionEvent(betob, "bet_action"));
			
			if ( CONFIG::debug ) 
			{
				//fake bet proccess
				dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BETRESULT));
			}
			else
			{
				dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BET));
			}
			
			return true;
		}
		
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
			var bet_list:Array = _Bet_info.getValue("self");			
			for ( var i:int = 0; i < bet_list.length ; i++)
			{
				var bet:Object = bet_list[i];			
				bet["bet_amount"] = 0;				
				dispatcher( new ActionEvent(bet, "bet_action"));			
			}		
			
			dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BET));
			return true;
		}
		
		public function empty_reaction(e:Event, idx:int):Boolean
		{
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
					is_sub = true;
				}
			}
			
			if ( !is_sub) 
			{
					utilFun.Log("del last_bet_idx = "+ bet_ob[Table]);
				_model.putValue("last_bet_idx", bet_ob[Table]);
			}
			else
			{
			    //退注 把last idx預設	下注最後一筆
				var lastTable:int = bet_list[bet_list.length - 1][Table];
				utilFun.Log("lastTable = "+lastTable);
				
				_model.putValue("last_bet_idx", lastTable);
			}
			
			_Bet_info.putValue("self", bet_list);
			
			dispatcher(new ModelEvent(WebSoketInternalMsg.BET_UPDATE));
			
			utilFun.SetTime(simulat_upate, 0.1);
			
			
			
		}
		
		public function simulat_upate():void
		{
			utilFun.Log("simulat_upate ");
				if ( CONFIG::debug ) 
			{
				var bet_ob:Object = _Actionmodel.excutionMsg();
				var is_bet:Array = _model.getValue("is_betarr");
				var num:int  = is_bet.length;						
				is_bet.splice(bet_ob["betType"], 0, 1);
				
				utilFun.Log("fake push is_bet ="+is_bet);
				_model.putValue("is_betarr", is_bet);						
				
				dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BET_STATE_UPDATE));
				utilFun.Log("send info =");
			}	
			
			//TODO test need to move to here 
			_Actionmodel.dropMsg();
			if ( _Actionmodel.length() != 0) 
			{
				utilFun.Log("dropMsg ");
				dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BET));
			}
				
			
		}
		
		public function get_my_betlist():Array
		{		
			 _Bet_info.getValue("self")
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
		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "clearn")]
		public function Clean_bet():void
		{			
			var bet_list:Array = _Bet_info.getValue("self");
			
			if ( bet_list.length == 0 ) return;
		}
	}

}