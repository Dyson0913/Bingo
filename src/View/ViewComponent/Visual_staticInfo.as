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
						
			//盤號 內盤,外盤
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
			
			_tool.SetControlMc(totalball_info.container);
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
						
			
			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "updateCredit")]
		public function updateCredit():void
		{							
			var s:int = _model.getValue("after_bet_credit");	
			if ( _model.getValue(modelName.HandShake_chanel) != null )
			{
				var response:Function = _model.getValue(modelName.HandShake_chanel);
				response(_model.getValue(modelName.Client_ID), ["HandShake_updateCredit", s]);
				utilFun.Log("Hand_she asking "+ _model.getValue(modelName.Client_ID));
			}
			else 
			{
				utilFun.SetText(GetSingleItem(modelName.CREDIT)["credit"], _model.getValue("after_bet_credit").toString());
			}
		}		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "update_result_Credit")]
		public function update_result_Credit():void
		{	
				var s:int = _model.getValue(modelName.CREDIT);
			if ( _model.getValue(modelName.HandShake_chanel) != null )
			{
				var response:Function = _model.getValue(modelName.HandShake_chanel);
				response(_model.getValue(modelName.Client_ID), ["HandShake_updateCredit", s]);				
			}
			else
			{
				utilFun.SetText(GetSingleItem(modelName.CREDIT)["credit"], _model.getValue(modelName.CREDIT).toString());
			}
		}
		
	}

}