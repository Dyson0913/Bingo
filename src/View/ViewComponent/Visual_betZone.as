package View.ViewComponent 
{
	import flash.display.MovieClip;
	import flash.events.Event;
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
		public var _regular:RegularSetting;
		
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _visual_coin:Visual_Coin;
		
		public function Visual_betZone() 
		{
			
		}
		
		public function init():void
		{
			//bet區容器
			//coin
			var coinob:MultiObject = prepare("betZone", new MultiObject(), GetSingleItem("_view").parent.parent);
			coinob.container.x = 151.85;
			coinob.container.y = 235.85;
			coinob.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[0,0,2,0]);
			coinob.CustomizedFun = BetListCustomizedFun;
			coinob.CustomizedData = _model.getValue("is_betarr");
			coinob.Create_by_list(coinob.CustomizedData.length,  [ResName.BetButton], 0 , 0, 10, 110.25, 71, "Coin_");
			coinob.mousedown = _betCommand.bet_local;
			
			//押分 pan num
			var betlist:MultiObject = prepare("betlist", new MultiObject(), GetSingleItem("_view").parent.parent);
			betlist.container.x = 1416.85;
			betlist.container.y = 160.3;
			betlist.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[0,0,2,0]);
			betlist.CustomizedFun = BetListFun;			
			betlist.Create_by_list(12,  [ResName.Bet_Pan_Num], 0 , 0, 1,0, 47, "Coin_");
			//betlist.mousedown = _betCommand.bet_local;//_visual_coin.betSelect;
			
			//押分底圖
			var betmaount:MultiObject = prepare("betamount", new MultiObject(), GetSingleItem("_view").parent.parent);
			betmaount.container.x = 1520.85;
			betmaount.container.y = 159.3;			
			betmaount.Create_by_list(12,  [ResName.Bet_amount_bg], 0 , 0, 1,0, 47, "Coin_");			
			
			var betmaount_num:MultiObject = prepare("betamount_num", new MultiObject(), GetSingleItem("_view").parent.parent);
			betmaount_num.container.x = 1558.85;
			betmaount_num.container.y = 162.3;
			betmaount_num.CustomizedFun = bet_amountFun;			
			betmaount_num.CustomizedData = [0,0,0,0,0,0,0,0,0,0,0,0,0];			
			betmaount_num.Create_by_list(12,  [ResName.Bet_amount_num], 0 , 0, 1,0,47 , "Coin_");			
			
			//押分sub
			var bet_sub:MultiObject = prepare("betamount_sub", new MultiObject(), GetSingleItem("_view").parent.parent);
			bet_sub.container.x = 1523.85;
			bet_sub.container.y = 161.3;
			bet_sub.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[0,0,2,1]);
			bet_sub.Create_by_list(12,  [ResName.Bet_sub], 0 , 0, 1, 0, 47, "Coin_");
			bet_sub.mousedown = _betCommand.sub_bet;
			bet_sub.mouseup = betSelect;
			
			var bet_add:MultiObject = prepare("betamount_add", new MultiObject(), GetSingleItem("_view").parent.parent);
			bet_add.container.x = 1685.85;
			bet_add.container.y = 161.3;
			bet_add.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[0,0,2,1]);
			bet_add.Create_by_list(12,  [ResName.Bet_add], 0 , 0, 1, 0, 47, "Coin_");		
			bet_add.mousedown = _betCommand.add_bet;
			bet_add.mouseup = betSelect;
			
			_tool.SetControlMc(betmaount_num.container);
			add(_tool);
		}		
		
		public function bet_amountFun(mc:MovieClip, idx:int, betamount:Array):void
		{
			if ( idx >= betamount.length) 
			{				
				return;
			}
			
			if (betamount[idx] != 0)
			{			
				var arr:Array = String(betamount[idx]).split("");
				var re:Array = arr.reverse();
				//utilFun.Log("reverse = "+re);			
				for ( var i:int = 0; i < re.length; i++)
				{
					if ( re[i] == "0" ) re[i] = "10";
					mc["_num_"+i].gotoAndStop( parseInt(re[i]));
				}			
			}
			else
			{
				mc["_num_0"].gotoAndStop(11);
				mc["_num_1"].gotoAndStop(11);
				mc["_num_2"].gotoAndStop(11);
				mc["_num_3"].gotoAndStop(11);
				mc["_num_4"].gotoAndStop(11);
			}
			
		}
				
		public function BetListFun(mc:MovieClip, idx:int, IsBetInfo:Array):void
		{
			utilFun.scaleXY(mc, 0.7, 0.7);
			utilFun.SetText(mc["tableNo"], "");
			
		}
		
		public function BetListCustomizedFun(mc:MovieClip,idx:int,IsBetInfo:Array):void
		{			
			utilFun.SetText(mc["tableNo"], utilFun.Format(idx, 2));
			//1,無人 2為自己, 3自己最後一注,4,為他人
			var arr:Array = []; //my bet _model.getValue("table");
			var cnt:int =  arr.length;
			
			//先調回無人下注
			mc.gotoAndStop( 1 );
			if ( idx > 49) mc.y +=15.2;
			//有人下非自己,變黃
			if ( IsBetInfo[idx] == 1)
			{
				var MyBet:int = arr.indexOf(idx)
				if ( MyBet != -1)
				{
					//紅
					if (  MyBet == (cnt - 1))  
					{
						mc.gotoAndStop( (IsBetInfo[idx] + 2) );
					}
					else mc.gotoAndStop( (IsBetInfo[idx] + 1) );
				}
				else
				{
					//黃
					mc.gotoAndStop( (IsBetInfo[idx] + 3) );
				}
			}
			
		}
		
		public function betSelect(e:Event, idx:int):Boolean
		{
			return true;
		}
		
		
		[MessageHandler(type="ConnectModule.websocket.WebSoketInternalMsg",selector="Betresult")]
		public function BetResult( ):void
		{
			var bet_result:int = _model.getValue("bet_result");
			//utilFun.Log("BetResult = "+_BetModel._Bet_result );
			utilFun.Log("BetResult = "+ bet_result );
			//if ( bet_result)
			//{
				//新增押注				
				//var betSuccess:Boolean = _BetModel.AddBetInfo(_BetModel._Bet_room_no);
				//if (betSuccess)
				//{
					//顥示新盤號
					//UpdatePanNumAndBet();
					//LoadingPan(_BetModel._Bet_room_no);
					//
					//押注BTN更新
					//BetList.CustomizedFun = BetListCustomizedFun;					
					//BetList.CustomizedData = _TableModel.GetisBet();
					//BetList.FlushObject();			
					//
				//}
			//}
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "bet_list_update")]
		public function betlist_update():void
		{
			var arr:Array = _betCommand.get_my_betlist();
			//utilFun.Log("bet_list_update = " + arr.length);

			var tab_no:Array = [];
			var amount_no:Array = [];
			for ( var i:int = 0; i < arr.length ; i++)
			{
				var bet_ob:Object = arr[i];
				tab_no.push(bet_ob["betType"]);
				amount_no.push(bet_ob["bet_amount"]);
				
			
			}
						
				utilFun.Log("bet_ob[betType] = " + tab_no);
				utilFun.Log("bet_ob[bet_amount] = " + amount_no);
				
			Get("betlist").CustomizedFun = CustomizedFun_ShowData;
			Get("betlist").CustomizedData = tab_no;
			Get("betlist").FlushObject();
			
			Get("betamount_num").CustomizedFun = bet_amountFun;
			Get("betamount_num").CustomizedData =  amount_no;
			Get("betamount_num").FlushObject();
		}
		
		public function CustomizedFun_ShowData(mc:MovieClip,idx:int,CustomizedData:Array):void
		{			
			var str:String = idx >= CustomizedData.length ? "" : CustomizedData[idx];
			utilFun.SetText( mc["tableNo"],str );			
		}		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "display")]
		public function display():void
		{
			var betzone:MultiObject = Get("betzone");
			betzone.mousedown = _betCommand.betTypeMain;
			betzone.mouseup = _betCommand.empty_reaction;
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function timer_hide():void
		{
			var betzone:MultiObject = Get("betzone");
			betzone.mousedown = null;
		}
		
		
	}

}