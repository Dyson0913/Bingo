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
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _regular:RegularSetting;
		
		[Inject]
		public var _poker:Visual_poker;
		
		[Inject]
		public var _timer:Visual_timer;
		
		[Inject]
		public var _hint:Visual_Hintmsg;
		
		[Inject]
		public var _betzone:Visual_betZone;
		
		[Inject]
		public var _coin:Visual_Coin;
		
		[Inject]
		public var _settle:Visual_Settle;
		
		[Inject]
		public var _playerinfo:Visual_PlayerInfo;
		
		[Inject]
		public var _path:Path_Generator;
		
		private var _mainroad:MultiObject = new MultiObject();
				
		public var _mainTable:LinkList = new LinkList();
		public var _bigroadTable:LinkList = new LinkList();
				
		
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
			utilFun.Log("in to EnterBetview=");			
			
			_tool = new AdjustTool();
			_betCommand.bet_init();
			
			var view:MultiObject = prepare("_view", new MultiObject() , this);
			view.Create_by_list(1, [ResName.Bet_Scene], 0, 0, 1, 0, 0, "a_");	
			
			
			_playerinfo.init();
			_betzone.init();
			
			_timer.init();
			//trig time
			
			//_path.init();
			//
			//_poker.init();
			//_settle.init();
			//
		
			//

			//_hint.init();			

			//_coin.init();
		//
			
			//_tool.SetControlMc(coinstack.ItemList[0]);
			//addChild(_tool);		
			
			//_tool.SetControlMc(hintmsg);
			//addChild(_tool);
			
			
		
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="LeaveView")]
		override public function ExitView(View:Intobject):void
		{
			if (View.Value != modelName.Bet) return;
			super.ExitView(View);
		}		
	}

}