package Command 
{
	import ConnectModule.websocket.WebSoketInternalMsg;
	import flash.events.Event;
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
			_model.putValue(modelName.BET_ZONE,betzone);
			
			//_model.putValue("coin_list", [100, 500, 1000, 5000, 10000]);
			_model.putValue("Bet_coin_List", [0, 100, 200, 300, 500, 1000]);
			_model.putValue("after_bet_credit", 0);
			_Bet_info.putValue("self", [] ) ;
		}
		
		public function betTypeMain(e:Event,idx:int):Boolean
		{			
			utilFun.Log("idx ="+idx);	
			
			if ( _Actionmodel.length() > 0) return false;
					
			//var bet_recode:Array = _Bet_info.getValue("self");			
			//if (bet_recode.length+1 > 12) 
			//{					
				//dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BET_FULL_HINT));
				//return false;
			//}
			//
			//
			
			//押注金額判定
			//if ( all_betzone_totoal() + _opration.array_idx("coin_list", "coin_selectIdx") > _model.getValue(modelName.CREDIT))
			//{
				//dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.NO_CREDIT));
				//return false;
			//}
			
			//TODO 太多筆 handel
			var coin_list:Array  = _model.getValue("Bet_coin_List");
			
			var bet:Object;
			var amount:int = get_amount(idx);
			utilFun.Log("amount = " + amount);
			utilFun.Log("coin_list.indexOf(amount) = " + coin_list.indexOf(amount));
			utilFun.Log("all_betzone_totoal() = " + all_betzone_totoal());
			
			bet = { "betType": idx, 											
			                           "bet_amount":  amount,		
									   "bet_idx":coin_list.indexOf(amount),
									   "total_amount":all_betzone_totoal()
									   };
			
			
			dispatcher( new ActionEvent(bet, "bet_action"));
			dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BET));
			
			return true;
		}		
		
		public function betbyTable(e:Event, idx:int):Boolean
		{			
			return add_bet(e, idx);
			return true;
		}
		
		public function betbyidx_add(e:Event, idx:int):Boolean
		{
			var bet_list:Array = _Bet_info.getValue("self");
			// table no  to bet_list idx 
			var tableNo :int = -1;
			
			if ( idx >= bet_list.length )
			{
			    //over idx
				utilFun.Log("over idx = ");
				return false
			}			
			
			var bet:Object = bet_list[idx];
			tableNo = bet["betType"];
			
			add_bet(e, tableNo);
			return true;
		}
		
		public function betbyidx_sub(e:Event, idx:int):Boolean
		{
			var bet_list:Array = _Bet_info.getValue("self");
			// table no  to bet_list idx 
			var tableNo :int = -1;
			
			var bet_list:Array = _Bet_info.getValue("self");
			if ( idx >= bet_list.length )
			{
				//over idx
				utilFun.Log("over idx = ");
				return false
			}
			
			var bet:Object = bet_list[idx];
			tableNo = bet["betType"];
			utilFun.Log("bus table no = "+ tableNo);
			sub_bet(e, tableNo);
			return true;
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
		
		public function check(e:Event, tableNo:int):Boolean
		{
			var bet_list:Array = _Bet_info.getValue("self");
			// table no  to bet_list idx 
			var list_idx:int = -1;
			for (var i:int = 0; i <  bet_list.length ; i++)
			{
				var bet:Object = bet_list[i];
				if ( bet["betType"] == tableNo )
				{
					list_idx = i;
					break;
				}
			}
			
			if ( list_idx == -1)
			{
				if (bet_list.length+1 > 12) 
				{					
					dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BET_FULL_HINT));
					return false;
				}
			}
			return true;
		}
		
		
		public function bet_local(e:Event,idx:int):Boolean
		{						
			utilFun.Log("idx ="+idx);			
			
			//TODO 太多筆 handel
			var coin_list:Array  = _model.getValue("Bet_coin_List");
			
			var bet:Object;
			var amount:int = get_amount(idx);
			bet = { "betType": idx, 											
			                           "bet_amount":  amount,		
									   "bet_idx":coin_list.indexOf(amount)						   
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
		
		public function test_bet(betob:Object):void
		{
			if ( _Bet_info.getValue("self") == null)
			{
				_Bet_info.putValue("self", [betob]);			
			}
			else {
				var bet_list:Array = _Bet_info.getValue("self");
					bet_list.push(betob);  
			_Bet_info.putValue("self",bet_list);		
			}
			
		}
		
		public function get_amount(tableNo:int ):int
		{
			var betlist:Array =  _model.getValue("Bet_coin_List");	
			//if ( _Bet_info.getValue("self") == null) return betlist[1];
			
			var bet_recode:Array = _Bet_info.getValue("self");			
			for ( var i:int = 0; i < bet_recode.length ; i++)
			{
				var bet:Object = bet_recode[i];
					
				if ( bet["betType"] == tableNo) return bet["bet_amount"] ;				
			}
			
			return betlist[1];
		}
		
		[MessageHandler(type = "ConnectModule.websocket.WebSoketInternalMsg", selector = "Betresult")]
		public function accept_bet():void
		{
			var bet_result:int = _model.getValue("bet_result");		
			
			var bet_ob:Object = _Actionmodel.excutionMsg();
			
//			dispatcher(new ValueObject( result.room_no, "bet_room_num") );
			
			if ( _Bet_info.getValue("self") == null)
			{
				_Bet_info.putValue("self", [bet_ob]);			
			}
			else
			{
				var bet_list:Array = _Bet_info.getValue("self");
                    //己經put,不用再push
                    var nofind:Boolean = true;
					var subrecode:Boolean = false;
					var indx:int = -1;
                    for (var i:int = 0; i < bet_list.length; i++)
                    {
                        var bet:Object = bet_list[i];
                         if ( bet["betType"] == bet_ob["betType"] )
                         {
							if (  bet_list[i]["bet_amount"] != 0 )
							{
								bet_list[i]["bet_amount"] = bet_ob["bet_amount"]
								bet_list[i]["bet_idx"] = bet_ob["bet_idx"]
							}
							else 
							{
								subrecode = true;
								indx = i;
							}
                            nofind = false;
                            break;
                         }
                        
                    }
					
					utilFun.Log("subrecode ="+subrecode);
					utilFun.Log("nofind ="+nofind);
					if ( !subrecode)
					{
						if (nofind)
						{							
							bet_list.push(bet_ob);  
							_Bet_info.putValue("self", bet_list);
						}
					}
					else
					{						
						utilFun.Log("del ="+indx);
						bet_list.splice(indx, 1);	
						//_Bet_info.putValue("self", bet_list);
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
		
		public function get_my_bet_info(type:String):Array
		{
			var arr:Array = _Bet_info.getValue("self");			
			var data:Array = [];
			
			for ( var i:int = 0; i < arr.length ; i++)
			{
				var bet_ob:Object = arr[i];
				if ( type == "table") data.push(bet_ob["betType"]);
				if ( type == "amount") data.push(bet_ob["bet_amount"]);								
			}
			return data;
		}
	
		
		private function self_show_credit():void
		{
			var total:Number = get_total_bet(-1);
			
			var credit:int = _model.getValue(modelName.CREDIT);
			_model.putValue("after_bet_credit", credit - total);
			
			dispatcher(new ModelEvent(WebSoketInternalMsg.BET_UPDATE));
			
			_Actionmodel.dropMsg();
			if ( _Actionmodel.length() != 0) dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BET));
		}
		
		private function all_betzone_totoal():Number
		{
			var betzone:Array = get_my_bet_info("table");//_model.getValue(modelName.BET_ZONE);
			
			var total:Number = 0;
			for each (var i:int in betzone)
			{
				total +=get_total_bet(i);
			}
			return total;
		}
		
		
		private function get_total_bet(type:int):Number
		{
			//if ( _Bet_info.getValue("self") == null) return 0;
			//
			var total:Number = 0;
			var bet_list:Array = _Bet_info.getValue("self");
			for (var i:int = 0; i < bet_list.length; i++)
			{
				var bet:Object = bet_list[i];				
				total += bet["bet_amount"];				
			}
			
			return total;
		}		
		
		public function add_bet(e:Event,tableNo:int):Boolean
		{
			var bet_list:Array = _Bet_info.getValue("self");
			// table no  to bet_list idx 
			var list_idx:int = -1;
			for (var i:int = 0; i <  bet_list.length ; i++)
			{
				var bet:Object = bet_list[i];
				if ( bet["betType"] == tableNo )
				{
					list_idx = i;
					break;
				}
			}
			
			//utilFun.Log("add_bet  list _idx = "+list_idx);
			//first bet TODO judge -1 = first or empty click
			if ( list_idx == -1)
			{
				//betTypeMain(e,tableNo);
				if (bet_list.length+1 > 12) 
				{					
					dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BET_FULL_HINT));
					return false;
				}
			}
			else
			{
				var total:Number = 0;				
				
				var bet:Object = bet_list[list_idx];							
				var betlist:Array =  _model.getValue("Bet_coin_List");	
				
				if ( (bet_list[list_idx]["bet_idx"] +1) > betlist.length-1 ) 
				{
					utilFun.Log("over bet list = ");
					return true;
				}
				
				bet["bet_idx"]++;
				bet_list[list_idx]["bet_amount"] = betlist[bet["bet_idx"]];
				_Bet_info.putValue("self",bet_list);	
				
			}
			
			betTypeMain(e,tableNo);			
			
			return true;
		}
		
		public function sub_bet(e:Event,TableNo:int):Boolean
		{
			var bet_list:Array = _Bet_info.getValue("self");
			
			// table no  to bet_list idx 
			var list_idx:int = -1;
			for (var i:int = 0; i <  bet_list.length ; i++)
			{
				var bet:Object = bet_list[i];
				if ( bet["betType"] == TableNo )
				{
					list_idx = i;
					break;
				}
			}
			
			var coin_list:Array =  _model.getValue("Bet_coin_List");
			var total:Number = 0;			
			var bet:Object = bet_list[list_idx];
			
			if ( (bet_list[list_idx]["bet_idx"] -1) == 0 ) 
			{		
				bet["bet_amount"] = 0;
				dispatcher( new ActionEvent(bet, "bet_action"));
				dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BET));				
				return false;
			}
			else
			{
				bet["bet_idx"] -= 1;
				bet_list[list_idx]["bet_amount"] = coin_list[bet["bet_idx"]];
				_Bet_info.putValue("self",bet_list);
				betTypeMain(e, TableNo);
			}
			
			
			return true;
		}
			
		
		[MessageHandler(type = "Model.ModelEvent", selector = "clearn")]
		public function Clean_bet():void
		{			
			if ( _model.getValue("_bet_info") == null) 
			{
				_Bet_info.clean();
			}
			else
			{
				var coin_list:Array  = _model.getValue("Bet_coin_List");
				var betinfo:Array = _model.getValue("_bet_info");
				for (var i:int = 0; i < betinfo.length; i++)
				{
					var bet:Object = betinfo[i];
					var amount:int = get_amount(bet["table_no"]);
					bet = { "betType": bet["table_no"], 											
							   "bet_amount":  amount,		
							   "bet_idx":coin_list.indexOf(amount)
						   };
						   
					if ( _Bet_info.getValue("self") == null) _Bet_info.putValue("self", [bet]);		
					else
					{
						var bet_list:Array = _Bet_info.getValue("self");
						bet_list.push(bet);  
						_Bet_info.putValue("self", bet_list);
						
					}
				}			
			}
			
			
		}
	}

}