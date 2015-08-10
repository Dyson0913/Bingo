package View.ViewComponent 
{
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
						
			//stick cotainer  
			var coinstack:MultiObject = prepare("bet_view_info", new MultiObject(), GetSingleItem("_view").parent.parent);	
			coinstack.container.x = 305;
			coinstack.container.y = 83;
			//coinstack.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			//coinstack.Post_CustomizedData = [[830,200],[180,100],[615,57]];
			coinstack.Create_by_list(4, [ResName.sys_num], 0, 0, 4, 300, 0, "time_");
			
			
			//下注區容器
			//var playerzone:MultiObject = prepare("betzone", new MultiObject() , GetSingleItem("_view").parent.parent);
			//playerzone.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[0,0,3,1]); //1 ,2,3,2
			//playerzone.container.x = 196;
			//playerzone.container.y = 502;
			//playerzone.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			//playerzone.Post_CustomizedData = [[760,0],[0,0],[575,-33]];
			//playerzone.Create_by_list(avaliblezone.length, avaliblezone, 0, 0, avaliblezone.length, 0, 0, "time_");
			
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