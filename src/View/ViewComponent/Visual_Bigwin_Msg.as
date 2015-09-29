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
	 * timer present way
	 * @author ...
	 */
	public class Visual_Bigwin_Msg  extends VisualHandler
	{
		[Inject]
		public var _betCommand:BetCommand;
		
		
		public function Visual_Bigwin_Msg() 
		{
			
		}
		
		public function init():void
		{
			var winhint:MultiObject = prepare("winhint", new MultiObject()  , GetSingleItem("_view").parent.parent);
			winhint.Create_by_list(1, [ResName.Winhint], 0, 0, 1, 0, 0, "time_");
			winhint.container.x = 449;
			winhint.container.y = 103;			
			
			var public_best_pan:MultiObject = prepare("bingowin_show", new MultiObject(), GetSingleItem("_view").parent.parent);			
			public_best_pan.CustomizedFun = pan_set;
			public_best_pan.container.x = 492.85;
			public_best_pan.container.y = 128.8;
			public_best_pan.Create_by_list(5, [ResName.BetButton], 0, 0, 5, 106.25, 80, "time_");  
			
			var switchbtn:MultiObject = prepare("switchbtn", new MultiObject(), GetSingleItem("_view").parent.parent);						
			switchbtn.container.x = 1770;
			switchbtn.container.y = 1000;
			switchbtn.Create_by_list(1, [ResName.switchbtn], 0, 0, 1, 106.25, 80, "time_");  
			
			var selfbingo_panel:MultiObject = prepare("selfbingo_panel", new MultiObject(), GetSingleItem("_view").parent.parent);						
			selfbingo_panel.container.x = 800;
			selfbingo_panel.container.y = 380;
			selfbingo_panel.Create_by_list(1, [ResName.selfbingo_panel], 0, 0, 1, 106.25, 80, "time_");  
			selfbingo_panel.container.visible = false;
			
		   //_tool.SetControlMc(selfbingo_panel.container);
		   //_tool.y = 200;
			//add(_tool);
		}
		
		public function pan_set(mc:MovieClip, idx:int, tablelist:Array):void
		{				
			mc.visible = false;
			
		}
		
		[MessageHandler(type = "ConnectModule.websocket.WebSoketInternalMsg", selector = "win_hint")]
		public function winhint():void
		{			
			GetSingleItem("winhint").gotoAndStop(2);
			
			//var bingo:Array = _betCommand.get_my_bet_info("table");			
			//var oblist:Array = _model.getValue("best_list");			
			//for (var i:int = 0; i < oblist.length ; i++)
			//{
				//tableNo.push(oblist[i].table_no);
			//}
			var tableNo:Array = _model.getValue(modelName.BINGO_TABLE);
			utilFun.Log("tableNo ----------"+tableNo.length);
			
			Get("bingowin_show").container.visible = true;
			Get("bingowin_show").CustomizedFun = BetListini;
			Get("bingowin_show").CustomizedData = tableNo;
			Get("bingowin_show").Create_by_list(tableNo.length, [ResName.BetButton], 0, 0, 10, 106.25, 80, "time_");
			Get("bingowin_show").FlushObject();
		}
		
		public function BetListini(mc:MovieClip,idx:int,bingo_recode:Array):void
		{
			//utilFun.scaleXY(mc, 0.7, 0.7);			
			utilFun.SetText(mc["tableNo"], bingo_recode[idx]);
			
			var arr:Array =  _betCommand.get_my_bet_info(BetCommand.Table);
			if ( arr.indexOf(bingo_recode[idx]) !=-1)
			{
				mc.gotoAndStop(2);
			}
			else mc.gotoAndStop(4);
		}
		
	}

}