package View.ViewComponent 
{	
	import Model.ModelEvent;
	import View.ViewBase.VisualHandler;		
	import util.*;
	
	import View.Viewutil.*;
	import Res.ResName;	
	import View.GameView.gameState;
	import Model.modelName;
	
	import Command.*;
	
	import caurina.transitions.Tweener;
	
	/**
	 * Visual_betTimer
	 * @author David
	 */
	public class Visual_betTimer  extends VisualHandler
	{
		[Inject]
		public var _betDelayCommand:BetDelayCommand;	
		
		[Inject]
		public var _betCommnad:BetCommand;
		
		private var _bet_timer:MultiObject;
		
		public const NEW_SECOND:int = 1;
		private var sec:int = -1;
		private var current_table:int = -1;
		
		public function Visual_betTimer() 
		{
			
		}
		
		public function init():void
		{			
			
			//倒數
			_bet_timer = prepare("bet_timer", new MultiObject(), GetSingleItem("_view").parent.parent);
			_bet_timer.container.x = 1733.85;
			_bet_timer.container.y = 161.3;
			_bet_timer.Create_by_list(1,  [ResName.Bet_timer], 0 , 0, 1, 0, 47, "Bet_timer_");	
		   
		    // utilFun.scaleXY(Get("bet_timer").container, 0.8, 0.8);
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "display")]
		public function display():void
		{	
			Get("bet_timer").container.visible = false;
			GetSingleItem("bet_timer", 0).visible = false;
			 setFrame("bet_timer", 2);
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "timerStart")]
		public function TimerStart(msg:ModelEvent):void {
			var table:int = msg.Value;
			
			if (current_table > -1 && table != current_table) {
				StopCurrentTimer();
			}else {
				Tweener.removeTweens(GetSingleItem("bet_timer", 0));
			}
			
			sec = NEW_SECOND;
			var time:int = sec;
			frame_setting_way(0, time);
				
			//讓秒數計到-1，方便判斷hide bet_timer元件
			var update_count:int = time + 1;
			Tweener.addCaller(GetSingleItem("bet_timer", 0), {  time:update_count , count: update_count, onUpdate:TimeCount,  transition:"linear" } );
			
			current_table = table;
				
			//GetSingleItem("bet_timer", 0).visible = true;
			
			var idx:int = _betCommnad.Find_Bet_type_idx(current_table);
			_bet_timer.container.y = GetSingleItem("betamount_add", idx).y + 160;
		}
		
		private function TimeCount():void
		{			
			var time:int  = sec - 1;
			if ( time < 0) {
				StopCurrentTimer();
				return;
			}

			frame_setting_way(0, time);		
			
			sec = time;
		}
		
		public function StopCurrentTimer():void {
			
			if (current_table > -1) {
				Tweener.removeTweens(GetSingleItem("bet_timer", 0));
				
				_betDelayCommand.sendDelayBet(current_table);
			
				GetSingleItem("bet_timer", 0).visible = false;
				
				current_table = -1;	
				
			}
		}
		
		public function frame_setting_way(idx:int, time:int):void
		{
			var arr:Array = utilFun.arrFormat(time, 2);
			if ( arr[0] == 0 ) arr[0] = 10;
			if ( arr[1] == 0 ) arr[1] = 10;
			GetSingleItem("bet_timer", idx)["_num_0"].gotoAndStop(arr[0]);
			GetSingleItem("bet_timer", idx)["_num_1"].gotoAndStop(arr[1]);
		}		
		
	}

}