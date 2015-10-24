package View.ViewComponent 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import View.ViewBase.Visual_Text;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.*;
	import Res.ResName;
	import caurina.transitions.Tweener;
	
	/**
	 * timer present way
	 * @author ...
	 */
	public class Visual_themes  extends VisualHandler
	{
		public const bigwinfire:String = "bigwin_fire";
		public const lottymsg:String = "lotty_msg";	
		
		public function Visual_themes() 
		{
			
		}
		
		public function init():void
		{
			var secondhint:MultiObject = prepare("second_hint", new MultiObject()  , GetSingleItem("_view").parent.parent);
			secondhint.Create_by_list(1, [ResName.secondhint], 0, 0, 1, 0, 0, "time_");
			secondhint.container.x = 458.6; 
			secondhint.container.y = 381.7;			
			
			
			var besthint:MultiObject = prepare("besthint", new MultiObject()  , GetSingleItem("_view").parent.parent);
			besthint.Create_by_list(1, [ResName.besthint], 0, 0, 1, 0, 0, "time_");
			besthint.container.x = 417.9;
			besthint.container.y = 81.95;
			
			//金幣泉
			var bigwinfire:MultiObject = create("lotty_fire", [bigwinfire]);
			bigwinfire.Create_(1, "lotty_fire");
			bigwinfire.container.x = 140;
			bigwinfire.container.y = -90;
			setFrame("lotty_fire", 1);
			
			//大獎字樣集
			var lottymsg:MultiObject = create("lottymsg",  [lottymsg]);
			lottymsg.Create_(1, "lottymsg");
			lottymsg.container.x = 1111;
			lottymsg.container.y = 500;		
			setFrame("lottymsg", 1);
			
		   //_tool.SetControlMc(lottymsg.container);
		   //_tool.y = 200;
			//add(_tool);
		}
		
		[MessageHandler(type = "ConnectModule.websocket.WebSoketInternalMsg", selector = "specail_round")]
		public function sp():void
		{
			GetSingleItem("besthint").gotoAndStop(2);
			_regular.Twinkle_by_JumpFrame(GetSingleItem("besthint"), 30, 90, 2, 3);
			
			GetSingleItem("second_hint").gotoAndStop(2);
		}	
		
		[MessageHandler(type = "ConnectModule.websocket.WebSoketInternalMsg", selector = "win_hint")]
		public function winhint():void
		{
			//hide spical item
			GetSingleItem("besthint").gotoAndStop(1);
			Tweener.pauseTweens(GetSingleItem("besthint"));
			GetSingleItem("second_hint").gotoAndStop(1);
			
			GetSingleItem("lottymsg").gotoAndStop(1);
			GetSingleItem("lotty_fire").gotoAndStop(1);
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "lotty_first_ok")]
		public function fist_ball_ok():void
		{
			//TODO first ball no
			GetSingleItem("second_hint").gotoAndStop(3);
			var ball:Array = _model.getValue(modelName.SPCIAL_BALL);			
			GetSingleItem("second_hint")["lobbyNum"].text = ball[0];
			
			
			
			//wait seoncball
			utilFun.SetTime(myse, 1);
			
		}
		
		public function myse():void
		{
			GetSingleItem("second_hint").gotoAndStop(4);
			//dispatcher(new ModelEvent("pick_seond_ball"));
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "pan_ok")]		
		public function pan_ok():void
		{			
			
			GetSingleItem("second_hint").gotoAndStop(5);
			var ball:Array = _model.getValue(modelName.SPCIAL_BALL);			
			GetSingleItem("second_hint")["panNum"].text = ball[1];
			
			//fire
			var ball:Array = _model.getValue(modelName.SPCIAL_BALL);
			GetSingleItem("lottymsg").gotoAndStop(2);
			
			var lo:int = ball[0];
			var arr:Array = utilFun.arrFormat(lo, 2);			
			if ( arr[0] == 0 ) arr[0] = 10;
			if ( arr[1] == 0 ) arr[1] = 10;
			GetSingleItem("lottymsg")["_num_0"].gotoAndStop(arr[0]);
			GetSingleItem("lottymsg")["_num_1"].gotoAndStop(arr[1]);
			utilFun.scaleXY(Get("lottymsg").container,4.0, 4.0);
			Get("lottymsg").container.alpha = 0;			
			Tweener.addTween(Get("lottymsg").container, { scaleX: 1, scaleY:1, alpha: 1, time:0.5, transition:"easeInQuart",onComplete:this.fire } );		
			
			
			
		}
		
		public function fire():void 
		{
			GetSingleItem("lotty_fire").gotoAndPlay(2);
		}
	}

}