package View.ViewComponent 
{
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
	
	/**
	 * history present way
	 * @author dyson0913
	 */
	public class Visual_hisotry  extends VisualHandler
	{
		[Inject]
		public var _page_arrow:Visual_page_arrow;
		
		public function Visual_hisotry() 
		{
			
		}
		
		public function init():void
		{
			//hisotry pan
			var arr:Array  = [];
			for (var i:int = 0; i < 67; i++)
			{
				var out:int = utilFun.Random(100);
				var fakeopenball:Array = [];
				for ( var k:int = 1; k < 75; k++)
				{
					
					var open_or_not:int = utilFun.Random(3);
					if ( open_or_not == 1) fakeopenball.push(k);				
				}								
				utilFun.Log("i = " + i + " fakeopenball = " + fakeopenball);
				
				
				
				var history_ob:Object ;
				history_ob = { "round": utilFun.Format(i,2),
			            "bingo_pan":  [utilFun.Random(99),utilFun.Random(99),utilFun.Random(99),utilFun.Random(99)],
						"out_pan": out,
						"in_pan":  100 - out,											
						"openball_list": 	fakeopenball,
						"total_openball": 	fakeopenball.length,
						"bingo_ball": 	utilFun.Random(99)
									   };
				arr.push(history_ob);
			}
			_model.putValue("history_opened_ball", arr);			
			
			
			create_container();			
			
			var font:Array = [ { size:50, align:_text.align_left,bold:true, color:0x999999 } ];			
			font = font.concat(["歷史看板"]);
			var title:MultiObject = create("title", [ResName.Paninfo_font],_myContain.container );			
			title.CustomizedData = font;
			title.CustomizedFun = _text.textSetting;
			title.Create_(1,"title");
			title.container.x = 1598;			
			title.container.y = 90;			
			
			var r_font:Array = [ { size:30, align:_text.align_left,bold:true, color:0x999999 } ];			
			r_font = r_font.concat(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]);			
			var row_title:MultiObject = create("row_title", [ResName.Paninfo_font],_myContain.container );			
			row_title.CustomizedData = r_font;
			row_title.CustomizedFun = _text.textSetting;
			row_title.Posi_CustzmiedFun =  _regular.Posi_Row_first_Setting;
			row_title.Post_CustomizedData = [10, 110, 0];
			row_title.Create_(10,"row_title");
			row_title.container.x = 531;			
			row_title.container.y = 108;			
			
			var c_font:Array = [ { size:30, align:_text.align_left,bold:true, color:0x999999 } ];			
			c_font = c_font.concat(["0*","1*","2*","3*","4*"]);
			var colum_title:MultiObject = create("colum_title", [ResName.Paninfo_font],_myContain.container );			
			colum_title.CustomizedData = c_font;
			colum_title.CustomizedFun = _text.textSetting;
			colum_title.Posi_CustzmiedFun =  _regular.Posi_Colum_first_Setting;
			colum_title.Post_CustomizedData = [5, 0, 75];
			colum_title.Create_(5,"colum_title");
			colum_title.container.x = 441;
			colum_title.container.y = 168;
			
			var board_font:Array = [ { size:30, align:_text.align_left,bold:true, color:0x999999 } ];			
			board_font = board_font.concat(["場    次 ","賓果盤號 ","賣    出 ","內    盤 ","球    數 ","賓果球 "]);
			var board_title:MultiObject = create("board_title", [ResName.Paninfo_font], _myContain.container );
			board_title.CustomizedData = board_font; 
			board_title.CustomizedFun = _text.textSetting;
			board_title.Posi_CustzmiedFun =  _regular.Posi_xy_Setting;
			board_title.Post_CustomizedData = [[0, 0], [0, 50], [0, 150], [0, 200], [0, 250], [0, 300]];
			board_title.Create_(6,"board_title");
			board_title.container.x = 1601;
			board_title.container.y = 158;
			
			//電子看版資料
			var board_data_font:Array = [ { size:30, align:_text.align_left,bold:true, color:0xFFFFFF } ];			
			board_data_font = board_data_font.concat(["1 ","2 ","3 ","4"]);
			var board_data:MultiObject = create("board_data", [ResName.Paninfo_font], _myContain.container );
			board_data.CustomizedData = board_data_font; 
			board_data.CustomizedFun = _text.textSetting;
			board_data.Posi_CustzmiedFun =  _regular.Posi_xy_Setting;
			board_data.Post_CustomizedData = [[0, 0], [0, 150], [0, 200], [0, 250],];
			board_data.Create_(4,"board_data");
			board_data.container.x = 1730;
			board_data.container.y = 158;
			
			//最後賓果小球
			var board_ball:MultiObject = create("board_ball", [ResName.Ball], _myContain.container);
		   board_ball.CustomizedFun = sballFun;		   
		   board_ball.CustomizedData = [0.4];	   
		   board_ball.Create_(1, "board_ball");
		   board_ball.container.x = 1720;
		   board_ball.container.y = 458;
		   board_ball.ItemList[0].visible = false;
			
		   //本局賓果盤號
		   var bingo_recode:MultiObject = create("history_bingo_recode", [ResName.BetButton], _myContain.container);
			bingo_recode.CustomizedFun = bingo_history_pan;
			bingo_recode.CustomizedData = [];
			bingo_recode.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			bingo_recode.Post_CustomizedData = [4, 80, 0];
			bingo_recode.Create_(4, "history_bingo_recode");
			bingo_recode.FlushObject_bydata();
			bingo_recode.container.x = 1600;
		    bingo_recode.container.y = 258;
		   
			//歷史75球
		   var hisotry_75:MultiObject = create("history_75", [ResName.Ball_pan], _myContain.container );		   
		   hisotry_75.CustomizedFun = ball_panfun;		   
		   hisotry_75.Create_(1, "history_75");
		   hisotry_75.container.x = 443.9;
		   hisotry_75.container.y = 557;
		   
		   //歷史記錄選項
		  
		   var history:MultiObject = create("history_recode", [ResName.BetButton],_myContain.container);
			history.container.x = 491;
			history.container.y = 156;
			history.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[0,0,3,1]);			
			history.CustomizedData = [];
			history.CustomizedFun = history_init;			
			history.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			history.Post_CustomizedData = [10, 110, 75];
			history.Create_(50,"history_recode");			
			history.mousedown = history_click;
			
			//page
			var arrow:MultiObject = create("arrow", ["arrow_up", "arrow_down"],_myContain.container);
			arrow.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [1, 2, 2, 0]);
			arrow.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			arrow.Post_CustomizedData = [2,0,410];
			arrow.container.x = 441;
			arrow.container.y = 108;
			arrow.Create_(2,"arrow");			
			arrow.rollover = empty_reaction;
			arrow.rollout = empty_reaction;			
			arrow.mousedown = _page_arrow.page_change;
			
			var history_ball:Array =  _model.getValue("history_opened_ball");
			_page_arrow.set_current_page_module(history_ball,"history_page")
			
			//_tool.SetControlMc(arrow.container);
			//add(_tool);		
			
			//TODO find good place to put (for switchbtn)
			var panellist:Array = [];
			if (  Get("ticket") != null) panellist.push( Get("ticket"))
			panellist.push(Get("ball_pan"));
			panellist.push(Get("Visual_hisotry_Contain"));
			
			_model.putValue("switchpanel", panellist);			
			_model.putValue("switchpanel_idx", 0);			
			
			_myContain.container.visible = false;
		}
		
		public function history_init(mc:MovieClip,idx:int,data:Array):void
		{			
			mc["pan_mask"].visible = false;			
			utilFun.SetText(mc["tableNo"], utilFun.Format(idx, 2));		
		}
		
		public function bingo_history_pan(mc:MovieClip,idx:int,bingo_recode:Array):void
		{
			mc["pan_mask"].visible = false;			
			utilFun.scaleXY(mc, 0.7, 0.7);
			
			if ( bingo_recode.length == 0) return;
			utilFun.SetText(mc["tableNo"], bingo_recode[idx]);
			
		}
		
		public function sballFun(mc:MovieClip, idx:int, scalesize:Array):void
		{
			//TODO combination setting ,like scale ,set test ,splite to reuse
			utilFun.scaleXY(mc,scalesize[0], scalesize[0]);
			utilFun.SetText(mc["ballNum"], "");			
		}
		
		public function ball_panfun(mc:MovieClip, idx:int, IsBetInfo:Array):void
		{						
		   var ball:MultiObject = create("history_opan_pan_ball",[ResName.Ball] ,mc);
		   ball.CustomizedFun = panballFun;
		   ball.CustomizedData = [0.4];
		   ball.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
		   ball.Post_CustomizedData = [15, 88, 85];
		   ball.Create_(75,"history_opan_pan_ball");
		   ball.container.x = 118.3;
		   ball.container.y = 18.35;
		}
		
		public function panballFun(mc:MovieClip, idx:int, scalesize:Array):void
		{			
			utilFun.scaleXY(mc, scalesize[0], scalesize[0]);
			mc.gotoAndStop( Math.ceil( (idx + 1) / 15) ) ;
			mc.visible = false;
			utilFun.SetText(mc["ballNum"], utilFun.Format(idx+1 , 1) );			
		}
		
		public function just_visible(mc:MovieClip, idx:int, data:Array):void
		{					
			mc.visible = false;			
		}
		
		public function history_click(e:Event, tableNo:int):Boolean
		{
			utilFun.Log("click = " + tableNo);
			setFrame("history_recode", 1);
			
			click_handle(tableNo);			
			return true;
		}
		
		public function click_handle(tableNo:int):void
		{
			var history_ball:Array =  _model.getValue("history_opened_ball");			
			var page_data:Array = _model.getValue("one_page_data");
			
			var hisotry_ob:Object = page_data[tableNo];
			
			//歷史開球
			var mu:MultiObject = Get("history_opan_pan_ball");
			mu.CustomizedData = [];
			mu.CustomizedFun = just_visible;
			mu.FlushObject();
			history_opened_ball(hisotry_ob["openball_list"]);
			
			//電子看版資訊
			var data:Array = [];
			data.push(hisotry_ob["round"]);
			data.push(hisotry_ob["out_pan"]);
			data.push(hisotry_ob["in_pan"]);
			data.push(hisotry_ob["total_openball"]);
			hisotry_ob["bingo_ball"]
			var board_data:MultiObject = Get("board_data");
			board_data.CustomizedData = data;
			board_data.CustomizedFun = _text.text_update;
			board_data.FlushObject_bydata();
			
			//二個特殊處理 賓果盤號和賓果球
			var bingo_ball:int = hisotry_ob["bingo_ball"];
			utilFun.SetText(GetSingleItem("board_ball", 0)["ballNum"], utilFun.Format(bingo_ball, 2) );				
			GetSingleItem("board_ball", 0).gotoAndStop( Math.ceil( bingo_ball / 15) ) ;
			GetSingleItem("board_ball", 0).visible = true;
			
			var bingo_history:MultiObject = Get("history_bingo_recode");
			bingo_history.CustomizedData =  hisotry_ob["bingo_pan"]
			bingo_history.CustomizedFun = bingo_history_pan;
			bingo_history.FlushObject_bydata();
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "page_update")]
		public function page_upate(para:ModelEvent):void
		{
			//if ( !_diplay ) return;			
			row_recode_update();
		}
		
		public function row_recode_update():void
		{
			var data:Array = _model.getValue("one_page_data");
			
			var bingo_data:Array = [];
			for ( var i:int = 0; i < data.length; i++)
			{
				var recode:Object = data[i];
				bingo_data.push(recode["bingo_pan"][0]);
			}
			
			var history:MultiObject = Get("history_recode");
			history.CustomizedData = bingo_data;
			history.CustomizedFun = update_page;			
			history.FlushObject_bydata();
			
			var data:Array = next_preset();
			var colum_title:MultiObject = Get("colum_title");
			colum_title.CustomizedData = data;
			colum_title.CustomizedFun = _text.text_update;
			colum_title.FlushObject_bydata();
		}
		
		public function update_page(mc:MovieClip,idx:int,data:Array):void
		{			
			mc["pan_mask"].visible = false;
			var page:int = _page_arrow.current_page();
			utilFun.SetText(mc["tableNo"], utilFun.Format(data[idx], 2));		
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "history_show")]
		public function display():void
		{
			utilFun.Log("his display");
			
			row_recode_update();
			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "history_hide")]
		public function hide():void
		{
			utilFun.Log("his hide");
		}
		
		public function next_preset():Array
		{
			var page:int = _page_arrow.current_page();
			page = (page / 10 ) % 10;
			
			var present:Array = [];			
			for (var i:int = 0; i < 5; i++)
			{				
				present.push( (page + i) + "*");
			}
			
			return present;
		}
		
		public function history_opened_ball(openball:Array):void
		{
			var Cnt:int = openball.length;
			for ( var i:int = 0; i < Cnt; i++)
			{
				//server 傳1 base
				var BallIdx:int = openball[i]-1;				
				var ball:MovieClip = GetSingleItem("history_opan_pan_ball", BallIdx);				
				ball.visible = true;				
			}
		}
	}

}