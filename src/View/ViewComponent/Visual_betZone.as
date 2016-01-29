package View.ViewComponent 
{
	import ConnectModule.websocket.WebSoketInternalMsg;
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
	import caurina.transitions.Tweener;
	
	/**
	 * betzone present way
	 * @author ...
	 */
	public class Visual_betZone  extends VisualHandler
	{
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _Actionmodel:ActionQueue;
		
		public const Cancel_ALLBet_Btn:String = "Cancel_ALL_Bet_Btn";
		
		public function Visual_betZone() 
		{
			
		}
		
		public function init():void
		{
			
			//押分 pan num
			var betlist:MultiObject = prepare("betlist", new MultiObject(), GetSingleItem("_view").parent.parent);
			betlist.container.x = 1416.85;
			betlist.container.y = 160.3;
			betlist.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[0,0,2,0]);
			betlist.CustomizedFun = BetListFun;			
			betlist.CustomizedData = _betCommand.get_my_bet_info(BetCommand.Table);			
			betlist.Create_by_list(12,  [ResName.Bet_Pan_Num], 0 , 0, 1,0, 47, "Coin_");
			//
			//
			//押分底圖
			var betmaount:MultiObject = prepare("betamount", new MultiObject(), GetSingleItem("_view").parent.parent);
			betmaount.container.x = 1520.85;
			betmaount.container.y = 159.3;			
			betmaount.Create_by_list(12,  [ResName.Bet_amount_bg], 0 , 0, 1,0, 47, "Coin_");			
			//
			//押分數字			
			var totalball_info:MultiObject = prepare("betamount_num", new MultiObject(), GetSingleItem("_view").parent.parent);
			totalball_info.CustomizedFun = _text.textSetting;
			totalball_info.CustomizedData = [{size:40,color:0xB50004,align:_text.align_right}, "","","","","","","","","","","",""];			
			totalball_info.container.x =1061.85;
			totalball_info.container.y = 155;
			totalball_info.Create_by_list(12, [ResName.Paninfo_font], 0, 0, 1, 0, 47, "time_");
			//
			//押分sub
			var bet_sub:MultiObject = prepare("betamount_sub", new MultiObject(), GetSingleItem("_view").parent.parent);
			bet_sub.container.x = 1523.85;
			bet_sub.container.y = 161.3;
			bet_sub.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[0,0,2,1]);
			bet_sub.Create_by_list(12,  [ResName.Bet_sub], 0 , 0, 1, 0, 47, "Coin_");		
			bet_sub.mousedown = Panel_sub_plus_condition;
			bet_sub.mouseup =  empty_reaction;
			//
			var bet_add:MultiObject = prepare("betamount_add", new MultiObject(), GetSingleItem("_view").parent.parent);
			bet_add.container.x = 1685.85;
			bet_add.container.y = 161.3;
			bet_add.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[0,0,2,1]);
			bet_add.Create_by_list(12,  [ResName.Bet_add], 0 , 0, 1, 0, 47, "Coin_");					
			bet_add.mousedown = Panel_add_plus_condition;
			bet_add.mouseup = empty_reaction;	
			//
			var cancel_bet:MultiObject = prepare("cancel_bet", new MultiObject(), GetSingleItem("_view").parent.parent);
			cancel_bet.container.x = 974;
			cancel_bet.container.y = 984;
			cancel_bet.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[0,0,2,1]);
			cancel_bet.Create_by_list(1,  [Cancel_ALLBet_Btn], 0 , 0, 1, 0, 0, "Coin_");					
			cancel_bet.mousedown = _betCommand.cancel_allbet;			
			cancel_bet.mouseup = empty_reaction;		
			
			//bet			
			var betPan:MultiObject = prepare("betZone", new MultiObject(), GetSingleItem("_view").parent.parent);
			var data:Array = _model.getValue("is_betarr");
			betPan.container.x = 151.85;
			betPan.container.y = 235.85;
			betPan.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[0,0,3,1]);
			betPan.CustomizedFun = BetListini;
			betPan.CustomizedData = [data,_betCommand.get_my_bet_info(BetCommand.Table)];
			betPan.Create_by_list(data.length,  [ResName.BetButton], 0 , 0, 10, 110.25, 71, "Coin_");
			betPan.mousedown = add_plus_condition;	
			
			//	test.mouseup =  _betCommand.check;
			//_tool.SetControlMc(totalball_info.container);
			//add(_tool);
		}		
		
		public function add_plus_condition(e:Event, tableNo:int):Boolean
		{
			if (_Actionmodel.length() != 0)
			{
				utilFun.Log("add click too quick forbiden");
				return false;
			}
			
			//other player 
			var betstate:Array = _model.getValue("is_betarr");
			if ( betstate[tableNo] == 1)
			{
				var mybet:Array =  _betCommand.get_my_bet_info(BetCommand.Table);				
				if ( mybet.indexOf(tableNo) == -1) 
				{
					utilFun.Log("not my");
					_model.putValue("last_bet_idx",tableNo);					
					pan_update();
					return false;				
				}
			}
			
			
			//over 12 bet type
			if (  _betCommand.Find_Bet_type_idx(tableNo) == -1)
			{
				var table:Array = _betCommand.get_my_bet_info(BetCommand.Table);				
				if ( table.length >= 12 )
				{
					dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BET_FULL_HINT));
					return false;
				}
			}
			
			return _betCommand.add_amount(e, tableNo);
		}
		
		public function Panel_add_plus_condition(e:Event, idx:int):Boolean
		{
			//convert from item idx to Tableno
			var table:Array = _betCommand.get_my_bet_info(BetCommand.Table);			
			if (table[idx] == undefined) return false;
			var tableNo:int = table[idx] ;
			
			return add_plus_condition(e, tableNo);
		}
		
		public function Panel_sub_plus_condition(e:Event, idx:int):Boolean
		{
			if (_Actionmodel.length() != 0)
			{
				utilFun.Log("cancel too quick forbiden");
				return false;
			}
			
			//convert from item idx to Tableno
			var table:Array = _betCommand.get_my_bet_info(BetCommand.Table);			
			if (table[idx] == undefined) return false;
			var tableNo:int = table[idx] ;
			
			return _betCommand.sub_amount(e, tableNo);
		}
		
		[MessageHandler(type="ConnectModule.websocket.WebSoketInternalMsg",selector="betstopHint")]
		public function forbidden():void
		{
			Get("betZone").mousedown = null;			
			Get("betamount_sub").mousedown = null;
			Get("betamount_sub").mouseup = null;
			Get("betamount_add").mousedown = null;
			Get("betamount_add").mouseup = null;
			Get("cancel_bet").mousedown = null;
			Get("cancel_bet").mouseup = null;			
		}
		
		public function BetListFun(mc:MovieClip, idx:int, IsBetInfo:Array):void
		{
			utilFun.scaleXY(mc, 0.7, 0.7);			
			var str:String = idx >= IsBetInfo.length ? "" : utilFun.Format(IsBetInfo[idx] , 2);			
			utilFun.SetText( mc["tableNo"], str );	
			
		}
		
		public function BetListCustomizedFun(mc:MovieClip,idx:int,data:Array):void
		{			
			utilFun.SetText(mc["tableNo"], utilFun.Format(idx, 2));
			//1,無人 2為自己, 3自己最後一注,4,為他人
			
			//先調回無人下注
			mc.gotoAndStop(1);
			mc["tableNo"].textColor = 0xD2D2D2;
			//有人下非自己,變黃
			var IsBetInfo:Array  = data[0];
			if ( IsBetInfo[idx] != 1) return;
			
			var frame:int = color_setting(idx,data[1]);			
			mc.gotoAndStop(frame);
			if ( frame == 5) mc["tableNo"].textColor = 0x666666;
		}
		
		public function BetListini(mc:MovieClip,idx:int,data:Array):void
		{			
			utilFun.SetText(mc["tableNo"], utilFun.Format(idx, 2));
			//1,無人 2為自己, 3自己最後一注,4,為他人			
			
			//先調回無人下注
			mc.gotoAndStop( 1 );
			mc["tableNo"].textColor = 0xD2D2D2;
			if ( idx > 49) mc.y += 15.2;			
			//有人下非自己,變黃
			var IsBetInfo:Array  = data[0];
			var arr:Array  = data[1];		
			if ( IsBetInfo[idx] != 1) return;	
			
			var frame:int = color_setting(idx,data[1]);			
			mc.gotoAndStop(frame);
			if ( frame == 5) mc["tableNo"].textColor = 0x666666;
		}
		
		public function color_setting(idx:int,arr:Array):int
		{			
			var inMyBet:int = arr.indexOf(idx);		
			var mylast_bet:int = _model.getValue("last_bet_idx");
			if ( inMyBet != -1)
			{			
				if (mylast_bet == idx) return 3; //blue
				else  return 2; //red
			}
			
			//點別人己下的盤
			if (mylast_bet == idx) return 6;
			
			return 5;
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "bet_list_update")]	
		public function betlist_update():void
		{			
			var tab_no:Array = _betCommand.get_my_bet_info(BetCommand.Table);
			var amount_no:Array = _betCommand.get_my_bet_info(BetCommand.TotalBet);		
			
			//utilFun.Log("tab_no = "+tab_no);
			//utilFun.Log("amount_no = "+amount_no);
			
			//自己下注 pan號
			Get("betlist").CustomizedFun = BetListFun;
			Get("betlist").CustomizedData = tab_no;
			Get("betlist").FlushObject();
			
			var font:Array = [{size:40,color:0xB50004,align:_text.align_right}];
			font = font.concat(amount_no);
			//utilFun.Log("fornt = "+amount_no);						
			Get("betamount_num").CustomizedData = font;			
			Get("betamount_num").Create_by_list(amount_no.length, [ResName.Paninfo_font], 0, 0, 1, 0, 47, "time_");
			//Get("betamount_num").FlushObject();
						
			//比押注更新結果更早收到,更新自己的最後一盤
			pan_update();			
		}		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "pan_update")]
		public function pan_update():void
		{
			//所有盤號更新
			Get("betZone").CustomizedFun = BetListCustomizedFun;
			Get("betZone").CustomizedData = [_model.getValue("is_betarr"),_betCommand.get_my_bet_info(BetCommand.Table)];
			Get("betZone").FlushObject();
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "display")]
		public function display():void
		{			
			Get("betzone").mousedown = add_plus_condition;			
			
			Get("betamount_sub").mousedown = Panel_sub_plus_condition;
			Get("betamount_sub").mouseup = empty_reaction;
			
			Get("betamount_add").mousedown = add_plus_condition;
			Get("betamount_add").mouseup = empty_reaction;	
			
		}
		
		
	}
	
}