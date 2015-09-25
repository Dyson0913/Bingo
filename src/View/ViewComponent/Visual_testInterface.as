package View.ViewComponent 
{
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
		public var _betzone:Visual_betZone;	
		
		[Inject]
		public var _settle:Visual_Settle;	
		
		[Inject]
		public var _text:Visual_Text;
		
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
			
			//腳本
			var script_list:MultiObject = prepare("script_list", new MultiObject() ,GetSingleItem("_view").parent.parent );			
			script_list.MouseFrame = utilFun.Frametype(MouseBehavior.ClickBtn);			
			script_list.stop_Propagation = true;
			script_list.mousedown = script_list_test;			
			script_list.mouseup = up;			
			script_list.CustomizedData = [{size:18},"下注腳本","開球腳本","結算腳本"]
			script_list.CustomizedFun = _text.textSetting;			
			script_list.Create_by_list(script_list.CustomizedData.length -1, [ResName.TextInfo], 0, 0, script_list.CustomizedData.length-1, 100, 20, "Btn_");			
			
			
			//腳本細項調整
			_script_item = prepare("script_item", new MultiObject() ,GetSingleItem("_view").parent.parent );			
			_script_item.MouseFrame = utilFun.Frametype(MouseBehavior.ClickBtn);			
			_script_item.stop_Propagation = true;
			_script_item.mousedown = _script_item_test;
			_script_item.mouseup = up;
			
			_model.putValue("allScript",[ [{size:18}, "時間", "提示訊息","注區"],
														   [{size:18}, "閒家一張牌", "莊家一張牌", "閒家第二張(報點數)", "閒家第二張(報點數)"],
														   [{size:18}, "出現發公牌字樣", "公牌第一張", "公牌第二張", "出現特殊牌型"],
														   [{size:18}, "結算表呈現","能量BAR集氣","能量BAR集滿效果"]														   
														  ]);
			
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
			_script_item.CustomizedData = _model.getValue("allScript")[idx];
			_script_item.CustomizedFun = _gameinfo.textSetting;			
			_script_item.Create_by_list(_script_item.CustomizedData.length -1, [ResName.TextInfo], 0, 100, 1, 0, 20, "Btn_");
			
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
			if ( idx == 0) 
			{				
				
				//================================================command btn
				//_btn.init();			
				
            }
			
			return true;
		}			
		
		
		[MessageHandler(type = "View.Viewutil.TestEvent", selector = "0")]
		public function betScript():void
		{
			changeBG(ResName.Bet_Scene);
			
			//=============================================gameinfo			
			_gameinfo.init();
			
			//=============================================paytable
			var arr:Array = _model.getValue("history_win_list");			
			for ( var i:int = 0; i < 10; i++)
			{
				var ran:int = utilFun.Random(3);
				if ( ran == 1) arr.push(ResName.angelball);
				else if ( ran == 2) arr.push(ResName.evilball);
				else arr.push(ResName.Noneball);
				_model.putValue("history_win_list", arr);
			}
			_paytable.init();
			
			//================================================betzone
			_betzone.init();			
			_coin_stack.init();
			_coin.init();
			_sencer.init();
			dispatcher(new ModelEvent("display"));
			
			//=============================================Hintmsg
			_hint.init();
			_hint.display();
			
			//================================================timer
			if ( !_timer.already_countDown)
			{
				_model.putValue(modelName.REMAIN_TIME, 20);					
				_timer.init();
				_timer.display();
			}
			
		}	
		
		[MessageHandler(type = "View.Viewutil.TestEvent", selector = "00")]
		public function test00():void
		{			
			//_settle.init();
			//_tool.SetControlMc(playerzone.ItemList[0]);
			//_tool.SetControlMc(Get(modelName.REMAIN_TIME).container);				
			//_model.putValue(modelName.PLAYER_POKER, ["2d"]);				
			//_model.putValue(modelName.BANKER_POKER, ["2d"]);		
			//_model.putValue(modelName.RIVER_POKER, []);		
			//_poker.prob_cal();
			
			_paytable.prob_percentupdate();
		}		
		
		[MessageHandler(type = "View.Viewutil.TestEvent", selector = "01")]
		public function test01():void
		{			
			_tool.SetControlMc(Get(modelName.HINT_MSG).container);			
		}
		
		[MessageHandler(type = "View.Viewutil.TestEvent", selector = "02")]
		public function test02():void
		{			
			changeBG(ResName.Bet_Scene);
			//================================================timer
			if ( !_timer.already_countDown)
			{
				_model.putValue(modelName.REMAIN_TIME, 20);					
				_timer.init();
				_timer.display();
			}
		}
		
		[MessageHandler(type = "View.Viewutil.TestEvent", selector = "1")]
		public function opencardScript():void
		{			
			_model.putValue(modelName.PLAYER_POKER, []);				
			_model.putValue(modelName.BANKER_POKER, []);		
			_model.putValue(modelName.RIVER_POKER, []);		
			_model.putValue("scirpt_pai", ["1s","2d","3s","5c","6h","9d"]);		
			
			changeBG(ResName.Bet_Scene);
			
			//=============================================gameinfo			
			_gameinfo.init();
			_gameinfo.opencard_parse();
			
			//=============================================paytable
			var arr:Array = _model.getValue("history_win_list");			
			for ( var i:int = 0; i < 10; i++)
			{
				var ran:int = utilFun.Random(3);
				if ( ran == 1) arr.push(ResName.angelball);
				else if ( ran == 2) arr.push(ResName.evilball);
				else arr.push(ResName.Noneball);
				_model.putValue("history_win_list", arr);
			}
			_paytable.init();
			_paytable.opencard_parse();
			
			
			//=============================================Hintmsg
			_hint.init();
			_model.putValue(modelName.GAMES_STATE,gameState.END_BET);
			_hint.hide();			
			
			//================================================poker
			_poker.init();
			dispatcher(new ModelEvent("hide"));
			
			
			
			//================================================settle info
			//_settle.init();
			
			
			//================================================ simu deal
			var arr:Array = ["Player", "Banker", "Player", "Banker", "River", "River"];
			_regular.Call(Get(modelName.PLAYER_POKER).container, { onUpdate:this.fackeDeal, onUpdateParams:[arr] }, 25, 0, 6, "linear");						
		}
		
		public function fackeDeal(type:Array):void
		{
			utilFun.Log("fackeDeal = "+fackeDeal);
			var cardlist:Array = _model.getValue("scirpt_pai");
			
			var card_type:String = type[0];
			var card:String = cardlist[0];
			type.shift();
			cardlist.shift();
			utilFun.Log("card = "+card);
			if ( card_type == "Player")
			{										
				var mypoker:Array = _model.getValue(modelName.PLAYER_POKER);										
				mypoker.push(card);
				_model.putValue(modelName.PLAYER_POKER, mypoker);										
				dispatcher(new Intobject(modelName.PLAYER_POKER, "poker_mi"));				
			}
			else if ( card_type == "Banker")
			{							
				var mypoker:Array = _model.getValue(modelName.BANKER_POKER);										
				mypoker.push( card);										
				_model.putValue(modelName.BANKER_POKER, mypoker);									
				dispatcher(new Intobject(modelName.BANKER_POKER, "poker_mi"));
			}					
			else if ( card_type == "River")
			{							
				var mypoker:Array = _model.getValue(modelName.RIVER_POKER);										
				mypoker.push( card);										
				_model.putValue(modelName.RIVER_POKER, mypoker);										
				dispatcher(new Intobject(modelName.RIVER_POKER, "poker_mi"));
			}					
		}
		
		
		[MessageHandler(type = "View.Viewutil.TestEvent", selector = "2")]
		public function settleScript():void
		{
			_model.putValue(modelName.PLAYER_POKER, ["4d","2s"]);				
			_model.putValue(modelName.BANKER_POKER, ["2s","3s"]);		
			_model.putValue(modelName.RIVER_POKER, ["5c","6c",]);					
			
			
			
			changeBG(ResName.Bet_Scene);
			
			//=============================================gameinfo			
			_gameinfo.init();
			_gameinfo.settle_parse();
			
			
			//=============================================Hintmsg
			//_hint.init();			
			
			//=============================================paytable
			var arr:Array = _model.getValue("history_win_list");			
			for ( var i:int = 0; i < 10; i++)
			{
				var ran:int = utilFun.Random(3);
				if ( ran == 1) arr.push(ResName.angelball);
				else if ( ran == 2) arr.push(ResName.evilball);
				else arr.push(ResName.Noneball);
				_model.putValue("history_win_list", arr);
			}
			_paytable.init();		
			_paytable.settle_parse();
			
			//================================================settle info
			_settle.init();			
			dispatcher(new Intobject(modelName.PLAYER_POKER, "show_judge"));
			dispatcher(new Intobject(modelName.BANKER_POKER, "show_judge"));			
			//摸擬押注
			//_betzone.init();			
			//_coin_stack.init();
			//_betCommand.bet_local(new MouseEvent(MouseEvent.MOUSE_DOWN, true, false), 0);
			//_betCommand.bet_local(new MouseEvent(MouseEvent.MOUSE_DOWN, true, false), 1);
			
			//
			var fakePacket:Object =  { "result_list": [
			                                                                {"bet_type": "BetBWPlayer", "settle_amount": 200, "odds": 2, "win_state": "WSBWFullHouse", "bet_amount": 100 },
																			{"bet_type": "BetBWBanker", "settle_amount": 0, "odds": 0, "win_state": "WSLost", "bet_amount": 100 } ],
																			"game_state": "EndRoundState", 
																			"game_result_id": "225761", 
																			"timestamp": 1439967961.396191, 
																			"remain_time": 4, 
																			"game_type": "BigWin", 
																			"game_round": 1, 
																			"game_id": "BigWin-1", 
																			"message_type": 
																			"MsgBPEndRound", 
			"id": "bfc643be464011e599caf23c9189e2a9" } ;
			
			_MsgModel.push(fakePacket);			
			
		}
		
		public function up(e:Event, idx:int):Boolean
		{			
			return true;
		}	
		
	}

}