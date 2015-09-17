package View.ViewComponent 
{
	import flash.display.MovieClip;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	import caurina.transitions.Tweener;
	
	/**
	 * hintmsg present way
	 * @author ...
	 */
	public class Visual_Hintmsg  extends VisualHandler
	{
		[Inject]
		public var _regular:RegularSetting;
		
		[Inject]
		public var _betCommand:BetCommand;
		
		public function Visual_Hintmsg() 
		{
			
		}
		
		public function init():void
		{
			var hintmsg:MultiObject = prepare(modelName.HINT_MSG, new MultiObject()  , GetSingleItem("_view").parent.parent);
			hintmsg.Create_by_list(1, [ResName.Hint], 0, 0, 1, 0, 0, "time_");
			hintmsg.container.x = 87;
			hintmsg.container.y = 459;
			hintmsg.container.visible = false;
		
			
			var winhint:MultiObject = prepare("winhint", new MultiObject()  , GetSingleItem("_view").parent.parent);
			winhint.Create_by_list(1, [ResName.Winhint], 0, 0, 1, 0, 0, "time_");
			winhint.container.x = 449;
			winhint.container.y = 103;
			winhint.container.visible = false;
			
			var public_best_pan:MultiObject = prepare("bingowin_show", new MultiObject(), GetSingleItem("_view").parent.parent);			
			//public_best_pan.CustomizedFun = pan_set;
			public_best_pan.container.x = 492.85;
			public_best_pan.container.y = 128.8;
			public_best_pan.Create_by_list(5, [ResName.BetButton], 0, 0, 5, 106.25, 80, "time_");
			public_best_pan.container.visible = false;
			//_tool.SetControlMc(public_best_pan.container);
			//add(_tool);
			
		}
		
		public function pan_set(mc:MovieClip, idx:int, tablelist:Array):void
		{				
			mc.visible = false;			
		}
		
		[MessageHandler(type="ConnectModule.websocket.WebSoketInternalMsg",selector="betstopHint")]
		public function display():void
		{
			Get(modelName.HINT_MSG).container.visible = true;
			GetSingleItem(modelName.HINT_MSG).gotoAndStop(1);	
			_regular.FadeIn( GetSingleItem(modelName.HINT_MSG), 2, 2, _regular.Fadeout);		
			
			Get("bingowin_show").container.visible = false;
			
			Tweener.addCaller(Get("bingowin_show").container, { time:2 , count: 1 , transition:"linear",onComplete: this.change } );
			
		}	
		
		public function change():void
		{
			dispatcher(new Intobject(modelName.openball, ViewCommand.SWITCH) );
		}
		
		[MessageHandler(type = "ConnectModule.websocket.WebSoketInternalMsg", selector = "betfullHint")]
		public function no_credit():void
		{			
			Get(modelName.HINT_MSG).container.visible = true;
			GetSingleItem(modelName.HINT_MSG).gotoAndStop(2);
			_regular.FadeIn( GetSingleItem(modelName.HINT_MSG), 2, 2, _regular.Fadeout);
		}
		
		[MessageHandler(type = "ConnectModule.websocket.WebSoketInternalMsg", selector = "win_hint")]
		public function winhint():void
		{			
			Get("winhint").container.visible = true;			
			//var bingo:Array = _betCommand.get_my_bet_info("table");
			//var fakebingo:int = utilFun.Random(99);
			//while ( bingo.indexOf(fakebingo) != -1)
			//{
				//fakebingo = utilFun.Random(99);
			//}			
			//var bighist:Array = _model.getValue("bighist");
			//bighist.push(fakebingo);
			//_model.putValue("bighist", bighist);
			//_regular.FadeIn( GetSingleItem("winhint"), 2, 2, _regular.Fadeout);
			
			//Get("bingowin_show").container.visible = true;
			//Get("bingowin_show").CustomizedFun = BetListini;
			//Get("bingowin_show").CustomizedData = bighist;
			//Get("bingowin_show").Create_by_list(bighist, [ResName.BetButton], 0, 0, 5, 106.25, 80, "time_");
			//Get("bingowin_show").FlushObject();
		}
		
		public function BetListini(mc:MovieClip,idx:int,bingo_recode:Array):void
		{
			utilFun.scaleXY(mc, 0.7, 0.7);
			var str:String = idx >= bingo_recode.length ? "" : bingo_recode[idx];
			utilFun.SetText(mc["tableNo"], str);
		}
	}

}