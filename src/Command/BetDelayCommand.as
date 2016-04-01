package Command 
{
	import com.adobe.serialization.json.JSON;
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
	import com.laiyonghao.Uuid;
	/**
	 * (加、減分)延遲送單流程
	 * @author david
	 */
	public class BetDelayCommand 
	{
		[MessageDispatcher]
        public var dispatcher:Function;
		
		[Inject]
		public var _model:Model;

		[Inject]
		public var _socket:WebSoketComponent;
		
		[Inject]
		public var _betCommnad:BetCommand;
		
		private var _uuid_queue:DI;
		private var _confirm_queue:DI;
		
		
		public function BetDelayCommand() 
		{
			
		}
		
		public function init():void
		{
			_uuid_queue = new DI();
			_confirm_queue = new DI();
			
			//初始盤的資料0~99
			for (var i:int = 0; i < 100;  i++) {
				var bet_ob:Object = new Object();
				bet_ob["bet_amount"] = 0;
				bet_ob["bet_idx"] = 0;
				bet_ob["betType"] = i;
				bet_ob["total_amount"] = 0;
				_confirm_queue.putValue(i, bet_ob);
			}
		}
		
		public function setSelfBet(bet_list:Array):void {
			init();
			
			for each (var bet_ob_view:Object in bet_list) {
				var bet_ob:Object = _confirm_queue.getValue(bet_ob_view[ "table_no"]);
				bet_ob["total_amount"] = bet_ob_view["total_bet_amount"];
				_confirm_queue.putValue(bet_ob_view[ "table_no"], bet_ob);
			}
		}
		
		public function newDelayTask(bet_ob_view:Object):void {

			var table:int = bet_ob_view["betType"];
			var bet_ob:Object = _confirm_queue.getValue(table);
			
			//買、退盤
			if (bet_ob["total_amount"] == 0 || bet_ob_view["total_amount"] == 0) {
				
				//送單
				sendBet(bet_ob, bet_ob_view);
				
			}
			//加、減分
			else if (bet_ob_view["total_amount"] > 0) {
				
				//啟動計時器
				dispatcher(new ModelEvent("timerStart", table));
				
			}else {
				utilFun.Log("wrong newDelayTask logic");
			}
			
		}
		
		//計時器call back(加減分延遲送單)
		public function sendDelayBet(table:int):void {
			
			var bet_ob:Object = _confirm_queue.getValue(table);
			var view_idx:int = _betCommnad.Find_Bet_type_idx(table);
			
			//有可能倒數結束前盤被退掉，找不到了
			if (view_idx > -1) {
				
				var bet_ob_view:Object = _betCommnad._Bet_info.getValue("self")[view_idx];
				
				if (bet_ob_view["total_amount"] > 0 && (bet_ob["total_bet_amount"] !=  bet_ob_view["total_amount"]) ) {
					//送單
					sendBet(bet_ob, bet_ob_view);
				}
			}
		}
		
		//送單
		private function sendBet(bet_ob:Object, bet_ob_view:Object):void {
			var uuid:Uuid = new Uuid();
			registerUUID(uuid.toString(), bet_ob_view);
			var betMsg:Object = createBetMsg(bet_ob, bet_ob_view, uuid.toString());	
			if ( CONFIG::debug ) {
						//本機測試
						//betSucessHandler(uuid.toString());
						_socket.SendMsg(betMsg);
				}else {
						_socket.SendMsg(betMsg);
				}
		}
		
		private function createBetMsg(bet_ob:Object, bet_ob_view:Object, uuid:String):Object {

			var bet_amount:int = Math.abs(bet_ob["total_amount"] - bet_ob_view["total_amount"]);
			var bet:Object = null;
			var total:Number = parseInt (bet_ob_view["total_amount"]);
			
			if (bet_ob_view["total_amount"] > bet_ob["total_amount"]) {
				
									bet = { 
												"timestamp":1111,
												"message_type":"MsgPlayerBet", 
											   "game_id":_model.getValue("game_id"),
											   "game_type":_model.getValue(modelName.Game_Name),										
											   "game_round":_model.getValue("game_round"),
												"room_no":_model.getValue("room_num"),
												"table_no":  bet_ob_view["betType"],
												"bet_amount":bet_amount,
												"total_bet_amount":total,
												"id":uuid
												};				
												
			}else {
				
									bet = {  
												"timestamp":1111,
												"message_type":"MsgPlayerDecBet", 
											   "game_id":_model.getValue("game_id"),
											   "game_type":_model.getValue(modelName.Game_Name),										
											   "game_round":_model.getValue("game_round"),
												"room_no":_model.getValue("room_num"),
												"table_no":  bet_ob_view["betType"],
												"dec_amount":bet_amount,
												"total_bet_amount":total,
												"id":uuid
												};			
												
			}
			
			//var jsonString:String = JSON.encode(bet);
			//utilFun.Log("jsonString "+ jsonString);
			return 	bet;							
		}
		
		//等待回復的注單區
		private function registerUUID(uuid:String, bet_ob:Object):void {
			_uuid_queue.putValue(uuid, bet_ob);
		}
		
		//下注成功的注單更新至confirm_queue
		public function betSucessHandler(uuid:String):void {
			var bet_ob:Object = _uuid_queue.getValue(uuid);
			_confirm_queue.putValue(bet_ob["betType"], bet_ob);
			_uuid_queue.Del(uuid);
			
			if (_uuid_queue.length() == 0) {
				dispatcher(new ModelEvent("openCancelBet"));
			}else {
				//當有注單未回覆，disable取消所有下注鈕
				dispatcher(new ModelEvent("closeCancelBet"));
			}
			
		}
		
		//下注失敗處理
		public function betFailHandler(uuid:String):void {
			utilFun.Log("into betFailHandler id" + uuid);
			var bet_ob_f:Object = _uuid_queue.getValue(uuid);
			var table:int = bet_ob_f["betType"];
			var bet_ob:Object = _confirm_queue.getValue(table);
			
			
			var view_betlist:Array = _betCommnad._Bet_info.getValue("self");
			
			//view還原成上次下注成功的狀態
			if (bet_ob["total_amount"] == 0) {
				
				//買盤失敗
				var view_idx:int = _betCommnad.Find_Bet_type_idx(table);
				view_betlist.splice(view_idx, 1);
				
				dispatcher(new ModelEvent(WebSoketInternalMsg.NO_CREDIT));
				
			}else if (bet_ob_f["total_amount"] == 0) {
				
				//退盤失敗
				view_betlist[view_betlist.length] = bet_ob;
				
			}else if (bet_ob_f["total_amount"] > 0) {
				
				//加、減分失敗
				var view_idx:int = _betCommnad.Find_Bet_type_idx(table);
				view_betlist[view_idx] = bet_ob;
				
			}else {
				utilFun.Log("wrong betFailHandler logic");
			}
			
			 _uuid_queue.Del(uuid);
			
			dispatcher(new ModelEvent(WebSoketInternalMsg.BET_UPDATE));
			
			if (_uuid_queue.length() == 0) {
				dispatcher(new ModelEvent("openCancelBet"));
			}else {
				//當有注單未回覆，disable取消所有下注鈕
				dispatcher(new ModelEvent("closeCancelBet"));
			}
		}
		
	}

}