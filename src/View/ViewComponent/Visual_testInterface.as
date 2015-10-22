package View.ViewComponent 
{
	import ConnectModule.websocket.WebSoketInternalMsg;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Transform;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import util.math.Path_Generator;
	import View.ViewBase.Visual_Text;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	import View.Viewutil.*;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import View.GameView.*;
	import Res.ResName;
	import caurina.transitions.Tweener;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import com.adobe.serialization.json.JSON;
	/**
	 * testinterface to fun quick test
	 * @author ...
	 */
	public class Visual_testInterface  extends VisualHandler
	{		
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _path:Path_Generator;
		
		[Inject]
		public var _MsgModel:MsgQueue;		
		
		[Inject]
		public var _hint:Visual_Hintmsg;
		
		[Inject]
		public var _timer:Visual_timer;
		
		[Inject]
		public var _playerinfo:Visual_PlayerInfo;
		
		[Inject]
		public var _betzone:Visual_betZone;	
		
		[Inject]
		public var _settle:Visual_Settle;	
		
		[Inject]
		public var _text:Visual_Text;
		
		[Inject]
		public var _ball:Visual_ball;
		
		[Inject]
		public var _roomItem:Visual_RoomSelect;
		
		[Inject]
		public var _bingo:Visual_bingoPan;
		
		[Inject]
		public var _staticinfo:Visual_staticInfo;
		
		[Inject]
		public var _ticket:Visual_ticket;
		
		[Inject]
		public var _Bigwin_Msg:Visual_Bigwin_Msg;
		
		[Inject]
		public var _Bigwin_Effect:Visual_Bigwin_Effect
		
		private var _script_item:MultiObject;
		
		public function Visual_testInterface() 
		{
			
		}
		
		public function init():void
		{			
			
			_betCommand.bet_init();
			_model.putValue("history_win_list", []);				
			_model.putValue("result_Pai_list", []);
			_model.putValue("game_round", 1);			
			
			var temp:Array = [];
			for (var i:int = 0; i < 100;i++)
			{
				temp.push(0);
			}
			_model.putValue("is_betarr",temp);		
			
			//腳本
			var script_list:MultiObject = prepare("script_list", new MultiObject() ,GetSingleItem("_view").parent.parent );			
			script_list.MouseFrame = utilFun.Frametype(MouseBehavior.ClickBtn);			
			script_list.stop_Propagation = true;
			script_list.mousedown = script_list_test;			
			script_list.mouseup = up;			
			script_list.CustomizedData = [{size:18},"選桌","下注","開球","結算"]
			script_list.CustomizedFun = _text.textSetting;			
			script_list.Create_by_list(script_list.CustomizedData.length -1, [ResName.Paninfo_font], 0, 0, script_list.CustomizedData.length-1, 100, 20, "Btn_");			
			
			
			//腳本細項調整
			//_script_item = prepare("script_item", new MultiObject() ,GetSingleItem("_view").parent.parent );			
			//_script_item.MouseFrame = utilFun.Frametype(MouseBehavior.ClickBtn);			
			//_script_item.stop_Propagation = true;
			//_script_item.mousedown = _script_item_test;
			//_script_item.mouseup = up;
			//
			//_model.putValue("allScript",[ [{size:18}, "時間", "提示訊息","注區"],
														   //[{size:18}, "閒家一張牌", "莊家一張牌", "閒家第二張(報點數)", "閒家第二張(報點數)"],
														   //[{size:18}, "出現發公牌字樣", "公牌第一張", "公牌第二張", "出現特殊牌型"],
														   //[{size:18}, "結算表呈現","能量BAR集氣","能量BAR集滿效果"]														   
														  //]);
			//
			_model.putValue("Script_idx", 0);
			//_model.putValue("Script_item_idx", 0);
			//_tool.y = 200;
			//add(_tool);
			//
		}				
		
		public function script_list_test(e:Event, idx:int):Boolean
		{
			utilFun.Log("script_list_test=" + idx);
			_model.putValue("Script_idx", idx);
			//_script_item.CustomizedData = _model.getValue("allScript")[idx];
			//_script_item.CustomizedFun = _gameinfo.textSetting;			
			//_script_item.Create_by_list(_script_item.CustomizedData.length -1, [ResName.TextInfo], 0, 100, 1, 0, 20, "Btn_");
			
			dispatcher(new TestEvent(_model.getValue("Script_idx").toString()));
			
			
			return true;
		}
	
		
		public function _script_item_test(e:Event, idx:int):Boolean
		{
			
			_model.putValue("Script_item_idx", idx);
			
			utilFun.Log("scirpt_id = "+ _model.getValue("Script_idx") + _model.getValue("Script_item_idx"));	
			var str:String = _model.getValue("Script_idx").toString() + _model.getValue("Script_item_idx").toString();			
			
			dispatcher(new TestEvent(str));
			
			return true;		
		}			
		
		
		[MessageHandler(type = "View.Viewutil.TestEvent", selector = "0")]
		public function betScript():void
		{
			changeBG(ResName.RoomSelect);			
			
			//fake model
			var arr:Array = [];
			for ( var i:int = 0; i < 100; i++)	
			{
				var roomob:Object = { "room_no":i , "bet_tables":i }; 
				arr.push(roomob);
			}
			_model.putValue("SelectRoomInfo",arr);
			
			_roomItem.init();			
			
			
		}	
		
		[MessageHandler(type = "View.Viewutil.TestEvent", selector = "1")]
		public function opencardScript():void
		{					
			changeBG(ResName.Bet_Scene);			
			
			_playerinfo.init();
			
			//fake model
			var table:Array = [];
			for ( var i:int = 0; i < 100; i++)	
			{				
				table.push(utilFun.Random(1));
			}			
			_model.putValue("is_betarr",table);
			_betzone.init();
			
			//fake model
			_model.putValue(modelName.REMAIN_TIME, 10);					
			_timer.init();			
			
			
			_hint.init();
			
			var balls:Array = [];
			for ( var i:int = 0; i < 100; i++)	
			{		
				var pan:Array = [];
				for ( var k:int = 0; k < 24; k++)
				{
				    pan.push(k);
				}
				balls.push(pan);
			}						
			_model.putValue("ballarr",balls);
			_bingo.init();
		
			//dispatcher(new ModelEvent("display"));		
			
			//_regular.Call(this, { onComplete:this.fake_stop_bet}, 10,0, 1, "linear");
			
		
			//TODO 押注功能重構
			//auto bet
			//_betCommand.re_bet();			
		}
		
		public function fake_stop_bet():void
		{
			dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BET_STOP_HINT));
		}
		
		[MessageHandler(type = "View.Viewutil.TestEvent", selector = "2")]
		public function settleScript():void
		{
		
			changeBG(ResName.Openball_Scene);
			
			//fake bet
			_betCommand.add_amount(new MouseEvent(MouseEvent.MOUSE_DOWN, true, false), 1);
			//_betCommand.add_amount(new MouseEvent(MouseEvent.MOUSE_DOWN, true, false), 1);
			//_betCommand.add_amount(new MouseEvent(MouseEvent.MOUSE_DOWN, true, false), 2);
			//_betCommand.add_amount(new MouseEvent(MouseEvent.MOUSE_DOWN, true, false), 3);
			
			//fake ball
			var balls:Array = [];
			for ( var i:int = 0; i < 100; i++)	
			{		
				var pan:Array = [];
				for ( var k:int = 0; k < 24; k++)
				{
				    pan.push(k);
				}
				balls.push(pan);
			}						
			_model.putValue("ballarr",balls);
			
			_ball.init();
			
			_staticinfo.init();
			
			
			_ticket.init();	
			
			_Bigwin_Msg.init();
		
			_Bigwin_Effect.init();
			//_Bigwin_Effect.hitbigwin();
			//last 2
			//var fakePacket:Object ={"game_state": "OpenState", "timestamp": 1443509759.091369, "game_type": "Bingo", "open_info": {"opened_history": [58, 54, 8, 32, 56, 46, 41, 59, 30, 67, 12, 66, 27, 57, 43, 23, 2, 31, 4, 37, 20, 16, 35, 65, 9, 55, 52, 28, 71, 18, 1, 73, 6, 51, 29, 42, 34, 45, 5, 70, 53, 7, 64, 36, 17, 10, 33, 15, 21, 47, 40, 75, 38, 61, 50, 49, 72, 63, 62, 74, 25, 13, 69], "current_ball": 24, "best_list": [{"table_no": 96, "ball_list": [11]}, {"table_no": 6, "ball_list": [48]}, {"table_no": 70, "ball_list": [19]}, {"table_no": 44, "ball_list": [26]}, {"table_no": 28, "ball_list": [39]}, {"table_no": 54, "ball_list": [68]}, {"table_no": 91, "ball_list": [14]}, {"table_no": 21, "ball_list": [68]}, {"table_no": 9, "ball_list": [14]}, {"table_no": 46, "ball_list": [3]}], "best_remain": 1, "second_list": [{"table_no": 97, "ball_list": [26, 19]}, {"table_no": 84, "ball_list": [3, 68]}, {"table_no": 59, "ball_list": [19, 22]}, {"table_no": 49, "ball_list": [19, 3]}, {"table_no": 45, "ball_list": [26, 3]}, {"table_no": 22, "ball_list": [60, 22]}, {"table_no": 7, "ball_list": [26, 22]}, {"table_no": 31, "ball_list": [60, 22]}, {"table_no": 5, "ball_list": [19, 68]}, {"table_no": 86, "ball_list": [60, 14]}, {"table_no": 52, "ball_list": [26, 60]}, {"table_no": 3, "ball_list": [48, 14]}, {"table_no": 85, "ball_list": [11, 3]}], "second_remain": 2}, "id": "23b59766667711e59348f23c9189e2a9", "game_id": "Bingo-1", "message_type": "MsgBGOpenBall", "game_round": 0}
			
			//last
			//var fakePacket:Object ={"game_state": "OpenState", "timestamp": 1443509761.087721, "game_type": "Bingo", "open_info": {"opened_history": [58, 54, 8, 32, 56, 46, 41, 59, 30, 67, 12, 66, 27, 57, 43, 23, 2, 31, 4, 37, 20, 16, 35, 65, 9, 55, 52, 28, 71, 18, 1, 73, 6, 51, 29, 42, 34, 45, 5, 70, 53, 7, 64, 36, 17, 10, 33, 15, 21, 47, 40, 75, 38, 61, 50, 49, 72, 63, 62, 74, 25, 13, 69, 24], "current_ball": 11, "best_list": [{"table_no": 96, "ball_list": []}], "best_remain": 0, "second_list": [{"table_no": 6, "ball_list": [48]}, {"table_no": 70, "ball_list": [19]}, {"table_no": 44, "ball_list": [26]}, {"table_no": 28, "ball_list": [39]}, {"table_no": 54, "ball_list": [68]}, {"table_no": 91, "ball_list": [14]}, {"table_no": 21, "ball_list": [68]}, {"table_no": 9, "ball_list": [14]}, {"table_no": 46, "ball_list": [3]}, {"table_no": 85, "ball_list": [3]}], "second_remain": 1}, "id": "24e636b8667711e59348f23c9189e2a9", "game_id": "Bingo-1", "message_type": "MsgBGOpenBall", "game_round": 0}
			//var fakePacket:Object ={"result_list": [{"bet_type": "24,13", "settle_amount": 0, "odds": 90, "win_state": "WSLost", "bet_amount": 100}, {"bet_type": "24,14", "settle_amount": 0, "odds": 90, "win_state": "WSLost", "bet_amount": 200}, {"bet_type": "24,15", "settle_amount": 0, "odds": 90, "win_state": "WSLost", "bet_amount": 100}, {"bet_type": "24,25", "settle_amount": 0, "odds": 90, "win_state": "WSLost", "bet_amount": 100}, {"bet_type": "24,24", "settle_amount": 0, "odds": 90, "win_state": "WSLost", "bet_amount": 100}, {"bet_type": "24,36", "settle_amount": 0, "odds": 90, "win_state": "WSLost", "bet_amount": 100}, {"bet_type": "24,33", "settle_amount": 0, "odds": 90, "win_state": "WSLost", "bet_amount": 100}, {"bet_type": "24,26", "settle_amount": 0, "odds": 90, "win_state": "WSLost", "bet_amount": 100}, {"bet_type": "24,17", "settle_amount": 0, "odds": 90, "win_state": "WSLost", "bet_amount": 100}], "game_state": "EndRoundState", "game_result_id": 1111, "room_no": 24, "timestamp": 1443509761.090936, "remain_time": 4, "game_type": "Bingo", "bingo_result": [96], "game_id": "Bingo-1", "game_round": 0, "message_type": "MsgBPEndRound", "id": "24e6b4f8667711e59348f23c9189e2a9"}
			
			//_MsgModel.push(fakePacket);			
			
		}
		
		public function up(e:Event, idx:int):Boolean
		{			
			return true;
		}	
		
	}

}