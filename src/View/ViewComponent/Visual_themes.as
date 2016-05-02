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
			create_container();
			
			var secondhint:MultiObject = create("second_hint",[ResName.secondhint],_myContain.container);
			secondhint.Create_(1, "second_hint");
			secondhint.container.x = 458.6; 
			secondhint.container.y = 381.7;			
			
			
			var besthint:MultiObject = create("besthint",  [ResName.besthint], _myContain.container);
			besthint.Create_(1, "besthint");
			besthint.container.x = 417.9;
			besthint.container.y = 81.95;			
			
			//押暗
			var DarkItem:MultiObject = create("Dark",  [Dark]);			
			DarkItem.Create_(1, "Dark");
			GetSingleItem("Dark")["_bg"].alpha = 0;
			
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
			
			GetSingleItem("_view")["_CurBal"].visible = true;
			
		}
		
		public function switch_panel(e:Event, idx:int):Boolean
		{
			var panellist:Array = _model.getValue("switchpanel");
			var hand_control:MultiObject = Get("Visual_themes_Contain") ;
			var switch_idx:int = _model.getValue("switchpanel_idx");
			switch_idx = (switch_idx + 1) % panellist.length;
			utilFun.Log("swfi = "+switch_idx);
				
			for (var i:int = 0; i < panellist.length; i++)
			{
				var mu:MultiObject = panellist[i];
				if ( i == switch_idx) 
				{
					mu.container.visible = true;
					
					//歷史記錄開啟,     最佳,次佳盤,非互斥顥示,必須手動hide
					//1 for testinterface 2 for real server
					if ( switch_idx == 1)
					{						
						hand_control.container.visible = false;
						dispatcher(new ModelEvent("history_show"));
					}
					else {
						hand_control.container.visible = true;
						dispatcher(new ModelEvent("history_hide"));
					}
				}
				else 
				{
					mu.container.visible = false;				
					
				}
			}
			_model.putValue("switchpanel_idx", switch_idx);		
			return true;
		}
		
		[MessageHandler(type = "ConnectModule.websocket.WebSoketInternalMsg", selector = "specail_round")]
		public function sp():void
		{
			GetSingleItem("besthint").gotoAndStop(2);
			//TODO wintype _wintype
			var frame:int =  _model.getValue(modelName.SPCIAL_FRAME_THOUSAND);
			GetSingleItem("besthint")["_wintype"].gotoAndStop(frame);		
			
			//光暉效果
			GetSingleItem("besthint")["_wintype"]["_win_effect"].gotoAndStop(frame);
			//_regular.Twinkle_by_JumpFrame(GetSingleItem("besthint")["_win_effect"], 30, 90, 2, 3);
			
			//四週跑燈
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
			GetSingleItem("second_hint").gotoAndStop(3);
			var ball:Array = _model.getValue(modelName.SPCIAL_BALL);	
			var frame:int =  ball[ball.length - 1];
			if ( frame == 0) frame = 10;
			GetSingleItem("second_hint")["_num_0"].gotoAndStop(frame);
			GetSingleItem("second_hint")["_num_1"].gotoAndStop(12);
			//GetSingleItem("second_hint")["lobbyNum"].text = ball[ball.length-1];
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "lotty_sec_ok")]
		public function sec_ball_ok():void
		{
			var ball:Array = _model.getValue(modelName.SPCIAL_BALL);
			var frame:int =  ball[ball.length - 2];
			if ( frame == 0) frame = 10;
			GetSingleItem("second_hint")["_num_0"].gotoAndStop(frame);
			frame  =  ball[ball.length - 1];
			if ( frame == 0) frame = 10;
			GetSingleItem("second_hint")["_num_1"].gotoAndStop(frame);
			
			//GetSingleItem("second_hint")["lobbyNum"].text = ball_s;		
			
			utilFun.SetTime(myse, 1);
		}
		
		public function myse():void
		{
			GetSingleItem("second_hint").gotoAndStop(4);
			
			//reset roller
			GetSingleItem("Roller_2")["_title"].gotoAndStop(2);
			dispatcher(new ModelEvent("reset_roller"));
			
			//reset ball
			var lottyball:MultiObject = Get("lottyball");
			lottyball.CleanList();
			lottyball.Create_by_list(1, [ResName.lottyball], 0 , 0, 2, 1880 , 0, "Bet_");
			lottyball.container.x = 30.6;
			lottyball.container.y = 541.75;			
			
			
			//dispatcher(new ModelEvent("pick_seond_ball"));
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "lotty_second_one_ok")]
		public function sec_first():void
		{			
			GetSingleItem("second_hint").gotoAndStop(5);
			
			var ball:Array = _model.getValue(modelName.SPCIAL_BALL);			
			var frame:int =  ball[ball.length - 1];
			if ( frame == 0) frame = 10;
			GetSingleItem("second_hint")["_num_2"].gotoAndStop(frame);		
			GetSingleItem("second_hint")["_num_3"].gotoAndStop(12);
			
			//GetSingleItem("second_hint")["panNum"].text = ball[ball.length-1];			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "lotty_second_two_ok")]
		public function lotty_second_two_ok():void
		{
			var ball:Array = _model.getValue(modelName.SPCIAL_BALL);			
			var frame:int =  ball[ball.length - 2];
			if ( frame == 0) frame = 10;
			GetSingleItem("second_hint")["_num_2"].gotoAndStop(frame);
			frame  =  ball[ball.length - 1];
			GetSingleItem("second_hint")["_num_3"].gotoAndStop(frame);
			
			//GetSingleItem("second_hint")["panNum"].text =  ball_s;
			
			pan_ok();
		}
		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "pan_ok")]		
		public function pan_ok():void
		{			
			GetSingleItem("Dark")["_bg"].alpha = 0.5;		
			
			//fire			
			//TODO wintype _wintype
			var frame:int =  _model.getValue(modelName.SPCIAL_FRAME_THOUSAND);
			GetSingleItem("lottymsg").gotoAndStop(frame+1);			
			//GetSingleItem("lottymsg").gotoAndStop(1);
			
			var ball:Array = _model.getValue(modelName.SPCIAL_BALL);			
			var arr:Array = [ball[0], ball[1]];			
			if ( arr[0] == 0 ) arr[0] = 10;
			if ( arr[1] == 0 ) arr[1] = 10;
			GetSingleItem("lottymsg")["_num_0"].gotoAndStop(arr[0]);
			GetSingleItem("lottymsg")["_num_1"].gotoAndStop(arr[1]);
			
			//pan			
			var arr2:Array = [ball[2], ball[3]];		
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