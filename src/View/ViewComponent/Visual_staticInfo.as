package View.ViewComponent 
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import View.ViewBase.Visual_Text;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	import caurina.transitions.Tweener;
	
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	
	/**
	 * playerinfo present way
	 * @author ...
	 */
	public class Visual_staticInfo  extends VisualHandler
	{
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _text:Visual_Text;
		
		public function Visual_staticInfo() 
		{
			
		}
		
		public function init():void
		{
			//包箱號
			var room:int = _model.getValue("room_num");			
			var myroom:MultiObject = prepare("myroom", new MultiObject(), GetSingleItem("_view").parent.parent);
			myroom.CustomizedFun = _text.textSetting;
			myroom.CustomizedData = [{size:30,color:0xFF0000}, room.toString()];			
			myroom.container.x = 532;
			myroom.container.y = 55;
			myroom.container.visible = true;
			myroom.Create_by_list(1, [ResName.Paninfo_font], 0, 0, 1, 0, 0, "time_");
			
			
			//最佳盤號 次佳盤數字
			var bestinfo:MultiObject = prepare("best_pan_info", new MultiObject(), GetSingleItem("_view").parent.parent);	
			bestinfo.CustomizedFun = info_initFun;
			bestinfo.container.x = 809;
			bestinfo.container.y = 55;
			bestinfo.Create_by_list(4, [ResName.Paninfo_font], 0, 0, 2, 180, 243, "time_");			
			
			//總球數
			var totalball_info:MultiObject = prepare("total_ball_info", new MultiObject(), GetSingleItem("_view").parent.parent);
			totalball_info.CustomizedFun = _text.textSetting;
			totalball_info.CustomizedData = [{size:40,color:0xCCCCCC}, ""];			
			totalball_info.container.x = -45;
			totalball_info.container.y = 89;
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
			
			//_tool.SetControlMc(myroom.container);
			//_tool.y = 200;
			//add(_tool);
		
		}
		
		public function info_initFun(mc:MovieClip, idx:int, scalesize:Array):void
		{				
			utilFun.SetText(mc["_text"], "");			
		}
		
		[MessageHandler(type="ConnectModule.websocket.WebSoketInternalMsg",selector="ballupdate")]
		public function UpdataTableBetInfo():void
		{	
			//utilFun.SetText(GetSingleItem("total_ball_info")["_text"], String( _model.getValue("opened_ball_num") ));
			utilFun.Clear_ItemChildren(GetSingleItem("total_ball_info"));
			Get("total_ball_info").CustomizedData =  [{size:40,color:0xCCCCCC, align:TextFormatAlign.CENTER}, String( _model.getValue("opened_ball_num"))];		
			Get("total_ball_info").FlushObject();
			
			
			utilFun.SetText(GetSingleItem("best_pan_info", 0)["_text"], String( _model.getValue("best_remain") ));
			utilFun.SetText(GetSingleItem("best_pan_info", 2)["_text"], String( _model.getValue("second_remain") ));
			
			var best_list:Array = _model.getValue("best_list");
			utilFun.SetText(GetSingleItem("best_pan_info", 1)["_text"], String( best_list.length ));
			var second_list:Array  = _model.getValue("second_list");
			utilFun.SetText(GetSingleItem("best_pan_info", 3)["_text"], String( second_list.length ));
			
			var table:Array = _betCommand.get_my_bet_info(BetCommand.Table);			
			table.sort(order_bet_table);			
			//TODO sort
			var bet:Object = best_list[0];			
			var ball_lenth:int =  bet.ball_list.length;
			best_list.sort(order_table);
			
			var table_no:Array = [];
			for ( var i:int = 0; i < best_list.length ; i++)
			{
				var ob:Object = best_list[i];
				table_no.push(ob["table_no"]);
			}			
			
			for ( var i: int = 0; i < table.length; i++)
			{
				var find_idx:int = table_no.indexOf(table[i]);
				if ( find_idx == -1) continue;				
				var ob1:Array  = best_list.slice(find_idx, find_idx+1);
				var fir:Object =  ob1[0];				
				best_list.splice(find_idx, 1);
				best_list.unshift(fir);				
			}			
			
			var dis:Array = [best_list,ball_lenth,"best"];		
			//utilFun.Log("best_list ball_lenth = " + ball_lenth) ;		
			
			//Get("public_best_pan_info").CustomizedFun = pan_set;						
			//Get("public_best_pan_info").CustomizedData = _model.getValue("best_list");				
			Get("public_best_pan_info").Posi_CustzmiedFun = reposition;						
			Get("public_best_pan_info").Post_CustomizedData = dis;
			Get("public_best_pan_info").customized();
			
			bet = second_list[0];
			ball_lenth =  bet.ball_list.length;
			second_list.sort(order_table);
			
			var table_no2:Array = [];
			for ( var i:int = 0; i < second_list.length ; i++)
			{
				var ob:Object = second_list[i];
				table_no2.push(ob["table_no"]);
			}
			
			for ( var i: int = 0; i < table.length; i++)
			{
				var find_idx:int = table_no2.indexOf(table[i]);
				if ( find_idx == -1) continue;
				var ob2:Array = second_list.slice(find_idx, find_idx+1);
				var fir2:Object =  ob2[0];
				second_list.splice(find_idx,1);
				second_list.unshift(fir2);	
			}
			
			dis = [second_list, ball_lenth,"second"];
			//utilFun.Log("second_list ball_lenth =" + sball_lenth) ;
			Get("public_second_pan_info").Posi_CustzmiedFun = reposition;						
			Get("public_second_pan_info").Post_CustomizedData = dis;
			Get("public_second_pan_info").customized();
			
			//utilFun.Log("down") ;
		}
		
		//傳回值 -1 表示第一個參數 a 是在第二個參數 b 之前。
		//傳回值 1 表示第二個參數 b 是在第一個參數 a 之前。
		//傳回值 0 指出元素都具有相同的排序優先順序。
		private function order_table(a:Object, b:Object):int 
		{
			if ( a["table_no"] < b["table_no"]) return -1;
			else if ( a["table_no"] > b["table_no"]) return 1;
			else return 0;
		}	
		
		//self bet table 
		//TODO check why can't  big -> small ><
		private function order_bet_table(a:int, b:int):int 
		{
			if ( a < b) return -1;
			else if ( a > b) return 1;
			else return 0;			
		}
		
		
		public function pan_set(mc:MovieClip, idx:int, tablelist:Array):void
		{				
			mc.visible = false;			
		}
		
		public function sballFun(mc:MovieClip, idx:int, ball:Array):void
		{
			//TODO combination setting ,like scale ,set test ,splite to reuse
			//utilFun.scaleXY(mc, 0.8, 0.8);
			var num:int = Math.ceil( (ball[idx] + 1) / 15);
			mc.gotoAndStop( Math.ceil( (ball[idx] + 1) / 15) ) ;			
			utilFun.SetText(mc["ballNum"], String(ball[idx]));
			
			//if ( num == 4 || num == 5) 
			mc["ballNum"].textColor = 0xFFFFFF;
			
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
				var listname:String =  dis[2];	
				if ( Get("small_ball"+listname + idx) == null)
				{
					var needSort:Array = bet.ball_list;
					needSort.sort(order);
					var sball:MultiObject = prepare("small_ball+"+listname + idx, new MultiObject()  , mc);
					sball.CustomizedFun = sballFun;		   
				   sball.CustomizedData = needSort;
				   sball.Create_by_list(ball_lenth, [ResName.Ballforfour], 0, 0, ball_lenth, 55, 0, "time_");
				   sball.container.x = 101;
				   sball.container.y = 8;
				}
				else
				{
					var needtoSort:Array = bet.ball_list;
					needtoSort.sort(order);
					var ballList:MultiObject = Get("small_ball"+listname + idx);
					ballList.CleanList();
					ballList.CustomizedFun = sballFun;		   
				    ballList.CustomizedData = needtoSort;
				    ballList.Create_by_list(ball_lenth, [ResName.Ballforfour], 0, 0, ball_lenth, 55, 0, "time_");
				    ballList.container.x = 101;
				    ballList.container.y = 8;
				}
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
			if ( _betCommand.get_my_betlist().length != 0) 
			{
				var table:Array = _betCommand.get_my_bet_info(BetCommand.Table);
				if ( table.indexOf( bet["table_no"]) != -1) mc.gotoAndStop(2);
			}
		}
		
		// ><  big -> small
		// <> small -> big
		 //small ball order
		private function order(a:int, b:int):int 
		{
			if (  a < b) return -1;
			else if ( a > b) return 1;
			else return 0;			
		}
		
		[MessageHandler(type = "ConnectModule.websocket.WebSoketInternalMsg", selector = "specail_round")]
		public function sp():void
		{
			Get("myroom").container.visible = false;
			Get("total_ball_info").container.visible = false;
			
			utilFun.SetText(GetSingleItem("best_pan_info", 0)["_text"], "" );
			utilFun.SetText(GetSingleItem("best_pan_info", 2)["_text"], "" );
			
			utilFun.SetText(GetSingleItem("best_pan_info", 1)["_text"], "");			
			utilFun.SetText(GetSingleItem("best_pan_info", 3)["_text"], "");
			
			
			Get("public_best_pan_info").CleanList()			
			Get("public_second_pan_info")..CleanList();			
			
		}
		
	}

}