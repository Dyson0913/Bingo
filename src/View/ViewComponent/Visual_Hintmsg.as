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
		public var _Actionmodel:ActionQueue;
		
		
		[Inject]
		public var _betCommand:BetCommand;
		
		private var _frame_Stop_bet:int = 2;
		private var _frame_uplimit_bet:int = 3;
		
		public function Visual_Hintmsg() 
		{
			
		}
		
		public function init():void
		{
			var hintmsg:MultiObject = prepare(modelName.HINT_MSG, new MultiObject()  , GetSingleItem("_view").parent.parent);
			hintmsg.Create_by_list(1, [ResName.Hint], 0, 0, 1, 0, 0, "time_");
			hintmsg.container.x = 87;
			hintmsg.container.y = 459;		
			
			//_tool.SetControlMc(public_best_pan.container);
			//add(_tool);			
		}
		
		[MessageHandler(type="ConnectModule.websocket.WebSoketInternalMsg",selector="betstopHint")]
		public function display():void
		{			
			GetSingleItem(modelName.HINT_MSG).gotoAndStop(_frame_Stop_bet);	
			_regular.FadeIn( GetSingleItem(modelName.HINT_MSG), 2, 2, _regular.Fadeout);		
			
			Tweener.addCaller(this, { time:1.5 , count: 1 , transition:"linear",onComplete: this.change } );
		}	
		
		public function change():void
		{			
			dispatcher(new Intobject(modelName.openball, ViewCommand.SWITCH) );
			_Actionmodel.cleanMsg();
		}
		
		[MessageHandler(type = "ConnectModule.websocket.WebSoketInternalMsg", selector = "CreditNotEnough")]
		public function no_credit():void
		{						
			GetSingleItem(modelName.HINT_MSG).gotoAndStop(3);
			_regular.FadeIn( GetSingleItem(modelName.HINT_MSG), 2, 2, _regular.Fadeout);
		}
		
		[MessageHandler(type = "ConnectModule.websocket.WebSoketInternalMsg", selector = "betfullHint")]
		public function betfull():void
		{			
			GetSingleItem(modelName.HINT_MSG).gotoAndStop(_frame_uplimit_bet);
			_regular.FadeIn( GetSingleItem(modelName.HINT_MSG), 2, 2, _regular.Fadeout);
		}
		
	}

}