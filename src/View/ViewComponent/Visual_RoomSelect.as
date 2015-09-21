package View.ViewComponent 
{
	import ConnectModule.websocket.WebSoketInternalMsg;
	import flash.display.MovieClip;
	import flash.events.Event;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	import View.Viewutil.*;
	import caurina.transitions.Tweener;
	
	/**
	 * hintmsg present way
	 * @author ...
	 */
	public class Visual_RoomSelect  extends VisualHandler
	{
		[Inject]
		public var _regular:RegularSetting;
		
		[Inject]
		public var _betCommand:BetCommand;
		
		
		private var _pageModel:PageStyleModel 
		
		public function Visual_RoomSelect() 
		{
			
		}
		
		public function init():void
		{
			var tabob:Object = _model.getValue("SelectRoomInfo");
			var spider:MultiObject = prepare("spider", new MultiObject()  , GetSingleItem("_view").parent.parent);
			spider.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [0, 0, 2, 1]);			
			spider.mousedown = select_room;
			spider.mouseup = test_reaction;
			spider.CustomizedData = [tabob];
			spider.CustomizedFun = table_setting_Setting;
			
			spider.Create_by_list(50, [ResName.roomitem], 0, 0, 10, 160, 163, "time_");
			spider.container.x = 120.3;
			spider.container.y = 170.95;			
			spider.customized();
			
			_pageModel = new PageStyleModel();
			_pageModel.UpDateModel(_model.getValue("SelectRoomInfo"), 50);			
			
			//_tool.SetControlMc(public_best_pan.container);
			//add(_tool);
			
			var page:MultiObject = prepare("pagearr", new MultiObject(), GetSingleItem("_view").parent.parent);
			page.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[0,0,2,1]);			
			page.mousedown = test_reaction;
			page.mouseup = reaction;			
			page.CustomizedFun = arror_turn;
			page.Create_by_list(2, [ResName.L_arrow_l, ResName.L_arrow_r], 0 , 0, 2, 1880 , 0, "Bet_");
			page.container.x = 10;
			page.container.y = 502;
			
		}
		
		public function select_room(e:Event, idx:int):Boolean
		{
			var ob:Object = _pageModel.GetOneDate(idx);
			utilFun.Log("ob.roomnUm = "+ob.room_no);
			_model.putValue("room_num", ob.room_no);
			dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.CHOOSE_ROOM));
			return true;
		}
		
		public function test_reaction(e:Event, idx:int):Boolean
		{			
			return true;
		}
		
		public function reaction(e:Event, idx:int):Boolean
		{
			
			if ( idx == 0)
			{				
				_pageModel.PrePage();				
			}
			else
			{				
				_pageModel.NextPage();
			}
			updatepage();
			return true;
		}
		
		private function updatepage():void
		{
			var data:Array = _pageModel.GetPageDate();
			Get("spider").CustomizedData = [data];
			Get("spider").customized();
		}
		
		public function arror_turn(mc:MovieClip, idx:int, data:Array):void
		{
			if ( idx == 1) mc.rotationY = 180;
			
		}
		
		public function table_setting_Setting(mc:MovieClip, idx:int, data:Array):void
		{
			var oblist:Object = data[0];
			
			var item:Object = oblist[idx];		
			mc["tableNo"].text = utilFun.Format(parseInt(item.room_no),2);
			mc["PeopleNo"].text = item.bet_tables;
			
			var row:int = Math.floor( idx / 10) ;
			if (row == 1 || row == 3 ) mc.x = 120.3 + (idx % 10) * 160;			
		}
		
	}

}