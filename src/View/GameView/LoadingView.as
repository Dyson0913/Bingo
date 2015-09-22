package View.GameView
{	
	import com.adobe.utils.DictionaryUtil;
	import Command.BetCommand;
	import Command.RegularSetting;
	import Command.ViewCommand;
	import ConnectModule.websocket.WebSoketInternalMsg;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;	
	import flash.text.TextField;
	import Model.valueObject.Intobject;
	import Res.ResName;
	import util.DI;
	import util.node;
	import View.ViewBase.ViewBase;
	import Command.DataOperation;
	import flash.text.TextFormat;
	import View.ViewComponent.*;
	import View.Viewutil.*;
	
	import Model.*;
	import util.utilFun;
	import caurina.transitions.Tweener;	
	
	/**
	 * ...
	 * @author hhg
	 */

	 
	public class LoadingView extends ViewBase
	{	
		private var _mainroad:MultiObject = new MultiObject();
		private var _localDI:DI = new DI();
		
		public var _mainTable:LinkList = new LinkList();
		public var _bigroadTable:LinkList = new LinkList();        
		
		[Inject]
		public var _regular:RegularSetting;	
		
		[Inject]
		public var _visual_test:Visual_testInterface;
		
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _ticket:Visual_ticket;
		
		[Inject]
		public var _hint:Visual_Hintmsg;
		
		public function LoadingView()  
		{
			
		}
		
			//result:Object
		public function FirstLoad(para:Array ):void
 		{			
			//dispatcher(new Intobject(modelName.openball, ViewCommand.SWITCH));		
			//return;
			
			_model.putValue("bingo_color", [0x41A0F0, 0xF01E1E, 0xB9B9B9, 0x23C323, 0xF58C00]);
			
			_model.putValue("SelectRoomInfo",[]);
			
			_model.putValue("is_betarr",[]);
			_model.putValue("ballarr",[]);
			_model.putValue("table", []);
			
			_model.putValue(modelName.UUID,  para[0]);
			_model.putValue(modelName.CREDIT, para[1]);
			_model.putValue(modelName.Client_ID, para[2]);
			_model.putValue(modelName.HandShake_chanel, para[3]);
			_model.putValue(modelName.Domain_Name, para[4]);
			
			dispatcher(new Intobject(modelName.Loading, ViewCommand.SWITCH));			
			//dispatcher(new Intobject(modelName.lobby, ViewCommand.SWITCH) );		
			//	dispatcher(new Intobject(modelName.openball, ViewCommand.SWITCH) );		
			
		}
		
		[MessageHandler(type="Model.valueObject.Intobject",selector="EnterView")]
		override public function EnterView (View:Intobject):void
		{
			utilFun.Log("LoadingView EnterView"+View.Value);
			if (View.Value != modelName.Loading) return;
			super.EnterView(View);
			var view:MultiObject = prepare("_view", new MultiObject() , this);
			view.Create_by_list(1, [ResName.Loading_Scene], 0, 0, 1, 0, 0, "a_");			
			_tool = new AdjustTool();			
			_betCommand.bet_init();
			//_regular.strdotloop(view.ItemList[0]["_Text"],20,40);			
			//Tweener.addTween(view.ItemList[0]["_mask"], { y:view.ItemList[0]["_mask"].y-164, time:3,onComplete:test,transition:"easeInOutQuart"} );			
		
			//
			utilFun.SetTime(connet, 0.1);
			//-------------------------------ticket
			//_hint.init();
			
			//-------------------------------ticket
			//_visual_test.init();
				//_ticket.init();
			//
		}
		private function connet():void
		{	
			dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.CONNECT));
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="LeaveView")]
		override public function ExitView(View:Intobject):void
		{
			if (View.Value != modelName.Loading) return;
			super.ExitView(View);
			utilFun.Log("LoadingView ExitView");
		}
		
		
	}

}