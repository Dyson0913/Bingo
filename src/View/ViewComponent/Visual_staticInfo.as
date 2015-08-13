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
		[Inject]
		public var _betCommand:BetCommand;
		
		public function Visual_staticInfo() 
		{
			
		}
		
		public function init():void
		{
						
			//最佳盤號 次佳盤數字
			var bestinfo:MultiObject = prepare("best_pan_info", new MultiObject(), GetSingleItem("_view").parent.parent);	
			bestinfo.CustomizedFun = info_initFun;
			bestinfo.container.x = 768;
			bestinfo.container.y = 58;
			bestinfo.Create_by_list(4, [ResName.Paninfo_font], 0, 0, 2, 180, 243, "time_");
			
			//總球數
			var totalball_info:MultiObject = prepare("total_ball_info", new MultiObject(), GetSingleItem("_view").parent.parent);
			totalball_info.CustomizedFun = info_initFun;
			totalball_info.container.x = 293;
			totalball_info.container.y = 79;
			totalball_info.Create_by_list(1, [ResName.Paninfo_font], 0, 0, 1, 0, 0, "time_");
			
			//最佳盤
			var public_best_pan:MultiObject = prepare("public_best_pan_info", new MultiObject(), GetSingleItem("_view").parent.parent);			
			public_best_pan.CustomizedFun = pan_set;
			public_best_pan.container.x = 492.85;
			public_best_pan.container.y = 128.8;
			public_best_pan.Create_by_list(26, [ResName.BetButton], 0, 0, 13, 106.25, 80, "time_");
			
			//次佳盤
			var public_second_pan:MultiObject = prepare("public_second_pan_info", new MultiObject(), GetSingleItem("_view").parent.parent);			
			public_second_pan.CustomizedFun = pan_set;
			public_second_pan.container.x = 492.85;
			public_second_pan.container.y = 368.8;
			public_second_pan.Create_by_list(26, [ResName.BetButton], 0, 0, 13, 106.25, 80, "time_");
			//_tool.SetControlMc(public_second_pan.container);
			//add(_tool);
		
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
			
			var best_list:Array = _model.getValue("best_list");
			utilFun.SetText(GetSingleItem("best_pan_info", 1)["_text"], String( best_list.length ));
			var second_list:Array  = _model.getValue("second_list");
			utilFun.SetText(GetSingleItem("best_pan_info", 3)["_text"], String( second_list.length ));
			
						
			//utilFun.Log("best_list" + tablelist.length) ;		
			var bet:Object = best_list[0];			
			var ball_lenth:int =  bet.ball_list.length;
			var dis:Array = [best_list,ball_lenth];		
			
			//Get("public_best_pan_info").CustomizedFun = pan_set;						
			//Get("public_best_pan_info").CustomizedData = _model.getValue("best_list");				
			Get("public_best_pan_info").Posi_CustzmiedFun = reposition;						
			Get("public_best_pan_info").Post_CustomizedData = dis;
			Get("public_best_pan_info").customized();
			
			var sebet:Object = second_list[0];
			ball_lenth =  sebet.ball_list.length;
			dis = [second_list, ball_lenth];
			//utilFun.Log("second_list ball_lenth" + ball_lenth) ;
			Get("public_second_pan_info").Posi_CustzmiedFun = reposition;						
			Get("public_second_pan_info").Post_CustomizedData = dis;
			Get("public_second_pan_info").customized();
			
			//utilFun.Log("down") ;
		}
		
		public function pan_set(mc:MovieClip, idx:int, tablelist:Array):void
		{				
			mc.visible = false;			
		}
		
		public function sballFun(mc:MovieClip, idx:int, ball:Array):void
		{
			//TODO combination setting ,like scale ,set test ,splite to reuse
			utilFun.scaleXY(mc, 0.3, 0.3);
			mc.gotoAndStop( Math.ceil( (ball[idx] + 1) / 15) ) ;
			utilFun.SetText(mc["ballNum"], String(ball[idx]));			
		}
		
		public function reposition(mc:MovieClip, idx:int, dis:Array):void
		{			
			var ball_lenth:int =  dis[1];	
			
			if ( ball_lenth == 4) 			
			{
				if ( idx >= 8) 
				{
					mc.visible = false
					return;
				}
			}
			else if ( ball_lenth == 3)  
			{
				if ( idx >= 10) 
				{
					mc.visible = false
					return;
				}
			}
			else if ( ball_lenth == 2) 
			{
				if ( idx >= 12)
				{
					mc.visible = false
					return;
				}
				
			}
			else if ( ball_lenth == 1)  
			{
				if ( idx >= 16)
				{
					mc.visible = false
					return;
				}
				
			}
			else if ( ball_lenth == 0)  
			{
				if ( idx >= 26) 
				{
					mc.visible = false
					return;
				}
				
			}
			//utilFun.Log("ball_lenth = " + ball_lenth);			
			
			var tablelist:Array = dis[0];	
			var bet:Object = tablelist[idx];			
			
				//utilFun.Log("idx = " + idx);
				//utilFun.Log("ball_lenth = " + tablelist.length);
			if ( idx > tablelist.length-1) 
			{			
				mc.visible = false;
				return;
			}
			
			//from more to few ,visible should switch back;
			mc.visible = true;
			mc.gotoAndStop(1);
			
			if ( ball_lenth > 0)
			{
				//utilFun.Log("bet.ball_list = " + bet.ball_list);
				//utilFun.Log("pan_set = " + idx);		
				
				
				//TODO  clean 
				var sball:MultiObject = prepare("small_ball"+idx, new MultiObject()  , mc);
				sball.CustomizedFun = sballFun;		   
			   sball.CustomizedData = bet.ball_list;
			   sball.Create_by_list(ball_lenth, [ResName.Ball], 0, 0, ball_lenth, 55, 0, "time_");
			   sball.container.x = 106;
			   sball.container.y = 10;		
				//_tool.SetControlMc(sball.container);
				//add(_tool);
				//utilFun.Log("mc.numChildren = " + mc.numChildren);		
				//utilFun.Log("mc.numChildren 0= " + mc.getChildAt(0));		
				//utilFun.Log("mc.numChildren 1= " + mc.getChildAt(1));		
				//utilFun.Log("mc.numChildren 1= " + mc.getChildAt(2));		
				//utilFun.Log("mc.numChildren 1= " + mc.getChildAt(2).name);		
			}
		
			utilFun.SetText(mc["tableNo"], String( bet["table_no"]) );		
			
			var rowmax:int;
			var rowdis:int;
			var RowCnt:int;
			var Ydiff:int = 80;
			if ( ball_lenth == 4) 
			{
				rowmax = 4;
				rowdis = 1350;
				RowCnt = 4;
			}
			else if ( ball_lenth == 3) 
			{
				rowmax = 5;
				rowdis = 1350;
				RowCnt = 5;
			}
			else if ( ball_lenth == 2) 
			{
				rowmax = 6;
				rowdis = 1350;
				RowCnt = 6;
			}
			else if ( ball_lenth == 1) 
			{
				rowmax = 8;
				rowdis = 1350;
				RowCnt = 8;
			}
			else if ( ball_lenth == 0) 
			{
				rowmax = 13;
				rowdis = 1350;
				RowCnt = 13;
			}
			
			var Xdiff:Number = utilFun.NPointInterpolateDistance(rowmax, 0, rowdis);
			mc.x = mc.parent.parent.x + (idx % RowCnt *Xdiff);
			mc.y = mc.parent.parent.y + ( Math.floor(idx / RowCnt) * Ydiff);		
			
			//TODO sort to first?
			if ( _betCommand.get_my_betlist() != null) 
			{
				var table:Array = _betCommand.get_my_bet_info("table");
				if ( table.indexOf( bet["table_no"]) != -1) mc.gotoAndStop(2);
			}
		}
		
		
		
	}

}