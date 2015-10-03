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
		public var _betCommand:BetCommand;
		
		
		private var _pageModel:PageStyleModel 
		
		public function Visual_RoomSelect() 
		{
			
		}
		
		public function init():void
		{			
			
			var tabob:Object = _model.getValue("SelectRoomInfo");
			var spider:MultiObject = prepare("spider", new MultiObject()  , GetSingleItem("_view").parent.parent);
			spider.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [1, 2, 2, 1]);			
			spider.mousedown = select_room;
			spider.rollover = test_reaction;
			spider.rollout = test_reaction;
			spider.mouseup = test_reaction;
			spider.CustomizedData = [tabob];
			spider.CustomizedFun = table_setting_Setting;
			spider.Posi_CustzmiedFun = Posi_Setting;
			spider.Post_CustomizedData = [15, 125, 124];
			spider.Create_by_list(100, [ResName.roomitem], 0, 0, 15, 125, 124, "time_");
			spider.container.x = 24.8
			spider.container.y = 160.6			
			spider.customized();
			
			_pageModel = new PageStyleModel();
			_pageModel.UpDateModel(_model.getValue("SelectRoomInfo"), 50);			
			
			//_tool.SetControlMc(spider.container);
			//add(_tool);
			
			//var page:MultiObject = prepare("pagearr", new MultiObject(), GetSingleItem("_view").parent.parent);
			//page.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[0,0,2,1]);			
			//page.mousedown = test_reaction;
			//page.mouseup = reaction;			
			//page.CustomizedFun = arror_turn;
			//page.Create_by_list(2, [ResName.L_arrow_l, ResName.L_arrow_r], 0 , 0, 2, 1880 , 0, "Bet_");
			//page.container.x = 10;
			//page.container.y = 502;
			
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
			
			//var row:int = Math.floor( idx / 15) ;
			//if ( row ==1)
		//	if (row == 1 || row == 3 ) mc.x = 120.3 + (idx % 10) * 160;			
		}
		
		public function Posi_Colum_first_Setting(mc:MovieClip, idx:int, data:Array):void
		{			
			var ColumnCnt:int = data[0];
			var xdiff:int = data[1];
			var ydiff:int = data[2];
			mc.x = ( Math.floor(idx / ColumnCnt) * data[1]);		
			mc.y = (idx % ColumnCnt * ydiff);
		}
		
		public function Posi_Setting(mc:MovieClip, idx:int, data:Array):void
		{		
			var rowCnt:int = data[0];
			var xdiff:int = data[1];
			var ydiff:int = data[2];
			
			var x_shift:Number = 0;
			if ( Math.floor(idx / rowCnt) == 1) x_shift = 125 / 2 * 1;
			if ( Math.floor(idx / rowCnt) == 2) x_shift = 125 / 2 * 4;
			if ( Math.floor(idx / rowCnt) == 3) x_shift = 125 / 2 * 5;
			if ( Math.floor(idx / rowCnt) == 4) x_shift = 125 / 2 * 8;
			if ( Math.floor(idx / rowCnt) == 5) x_shift = 125 / 2 * 9;
			if ( Math.floor(idx / rowCnt) == 6) x_shift = 125 / 2 * 10;
			
			if ( idx == 29) 
			{
				mc.x = (30 % rowCnt * xdiff ) + (x_shift * 2);					
			}
			//row3
			else if (idx == 43)
			{
				mc.x = (45 % rowCnt * xdiff )  + (125 / 2 ) * 1;				
			}
			else if (idx == 44)
			{
				mc.x = (45 % rowCnt * xdiff )  + (125 / 2 ) * 3;				
			}
			//row5
			else if (idx == 57 || idx ==58 || idx ==59)
			{
				mc.x = (60 % rowCnt * xdiff )  + (125  ) * (idx-56);				
			}		
			else if (idx == 71)
			{
				mc.x = (75 % rowCnt * xdiff )  + (125 / 2 ) * 1;
			}
			else if (idx == 72)
			{
				mc.x = (75 % rowCnt * xdiff )  + (125 / 2 ) * 3;
			}
			else if (idx == 73)
			{
				mc.x = (75 % rowCnt * xdiff )  + (125 / 2 ) * 5;
			}
			else if (idx == 74)
			{
				mc.x = (75 % rowCnt * xdiff )  + (125 / 2 ) * 7;
			}
			else if (idx == 85 || idx == 86 || idx ==87 || idx ==88 || idx ==89)
			{
				mc.x = (90 % rowCnt * xdiff )  + (125  ) * (idx-85);
			}
			
			else mc.x = (idx % rowCnt * xdiff ) +x_shift;
			
			if ( idx == 29) 
			{
				mc.y = ( Math.floor(30 / rowCnt) * ydiff );
			}
			else if (idx == 43 || idx == 44)
			{
				mc.y = ( Math.floor(45 / rowCnt) * ydiff )			
			}			
			else if (idx == 57 || idx == 58 || idx ==59)
			{
				mc.y = ( Math.floor(60 / rowCnt) * ydiff )			
			}
			else if (idx == 71 || idx == 72 || idx ==73 || idx ==74)
			{
				mc.y = ( Math.floor(75 / rowCnt) * ydiff )			
			}		
			else if (idx == 85 || idx == 86 || idx ==87 || idx ==88 || idx ==89)
			{
				mc.y = ( Math.floor(90 / rowCnt) * ydiff )			
			}		
			else mc.y = ( Math.floor(idx / rowCnt) * ydiff );		
			
			
		}
		
	}

}