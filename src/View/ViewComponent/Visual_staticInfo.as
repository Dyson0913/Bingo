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
			public_best_pan.container.x = 492.85;
			public_best_pan.container.y = 128.8;
			public_best_pan.Create_by_list(26, [ResName.BetButton], 0, 0, 13, 106.25, 80, "time_");
			
			//26 -> 1 row 13 106.25  80
			
			_tool.SetControlMc(public_best_pan.ItemList[4]);
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
			
		
			var ball:Array = [1, 2, 3, 4];
			var dis:Array = [_model.getValue("best_list"), 80,5,1260];
		//	var dis:Array = [106.25, 80,6,1260];
			//Get("public_best_pan_info").CustomizedFun = pan_set;						
			//Get("public_best_pan_info").CustomizedData = _model.getValue("best_list");				
			Get("public_best_pan_info").Posi_CustzmiedFun = reposition;						
			Get("public_best_pan_info").Post_CustomizedData = dis;
			Get("public_best_pan_info").customized();
			
			  
		}
		
		public function pan_set(mc:MovieClip, idx:int, tablelist:Array):void
		{				
			
				
			
		}
		
		public function sballFun(mc:MovieClip, idx:int, ball:Array):void
		{
			//TODO combination setting ,like scale ,set test ,splite to reuse
			utilFun.scaleXY(mc, 0.3, 0.3);
			//mc.gotoAndStop( Math.ceil( (ball[idx] + 1) / 15) ) ;
			//utilFun.SetText(mc["ballNum"], String(ball[idx]));			
		}
		
		public function reposition(mc:MovieClip, idx:int, dis:Array):void
		{
			
			if ( dis[2] == 5)  if ( idx >= 10) 
			{
				mc.visible = false
				return;
			}
			
			var tablelist:Array = dis[0];			
			utilFun.Log("pan_set = "+idx);			
			
			var bet:Object = tablelist[idx];
			if ( bet.ball_list.length > 0)
			{
				utilFun.Log("bet.ball_list = "+bet.ball_list);
				var sball:MultiObject = prepare("small_ball", new MultiObject()  , mc);
				sball.CustomizedFun = sballFun;		   
			   sball.CustomizedData = bet.ball_list;
			   sball.Create_by_list(4, [ResName.Ball], 0, 0, 4, 50, 0, "time_");
			   sball.container.x = 106;
			   //sball.container.y = 413;		
				//_tool.SetControlMc(sball.container);
				//add(_tool);
			}
		
			utilFun.SetText(mc["tableNo"], String( bet["table_no"]) );		
			
			
			
			var Xdiff:Number = utilFun.NPointInterpolateDistance(dis[2], 0, dis[3]);
			mc.x = mc.parent.parent.x + (idx % dis[2] *Xdiff);
			mc.y = mc.parent.parent.y + ( Math.floor(idx / dis[2]) * dis[1]);			
		}
		
	}

}