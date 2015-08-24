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
			var betview_info:MultiObject = prepare("bet_view_info", new MultiObject(), GetSingleItem("_view").parent.parent);	
			betview_info.CustomizedFun = betview_fun			
			betview_info.container.x = 267;
			betview_info.container.y = 80;		
			betview_info.Create_by_list(4, [ResName.Paninfo_font], 0, 0, 4, 300, 0, "time_");
			
			var bingo_recode:MultiObject = prepare("bingo_recode", new MultiObject(), GetSingleItem("_view").parent.parent);	
			bingo_recode.CustomizedFun = BetListini
			bingo_recode.CustomizedData = [11,26,35];
			bingo_recode.container.x = 564;
			bingo_recode.container.y = 970;		
			bingo_recode.Create_by_list(5, [ResName.BetButton], 0, 0, 5, 75, 0, "time_");
			
			//_tool.SetControlMc(bingo_recode.container);
			//_tool.SetControlMc(bingo_recode.ItemList[1]);
			//add(_tool);						
		}
		
		public function BetListini(mc:MovieClip,idx:int,bingo_recode:Array):void
		{
			utilFun.scaleXY(mc, 0.7, 0.7);
			var str:String = idx >= bingo_recode.length ? "" : bingo_recode[idx];
			utilFun.SetText(mc["tableNo"], str);
			//1,無人 2為自己, 3自己最後一注,4,為他人			
			
			//先調回無人下注
			mc.gotoAndStop( 1 );
			
			//有人下非自己,變黃
			//if ( bingo_recode[idx] == 1)
			//{
				//var MyBet:int = arr.indexOf(idx)
				//if ( MyBet != -1)
				//{
					//紅
					//if (  MyBet == (cnt - 1))  
					//{
						//mc.gotoAndStop( (bingo_recode[idx] + 2) );
					//}
					//else mc.gotoAndStop( (bingo_recode[idx] + 1) );
				//}
				//else
				//{
					//黃
					//mc.gotoAndStop( (bingo_recode[idx] + 3) );
				//}
			//}
			
		}
		
		public function betview_fun(mc:MovieClip, idx:int, CustomizedData:Array):void
		{
			utilFun.SetText(mc["_text"], "");
			
			//包廂
			if ( idx == 0) 	utilFun.SetText(mc["_text"], String(99));
			
			//內盤 (沒人押叫內盤)
			if ( idx == 1) 	utilFun.SetText(mc["_text"], String(100));
			
			//外盤 (有人押叫外盤)			
			if ( idx == 2) 	utilFun.SetText(mc["_text"], String(0));
			
			//場次
			if( idx ==3) 	utilFun.SetText(mc["_text"], String(0));
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "bet_list_update")]
		public function UpdataTableBetInfo():void
		{				
			//外盤 (有人押叫外盤)		
			utilFun.SetText(GetSingleItem("bet_view_info", 2)["_text"], String(GetBetCnt()));
			
			//內盤 (沒人押叫內盤)			
			utilFun.SetText( GetSingleItem("bet_view_info", 1)["_text"], String(_model.getValue("NoOne_bet")));			
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
			
			_model.putValue("NoOne_bet", (len - Cnt));
			return Cnt;
		}
		
		
		
	}

}