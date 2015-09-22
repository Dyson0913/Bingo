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
			//var file:file = File.desktopDirectory.resolvePath("MyTextFile.txt");
//var stream:FileStream = new FileStream();
//stream.open(file, FileMode.WRITE);
//stream.writeUTFBytes("This is my text file.");
//stream.close();

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
							for ( i = 0; i < num ; i++)
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
						_model.putValue("Curball", parseInt(result.open_info.current_ball) );
							
						var arr:Array = result.open_info.opened_history;
						_model.putValue("opened_ball_num", arr.length );
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
						if ( state == gameState.NEW_ROUND)
						{							
							utilFun.Log("new rount go to betview");
							dispatcher(new ValueObject(  result.remain_time, modelName.REMAIN_TIME) );		
							dispatcher(new Intobject(modelName.Bet, ViewCommand.SWITCH) );		
							//triger timer,
							dispatcher(new ModelEvent("display"));
						}
						if (  state == gameState.END_BET)
						{
							dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BET_STOP_HINT));
						}
					}
					break;
					
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
						utilFun.Log("push is_bet ="+is_bet);
						_model.putValue("is_betarr", is_bet);
						
						dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BET_STATE_UPDATE));
						utilFun.Log("send info =");
					}
					break;
					case "MsgBPEndRound":
					{
						var state:int = 0;
						//if (  result.game_state == "NewRoundState") state = gameState.NEW_ROUND;
						//if (  result.game_state == "EndBetState") state = gameState.END_BET;
						//if (  result.game_state == "OpenState") state = gameState.START_OPEN;
						if (  result.game_state == "EndRoundState") state = gameState.END_ROUND;
						
						//var result_l:Array = result.result_list)
						
						dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.WIN_HINT));
						
					}
					break;
					case Message.MSG_TYPE_PLAYER_INITIAL:
					{					
						utilFun.Log("recv Player Initial");
						var msg:Object = {"message_type":Message.MSG_TYPE_PLAYER_AUTH, "session_id":"FO1h0Is1RPGswo/tVScLzKvWRvE5dEvkjgIWuHTn6BY="};
						SendMsg(msg);						
						break;
					}
						case Message.MSG_TYPE_DISPLAY_ROOMS:
					{
						utilFun.Log("recv Display Rooms");
						
						dispatcher(new ValueObject( result.player_info.id, modelName.UUID) );
						dispatcher(new ValueObject( result.player_info.nickname,modelName.NICKNAME) );
						dispatcher(new ValueObject(result.player_info.credit, modelName.CREDIT) );
						
						var arr:Array = result.room_info;					
						var num:int = arr.length;
						var room_no:Array = [];
						var room_players:Array = [];
						//utilFun.Log("num = " + num);
						for (var i:int = 0; i < num ; i++)
						{						
							room_no.push( arr[i].room_no);
							room_players.push(arr[i].players);
						}
						
						dispatcher(new ArrayObject(room_no, "roomNo") );
						dispatcher(new ArrayObject(room_players, "room_player") );					
							
						//載入選桌大廳
						dispatcher(new Intobject(modelName.lobby, ViewCommand.SWITCH) );			
						
						break;
					}
					
						case Message.MSG_TYPE_ENTER_ROOM:
					{
						utilFun.Log("recv Enter Room sub =" + result.message_sub);
						
						//先收到0,再收到1,why? result.message_sub=0 
						if (result.message_sub == 1) 
						{
							//arrlist =[object Object],[object Object],						
							//後半包
							var arr_lat:Array = result.game_info.table_info;						
							num = arr_lat.length;						
							var is_bet:Array = _model.getValue("is_betarr");
							var balls:Array = _model.getValue("ballarr");
							var table_no:Array = _model.getValue("table");							
							for ( i = 0; i < num ; i++)
							{						
								is_bet.push( arr_lat[i].is_bet);
								balls.push( arr_lat[i].balls);
								table_no.push( arr_lat[i].table_no);
							}					
							
							_model.putValue("is_betarr",is_bet);
							_model.putValue("ballarr",balls);
							_model.putValue("table", table_no);						
							
							m_game_state = Message.MSG_TYPE_ENTER_ROOM;							
							dispatcher(new Intobject(modelName.Bet, ViewCommand.SWITCH) );						
							
							
							
						} else {
							
							//還沒處理
							check_game_state(result);
						}				
						break;
					}
					case Message.MSG_TYPE_BET:
					{						
						dispatcher(new ValueObject( result.room_no, "bet_room_num") );
						dispatcher(new ValueObject(  result.result, "bet_result") );
						
						dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BETRESULT));						
						
						break;
					}
					
					case Message.MSG_TYPE_UPDATE_BET:
					{
						//比押注結果更早收到 球資訊為空,,之前進入己傳過
						utilFun.Log("recv MSG_TYPE_UPDATE_BET=");			
						var arrlist:Array = result.bet_info;	
						var table_no:Array = _model.getValue("table");		
						var is_bet:Array = _model.getValue("is_betarr");
						num = arrlist.length;
						table_no.length = 0;
						is_bet.length = 0;
						for ( i = 0; i < num ; i++)
						{
							table_no.push(arrlist[i]["table_no"]);
							is_bet.push(arrlist[i]["is_bet"]);
						}
							
						_model.putValue("table", table_no);
						_model.putValue("is_betarr", is_bet);
						
						dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BET_STATE_UPDATE));
							
						break;
					}
					case Message.MSG_TYPE_END_BET:
					{
						utilFun.Log("recv End Bet");
						m_game_state = Message.GAME_STATE_END_BET;
						dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BET_STOP_HINT));
						break;
					}
					
					case Message.MSG_TYPE_OPEN_BALL:
					{
						utilFun.Log("recv Open Ball" +m_game_state);		
						//收到結束,切到開球畫面
						if (m_game_state == Message.GAME_STATE_END_BET) 
						{
							dispatcher(new Intobject(modelName.openball, ViewCommand.SWITCH) );								
							
							m_game_state = 	Message.GAME_STATE_START_ROUND;
						}  
						else
						{			
							_model.putValue("Curball", parseInt(result.game_info.opened_info.current_ball) );
							
							_model.putValue("opened_ball_num", result.game_info.opened_info.opened_ball_num );
							_model.putValue("best_remain", parseInt(result.game_info.opened_info.best_remain) );
							_model.putValue("second_remain", parseInt(result.game_info.opened_info.second_remain) );
							 
							_model.putValue("best_list", result.game_info.opened_info.best_list );
							_model.putValue("second_list", result.game_info.opened_info.second_list );						
							dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BALL_UPDATE));
						}
						
						break;
					}
					
					case Message.MSG_TYPE_BINGO:
					{
						_model.putValue("_bet_info", result.bet_info);
						_model.putValue("best_list", result.game_info.opened_info.best_list );
						
						dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.WIN_HINT));
					}
					break;
					case Message.MSG_TYPE_NEW_ROUND_WITH_BALL:
					{
						utilFun.Log("recv New Round =" +result.message_sub );
						if (result.message_sub == 1) 
						{
							//後半包
							var arr_lat:Array = result.game_info.table_info;						
							num = arr_lat.length;						
							var is_bet:Array = _model.getValue("is_betarr");
							var balls:Array = _model.getValue("ballarr");
							var table_no:Array = _model.getValue("table");							
							for ( i = 0; i < num ; i++)
							{						
								is_bet.push( arr_lat[i].is_bet);
								balls.push( arr_lat[i].balls);
								table_no.push( arr_lat[i].table_no);
							}					
							_model.putValue("is_betarr",is_bet);
							_model.putValue("ballarr",balls);
							_model.putValue("table", table_no);						
							dispatcher(new Intobject(modelName.Bet, ViewCommand.SWITCH) );													
							//triger timer,
							dispatcher(new ModelEvent("display"));
						}
						else 
						{						
							//前半包
							var arr:Array = result.game_info.table_info;							
								var num:int = arr.length;
								//utilFun.Log("arrlist = " + num);
								var is_bet:Array = [];
								var balls:Array = [];
								var table_no:Array = [];
								//utilFun.Log("num = " + num);
								for (var i:int = 0; i < num ; i++)
								{						
									is_bet.push( arr[i].is_bet);
									balls.push( arr[i].balls);
									table_no.push( arr[i].table_no);
								}
								
							dispatcher(new ValueObject(result.remain_time, modelName.REMAIN_TIME) );						
							_model.putValue("is_betarr",is_bet);
							_model.putValue("ballarr",balls);
							_model.putValue("table", table_no);
							
							
						}
						break;
					}
					
					
					//case Message.MSG_TYPE_INTO_GAME:
					//{						
						//進入 遊戲,得到第一個畫面(不論半途或一開始
						//
						//dispatcher(new ValueObject( result.inside_game_info.player_info.nickname,modelName.NICKNAME) );
						//dispatcher(new ValueObject( result.inside_game_info.player_info.userid, modelName.UUID) );
						//
						//from lobby or single server
						//if( _model.getValue(modelName.HandShake_chanel) == null )  dispatcher(new ValueObject( result.inside_game_info.player_info.credit, modelName.CREDIT) );					
						//
						//dispatcher(new ValueObject(  result.inside_game_info.remain_time,modelName.REMAIN_TIME) );						
						//dispatcher(new ValueObject(  result.inside_game_info.games_state, modelName.GAMES_STATE) );						
						//dispatcher(new ValueObject(  result.inside_game_info.split_symbol, modelName.SPLIT_SYMBOL) );
						//dispatcher(new ValueObject(  result.inside_game_info.bet_zone, modelName.BET_ZONE) );
						//
                        //dispatcher( new ValueObject(result.inside_game_info.game_info["player_card_list"], modelName.PLAYER_POKER) );
                        //dispatcher( new ValueObject(result.inside_game_info.game_info["banker_card_list"], modelName.BANKER_POKER) );
						//
						//dispatcher(new Intobject(modelName.Bet, ViewCommand.SWITCH) );
						//dispatcher(new Intobject(modelName.Hud, ViewCommand.ADD)) ;
						//
						//dispatcher(new ModelEvent("update_state"));
						//dispatcher(new Intobject(modelName.PLAYER_POKER, "pokerupdate"));
						//dispatcher(new Intobject(modelName.BANKER_POKER, "pokerupdate"));
						//dispatcher(new ModelEvent("update_result_Credit"));
						//
						//break;
					//}
					//
					//case Message.MSG_TYPE_STATE_INFO:
					//{					  
					  //
					  //dispatcher(new ValueObject(  result.games_state, modelName.GAMES_STATE) );
					  //dispatcher(new ValueObject(  result.remain_time,modelName.REMAIN_TIME) );
					   //dispatcher(new ModelEvent("update_state"));
					   //break;
					//}
					//
					//case Message.MSG_TYPE_GAME_OPEN_INFO:
					//{
						//dispatcher(new ValueObject(  result.games_state, modelName.GAMES_STATE) );
                        //var card:Array = result.card_info["card_list"];
                        //var card_type:int = result.card_info["card_type"];
						//if ( card_type == CardType.PLAYER)
						//{
							//dispatcher( new ValueObject( card, modelName.PLAYER_POKER) );
							//dispatcher(new Intobject(modelName.PLAYER_POKER, "playerpokerAni"));							
						//}
						//else if ( card_type == CardType.BANKER)
						//{							
						    //dispatcher( new ValueObject(card, modelName.BANKER_POKER) );							
							//dispatcher(new ModelEvent("playerpokerAni"));
							//dispatcher(new Intobject(modelName.BANKER_POKER, "playerpokerAni"));
						//}
						//
						//break;
					//}					
					//case Message.MSG_TYPE_BET_INFO:
					//{
						//if (result.result)
						//{
							//dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BETRESULT));
							//dispatcher(new ModelEvent("updateCredit"));
							//dispatcher(new ModelEvent("updateCoin"));
						//}
						//else
						//{
							//_actionqueue.dropMsg();
							//error handle
						//}
						//break;
					//}
					//case Message.MSG_TYPE_ROUND_INFO:
					//{
						//dispatcher( new ValueObject(result.bet_amount,modelName.BET_AMOUNT));
						//dispatcher( new ValueObject(result.settle_amount,modelName.SETTLE_AMOUNT));
						//dispatcher(new ValueObject( result.player_info.credit,modelName.CREDIT) );						
						//
						//dispatcher( new ValueObject(result.win_type, modelName.ROUND_RESULT));
						//dispatcher(new ModelEvent("round_result"));
						//dispatcher(new ModelEvent("update_result_Credit"));
						//
						//break;
					//}
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
		
		private function check_game_state(msg:Object):void
		{
			utilFun.Log("check_game_state="+msg.game_state);
			switch(msg.game_state) 
			{
				case Message.GAME_STATE_NEW_ROUND:
				{					
					m_game_state = Message.GAME_STATE_NEW_ROUND;					
					//前半包
					var arr:Array = msg.game_info.table_info;							
						var num:int = arr.length;
						//utilFun.Log("arrlist = " + num);
						var is_bet:Array = [];
						var balls:Array = [];
						var table_no:Array = [];
						//utilFun.Log("num = " + num);
						for (var i:int = 0; i < num ; i++)
						{						
							is_bet.push( arr[i].is_bet);
							balls.push( arr[i].balls);
							table_no.push( arr[i].table_no);
						}
						
						dispatcher(new ValueObject(msg.remain_time, modelName.REMAIN_TIME) );						
						_model.putValue("is_betarr",is_bet);
						_model.putValue("ballarr",balls);
						_model.putValue("table", table_no);
					break;
				}
				case Message.GAME_STATE_END_BET:
				{
					m_game_state = Message.GAME_STATE_END_BET;					
					dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BET_STOP_HINT));
					
					break;
				}
				case Message.GAME_STATE_START_ROUND:
				{
					m_game_state = 	Message.GAME_STATE_START_ROUND;
					//中途入局
					utilFun.Log("中途入局");
					  //msg =room_no = 92				
					   _model.putValue("openBalllist", msg.game_info.opened_history);
					  utilFun.Log("中途入局 open_hist ="+msg.game_info.opened_history);
					  var arr:Array = msg.game_info.opened_history.concat();
					//
						arr.reverse();					
					   _model.putValue("open3Balllist", arr.slice(0, Math.min(arr.length, 3)) );
						
						_model.putValue("Curball", parseInt(msg.game_info.opened_info.current_ball) );
						_model.putValue("opened_ball_num", msg.game_info.opened_info.opened_ball_num );
						_model.putValue("best_remain", parseInt(msg.game_info.opened_info.best_remain) );
						_model.putValue("second_remain", parseInt(msg.game_info.opened_info.second_remain) );
						
						_model.putValue("best_list", msg.game_info.opened_info.best_list );
						_model.putValue("second_list", msg.game_info.opened_info.second_list );						
						
						dispatcher(new Intobject(modelName.openball, ViewCommand.SWITCH) );												
						//
						dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.HALF_ENTER_UPDATE));
						dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BALL_UPDATE));
						
					break;
				}	
			
			}
		}
		
		public function SendMsg(msg:Object):void 
		{
			var jsonString:String = JSON.encode(msg);
			utilFun.Log("jsonString "+ jsonString);
			websocket.sendUTF(jsonString);
		}
		
	}
}