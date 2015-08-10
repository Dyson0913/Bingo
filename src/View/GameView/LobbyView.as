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
	import View.Viewutil.*;
	import View.ViewBase.ViewBase;
	import util.*;
	import View.ViewComponent.Visual_Coin;
	
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
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _regular:RegularSetting;			
		
		
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
			
			utilFun.Log("in lobby");	
			
			
			
			//var view:MultiObject = prepare("_view", new MultiObject() , this);
			//view.Create_by_list(1, [ResName.lobby_], 0, 0, 1, 0, 0, "a_");			
						
			utilFun.SetTime(connet, 1);
		}			 
		
		private function connet():void
		{	
			utilFun.Log("send connet");	
			dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.CHOOSE_ROOM));		
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="LeaveView")]
		override public function ExitView(View:Intobject):void
		{
			if (View.Value != modelName.lobby) return;
			super.ExitView(View);
		}		
	}

}