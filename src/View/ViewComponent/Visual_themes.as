package View.ViewComponent 
{
	import flash.display.DisplayObjectContainer;
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
	
	import flash.filters.*;
	
	/**
	 * timer present way
	 * @author ...
	 */
	public class Visual_themes  extends VisualHandler
	{
		[Inject]
		public var _betCommand:BetCommand;
		
		public const bigwinfire:String = "bigwin_fire";
		public const lottymsg:String = "lotty_msg";	
		public const Dark:String = "Dark";
		
		public const Res_switchbtn:String = "switch_btn";
		
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
			
			//押暗
			//var DarkItem:MultiObject = create("Dark",  [Dark]);			
			//DarkItem.Create_(1, "Dark");
			//GetSingleItem("Dark")["_bg"].alpha = 0;
			
			//金幣泉
			var bigwinfire:MultiObject = create("lotty_fire", [bigwinfire]);
			bigwinfire.Create_(1, "lotty_fire");
			bigwinfire.container.x = 90;
			bigwinfire.container.y = -140;
			setFrame("lotty_fire", 1);
			
			//大獎字樣集
			var lottymsg:MultiObject = create("lottymsg",  [lottymsg]);
			lottymsg.Create_(1, "lottymsg");
			lottymsg.container.x = 1000;
			lottymsg.container.y = 300;
			setFrame("lottymsg", 1);
			
			//自己無押注,不產生切換鈕	
			if ( _betCommand.get_my_betlist().length != 0) 
			{				
				//畫面按鈕,在押暗後生成,才按的到
				var switchbtn:MultiObject = create("switchbtn", [Res_switchbtn]);
				switchbtn.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [1, 2, 2, 1]);			
				switchbtn.mousedown = switch_panel;
				switchbtn.mouseup = empty_reaction;
				switchbtn.rollout = empty_reaction;
				switchbtn.rollover = empty_reaction;
				switchbtn.container.x = 1770;
				switchbtn.container.y = 1000;
				switchbtn.Create_(1, "switchbtn");
			}			
			
		    //_tool.SetControlMc(Roller_Num.container);
		    //_tool.y = 200;
			//add(_tool);
			
			GetSingleItem("_view")["_CurBal"].visible = true;
		}
		
		public function switch_panel(e:Event, idx:int):Boolean
		{
			var pan_75ball:MultiObject = Get("ball_pan");
			var ticket:MultiObject = Get("ticket");
			if ( pan_75ball.container.visible )
			{
			   pan_75ball.container.visible = false;
			   ticket.container.visible = true;
			}
			else
			{
				pan_75ball.container.visible = true;
			   ticket.container.visible = false;
			}
			
			
			return true;
		}
		
		[MessageHandler(type = "ConnectModule.websocket.WebSoketInternalMsg", selector = "specail_round")]
		public function sp():void
		{
			GetSingleItem("besthint").gotoAndStop(2);
			//TODO wintype _wintype
			//GetSingleItem("besthint")[" _wintype"].gotoAndStop(2);
			
			_regular.Twinkle_by_JumpFrame(GetSingleItem("besthint"), 30, 90, 2, 3);
			
			GetSingleItem("second_hint").gotoAndStop(2);
			
			GetSingleItem("_view")["_CurBal"].visible = false;
			
		}	
		
		[MessageHandler(type = "ConnectModule.websocket.WebSoketInternalMsg", selector = "win_hint")]
		public function winhint():void
		{
			//hide spical item
			GetSingleItem("Dark")["_bg"].alpha = 0;
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
			GetSingleItem("Dark")["_bg"].alpha = 0.5;
			GetSingleItem("second_hint").gotoAndStop(5);
			var ball:Array = _model.getValue(modelName.SPCIAL_BALL);			
			GetSingleItem("second_hint")["panNum"].text = ball[1];
			
			//fire			
			//TODO wintype _wintype
			GetSingleItem("lottymsg").gotoAndStop(2);			
			//GetSingleItem("lottymsg").gotoAndStop(1);
			
			
			var lo:int = ball[0];
			var arr:Array = utilFun.arrFormat(lo, 2);			
			if ( arr[0] == 0 ) arr[0] = 10;
			if ( arr[1] == 0 ) arr[1] = 10;
			GetSingleItem("lottymsg")["_num_0"].gotoAndStop(arr[0]);
			GetSingleItem("lottymsg")["_num_1"].gotoAndStop(arr[1]);
			
			//pan
			var lo2:int = ball[1];
			var arr2:Array = utilFun.arrFormat(lo2, 2);			
			if ( arr2[0] == 0 ) arr2[0] = 10;
			if ( arr2[1] == 0 ) arr2[1] = 10;
			GetSingleItem("lottymsg")["_num_2"].gotoAndStop(arr2[0]);
			GetSingleItem("lottymsg")["_num_3"].gotoAndStop(arr2[1]);
			
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