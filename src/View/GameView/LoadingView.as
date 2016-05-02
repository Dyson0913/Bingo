package View.GameView
{
	import Command.*;
	import ConnectModule.websocket.WebSoketInternalMsg;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;	
	import flash.text.TextField;
	import Model.valueObject.Intobject;
	import Res.ResName;
	import util.DI;
	import util.node;
	import View.ViewBase.ViewBase;
	import Command.DataOperation;
	import flash.text.TextFormat;
	import View.ViewComponent.*;
	import View.Viewutil.*;
	
	import Model.*;
	import util.utilFun;
	import caurina.transitions.Tweener;	
	
	/**
	 * ...
	 * @author hhg
	 */

	 
	public class LoadingView extends ViewBase
	{	
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _sound:SoundCommand;
		
		[Inject]
		public var _test:Visual_testInterface;
		
		public function LoadingView()  
		{
			
		}
		
			//result:Object
		public function FirstLoad(para:Array ):void
 		{			
			//dispatcher(new Intobject(modelName.openball, ViewCommand.SWITCH));		
			//return;
			
			
			_model.putValue("bingo_color", [0x41A0F0, 0xF01E1E, 0xB9B9B9, 0x23C323, 0xFFDE00]);
			
			_model.putValue("SelectRoomInfo",[]);
			
			_model.putValue("is_betarr",[]);
			_model.putValue("ballarr",[]);
			_model.putValue("table", []);
			
			_model.putValue(modelName.SELF_BET,[]);
			
			_model.putValue(modelName.Game_Name, "Bingo");
			//2,開球 3,best 3
			_model.putValue("select_openball_view_info", 2);
			
			_model.putValue(modelName.BINGO_TABLE, []);
			_model.putValue(modelName.BINGO_HISTORY, []);
			
			_model.putValue(modelName.UUID,  para[0]);
			_model.putValue(modelName.CREDIT, para[1]);
			_model.putValue(modelName.Client_ID, para[2]);
			_model.putValue(modelName.HandShake_chanel, para[3]);
			_model.putValue(modelName.Domain_Name, para[4]);
			
			_betCommand.bet_init();
			_sound.init();
			
			_model.putValue("lobby_disconnect", false);
			
			//FORTEST			
			//debug-3 pan
			//var result:Object = {"table_bet_info": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], "game_state": "OpenState", "room_no": 0, "timestamp": 1454144708.981233, "remain_time": 0, "game_type": "Bingo", "open_info": {"best_list": [{"table_no": 5, "ball_list": []}], "best_remain": 12, "opened_history": [35, 38, 67, 72, 10, 27, 12, 48, 22, 17, 6], "current_ball": 32, "second_list": [{"table_no": 21, "ball_list": []}], "waitting_ball": [14, 57], "second_remain": 16}, "game_round": 23, "table_info": [{"table_no": 0, "ball_list": [6, 7, 10, 13, 14, 16, 20, 21, 24, 27, 31, 33, 35, 39, 48, 53, 54, 56, 60, 61, 65, 71, 72, 74]}, {"table_no": 1, "ball_list": [5, 7, 8, 11, 14, 17, 20, 22, 27, 29, 34, 35, 41, 44, 47, 48, 50, 51, 59, 61, 62, 64, 74, 75]}, {"table_no": 2, "ball_list": [4, 7, 9, 13, 15, 16, 17, 24, 27, 29, 33, 34, 35, 37, 52, 53, 54, 55, 56, 65, 66, 67, 71, 75]}, {"table_no": 3, "ball_list": [6, 11, 12, 13, 15, 17, 19, 21, 29, 30, 31, 34, 42, 45, 48, 52, 53, 57, 59, 61, 65, 69, 73, 74]}, {"table_no": 4, "ball_list": [4, 5, 6, 8, 12, 16, 17, 23, 25, 27, 31, 38, 43, 44, 47, 48, 49, 53, 56, 65, 66, 67, 68, 71]}, {"table_no": 5, "ball_list": [3, 6, 10, 12, 14, 17, 20, 22, 23, 27, 32, 35, 38, 43, 46, 48, 49, 56, 57, 61, 67, 72, 73, 75]}, {"table_no": 6, "ball_list": [5, 6, 7, 9, 15, 16, 20, 23, 24, 28, 39, 42, 44, 45, 51, 52, 53, 58, 60, 61, 65, 67, 72, 74]}, {"table_no": 7, "ball_list": [1, 3, 7, 13, 14, 18, 23, 24, 26, 30, 33, 39, 42, 44, 48, 49, 52, 58, 60, 67, 68, 69, 70, 73]}, {"table_no": 8, "ball_list": [5, 6, 10, 12, 15, 20, 22, 23, 24, 26, 33, 36, 39, 45, 46, 50, 55, 57, 59, 63, 66, 69, 73, 75]}, {"table_no": 9, "ball_list": [4, 7, 8, 14, 15, 16, 20, 23, 24, 26, 31, 41, 42, 44, 48, 49, 50, 54, 60, 61, 64, 66, 71, 75]}, {"table_no": 10, "ball_list": [4, 6, 8, 9, 14, 16, 18, 25, 27, 28, 33, 36, 43, 44, 52, 54, 55, 57, 60, 63, 66, 67, 69, 74]}, {"table_no": 11, "ball_list": [2, 7, 11, 12, 14, 17, 18, 22, 24, 26, 39, 40, 43, 44, 46, 51, 52, 59, 60, 62, 69, 71, 74, 75]}, {"table_no": 12, "ball_list": [4, 6, 7, 13, 15, 18, 19, 21, 25, 27, 33, 35, 38, 43, 48, 51, 52, 53, 54, 66, 70, 71, 72, 75]}, {"table_no": 13, "ball_list": [1, 4, 8, 9, 13, 17, 21, 26, 27, 28, 36, 39, 40, 43, 46, 47, 57, 59, 60, 61, 62, 63, 69, 72]}, {"table_no": 14, "ball_list": [1, 8, 9, 10, 14, 16, 18, 19, 23, 24, 39, 40, 42, 45, 48, 49, 51, 55, 60, 70, 71, 72, 73, 74]}, {"table_no": 15, "ball_list": [6, 8, 11, 12, 14, 16, 22, 23, 27, 29, 36, 38, 39, 41, 51, 54, 58, 59, 60, 66, 67, 70, 72, 75]}, {"table_no": 16, "ball_list": [2, 7, 10, 12, 14, 19, 22, 26, 27, 28, 32, 33, 42, 44, 47, 49, 50, 56, 59, 65, 68, 72, 74, 75]}, {"table_no": 17, "ball_list": [4, 5, 9, 10, 13, 18, 20, 24, 27, 30, 33, 36, 39, 45, 46, 48, 52, 56, 58, 63, 65, 67, 68, 71]}, {"table_no": 18, "ball_list": [1, 3, 6, 13, 14, 19, 24, 26, 27, 28, 31, 32, 39, 45, 47, 49, 50, 53, 58, 63, 66, 70, 71, 74]}, {"table_no": 19, "ball_list": [1, 2, 4, 11, 12, 22, 25, 26, 28, 29, 38, 39, 44, 45, 46, 47, 50, 56, 59, 61, 64, 67, 68, 71]}, {"table_no": 20, "ball_list": [3, 7, 10, 14, 15, 16, 20, 25, 28, 30, 31, 35, 39, 41, 54, 56, 57, 58, 60, 66, 69, 70, 72, 75]}, {"table_no": 21, "ball_list": [3, 6, 7, 10, 12, 16, 19, 22, 27, 29, 31, 32, 38, 44, 48, 51, 53, 55, 58, 62, 63, 65, 70, 75]}, {"table_no": 22, "ball_list": [3, 8, 11, 13, 15, 20, 21, 25, 27, 28, 37, 41, 42, 44, 50, 53, 54, 55, 59, 66, 70, 71, 72, 74]}, {"table_no": 23, "ball_list": [1, 4, 10, 11, 12, 17, 20, 21, 22, 23, 32, 40, 41, 44, 48, 49, 50, 53, 57, 61, 69, 71, 73, 75]}, {"table_no": 24, "ball_list": [1, 4, 10, 14, 15, 17, 18, 20, 21, 28, 35, 37, 39, 43, 47, 53, 56, 58, 60, 61, 62, 64, 74, 75]}, {"table_no": 25, "ball_list": [2, 6, 8, 11, 15, 16, 19, 23, 24, 26, 31, 36, 43, 44, 47, 49, 54, 55, 60, 62, 67, 69, 70, 73]}, {"table_no": 26, "ball_list": [1, 6, 8, 10, 15, 18, 19, 20, 22, 25, 31, 36, 38, 40, 50, 55, 56, 57, 59, 64, 65, 68, 70, 72]}, {"table_no": 27, "ball_list": [1, 3, 5, 8, 13, 16, 17, 21, 25, 27, 32, 41, 43, 44, 46, 47, 50, 53, 57, 62, 63, 66, 70, 73]}, {"table_no": 28, "ball_list": [5, 6, 8, 10, 14, 18, 19, 21, 23, 28, 31, 40, 43, 44, 46, 52, 54, 56, 60, 61, 65, 66, 69, 74]}, {"table_no": 29, "ball_list": [1, 4, 5, 6, 8, 18, 21, 23, 24, 29, 31, 37, 39, 41, 54, 55, 58, 59, 60, 65, 67, 68, 70, 75]}, {"table_no": 30, "ball_list": [8, 10, 11, 14, 15, 17, 21, 22, 27, 29, 33, 34, 37, 39, 46, 49, 55, 58, 59, 63, 66, 69, 70, 75]}, {"table_no": 31, "ball_list": [4, 5, 7, 14, 15, 16, 19, 20, 23, 24, 36, 37, 41, 44, 46, 47, 50, 57, 58, 64, 67, 68, 69, 74]}, {"table_no": 32, "ball_list": [3, 6, 9, 12, 14, 19, 23, 24, 28, 30, 34, 38, 43, 44, 46, 50, 52, 53, 58, 62, 64, 66, 72, 75]}, {"table_no": 33, "ball_list": [1, 4, 10, 13, 15, 18, 22, 23, 27, 28, 33, 40, 41, 42, 47, 49, 50, 55, 58, 63, 65, 66, 69, 71]}, {"table_no": 34, "ball_list": [5, 7, 9, 13, 14, 21, 27, 28, 29, 30, 33, 36, 39, 43, 46, 47, 48, 49, 60, 64, 66, 67, 68, 72]}, {"table_no": 35, "ball_list": [3, 7, 11, 12, 13, 19, 22, 23, 24, 27, 31, 36, 39, 41, 47, 48, 54, 55, 57, 65, 69, 70, 71, 72]}, {"table_no": 36, "ball_list": [1, 6, 10, 12, 13, 16, 20, 22, 23, 28, 40, 41, 42, 45, 46, 49, 54, 55, 57, 64, 68, 70, 73, 74]}, {"table_no": 37, "ball_list": [2, 5, 7, 14, 15, 17, 19, 20, 24, 29, 32, 34, 37, 42, 47, 50, 51, 59, 60, 61, 62, 66, 68, 72]}, {"table_no": 38, "ball_list": [6, 7, 8, 13, 14, 18, 20, 23, 27, 29, 31, 34, 37, 40, 48, 50, 54, 56, 60, 61, 63, 65, 68, 74]}, {"table_no": 39, "ball_list": [5, 8, 9, 10, 14, 16, 17, 25, 26, 29, 33, 34, 40, 44, 47, 50, 52, 55, 58, 61, 62, 67, 73, 75]}, {"table_no": 40, "ball_list": [2, 3, 6, 11, 12, 18, 20, 25, 27, 29, 38, 43, 44, 45, 46, 50, 51, 57, 60, 66, 67, 70, 71, 72]}, {"table_no": 41, "ball_list": [7, 10, 13, 14, 15, 25, 26, 27, 28, 29, 33, 34, 38, 40, 51, 52, 54, 55, 59, 65, 66, 73, 74, 75]}, {"table_no": 42, "ball_list": [5, 8, 9, 10, 14, 22, 23, 26, 27, 30, 34, 35, 40, 43, 46, 52, 53, 54, 59, 64, 67, 70, 73, 74]}, {"table_no": 43, "ball_list": [6, 9, 10, 11, 14, 17, 20, 23, 28, 30, 33, 36, 39, 42, 49, 52, 53, 57, 60, 64, 66, 69, 70, 75]}, {"table_no": 44, "ball_list": [2, 6, 8, 11, 12, 17, 21, 22, 25, 29, 31, 37, 42, 43, 48, 49, 56, 58, 60, 68, 70, 72, 73, 74]}, {"table_no": 45, "ball_list": [2, 4, 9, 10, 14, 16, 20, 21, 24, 30, 32, 36, 39, 44, 47, 48, 49, 55, 56, 63, 66, 67, 73, 75]}, {"table_no": 46, "ball_list": [5, 6, 9, 10, 14, 16, 19, 24, 25, 30, 32, 33, 36, 40, 48, 52, 54, 57, 60, 68, 69, 70, 71, 72]}, {"table_no": 47, "ball_list": [3, 6, 8, 13, 15, 23, 24, 26, 29, 30, 32, 39, 43, 45, 48, 51, 55, 56, 59, 63, 67, 69, 72, 75]}, {"table_no": 48, "ball_list": [1, 4, 5, 8, 14, 17, 19, 23, 24, 26, 35, 38, 40, 43, 47, 53, 54, 57, 58, 61, 63, 70, 71, 74]}, {"table_no": 49, "ball_list": [1, 6, 7, 10, 13, 16, 17, 18, 27, 30, 35, 37, 38, 43, 48, 54, 58, 59, 60, 61, 65, 66, 71, 74]}, {"table_no": 50, "ball_list": [1, 2, 9, 11, 13, 16, 17, 21, 22, 23, 35, 36, 39, 42, 49, 50, 51, 52, 53, 62, 63, 72, 73, 75]}, {"table_no": 51, "ball_list": [2, 3, 4, 7, 10, 20, 26, 27, 28, 29, 38, 39, 41, 42, 47, 48, 53, 55, 60, 61, 65, 66, 70, 75]}, {"table_no": 52, "ball_list": [5, 9, 10, 12, 14, 17, 18, 25, 27, 28, 38, 42, 44, 45, 46, 54, 56, 57, 58, 62, 64, 66, 67, 68]}, {"table_no": 53, "ball_list": [1, 4, 7, 8, 10, 21, 25, 26, 27, 29, 31, 32, 36, 37, 48, 57, 58, 59, 60, 62, 64, 65, 66, 73]}, {"table_no": 54, "ball_list": [2, 4, 5, 13, 14, 17, 18, 21, 25, 26, 33, 34, 36, 45, 46, 50, 53, 55, 60, 61, 67, 71, 72, 74]}, {"table_no": 55, "ball_list": [1, 6, 10, 13, 14, 20, 23, 24, 27, 29, 32, 33, 34, 45, 48, 51, 52, 54, 55, 64, 68, 69, 72, 75]}, {"table_no": 56, "ball_list": [1, 5, 7, 8, 14, 25, 26, 28, 29, 30, 31, 34, 37, 44, 47, 50, 53, 55, 60, 61, 62, 65, 71, 72]}, {"table_no": 57, "ball_list": [1, 6, 8, 13, 14, 16, 21, 25, 27, 28, 33, 36, 40, 44, 49, 54, 57, 59, 60, 67, 68, 71, 74, 75]}, {"table_no": 58, "ball_list": [3, 4, 6, 8, 14, 17, 18, 20, 23, 27, 34, 42, 43, 45, 46, 50, 51, 58, 59, 63, 64, 65, 68, 69]}, {"table_no": 59, "ball_list": [4, 8, 9, 12, 14, 17, 18, 21, 26, 30, 35, 36, 38, 41, 48, 49, 54, 55, 57, 62, 67, 68, 71, 75]}, {"table_no": 60, "ball_list": [1, 2, 9, 10, 12, 16, 17, 18, 28, 30, 31, 32, 35, 39, 53, 54, 56, 58, 60, 61, 65, 69, 70, 74]}, {"table_no": 61, "ball_list": [1, 8, 12, 13, 14, 16, 17, 24, 26, 28, 32, 37, 39, 44, 46, 47, 53, 56, 60, 61, 62, 70, 71, 75]}, {"table_no": 62, "ball_list": [1, 9, 10, 13, 14, 19, 22, 24, 26, 29, 33, 34, 35, 36, 47, 50, 51, 53, 57, 61, 62, 70, 73, 75]}, {"table_no": 63, "ball_list": [4, 9, 13, 14, 15, 19, 20, 25, 26, 28, 35, 37, 38, 42, 49, 53, 54, 55, 58, 61, 62, 65, 66, 68]}, {"table_no": 64, "ball_list": [3, 5, 11, 13, 15, 18, 21, 26, 27, 28, 31, 38, 39, 40, 46, 47, 53, 57, 59, 64, 66, 71, 72, 75]}, {"table_no": 65, "ball_list": [2, 9, 11, 12, 15, 16, 19, 22, 27, 30, 33, 35, 38, 45, 47, 51, 53, 54, 58, 64, 66, 67, 70, 75]}, {"table_no": 66, "ball_list": [9, 11, 13, 14, 15, 20, 22, 23, 26, 30, 31, 38, 39, 45, 47, 51, 52, 56, 58, 69, 70, 71, 72, 75]}, {"table_no": 67, "ball_list": [3, 4, 5, 9, 11, 16, 20, 21, 23, 26, 34, 40, 42, 44, 50, 52, 53, 56, 57, 65, 66, 69, 71, 74]}, {"table_no": 68, "ball_list": [1, 3, 6, 12, 14, 24, 25, 27, 28, 30, 38, 41, 43, 45, 46, 47, 54, 56, 60, 63, 66, 68, 71, 74]}, {"table_no": 69, "ball_list": [2, 5, 7, 8, 10, 19, 20, 21, 24, 30, 31, 36, 39, 45, 48, 50, 52, 53, 54, 63, 64, 68, 73, 74]}, {"table_no": 70, "ball_list": [6, 7, 8, 10, 14, 16, 23, 24, 28, 29, 37, 39, 41, 44, 46, 48, 53, 54, 60, 63, 69, 70, 71, 74]}, {"table_no": 71, "ball_list": [5, 6, 7, 8, 13, 24, 25, 27, 29, 30, 32, 34, 36, 40, 46, 48, 49, 50, 54, 65, 68, 70, 72, 73]}, {"table_no": 72, "ball_list": [3, 6, 11, 14, 15, 16, 17, 20, 23, 25, 32, 37, 42, 44, 46, 49, 51, 55, 60, 66, 67, 72, 74, 75]}, {"table_no": 73, "ball_list": [3, 7, 8, 10, 15, 19, 21, 22, 23, 26, 35, 36, 41, 42, 47, 48, 50, 58, 60, 61, 64, 65, 66, 69]}, {"table_no": 74, "ball_list": [5, 7, 8, 11, 15, 17, 19, 20, 23, 30, 37, 41, 42, 44, 51, 52, 53, 57, 58, 62, 64, 66, 69, 70]}, {"table_no": 75, "ball_list": [2, 3, 5, 6, 12, 17, 18, 19, 24, 28, 33, 34, 40, 42, 49, 52, 56, 57, 58, 61, 63, 65, 70, 74]}, {"table_no": 76, "ball_list": [2, 5, 6, 12, 15, 19, 21, 23, 29, 30, 32, 38, 43, 44, 46, 47, 49, 50, 53, 61, 65, 68, 72, 73]}, {"table_no": 77, "ball_list": [3, 5, 10, 12, 14, 22, 23, 26, 27, 30, 36, 37, 43, 44, 46, 50, 51, 54, 55, 62, 64, 69, 73, 74]}, {"table_no": 78, "ball_list": [2, 3, 4, 9, 11, 18, 22, 25, 29, 30, 37, 40, 44, 45, 48, 52, 57, 58, 59, 61, 65, 67, 68, 73]}, {"table_no": 79, "ball_list": [1, 3, 5, 11, 12, 17, 19, 20, 23, 27, 31, 34, 37, 42, 46, 49, 51, 53, 54, 61, 66, 69, 71, 74]}, {"table_no": 80, "ball_list": [3, 4, 8, 12, 14, 16, 20, 26, 28, 29, 32, 34, 39, 42, 50, 51, 53, 54, 60, 61, 64, 65, 71, 74]}, {"table_no": 81, "ball_list": [1, 3, 6, 12, 15, 17, 26, 28, 29, 30, 33, 41, 43, 45, 47, 49, 53, 56, 57, 62, 63, 71, 74, 75]}, {"table_no": 82, "ball_list": [1, 6, 8, 10, 12, 18, 21, 24, 27, 28, 31, 34, 35, 43, 51, 54, 56, 58, 60, 61, 63, 64, 70, 72]}, {"table_no": 83, "ball_list": [1, 2, 8, 10, 14, 16, 19, 20, 24, 29, 34, 35, 41, 45, 47, 50, 52, 56, 57, 63, 64, 65, 67, 70]}, {"table_no": 84, "ball_list": [5, 7, 9, 10, 12, 16, 19, 20, 24, 28, 31, 33, 34, 41, 49, 50, 52, 57, 60, 65, 67, 68, 71, 72]}, {"table_no": 85, "ball_list": [6, 8, 11, 14, 15, 16, 17, 18, 22, 26, 33, 34, 36, 39, 48, 50, 53, 56, 59, 63, 66, 67, 68, 74]}, {"table_no": 86, "ball_list": [4, 11, 12, 14, 15, 18, 19, 21, 23, 28, 33, 36, 43, 44, 53, 55, 57, 59, 60, 61, 64, 67, 69, 74]}, {"table_no": 87, "ball_list": [7, 9, 11, 13, 14, 21, 23, 26, 28, 30, 35, 39, 44, 45, 52, 55, 56, 58, 60, 66, 69, 72, 73, 74]}, {"table_no": 88, "ball_list": [5, 8, 11, 12, 14, 16, 18, 19, 21, 23, 31, 32, 36, 37, 48, 54, 56, 57, 58, 61, 66, 73, 74, 75]}, {"table_no": 89, "ball_list": [1, 5, 7, 9, 15, 22, 23, 25, 28, 29, 31, 32, 33, 36, 46, 47, 49, 50, 52, 63, 70, 71, 72, 75]}, {"table_no": 90, "ball_list": [8, 9, 10, 11, 14, 16, 18, 19, 22, 30, 32, 33, 35, 45, 47, 48, 49, 58, 59, 61, 62, 64, 67, 69]}, {"table_no": 91, "ball_list": [1, 2, 6, 10, 15, 17, 19, 21, 23, 29, 35, 42, 44, 45, 47, 52, 53, 54, 59, 66, 67, 68, 70, 71]}, {"table_no": 92, "ball_list": [1, 6, 11, 14, 15, 17, 19, 24, 28, 30, 33, 40, 41, 43, 50, 52, 56, 58, 60, 62, 64, 66, 71, 73]}, {"table_no": 93, "ball_list": [1, 4, 5, 9, 10, 22, 23, 24, 27, 29, 32, 37, 38, 44, 47, 48, 50, 53, 60, 62, 63, 67, 73, 74]}, {"table_no": 94, "ball_list": [1, 3, 7, 8, 13, 17, 23, 24, 29, 30, 36, 40, 42, 43, 46, 48, 51, 55, 57, 61, 67, 69, 71, 73]}, {"table_no": 95, "ball_list": [2, 3, 5, 6, 10, 19, 20, 24, 28, 29, 31, 35, 36, 42, 46, 48, 49, 55, 59, 61, 63, 64, 68, 71]}, {"table_no": 96, "ball_list": [2, 7, 9, 13, 15, 17, 19, 23, 24, 25, 31, 32, 34, 45, 46, 49, 50, 52, 60, 61, 64, 68, 69, 72]}, {"table_no": 97, "ball_list": [1, 8, 9, 13, 15, 18, 19, 23, 24, 27, 33, 37, 40, 41, 48, 49, 55, 57, 58, 61, 64, 66, 67, 70]}, {"table_no": 98, "ball_list": [2, 5, 8, 9, 12, 18, 24, 26, 29, 30, 34, 37, 39, 44, 47, 48, 53, 57, 58, 62, 66, 69, 72, 75]}, {"table_no": 99, "ball_list": [1, 2, 8, 13, 15, 17, 20, 22, 24, 30, 33, 35, 44, 45, 48, 49, 51, 55, 57, 63, 69, 71, 73, 74]}], "game_id": "Bingo-1", "message_type": "MsgBGRoomInitialInfo", "id": "8fd03112c73011e5a6d0f23c9189e2a9"}
			//var arr_lat:Array = result.table_info;						
			//var num:int= arr_lat.length;			
			//var balls:Array = _model.getValue("ballarr");
			//var table_no:Array = _model.getValue("table");							
			//for (var  i:int = 0; i < num ; i++)
			//{				
				//balls.push( arr_lat[i].ball_list);
				//table_no.push( arr_lat[i].table_no);
			//}			
			//_model.putValue("ballarr",balls);
			//_model.putValue("table", table_no);
			
			//TODO 沒經過betview不會有,沒押注也不會有
			_model.putValue("SomeOne_bet", 0);
			_model.putValue("NoOne_bet", 0);
			_model.putValue("history_opened_ball", []);		
			
			dispatcher(new Intobject(modelName.Loading, ViewCommand.SWITCH));			
			//dispatcher(new Intobject(modelName.Bet, ViewCommand.SWITCH) );			
		}
		
		[MessageHandler(type="Model.valueObject.Intobject",selector="EnterView")]
		override public function EnterView (View:Intobject):void
		{
			utilFun.Log("LoadingView EnterView"+View.Value);
			if (View.Value != modelName.Loading) return;
			super.EnterView(View);
			var view:MultiObject = prepare("_view", new MultiObject() , this);
			view.Create_by_list(1, [ResName.empty], 0, 0, 1, 0, 0, "a_");			
			
			
			if ( CONFIG::debug ) 
			{
				_test.init();
			}else {
				utilFun.SetTime(connet, 0.1);
			}
			
		}
		private function connet():void
		{	
			dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.CONNECT));
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="LeaveView")]
		override public function ExitView(View:Intobject):void
		{
			if (View.Value != modelName.Loading) return;
			super.ExitView(View);
			utilFun.Log("LoadingView ExitView");
		}
		
		
	}

}