package View.ViewComponent 
{	
	import Command.BetCommand;
	import flash.display.MovieClip;
	import flash.events.Event;
	import Model.ModelEvent;
	import Model.PageStyleModel;
	import View.ViewBase.VisualHandler;
	import View.Viewutil.*;
	import util.*;
	
	import Model.modelName;
	import View.GameView.gameState;
	
	
	/**
	 * differ page item diplay
	 * @author Dyson0913
	 */
	public class Visual_page_arrow  extends VisualHandler
	{
		[Inject]
		public var _betCommand:BetCommand;
		
		public function Visual_page_arrow() 
		{
			
		}
		
		public function init():void
		{
			//如無特殊需求,可直接在這裡生成,要在別的地方,copy到想要用的地方
			//var arrow:MultiObject = create("arrow", ["arrow_left", "arrow_right"]);
			//arrow.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [0, 0, 3, 2]);
			//arrow.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			//arrow.Post_CustomizedData = [2,1826,0];
			//arrow.container.x = 1.1;
			//arrow.container.y = 593.35;
			//arrow.Create_(2);		
			
			//page 功能會使用的model
			
			//TODO 應該不用這個idx,每個pageModel裡有記
			_model.putValue("Current_item_selcet_idx", 0);
			
			var page:DI = new DI();			
			
			var new_Model:PageStyleModel = new PageStyleModel();
			new_Model.UpDateModel([], 50);
			page.putValue("history_page", new_Model);
			
			_model.putValue("page_module", page);
			_model.putValue("current_page_module", new PageStyleModel());
			
			//state_parse([gameState.NEW_ROUND,gameState.END_ROUND]);
		}
		
		public function appear():void
		{
			setFrame("arrow", 2);
			var arrow:MultiObject = Get("arrow");			
			arrow.mousedown = page_change;
			arrow.mouseup = empty_reaction;
			arrow.FlushObject();
			
		}
		
		public function disappear():void
		{
			setFrame("arrow", 1);
			var arrow:MultiObject = Get("arrow");						
			arrow.mousedown = null;
			arrow.mouseup = null;
		}
		
		public function page_change(e:Event, idx:int):Boolean
		{			
			var _current_Model:PageStyleModel =  _model.getValue("current_page_module");
			if ( idx == 0) _current_Model.PrePage();		
			else _current_Model.NextPage();
			
			update_page_and_all();			
			updatepage();
			
			return true;
		}
		
		public function updatepage():void
		{			
			dispatcher(new ModelEvent("page_update"));	
		}	
		
		//更新目前page model 項目時,也一拼更新該page_model 一頁所需的data,以及該項目的所有data
		public function set_current_page_module(dynamic_module:Array,pagekind:String ):void
		{
			var current_module:PageStyleModel = _model.getValue("page_module").getValue(pagekind);
			current_module.UpDateModel(dynamic_module, current_module.PageAmount);
			_model.putValue("current_page_module", current_module);			
			
			//客制處理不應該在這
			//if (pagekind == "buy_ticket") {
				//var current_module:PageStyleModel = _model.getValue("page_module").getValue("buy_ticket");
				//current_module.GoLastPage();
			//}
			
			//一頁data			
			update_page_and_all();
			
			//客制處理不應該在這
			//該項目所有選項
			//if ( pagekind != "buy_ticket") 
			//{
				//_model.putValue("one_catalog_data", dynamic_module);
			//}
			
		}	
		
		public function update_page_and_all():void
		{
			var current_Model:PageStyleModel =  _model.getValue("current_page_module");
			_model.putValue("one_page_data", current_Model.GetPageDate());			
		}
		
		public function update_select_item(idx:int):void
		{
			var current_Model:PageStyleModel =  _model.getValue("current_page_module");
			_model.putValue("current_item", current_Model.GetOneDate(idx));
		}
		
		public function current_page():int
		{
			var current_Model:PageStyleModel =  _model.getValue("current_page_module");
			return current_Model.ItemPageIdx;
		}
		
		public function test_suit():void
		{
			//var state:int = _model.getValue(modelName.GAMES_STATE);
			//if ( state == gameState.NEW_ROUND  || state == gameState.START_BET)
			//{				
				//test_frame_Not_equal( GetSingleItem("theme") , 1);
				//test_frame_Not_equal(GetSingleItem("theme")["Logo"] , 1);	
				//
				//test_frame_Not_equal(GetSingleItem("Zonetitle", 0), 1);
				//test_frame_Not_equal(GetSingleItem("Zonetitle", 1), 2);
			//}
			//else if ( state == gameState.END_BET  || state == gameState.START_OPEN)
			//{
				//test_frame_Not_equal( GetSingleItem("theme") , 2);
				//test_frame_Not_equal(GetSingleItem("theme")["Logo"] , 1);	
				//
				//test_frame_Not_equal(GetSingleItem("Zonetitle", 0), 4);
				//test_frame_Not_equal(GetSingleItem("Zonetitle", 1), 3);
			//}
			//else if ( state == gameState.END_ROUND )
			//{
				//test_frame_Not_equal( GetSingleItem("theme") , 2);
				//test_frame_equal(GetSingleItem("theme")["Logo"] , 1);
				//
				//test_frame_Not_equal(GetSingleItem("Zonetitle", 0), 4);
				//test_frame_Not_equal(GetSingleItem("Zonetitle", 1), 5);
			//}
			//else 
			//{
				//Log("visual_theme not  handle");
			//}
		}
		
	}

}