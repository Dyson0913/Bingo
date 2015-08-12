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
			Clean_bet();					
		}
		
		public function bet_init():void
		{
			_model.putValue("coin_selectIdx", 0);
			
			//_model.putValue("coin_list", [100, 500, 1000, 5000, 10000]);
			_model.putValue("Bet_coin_List", [0, 100, 200, 300, 500, 1000]);
			_model.putValue("after_bet_credit", 0);
		}
		
		public function betTypeMain(e:Event,idx:int):Boolean
		{			
			utilFun.Log("idx ="+idx);	
			
			if ( _Actionmodel.length() > 0) return false;
			
			if ( _Bet_info.getValue("self") != null)
			{
				var bet_recode:Array = _Bet_info.getValue("self");			
				if (bet_recode.length+1 > 12) 
				{					
					dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BET_FULL_HINT));
					return false;
				}
				
			}
			
			
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
			bet = { "betType": idx, 											
			                           "bet_amount":  amount,		
									   "bet_idx":coin_list.indexOf(amount)
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
			if ( _Bet_info.getValue("self") == null) return betlist[1];
			
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
			if ( !bet_result) 
			{
				//TODO bet faile
				return;
			}
			
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
			//TODO check null
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
			
			dispatcher(new ModelEvent("bet_list_update"));
			
			_Actionmodel.dropMsg();
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
		
		public function get_Bet_type():Array
		{
			if ( _Bet_info.getValue("self") == null) return [];
			
			var bet_list:Array = _Bet_info.getValue("self");
			var table:Array = [];
			for (var i:int = 0; i < bet_list.length; i++)
			{
				var bet:Object = bet_list[i];
				table.push( bet["betType"] );		
			}			
			return table;
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
			
			if ( (bet_list[idx]["bet_idx"] +1) > betlist.length-1 ) 
			{
				utilFun.Log("over bet list = ");
				return false
			}
			
			bet["bet_idx"]++;
			bet_list[idx]["bet_amount"] = betlist[bet["bet_idx"]];
			_Bet_info.putValue("self",bet_list);	
				
			betTypeMain(e, bet["betType"]);
			
			return true;
		}
		
		public function sub_bet(e:Event,idx:int):Boolean
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
			if ( (bet_list[idx]["bet_idx"] -1) == 0 ) 
			{		
				bet["bet_amount"] = 0;
				dispatcher( new ActionEvent(bet, "bet_action"));
				dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BET));				
				return false;
			}
			else
			{
				bet["bet_idx"] -= 1;
				bet_list[idx]["bet_amount"] = betlist[bet["bet_idx"]];
				_Bet_info.putValue("self",bet_list);
				betTypeMain(e, bet["betType"]);
			}
			
			
			return true;
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "clearn")]
		public function Clean_bet():void
		{
			_Bet_info.clean();
		}
	}

}