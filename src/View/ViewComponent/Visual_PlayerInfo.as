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
			
				
			//_tool.SetControlMc(betview_info.container);
			//add(_tool);						
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