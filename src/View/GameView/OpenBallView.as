package View.GameView
{
	import ConnectModule.websocket.WebSoketInternalMsg;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.printing.PrintJob;
	import flash.text.TextField;
	import Model.valueObject.*
	import Res.ResName;
	import util.DI;
	import Model.*
	import util.math.Path_Generator;
	import util.node;
	import View.Viewutil.*;
	import View.ViewBase.ViewBase;
	import util.*;
	import View.ViewComponent.*;
	
	import Command.*;
	
	import caurina.transitions.Tweener;
	
	/**
	 * ...
	 * @author hhg
	 */
	public class OpenBallView extends ViewBase
	{
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _regular:RegularSetting;	
		
		[Inject]
		public var _timer:Visual_timer;		
		
		[Inject]
		public var _ball:Visual_ball;
		
		[Inject]
		public var _staticinfo:Visual_staticInfo;
		
		[Inject]
		public var _ticket:Visual_ticket;
		
		[Inject]
		public var _settle:Visual_Settle;
		
		[Inject]
		public var _Bigwin_Msg:Visual_Bigwin_Msg;
		
		[Inject]
		public var _Bigwin_Effect:Visual_Bigwin_Effect
		
		[Inject]
		public var _themes:Visual_themes;
		
		[Inject]
		public var _Roller:Visual_Roller;
		
		public function OpenBallView()  
		{
			utilFun.Log("OpenBallView");
		}
		
		[MessageHandler(type="Model.valueObject.Intobject",selector="EnterView")]
		override public function EnterView (View:Intobject):void
		{
			if (View.Value != modelName.openball) return;
			super.EnterView(View);
			//清除前一畫面
			utilFun.Log("in to OpenBallView=");			
					
			if ( _model.getValue("chang_order") ) this.parent.swapChildrenAt(3, 2);			
			else _model.putValue("chang_order",1);
			
			
			var view:MultiObject = prepare("_view", new MultiObject() , this);
			view.Create_by_list(1, [ResName.Openball_Scene], 0, 0, 1, 0, 0, "a_");	
			
			_staticinfo.init();
			_ball.init();
			
			_ticket.init();	
			
			_Bigwin_Msg.init();
			_Bigwin_Effect.init();
			
			_themes.init();
			_Roller.init();
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="LeaveView")]
		override public function ExitView(View:Intobject):void
		{
			if (View.Value != modelName.openball) return;
			utilFun.Log("leave to OpenBallView=");			
			super.ExitView(View);
		}		
	}

}