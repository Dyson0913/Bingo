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
	import util.node;	
	import View.ViewComponent.Visual_ball;
	import View.ViewComponent.Visual_RoomSelect;
	import View.Viewutil.*;
	import View.ViewBase.ViewBase;
	import util.*;
	
	import Command.*;
	
	import caurina.transitions.Tweener;	
	import caurina.transitions.properties.CurveModifiers;
	/**
	 * ...
	 * @author hhg
	 */
	public class LobbyView extends ViewBase
	{
		[Inject]
		public var _regular:RegularSetting;			
		
		[Inject]
		public var _roomItem:Visual_RoomSelect;
		
		
		public function LobbyView()  
		{
			
		}
		
		[MessageHandler(type="Model.valueObject.Intobject",selector="EnterView")]
		override public function EnterView (View:Intobject):void
		{
			utilFun.Log("LobbyView in to EnterBetview="+View.Value);	
			if (View.Value != modelName.lobby) return;
			super.EnterView(View);
			//清除前一畫面		
			var view:MultiObject = prepare("_view", new MultiObject() , this);
			view.Create_by_list(1, [ResName.RoomSelect], 0, 0, 1, 0, 0, "a_");			
						
			_roomItem.init();
			
			
		}	
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="LeaveView")]
		override public function ExitView(View:Intobject):void
		{
			if (View.Value != modelName.lobby) return;
			super.ExitView(View);
		}		
	}

}