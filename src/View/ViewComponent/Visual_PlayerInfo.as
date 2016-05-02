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
	
	import flash.text.TextFormat;
	import 	flash.text.TextFormatAlign;
	
	/**
	 * playerinfo present way
	 * @author ...
	 */
	public class Visual_PlayerInfo  extends VisualHandler
	{
		[Inject]
		public var _betCommand:BetCommand;
		
		public function Visual_PlayerInfo() 
		{
			
		}
		
		public function init():void
		{
						
			//盤號 內盤,外盤
			var betview_info:MultiObject = create("bet_view_info",  [ResName.Paninfo_font]);
			betview_info.CustomizedFun = betview_fun			
			betview_info.container.x = 267;
			betview_info.container.y = 80;		
			betview_info.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			betview_info.Post_CustomizedData = [[0.0], [300, 0], [600, 0], [888, 0]];
			betview_info.Create_(4, "bet_view_info");
			
			var arr:Array = _model.getValue(modelName.BINGO_TABLE);
			var history:Array = _model.getValue(modelName.BINGO_HISTORY);
			
			//arr = [13, 25, 39];
			
			if ( arr.length > 10) 
			{
				arr = arr.slice(0, 10);
			}
			
			//history = [ [1,2,3,4,5,6],[1,2,3,4,5,6],[7,8,9,10,11,12,13],[10],[10],[10],[10],[10],[10],[10] ];
			
			if (history.length >= 10) {
					history.shift();
			}
			
			history.push(arr);
			_model.putValue(modelName.BINGO_HISTORY, history);
			
			var bingo_recode:MultiObject = prepare("bingo_recode", new MultiObject(), GetSingleItem("_view").parent.parent);	
			bingo_recode.CustomizedFun = BetListini
			bingo_recode.CustomizedData = _model.getValue(modelName.BINGO_HISTORY);
			bingo_recode.container.x = 374;
			bingo_recode.container.y = 970;		
			bingo_recode.Create_by_list(10, [ResName.BetButton], 0, 0, 10, 75, 0, "time_");
			
			//_tool.SetControlMc(bingo_recode.container);
			//_tool.SetControlMc(bingo_recode.ItemList[1]);
			//add(_tool);						
		}
		
		public function BetListini(mc:MovieClip,idx:int,bingo_recode:Array):void
		{
			mc["pan_mask"].visible = false;
			
			utilFun.scaleXY(mc, 0.7, 0.7);
			if (bingo_recode.length > idx && bingo_recode[idx].length > 0) {
				
				var str:String = "";
				var myFormat:TextFormat = new TextFormat();
				
				for (var i:int = 0; i <  bingo_recode[idx].length; i++) {
					bingo_recode[idx][i] = utilFun.Format(bingo_recode[idx][i], 2);
				}
				
				if (bingo_recode[idx].length == 1) {
					str = bingo_recode[idx][0];
				}else if (bingo_recode[idx].length == 2) {
					str = bingo_recode[idx][0] + "." +  bingo_recode[idx][1];
					myFormat.size = 38;
					mc["tableNo"].x = -2;
					mc["tableNo"].width = 120;
					myFormat.align = TextFormatAlign.LEFT;

				}else if (bingo_recode[idx].length == 3) {
					str = bingo_recode[idx][0] + "." +  bingo_recode[idx][1] + "\n"  + bingo_recode[idx][2];
					myFormat.size = 25;
					mc["tableNo"].height = 100;
					mc["tableNo"].width = 100;
					mc["tableNo"].x = 10;
					mc["tableNo"].y = 2;
					myFormat.align = TextFormatAlign.LEFT;
					
				}else if(bingo_recode[idx].length == 4) {
					str = bingo_recode[idx][0] + "." +  bingo_recode[idx][1] + "\n" + bingo_recode[idx][2] + "." + bingo_recode[idx][3];
					myFormat.size = 25;
					mc["tableNo"].height = 100;
					mc["tableNo"].width = 100;
					mc["tableNo"].x = 10;
					mc["tableNo"].y = 2;
					myFormat.align = TextFormatAlign.LEFT;
					
				}else if(bingo_recode[idx].length > 4){
					str = bingo_recode[idx][0] + "." +  bingo_recode[idx][1] + "\n" + bingo_recode[idx][2] + "." + bingo_recode[idx][3] + "..";
					myFormat.size = 25;
					mc["tableNo"].height = 100;
					mc["tableNo"].width = 100;
					mc["tableNo"].x = 10;
					mc["tableNo"].y = 2;
					myFormat.align = TextFormatAlign.LEFT;
					
				}
			
				mc["tableNo"].defaultTextFormat = myFormat;
			}else {
				str = "";
			}
			
			
			utilFun.SetText(mc["tableNo"], str);
			
			if ( idx == 0) mc["tableNo"].textColor = 0xFF0000;
			
			//先調回無人下注
			mc.gotoAndStop( 1 );			
			
		}
		
		public function betview_fun(mc:MovieClip, idx:int, CustomizedData:Array):void
		{
			utilFun.SetText(mc["_text"], "");
			
			//包廂
			if ( idx == 0) 	utilFun.SetText(mc["_text"], String(_model.getValue("room_num")));
			
			//內盤 (沒人押叫內盤)
			if ( idx == 1) 	utilFun.SetText(mc["_text"], String(100));
			
			//外盤 (有人押叫外盤)			
			if ( idx == 2) 	utilFun.SetText(mc["_text"], String(0));
			
			//場次
			if( idx ==3) 	utilFun.SetText(mc["_text"], String(_model.getValue("game_round")));
		}
		
		//[MessageHandler(type = "Model.ModelEvent", selector = "betstateupdate")]
		//[MessageHandler(type = "Model.ModelEvent", selector = "bet_list_update")]		
		//[MessageHandler(type = "Model.ModelEvent", selector = "betstateupdate")]
		[MessageHandler(type="ConnectModule.websocket.WebSoketInternalMsg",selector="betstateupdate")]
		public function UpdataTableBetInfo():void
		{							
			//外盤 (有人押叫外盤)		
			utilFun.SetText(GetSingleItem("bet_view_info", 2)["_text"], String(GetBetCnt()));
			
			//內盤 (沒人押叫內盤)			
			utilFun.SetText( GetSingleItem("bet_view_info", 1)["_text"], String(_model.getValue("NoOne_bet")));			
			
			//實際押注更新資訊
			dispatcher(new ModelEvent("pan_update"));
		}
		
		public function GetBetCnt():int
		{
			var is_bet:Array = _model.getValue("is_betarr");
			
			var Cnt:int = 0;
			var len:int =  is_bet.length;
			for (var i:int = 0; i < len; i++)
			{				
				if ( is_bet[i] == 1)
				{
					Cnt++;
				}
			}
			
			_model.putValue("SomeOne_bet", Cnt);
			_model.putValue("NoOne_bet", (len - Cnt));
			return Cnt;
		}
		
		
		
	}

}