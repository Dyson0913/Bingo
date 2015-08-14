package View.ViewComponent 
{
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
			
			//_tool.SetControlMc(winhint.container);
			//add(_tool);
		}
		
		[MessageHandler(type="ConnectModule.websocket.WebSoketInternalMsg",selector="betstopHint")]
		public function display():void
		{
			Get(modelName.HINT_MSG).container.visible = true;
			GetSingleItem(modelName.HINT_MSG).gotoAndStop(1);	
			_regular.FadeIn( GetSingleItem(modelName.HINT_MSG), 2, 2, _regular.Fadeout);		
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
			//_regular.FadeIn( GetSingleItem("winhint"), 2, 2, _regular.Fadeout);
		}
		
	}

}