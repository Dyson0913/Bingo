package View.GameView
{
	import ConnectModule.websocket.WebSoketInternalMsg;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
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
	public class betView extends ViewBase
	{
		[Inject]
		public var _regular:RegularSetting;	
		
		[Inject]
		public var _timer:Visual_timer;
		
		[Inject]
		public var _hint:Visual_Hintmsg;
		
		[Inject]
		public var _betzone:Visual_betZone;
		
		[Inject]
		public var _playerinfo:Visual_PlayerInfo;
		
		[Inject]
		public var _bingo:Visual_bingoPan;
		
		[Inject]
		public var _test:Visual_testInterface;
		
		public function betView()  
		{
			utilFun.Log("betView");
		}
		
		[MessageHandler(type="Model.valueObject.Intobject",selector="EnterView")]
		override public function EnterView (View:Intobject):void
		{
			if (View.Value != modelName.Bet) return;
			super.EnterView(View);
			//清除前一畫面
			
			//in to bet view=[object LoadingView]
 //[I] in to bet view=[object LobbyView]
 //[I] in to bet view=[object betView]
 //[I] in to bet view=[object OpenBallView]
			
			this.parent.swapChildrenAt(3, 2);
			//utilFun.Log("in to bet view=");			
			//utilFun.Log("in to bet view="+this.parent.getChildAt(0).toString());			
			//utilFun.Log("in to bet view="+this.parent.getChildAt(1).toString());			
			//utilFun.Log("in to bet view="+this.parent.getChildAt(2).toString());			
			//utilFun.Log("in to bet view=" + this.parent.getChildAt(3).toString() );			
			_tool = new AdjustTool();
			
			
			var view:MultiObject = prepare("_view", new MultiObject() , this);
			view.Create_by_list(1, [ResName.Bet_Scene], 0, 0, 1, 0, 0, "a_");	
			
			//_test.init();
				
			_playerinfo.init();
			_betzone.init();
			
			_timer.init();
			_hint.init();
			_bingo.init();
			utilFun.Log("bet view= end");			
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="LeaveView")]
		override public function ExitView(View:Intobject):void
		{
			if (View.Value != modelName.Bet) return;
			super.ExitView(View);
		}		
	}

}