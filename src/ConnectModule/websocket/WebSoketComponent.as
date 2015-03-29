package ConnectModule.websocket 
{
	import caurina.transitions.PropertyInfoObj;
	import com.worlize.websocket.WebSocket
	import com.worlize.websocket.WebSocketEvent
	import com.worlize.websocket.WebSocketMessage
	import com.worlize.websocket.WebSocketErrorEvent
	import com.adobe.serialization.json.JSON	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.system.Security;
	import Model.LobbyModel;
	
	import Model.valueObject.StringObject;
	import Model.valueObject.ArrayObject;
	import Model.valueObject.Intobject;
	
	import View.GameView.ViewState;
	
	import View.componentLib.util.utilFun;	
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
		public var _LobbyModel:LobbyModel;
		
		
		public var EnterBetView:Function;
		public var stopBetView:Function;
		public var OpenBallView:Function;
		public var HalfEnterInit:Function;
		public var UpdataBallInfo:Function;
		public var UpdateBetInfo:Function;
		public var BetResult:Function;
		public var cleanResult:Function;
		public var UpTableBetInfo:Function;
		
		public var BingoHint:Function;
		
		private var websocket:WebSocket;		
		
		private var best_table_list:Array;
		private var best_remain:Number;
		private var second_table_list:Array;
		private var second_remain:Number;
		private var m_game_state:int = 0;
		private var _remainTime:int = 0; 
		private var _credit:int = 0;		
		public var _CleanAllbet:int = 0;
		
		//移載到model
		public var TableNo:Array = [];
		public var is_betarr:Array = [];
		public var ballarr:Array = [];
		public var room_no:Array = [];
		public var room_player:Array = [];	
		
		
		
		
		public function WebSoketComponent() 
		{
			
		}
		
		public function Connect():void
		{
			websocket = new WebSocket("ws://106.186.116.216:8888/gamesocket", "");
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
		  if (event.message.type === WebSocketMessage.TYPE_UTF8) 
		  {
			var result:Object = JSON.decode(event.message.utf8Data);
			//var result = JSON.parse(event.message.utf8Data, function(k,v){			
		  }
				
				switch(result.message_type)
				{
					case Message.MSG_TYPE_PLAYER_INITIAL:
					{
						utilFun.Log("recv Player Initial");
						var msg:Object = {"message_type":Message.MSG_TYPE_PLAYER_AUTH, "session_id":Message.DEMO_SESSION};
						SendMsg(msg);
						
						break;
					}
					case Message.MSG_TYPE_DISPLAY_ROOMS:
					{
						utilFun.Log("recv Display Rooms");							
												
						var uid:Intobject = new Intobject(result.player_info.id,"uuid");
						dispatcher(uid);
						var nickname:StringObject = new StringObject(result.player_info.nickname, "nickname");
						dispatcher(nickname);
						//
						var intob:Intobject = new Intobject(result.player_info.credit,"credit");
						dispatcher(intob);				
						 //
						TableNo.length = 0;
						is_betarr.length = 0;
						ballarr.length = 0;
						
						var arr:Array = result.room_info;						
						for ( var o : * in arr)
						{
							var roomNo:int = arr[o] ["room_no"];
							var player:int = arr[o] ["players"];								
							room_no.push(roomNo);
							room_player.push(player);
							//utilFun.Log("roominfo = " + roomNo +" room_p"+ player);
						}
						
						var room:ArrayObject  = new ArrayObject(room_no, "roomNo");
						dispatcher(room);
						var roomplayer:ArrayObject  = new ArrayObject(room_player, "room_player");
						dispatcher(roomplayer);
						
						//載入選桌大廳
						//dispatcher(new WebSoketInternalMsg(WebSoketInternalMsg.CHOOSE_ROOM));
						dispatcher(new ViewState(ViewState.Lobb,ViewState.ENTER) );
						//dispatcher(new ViewState(ViewState.Hud,ViewState.ADD) );
						
						dispatcher(new ViewState(ViewState.Loading,ViewState.LEAVE) );
						
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
							var arrlist:Array = result.game_info.table_info;
							
							for ( var p:* in arrlist)
							{
								var is_bet:int = arrlist[p] ["is_bet"];
								var ball:Array = arrlist[p] ["balls"];
								var Table:int = arrlist[p] ["table_no"];
								
								TableNo.push(Table);
								is_betarr.push(is_bet);
								ballarr.push(ball);								
							}
							
							var table:ArrayObject = new ArrayObject(TableNo, "table");
							dispatcher(table);
							
							var _bet:ArrayObject = new ArrayObject(is_betarr, "is_betarr");
							dispatcher(_bet);
							
							var _ballarr:ArrayObject = new ArrayObject(ballarr, "ballarr");
							dispatcher(_ballarr);
							
							m_game_state = Message.MSG_TYPE_ENTER_ROOM;							
							
							dispatcher(new ViewState(ViewState.Bet,ViewState.ENTER) );
							dispatcher(new ViewState(ViewState.Hud,ViewState.ADD) );
							dispatcher(new ViewState(ViewState.Lobb, ViewState.LEAVE) );
							
							//EnterBetView(TableNo,is_betarr,ballarr,_remainTime,_credit);
							
						} else {
							
							//還沒處理
							check_game_state(result);
						}				
						break;
					}
					case Message.MSG_TYPE_BET:
					{
						//utilFun.Log("recv MSG_TYPE_BET=");
						var room_no:int =  result.room_no;
						var Betresult:int = result.result;
						//utilFun.Log("room_no = "+room_no);
						//utilFun.Log("result = " + Betresult);
						
						//結束押盤
						
						
						
						if ( _CleanAllbet >=1)
						{
							_CleanAllbet--;
							//utilFun.Log("recv _CleanAllbet = " + _CleanAllbet + "Betresult = " + Betresult);
							if ( _CleanAllbet == 0)
							{
								cleanResult();
							}
						}
						else
						{							
							BetResult(room_no, Betresult);
						}
						
						break;
					}
					case Message.MSG_TYPE_UPDATE_BET:
					{
						//比押注結果更早收到 球資訊為空,,之前進入己傳過
						//utilFun.Log("recv MSG_TYPE_UPDATE_BET=");						
						TableNo.length = 0;
						is_betarr.length = 0;						
						var arrlist:Array = result.bet_info;							
						for ( var p:* in arrlist)
						{
							var is_bet:int = arrlist[p] ["is_bet"];
							var Table:int = arrlist[p] ["table_no"];
							
							TableNo.push(Table);
							is_betarr.push(is_bet);
						}
						UpTableBetInfo(TableNo, is_betarr,ballarr);
							
						break;
					}
					
					
					case Message.MSG_TYPE_NEW_ROUND_WITH_BALL:
					{
						utilFun.Log("recv New Round =" +result.message_sub );
						if (result.message_sub == 1) 
						{
							var arrlist:Array = result.game_info.table_info;
						
							//拿到後半資訊
							for ( var p:* in arrlist)
							{
								var is_bet:int = arrlist[p] ["is_bet"];
								var ball:Array = arrlist[p] ["balls"];
								var Table:int = arrlist[p] ["table_no"];
								
								TableNo.push(Table);
								is_betarr.push(is_bet);
								ballarr.push(ball);								
							}
							
							//utilFun.Log("TableNo = " + TableNo.length);
							//utilFun.Log("is_betarr = " + is_betarr);
							
							dispatcher(new ViewState(ViewState.openball,ViewState.ENTER) );
							dispatcher(new ViewState(ViewState.Bet, ViewState.LEAVE) );
							//EnterBetView(TableNo,is_betarr,ballarr,_remainTime,_credit);
						}
						else 
						{
							//似乎沒用 result.message_sub =0 可以不用傳
							_remainTime = result.remain_time;
							var arrlist:Array = result.game_info.table_info;
							
							//拿到前半資訊
							for ( var p:* in arrlist)
							{
								var is_bet:int = arrlist[p] ["is_bet"];
								var ball:Array = arrlist[p] ["balls"];
								var Table:int = arrlist[p] ["table_no"];
								
								TableNo.push(Table);
								is_betarr.push(is_bet);
								ballarr.push(ball);								
							}
							
							//server傳的確認押注結果
							var table_no:Array = [];
                            var amount:Array = [];
                            var arrlist:Array = result.bet_info;
                            for ( var p:* in arrlist)
                            {
                                var is_bet:int = arrlist[p] ["table_no"];
                                var my:int = arrlist[p] ["amount"];
                                
                                table_no.push(is_bet);
                                amount.push(my);
                            }
							//更新到新己的betinfo
							UpdateBetInfo(table_no,amount);
							
							_credit = result.player_info.credit;
						}
						break;
					}
					case Message.MSG_TYPE_END_BET:
					{
						utilFun.Log("recv End Bet");
						m_game_state = Message.GAME_STATE_END_BET;						
						stopBetView();
						break;
					}
					case Message.MSG_TYPE_OPEN_BALL:
					{
						utilFun.Log("recv Open Ball" +m_game_state);						
						//收到結束,切到開球畫面
						if (m_game_state == Message.GAME_STATE_END_BET) 
						{
							OpenBallView();
							m_game_state = 	Message.GAME_STATE_START_ROUND;
						}  
						else
						{							
							UpdataBallInfo(result, false);
						}
						
						break;
					}
					case Message.MSG_TYPE_BINGO:
					{
						utilFun.Log("recv Bingo");						
						
						TableNo.length = 0;
						is_betarr.length = 0;
						ballarr.length = 0;
						
						//會拿到新credit
						//utilFun.Log("new MSG_TYPE_BINGO credit = " + result.player_info.credit);
						
						BingoHint();	
						break;						
					}
				}
				
				//else if (event.message.type === WebSocketMessage.TYPE_BINARY)
				//{
					//trace("Got binary message of length " + event.message.binaryData.length);
				//}
				 
		}
		
		public function SendBet(TableNo:int,betamount:int):void
		{
			var dd:Object = {"message_type":Message.MSG_TYPE_BET,"table_no":TableNo, "amount":betamount};
			var jsonString:String = JSON.encode(dd);
			websocket.sendUTF(jsonString);
		}
		
		[MessageHandler(type="ConnectModule.websocket.WebSoketInternalMsg",selector="chooseRoom")]
		public function enterRoom():void
		{
			var choose_room_msg:Object = {"message_type":Message.MSG_TYPE_DISPLAY_ROOMS, "room_no":_LobbyModel._currentRoomNum };
			SendMsg(choose_room_msg);
		}
		
		public function SendMsg(msg:Object):void 
		{
			var jsonString:String = JSON.encode(msg);
			websocket.sendUTF(jsonString);
		}
		
		private function check_game_state(msg:Object):void
		{
			utilFun.Log("check_game_state="+msg.game_state);
			switch(msg.game_state) 
			{
				case Message.GAME_STATE_NEW_ROUND:
				{					
					m_game_state = Message.GAME_STATE_NEW_ROUND;					
					//一存取idx就掛
					//前半包
					var arrlist:Array = msg.game_info.table_info;
					for ( var o : * in arrlist)
					{
						var is_bet:int = arrlist[o] ["is_bet"];
						var ball:Array = arrlist[o] ["balls"];
						var Table:int = arrlist[o] ["table_no"];
						
						TableNo.push(Table);
						is_betarr.push(is_bet);
						ballarr.push(ball);								
					}
					
					var remainTime:Intobject = new Intobject( msg.remain_time,"remainTime");
					dispatcher(remainTime);
					
					//utilFun.Log("check_game_state remainTime = " + _remainTime);
							
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
					   for (var id:String in msg)
                       {
                         var value:Object = msg[id];
                         utilFun.Log(" msg =" + id + " = " + value);                                    
                       }
					  
					  //msg =room_no = 92
					   
					    for (var id:String in msg.game_info)
                       {
                         var value:Object = msg.game_info[id];
                         utilFun.Log(" msg.game_info =" + id + " = " + value);                                    
                       }
					   
					   //player_info
					    //=credit = 50000
					   // =id = Player1
					   // =nickname = Player1
					   var intob:Intobject = new Intobject(msg.player_info.credit,"credit");
						dispatcher(intob);
					   //msg.game_info
					   //= opened_history array
					  
					   dispatcher(new ViewState(ViewState.openball,ViewState.ENTER) );
					   dispatcher(new ViewState(ViewState.Lobb, ViewState.LEAVE) );
					   
					  // OpenBallView();
					   //HalfEnterInit(_credit,msg.game_info.opened_history);
					   
					break;
				}	
				case Message.GAME_STATE_END_ROUND:
				{				
					//utilFun.Log("GAME_STATE_END_ROUND");
					break;
				}
			}
		}

		
	}
}