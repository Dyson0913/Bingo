package ConnectModule.websocket 
{	
	import com.worlize.websocket.WebSocket
	import com.worlize.websocket.WebSocketEvent
	import com.worlize.websocket.WebSocketMessage
	import com.worlize.websocket.WebSocketErrorEvent
	import com.adobe.serialization.json.JSON	
	import Command.ViewCommand;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.system.Security;
	import Model.*;	
	
	
	import Model.valueObject.*;
		
	import View.GameView.CardType;
	
	import util.utilFun;	
	import ConnectModule.websocket.Message
	import View.GameView.gameState;

	
	/**
	 * socket 連線元件
	 * @author hhg4092
	 */
	public class WebSoketComponent 
	{
		[MessageDispatcher]
        public var dispatcher:Function;
		
		[Inject]
		public var _MsgModel:MsgQueue;		
		
		[Inject]
		public var _actionqueue:ActionQueue;
		
		[Inject]
		public var _model:Model;
		
		private var websocket:WebSocket;
	
		private var m_game_state:int = 0;
		
		public function WebSoketComponent() 
		{
			
		}
		
		[MessageHandler(type="ConnectModule.websocket.WebSoketInternalMsg",selector="connect")]
		public function Connect():void
		{
			//var object:Object = _model.getValue(modelName.LOGIN_INFO);						
				var uuid:String = _model.getValue(modelName.UUID);			
			utilFun.Log("uuid =" + uuid);
			websocket = new WebSocket("ws://" + _model.getValue(modelName.Domain_Name) +":8301/gamesocket/token/" + uuid, "");
			
			websocket.addEventListener(WebSocketEvent.OPEN, handleWebSocket);
			websocket.addEventListener(WebSocketEvent.CLOSED, handleWebSocket);
			websocket.addEventListener(WebSocketErrorEvent.CONNECTION_FAIL, handleConnectionFail);
			websocket.addEventListener(WebSocketEvent.MESSAGE, handleWebSocketMessage);
			websocket.connect();
		}
		
		private function handleWebSocket(event:WebSocketEvent):void 
		{			
			if ( event.type == WebSocketEvent.OPEN)
			{
				utilFun.Log("Connected open="+ event.type );
			}
			else if ( event.type == WebSocketEvent.CLOSED)
			{
				utilFun.Log("Connected close="+ event.type );
			}
		}
		
		private function handleConnectionFail(event:WebSocketErrorEvent):void 
		{
			utilFun.Log("Connected= fale"+ event.type);
		}
		
		
		private function handleWebSocketMessage(event:WebSocketEvent):void 
		{
			var result:Object ;
			
			if (event.message.type === WebSocketMessage.TYPE_UTF8) 
			{
				utilFun.Log("before"+event.message.utf8Data)
				result = JSON.decode(event.message.utf8Data);
				//utilFun.Log("after"+result)
			}
			
			_MsgModel.push(result);
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "popmsg")]
		public function msghandler():void
		{
			   var result:Object  = _MsgModel.getMsg();
			   
			   if (result.game_type != "Bingo") return;
			   
				switch(result.message_type)
				{
					case "MsgBGInitialInfo":
					{
						dispatcher(new ValueObject(  result.game_round, "game_round") );
						dispatcher(new ValueObject(  result.game_id, "game_id") );
						
						_model.putValue("SelectRoomInfo",result.room_info);
						dispatcher(new Intobject(modelName.lobby, ViewCommand.SWITCH) );
						
					}					
					break;
					
					case "MsgBGRoomInitialInfo":
					{
						//"game_state": "EndBetState"
						_model.putValue("room_num", result.room_no);
						dispatcher(new ValueObject(  result.game_round, "game_round") );
						dispatcher(new ValueObject(  result.remain_time, modelName.REMAIN_TIME) );														
								var state:int = 0;
								if (  result.game_state == "NewRoundState") state = gameState.NEW_ROUND;
								if (  result.game_state == "EndBetState") state = gameState.END_BET;
								if (  result.game_state == "OpenState") state = gameState.START_OPEN;
								if (  result.game_state == "EndRoundState") state = gameState.END_ROUND;
								//dispatcher(new ValueObject(  state, modelName.GAMES_STATE) );			
						
						//依狀態切換 bet view or openballview
						var arr_lat:Array = result.table_info;						
						var num:int= arr_lat.length;						
							//var is_bet:Array = _model.getValue("is_betarr");
							var balls:Array = _model.getValue("ballarr");
							var table_no:Array = _model.getValue("table");							
							for (var  i:int = 0; i < num ; i++)
							{	
								//TODO fake input
								//is_bet.push( 0);
								balls.push( arr_lat[i].ball_list);
								table_no.push( arr_lat[i].table_no);
							}					
							//_model.putValue("is_betarr",is_bet);
							_model.putValue("ballarr",balls);
							_model.putValue("table", table_no);													
							
							
							var arrlist:Array = result.table_bet_info;													
						var is_bet:Array = _model.getValue("is_betarr");
						is_bet.length = 0;
						is_bet = arrlist;												
						_model.putValue("is_betarr", arrlist);
							
							if ( state == gameState.END_BET ||  state == gameState.NEW_ROUND)
							{
								_model.putValue("chang_order",1);
								dispatcher(new Intobject(modelName.Bet, ViewCommand.SWITCH) );		
								//triger timer,
								dispatcher(new ModelEvent("display"));
							}
							else if ( state == gameState.START_OPEN ||  state == gameState.END_ROUND)
							{
								_model.putValue("chang_order", 0);
								
								 
								dispatcher(new Intobject(modelName.openball, ViewCommand.SWITCH) );	
								_model.putValue("openBalllist", result.open_info.opened_history);
								 dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.HALF_ENTER_UPDATE));
							}
								
					}
					break;
					
					case "MsgBGOpenBall":
					{
						if ( result.sub_state == "BingoSpecialOpenState")
						{
							//no ball notify
							if ( result.first_ball == undefined)
							{
								dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.SPECAIL_ROUND));
								break;
							}
							
							
							var arr:Array = [];
							if ( result.first_ball != "") arr.push( result.first_ball);
							if ( result.second_ball != "") arr.push( result.second_ball);
							
							dispatcher( new ValueObject(arr, modelName.SPCIAL_BALL));	
						   dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BALL_COMING));
							break;						   
						}
						
						_model.putValue("Curball", parseInt(result.open_info.current_ball) );						
						_model.putValue("waitting_ball",result.open_info.waitting_ball);
						var arr:Array = result.open_info.opened_history;
						_model.putValue("opened_ball_num", arr.length +1 );
						_model.putValue("openBalllist", arr);
						_model.putValue("best_remain", parseInt(result.open_info.best_remain) );
						_model.putValue("second_remain", parseInt(result.open_info.second_remain) );
							 
						_model.putValue("best_list", result.open_info.best_list );
						_model.putValue("second_list", result.open_info.second_list );						
						dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BALL_UPDATE));
					}
					
					break;
					
					case "MsgBPState": 
					{
						if (  result.game_state == "NewRoundState") state = gameState.NEW_ROUND;
						if (  result.game_state == "EndBetState") state = gameState.END_BET;
						
						//deprecated to MsgBGNewRound
						if ( state == gameState.NEW_ROUND)
						{							
							utilFun.Log("new rount go to betview");
							//dispatcher(new ValueObject(  result.game_round, "game_round") );
							dispatcher(new ValueObject(  result.remain_time, modelName.REMAIN_TIME) );		
							dispatcher(new Intobject(modelName.Bet, ViewCommand.SWITCH) );							
							dispatcher(new ModelEvent("display"));
						}
						if (  state == gameState.END_BET)
						{
							dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BET_STOP_HINT));
						}
					}
					break;
					
					case "MsgPlayerDecBet":
					case "MsgPlayerBet":
					{
						if (result.result == 0)
						{
							//押注結果
							dispatcher(new ValueObject( result.room_no, "bet_room_num") );
							dispatcher(new ValueObject(  result.result, "bet_result") );
							
							dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BETRESULT));
						}
						else
						{
							//error code
						}
					}
					break;
					
					case "MsgBGBetInfo":
					{
						var arrlist:Array = result.table_bet_info;													
						var is_bet:Array = _model.getValue("is_betarr");
						var num:int  = arrlist.length;						
						is_bet.length = 0;
						is_bet = arrlist;
						//for ( i = 0; i < num ; i++)
						//{							
							//is_bet.push(arrlist[i]);
							//utilFun.Log("item  ="+arrlist[i]);
							//
						//}	
						//utilFun.Log("push is_bet ="+is_bet);
						_model.putValue("is_betarr", is_bet);
						
						dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BET_STATE_UPDATE));
						
					}
					break;
					
					//case "MsgBGSpecialRound":
					//{
						//var arr:Array = [];
						//arr.push( result.special_info.first_ball);
						//arr.push( result.special_info.second_ball);
						//dispatcher( new ValueObject(arr, modelName.SPCIAL_BALL));	
						//
						//dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.SPECAIL_ROUND));
						//utilFun.Log("send spcical =====================================");
					//}
					//break;
					
					case "MsgBPEndRound":
					{
						dispatcher( new ValueObject(result.result_list, modelName.ROUND_RESULT));
						dispatcher( new ValueObject(result.bingo_result, modelName.BINGO_TABLE));						
						
						dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.WIN_HINT));
						
					}
					break;
					
					case "MsgBGNewRound":
					{
						//new betinfo
						var arrlist:Array = result.table_bet_info;													
						var is_bet:Array = _model.getValue("is_betarr");
						var num:int  = arrlist.length;						
						is_bet.length = 0;
						is_bet = arrlist;
						_model.putValue("is_betarr", is_bet);
						
						//self betlist
						//[{"table_no":5,"total_bet_amount":200},{"table_no":7, "total_bet_amount":500}]
						dispatcher( new ValueObject(result.bet_list, modelName.SELF_BET));
						
						dispatcher(new ValueObject(  result.game_round, "game_round") );
						utilFun.Log("new rount go to betview");
						dispatcher(new ValueObject(  result.remain_time, modelName.REMAIN_TIME) );		
						dispatcher(new Intobject(modelName.Bet, ViewCommand.SWITCH) );		
						//triger timer,
						dispatcher(new ModelEvent("display"));
												
						//dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BET_STATE_UPDATE));
						
					}	
					break;
					
					case "MsgBGNewRound":
					{
						var arrlist:Array = result.table_bet_info;													
						var is_bet:Array = _model.getValue("is_betarr");
						var num:int  = arrlist.length;						
						is_bet.length = 0;
						is_bet = arrlist;					
						_model.putValue("is_betarr", is_bet);
						
						dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BET_STATE_UPDATE));
					}
					break;
				}
		}
		
		[MessageHandler(type="ConnectModule.websocket.WebSoketInternalMsg",selector="chooseRoom")]
		public function enterRoom():void
		{
			_model.getValue("room_num");
			var entermsg:Object = {  "id": String(_model.getValue(modelName.UUID)),
			                              "timestamp":1111,
											"message_type":"MsgBGPlayerEnterRoom", 
			                               "game_id":_model.getValue("game_id"),
										   "game_type":"Bingo",										
										   "game_round":_model.getValue("game_round"),							
											"room_no":_model.getValue("room_num")
											};
										   
			SendMsg(entermsg);
		}
		
		
		[MessageHandler(type="ConnectModule.websocket.WebSoketInternalMsg",selector="Bet")]
		public function SendBet():void
		{
			var ob:Object = _actionqueue.getMsg();
			var total:Number = parseInt (ob["total_amount"]);
			var bet:Object = {  "id": String(_model.getValue(modelName.UUID)),
			                                "timestamp":1111,
											"message_type":"MsgPlayerBet", 
			                               "game_id":_model.getValue("game_id"),
										   "game_type":"Bingo",										
										   "game_round":_model.getValue("game_round"),
											"room_no":_model.getValue("room_num"),
											"table_no":  ob["betType"],
										    "bet_amount":ob["bet_amount"],
											"total_bet_amount":total
											};
											
			SendMsg(bet);
		}
		
		[MessageHandler(type="ConnectModule.websocket.WebSoketInternalMsg",selector="Bet_nosign")]
		public function SendBet_no_sign():void
		{
			var ob:Object = _actionqueue.getMsg();
			var total:Number = parseInt (ob["total_amount"]);
			var bet:Object = {  "id": String(_model.getValue(modelName.UUID)),
			                                "timestamp":1111,
											"message_type":"MsgPlayerDecBet", 
			                               "game_id":_model.getValue("game_id"),
										   "game_type":"Bingo",										
										   "game_round":_model.getValue("game_round"),
											"room_no":_model.getValue("room_num"),
											"table_no":  ob["betType"],
										    "dec_amount":ob["bet_amount"],
											"total_bet_amount":total
											};											
											
			SendMsg(bet);
		}
		
		public function SendMsg(msg:Object):void 
		{
			var jsonString:String = JSON.encode(msg);
			utilFun.Log("jsonString "+ jsonString);
			websocket.sendUTF(jsonString);
		}
		
	}
}