package View.ViewComponent 
{
	import ConnectModule.websocket.WebSoketInternalMsg;
	import flash.display.MovieClip;
	import flash.events.Event;
	import View.ViewBase.Visual_Text;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.*;
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
			
			//自己中賓果提示
			var selfbingo_panel:MultiObject = prepare("selfbingo_panel", new MultiObject(),GetSingleItem("_view").parent.parent );						
			selfbingo_panel.container.x = 800;
			selfbingo_panel.container.y = 380;
			selfbingo_panel.Create_by_list(1, [ResName.selfbingo_panel], 0, 0, 1, 106.25, 80, "time_");  
			selfbingo_panel.container.visible = false;
			
			
			//提示數字
			var selfbgino_text:MultiObject = prepare("selfbgino_text", new MultiObject(), selfbingo_panel.container);
			selfbgino_text.CustomizedFun = _text.colortextSetting;
			selfbgino_text.CustomizedData = [{size:30,color:0xFFFFFF,align:_text.align_right}, "100","90","9000"];			
			selfbgino_text.container.x = -210;
			selfbgino_text.container.y = 220;
			selfbgino_text.Create_by_list(3, [ResName.Paninfo_font], 0, 0, 1, 0, 78, "time_");
			
		
		   //_tool.SetControlMc(selfbgino_text.container);
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
			
			//自己bingo 結算金額
			var Totalbet:int = 0;
			var total_settle_amount:int = 0;
			var odds:int = 0;
			var i_win:Boolean = false;
			
			var result_list:Array = _model.getValue(modelName.ROUND_RESULT);						
			var history:Array = [];
			for (var i:int = 0; i < result_list.length; i++)
			{
				var betob:Object = result_list[i];
				//var room_and_table:String = betob["bet_type"];
				var settle_amount:int = betob["settle_amount"];				
				if (settle_amount != 0)
				{
					total_settle_amount += settle_amount;
					Totalbet += betob["bet_amount"];				
					odds = betob["odds"];	
					i_win = true;
				}
			}		
			
			if ( i_win)
			{
				Get("selfbingo_panel").container.visible = true;
				
				GetSingleItem("selfbgino_text", 0).getChildByName("Dy_Text").text = Totalbet.toString();
				GetSingleItem("selfbgino_text", 1).getChildByName("Dy_Text").text = odds.toString();
				GetSingleItem("selfbgino_text", 2).getChildByName("Dy_Text").text = total_settle_amount.toString();
			}
			
			
		}
		
		public function BetListini(mc:MovieClip,idx:int,bingo_recode:Array):void
		{
			//utilFun.scaleXY(mc, 0.7, 0.7);			
			utilFun.SetText(mc["tableNo"], utilFun.Format( bingo_recode[idx], 2));			
			
			var frame:int = _betCommand.get_bet_frame(bingo_recode[idx]);				
			mc.gotoAndStop(frame);			
		}
		
	}

}