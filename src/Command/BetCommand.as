package Command 
{
	import ConnectModule.websocket.WebSoketInternalMsg;
	import flash.events.Event;
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
		
		public function BetCommand() 
		{
			Clean_bet();					
		}
		
		public function bet_init():void
		{
			_model.putValue("coin_selectIdx", 0);
			_model.putValue("coin_list", [100, 500, 1000, 5000, 10000]);
			_model.putValue("Bet_coin_List",[0,100, 200, 300, 500, 1000]);			
			_model.putValue("after_bet_credit", 0);
		}
		
		public function betTypeMain(e:Event,idx:int):Boolean
		{			
			idx += 1;
			
			if ( _Actionmodel.length() > 0) return false;
			
			//押注金額判定
			if ( all_betzone_totoal() + _opration.array_idx("coin_list", "coin_selectIdx") > _model.getValue(modelName.CREDIT))
			{
				dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.NO_CREDIT));
				return false;
			}
			
			var bet:Object = { "betType": idx, 			                               
			                               "bet_amount":  get_amount(idx)
										};
			
			
			dispatcher( new ActionEvent(bet, "bet_action"));
			dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BET));
			
			return true;
		}		
		
		
		
		public function empty_reaction(e:Event, idx:int):Boolean
		{
			return true;
		}
		
		public function bet_local(e:Event,idx:int):Boolean
		{						
			utilFun.Log("idx ="+idx);			
			
			//TODO 太多筆
			
			//add 
			var coin_list:Array  = _model.getValue("Bet_coin_List");
			var bet:Object = { "betType": idx, 											
			                               "bet_amount":  get_amount(idx),		
										   "bet_idx":coin_list.indexOf(get_amount(idx))
										   };		
										  		
			
			//var bet_list:Array =  _model.getValue("Bet_recode_List");
			//for (var i:int = 0; i < bet_list.length; i++)
			//{
				//var bet:Object = bet_list[i];
				//
				//utilFun.Log("bet_info  = "+bet["betType"] +" amount ="+ bet["bet_amount"]);
			//}
			//return true;
			dispatcher( new ActionEvent(bet, "bet_action"));
			
			//fake bet proccess
			dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BETRESULT));
			//dispatcher(new ModelEvent("updateCoin"));
			
			return true;
		}		
		
		
		public function get_amount(tableNo:int ):int
		{
			var bet_recode:Array = _model.getValue("Bet_recode_List");
			if ( bet_recode)
			{
				for ( var i:int = 0; i < bet_recode.length ; i++)
				{
					var bet:Object = bet_recode[i];
					
					if ( bet["betType"] == tableNo) return bet["bet_amount"] ;				
				}
			}
			
			var betlist:Array =  _model.getValue("Bet_coin_List");	
			return betlist[1];
		}
		
		[MessageHandler(type = "ConnectModule.websocket.WebSoketInternalMsg", selector = "Betresult")]
		public function accept_bet():void
		{
			var bet_ob:Object = _Actionmodel.excutionMsg();
			
//			dispatcher(new ValueObject( result.room_no, "bet_room_num") );
//						dispatcher(new ValueObject(  result.result, "bet_result") );
			
			if ( _Bet_info.getValue("self") == null)
			{
				_Bet_info.putValue("self", [bet_ob]);			
			}
			else
			{
				var bet_list:Array = _Bet_info.getValue("self");
                    //己經put,不用再push
                    var nofind:Boolean = true;
                    for (var i:int = 0; i < bet_list.length; i++)
                    {
                         var bet:Object = bet_list[i];
                         if ( bet["betType"] == bet_ob["betType"] )
                         {
							  utilFun.Log("find  = ");
                               bet_list[i]["bet_amount"] = bet_ob["bet_amount"]
                               bet_list[i]["bet_idx"] = bet_ob["bet_idx"]
							  
                              nofind = false;
							  
							  utilFun.Log("accept_bet[i] betidx = "+bet_list[i]["bet_idx"]);
							utilFun.Log("accept_bet[i] amount = "+   bet_list[i]["bet_amount"]  );			
							utilFun.Log("accept_bet[i] type = "+bet_list[i]["bet_idx"] );		
                              break;
                         }
                        
                    }
                    if (nofind)
					{
						bet_list.push(bet_ob);  
						_Bet_info.putValue("self", bet_list);
					}
					
						
				
			}
			self_show_credit()
			//var bet_list:Array = _Bet_info.getValue("self");
			//for (var i:int = 0; i < bet_list.length; i++)
			//{
				//var bet:Object = bet_list[i];
				//
				//utilFun.Log("bet_info  = "+bet["betType"] +" amount ="+ bet["bet_amount"]);
			//}
		}
		
		public function get_my_betlist():Array
		{
			return _Bet_info.getValue("self");		
		}
		
		private function self_show_credit():void
		{
			var total:Number = get_total_bet(-1);
			
			var credit:int = _model.getValue(modelName.CREDIT);
			_model.putValue("after_bet_credit", credit - total);
			
			dispatcher(new ModelEvent("bet_list_update"));
		}
		
		private function all_betzone_totoal():Number
		{
			var betzone:Array = _model.getValue(modelName.BET_ZONE);
			
			var total:Number = 0;
			for each (var i:int in betzone)
			{
				total +=get_total_bet(i);
			}
			return total;
		}
		
		
		private function get_total_bet(type:int):Number
		{
			if ( _Bet_info.getValue("self") == null) return 0;
			
			var total:Number = 0;
			var bet_list:Array = _Bet_info.getValue("self");
			for (var i:int = 0; i < bet_list.length; i++)
			{
				var bet:Object = bet_list[i];				
				total += bet["bet_amount"];				
			}
			
			return total;
		}
		
		public function has_Bet_type(type:int):Boolean
		{
			var bet_list:Array = _Bet_info.getValue("self");
			for (var i:int = 0; i < bet_list.length; i++)
			{
				var bet:Object = bet_list[i];
				if ( bet["betType"] == type) return true;				
			}			
			return false;
		}
		
		public function Bet_type_betlist(type:int):Array
		{
			var bet_list:Array = _Bet_info.getValue("self");
			var arr:Array = [];
			for (var i:int = 0; i < bet_list.length; i++)
			{
				var bet:Object = bet_list[i];
				if ( bet["betType"] == type)
				{
					arr.push( bet["bet_amount"]);
				}
			}			
			return arr;
		}
		
		public function add_bet(e:Event,idx:int):Boolean
		{			
			if ( _Bet_info.getValue("self") == null) 
			{
				utilFun.Log("return null = ");
				return false;
			}
			
			
			var total:Number = 0;
			var bet_list:Array = _Bet_info.getValue("self");
			if ( idx >= bet_list.length )
			{
				//over idx
					utilFun.Log("over idx = ");
				return false
			}			
			
			var bet:Object = bet_list[idx];							
			var betlist:Array =  _model.getValue("Bet_coin_List");	
			bet["bet_idx"]++
			if ( bet["bet_idx"] > betlist.length-1 ) 
			{
				utilFun.Log("over bet list = ");
				return false
			}
			
			bet["bet_amount"] = betlist[bet["bet_idx"]];
			
			
			utilFun.Log("add_bet[i] bet idx = "+bet["bet_idx"]);
			utilFun.Log("add_bet[i] amount = "+bet["bet_amount"] );			
			utilFun.Log("add_bet[i] type = "+bet["betType"] );			
				
			bet_local(e, bet["betType"]);
			
			return true;
		}
				
								
		public function sub_bet(e:Event,idx:int):void
		{
			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "clearn")]
		public function Clean_bet():void
		{
			_Bet_info.clean();
		}
	}

}