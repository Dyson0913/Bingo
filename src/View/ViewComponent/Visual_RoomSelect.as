package View.ViewComponent 
{
	import ConnectModule.websocket.WebSoketInternalMsg;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
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
		
		private var _width_dis:Number;
		
		private var _room:MultiObject;
		
		public function Visual_RoomSelect() 
		{
			
		}
		
		public function init():void
		{			
			_width_dis = 128;
			var tabob:Array = _model.getValue("SelectRoomInfo");
			
			_room = prepare("spider", new MultiObject()  , GetSingleItem("_view").parent.parent);
			_room.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [1, 1, 1, 1]);		
			_room.mousedown = select_room;
			_room.CustomizedData = [tabob];
			_room.CustomizedFun = table_setting_Setting;
			_room.Posi_CustzmiedFun = Posi_Setting;
			_room.Post_CustomizedData = [15, _width_dis, 131];
			_room.Create_by_list(100, [ResName.roomitem], 0, 0, 15, 125, 124, "time_");
			_room.container.x = 99.85;
			_room.container.y = 210.3 - 6;
			_room.customized();
			utilFun.scaleXY(_room.container, 0.9, 0.9);
			
			var _sencer:MultiObject = prepare("roomsencer", new MultiObject()  , GetSingleItem("_view").parent.parent);
			_sencer.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [1, 2, 2, 1]);			
			_sencer.mousedown = room_sencer;
			_sencer.rollover = room_sencer;
			_sencer.rollout = room_sencer;
			_sencer.mouseup = room_sencer;
			_sencer.Posi_CustzmiedFun = Posi_Setting;
			_sencer.Post_CustomizedData = [15, _width_dis, 131];
			_sencer.Create_by_list(100, [ResName.R_roomSencer], 0, 0, 15, 125, 124, "time_");
			_sencer.container.x = 113.85;
			_sencer.container.y = 214.3 - 6;
			_sencer.customized();
			utilFun.scaleXY(_sencer.container, 0.9, 0.9);
			
			_pageModel = new PageStyleModel();
			_pageModel.UpDateModel(_model.getValue("SelectRoomInfo"), 100);			
			
			var lobbyhint:MultiObject = create("lobby_hint", ["lobby_hint"]);
			lobbyhint.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [0, 0, 1, 0]);	
			lobbyhint.container.y = 250;
			lobbyhint.Create_(1,"lobby_hint");
			lobbyhint.mousedown = table_true;
			
			//_tool.SetControlMc(lobbyhint.container);
			//_tool.y = 200;
			//add(_tool);		
			
		}			
		
		public function table_true(e:Event, idx:int):Boolean
		{			
			var lobby_hint:MultiObject = Get("lobby_hint");
			lobby_hint.container.visible = !lobby_hint.container.visible;				
			return true;
		}
		
		public function select_room(e:Event, idx:int):Boolean
		{
			var ob:Object = _pageModel.GetOneDate(idx);
			utilFun.Log("ob.roomnUm = "+ob.room_no);
			_model.putValue("room_num", ob.room_no);
			dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.CHOOSE_ROOM));
			return true;
		}
		
		public function room_sencer(e:Event,idx:int):Boolean
		{	
			if ( e.type == MouseEvent.ROLL_OVER)
			{
				var mc:MovieClip = _room.ItemList[idx]["_room"];
				var frame:int = mc.currentFrame ;
				_room.ItemList[idx].gotoAndStop(2);	
				_room.ItemList[idx]["_room"].gotoAndStop(frame);
				return false;
			}
			
			if ( e.type == MouseEvent.ROLL_OUT)
			{
				var mc:MovieClip = _room.ItemList[idx]["_room"];
				var frame:int = mc.currentFrame ;
				_room.ItemList[idx].gotoAndStop(1);	
				_room.ItemList[idx]["_room"].gotoAndStop(frame);
				return false;
			}
			
			if ( e.type == MouseEvent.MOUSE_DOWN)
			{
				var ob:Object = _pageModel.GetOneDate(idx);
				utilFun.Log("ob.roomnUm = "+ob.room_no);
				_model.putValue("room_num", ob.room_no);
				dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.CHOOSE_ROOM));
				return true;
			}
			
			//var betzone:MultiObject = Get("spider");
			//var mc:MovieClip = betzone.ItemList[idx];
			//mc.dispatchEvent(new MouseEvent(e.type, true, false));			
			
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
		
		public function table_setting_Setting(mc:MovieClip, idx:int, data:Array):void
		{
			var oblist:Object = data[0];
			
			var item:Object = oblist[idx];		
			//mc["tableNo"].text = utilFun.Format(parseInt(item.room_no),2);
			//mc["PeopleNo"].text = item.bet_tables;	
			var room_no:int = item.room_no ;
			var room_bet_table:int = item.bet_tables ;
			
			var arr:Array = utilFun.arrFormat(room_no, 2);
			if ( arr[0] == 0 ) arr[0] = 10;
			if ( arr[1] == 0 ) arr[1] = 10;
			mc["room_num_0"].gotoAndStop(arr[0]);
			mc["room_num_1"].gotoAndStop(arr[1]);
			
			arr = utilFun.arrFormat(room_bet_table, 2);
			if ( arr[0] == 0 ) arr[0] = 10;
			if ( arr[1] == 0 ) arr[1] = 10;
			mc["man_num_0"].gotoAndStop(arr[0]);
			mc["man_num_1"].gotoAndStop(arr[1]);
			
			if ( idx % 3 == 0) mc["_room"].gotoAndStop(1);
			if ( idx % 3 == 1) mc["_room"].gotoAndStop(2);
			if ( idx % 3 == 2) mc["_room"].gotoAndStop(3);
		}
		
		public function Posi_Setting(mc:MovieClip, idx:int, data:Array):void
		{		
			var rowCnt:int = data[0];
			var xdiff:int = data[1];
			var ydiff:int = data[2];
			
			var x_shift:Number = 0;
			if ( Math.floor(idx / rowCnt) == 1) x_shift = _width_dis / 2 * 1;
			if ( Math.floor(idx / rowCnt) == 2) x_shift = _width_dis / 2 * 4;
			if ( Math.floor(idx / rowCnt) == 3) x_shift = _width_dis / 2 * 5;
			if ( Math.floor(idx / rowCnt) == 4) x_shift = _width_dis / 2 * 8;
			if ( Math.floor(idx / rowCnt) == 5) x_shift = _width_dis / 2 * 9;
			if ( Math.floor(idx / rowCnt) == 6) x_shift = _width_dis / 2 * 10;
			
			if ( idx == 29) 
			{
				mc.x = (30 % rowCnt * xdiff ) + (x_shift * 2);					
			}
			//row3
			else if (idx == 43)
			{
				mc.x = (45 % rowCnt * xdiff )  + (_width_dis / 2 ) * 1;				
			}
			else if (idx == 44)
			{
				mc.x = (45 % rowCnt * xdiff )  + (_width_dis / 2 ) * 3;				
			}
			//row5
			else if (idx == 57 || idx ==58 || idx ==59)
			{
				mc.x = (60 % rowCnt * xdiff )  + (_width_dis  ) * (idx-56);				
			}		
			else if (idx == 71)
			{
				mc.x = (75 % rowCnt * xdiff )  + (_width_dis / 2 ) * 1;
			}
			else if (idx == 72)
			{
				mc.x = (75 % rowCnt * xdiff )  + (_width_dis / 2 ) * 3;
			}
			else if (idx == 73)
			{
				mc.x = (75 % rowCnt * xdiff )  + (_width_dis / 2 ) * 5;
			}
			else if (idx == 74)
			{
				mc.x = (75 % rowCnt * xdiff )  + (_width_dis / 2 ) * 7;
			}
			else if (idx == 85 || idx == 86 || idx ==87 || idx ==88 || idx ==89)
			{
				mc.x = (90 % rowCnt * xdiff )  + (_width_dis  ) * (idx-85);
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