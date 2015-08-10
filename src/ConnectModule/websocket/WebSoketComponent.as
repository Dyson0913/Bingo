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
			websocket = new WebSocket("ws://106.186.116.216:8888/gamesocket","");
			//websocket = new WebSocket("ws://106.186.116.216:9001/gamesocket/token/123", "");
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
				//utilFun.Log("before"+event.message.utf8Data)
				result = JSON.decode(event.message.utf8Data);
				//utilFun.Log("after"+result)
			}
			
			_MsgModel.push(result);
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "popmsg")]
		public function msghandler():void
		{
			   var result:Object  = _MsgModel.getMsg();
				switch(result.message_type)
				{
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
							
							dispatcher(new ModelEvent("display"));
							
						} else {
							
							//還沒處理
							check_game_state(result);
						}				
						break;
					}
					case Message.MSG_TYPE_BET:
					{	
						//TODO 用int objec 解偶
						dispatcher(new ValueObject( result.room_no, "bet_room_num") );
						dispatcher(new ValueObject(  result.result, "bet_result") );
						//_BetModel._Bet_room_no =  result.room_no;
						//_BetModel._Bet_result = result.result;
						
						//if ( _LobbyModel._CleanAllbet >=1)
						//{
							//_LobbyModel._CleanAllbet--;
							//utilFun.Log("recv _CleanAllbet = " + _CleanAllbet + "Betresult = " + Betresult);
							//if ( _LobbyModel._CleanAllbet == 0)
							//{
								//cleanResult();
								//utilFun.Log("all retrun");
								//dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BET_CLEARN_ALL));
							//}
						//}
						//else
						//{							
							//BetResult(room_no, Betresult);
							dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BETRESULT));
						//}
						
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
			utilFun.Log("send");
			var choose_room_msg:Object = {"message_type":Message.MSG_TYPE_DISPLAY_ROOMS, "room_no":26 };
			SendMsg(choose_room_msg);
		}
		
		
		[MessageHandler(type="ConnectModule.websocket.WebSoketInternalMsg",selector="Bet")]
		public function SendBet():void
		{
			var ob:Object = _actionqueue.getMsg();
			var bet:Object = { "message_type":Message.MSG_TYPE_BET, 
			                               "serial_no":0,
										   "game_type":1,
										   "bet_type":ob["betType"],
										    "amount":ob["bet_amount"]};
										   
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
					//DisplayEndBet();
					break;
				}
				case Message.GAME_STATE_START_ROUND:
				{
					m_game_state = 	Message.GAME_STATE_START_ROUND;
					//中途入局
					utilFun.Log("中途入局");
					  //msg =room_no = 92
					  
					   //player_info
					    //=credit = 50000
					   // =id = Player1
					   // =nickname = Player1
					   
						//dispatcher(new Intobject(msg.player_info.credit, "credit"));
						//dispatcher(new ArrayObject(msg.game_info.opened_history, "opened_history"));
					  //
					   //dispatcher(new ViewState(ViewState.openball,ViewState.ENTER) );
					   //dispatcher(new ViewState(ViewState.Lobb, ViewState.LEAVE) );
					   
					break;
				}	
				case Message.GAME_STATE_END_ROUND:
				{				
					//utilFun.Log("GAME_STATE_END_ROUND");
					break;
				}
			}
		}
		
		public function SendMsg(msg:Object):void 
		{
			var jsonString:String = JSON.encode(msg);
			websocket.sendUTF(jsonString);
		}
		
	}
}