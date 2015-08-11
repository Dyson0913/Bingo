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
	 * playerinfo present way
	 * @author ...
	 */
	public class Visual_staticInfo  extends VisualHandler
	{
		
		public function Visual_staticInfo() 
		{
			
		}
		
		public function init():void
		{
						
			//最佳盤號 次佳盤
			var bestinfo:MultiObject = prepare("best_pan_info", new MultiObject(), GetSingleItem("_view").parent.parent);	
			bestinfo.CustomizedFun = info_initFun;
			bestinfo.container.x = 768;
			bestinfo.container.y = 58;
			bestinfo.Create_by_list(4, [ResName.Paninfo_font], 0, 0, 2, 180, 243, "time_");
			
			
			var totalball_info:MultiObject = prepare("total_ball_info", new MultiObject(), GetSingleItem("_view").parent.parent);
			totalball_info.CustomizedFun = info_initFun;
			totalball_info.container.x = 293;
			totalball_info.container.y = 79;
			totalball_info.Create_by_list(1, [ResName.Paninfo_font], 0, 0, 1, 0, 0, "time_");
			
			var public_best_pan:MultiObject = prepare("public_best_pan_info", new MultiObject(), GetSingleItem("_view").parent.parent);
			//public_best_pan.CustomizedFun = info_initFun;
			public_best_pan.container.x = 492.85;
			public_best_pan.container.y = 128.8;
			public_best_pan.Create_by_list(26, [ResName.BetButton], 0, 0, 13, 106.25, 80, "time_");
			
			//26 -> 1 row 13 106.25  80
			
			
			_tool.SetControlMc(public_best_pan.container);
			add(_tool);
		}
		
		public function info_initFun(mc:MovieClip, idx:int, scalesize:Array):void
		{				
			utilFun.SetText(mc["_text"], "");			
		}
		
		
		[MessageHandler(type="ConnectModule.websocket.WebSoketInternalMsg",selector="ballupdate")]
		public function UpdataTableBetInfo():void
		{			
			
			utilFun.SetText(GetSingleItem("total_ball_info")["_text"], String( _model.getValue("opened_ball_num") ));
			utilFun.SetText(GetSingleItem("best_pan_info", 0)["_text"], String( _model.getValue("best_remain") ));
			utilFun.SetText(GetSingleItem("best_pan_info", 2)["_text"], String( _model.getValue("second_remain") ));
			
			var list:Array = _model.getValue("best_list");
			utilFun.SetText(GetSingleItem("best_pan_info", 1)["_text"], String( list.length ));
			list  = _model.getValue("second_list");
			utilFun.SetText(GetSingleItem("best_pan_info", 3)["_text"], String( list.length ));
			
			Get("public_best_pan_info")
			
			Get("public_best_pan_info").CustomizedFun = info_initFun;						
			Get("public_best_pan_info").Create_by_list(26, [ResName.BetButton], 0, 0, 13, 106.25, 80, "time_");
			
		}
		
		
		
	}

}