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
		
		public function Visual_betZone() 
		{
			
		}
		
		public function init():void
		{
			//bet			
			var betPan:MultiObject = prepare("betZone", new MultiObject(), GetSingleItem("_view").parent.parent);
			betPan.container.x = 151.85;
			betPan.container.y = 235.85;
			betPan.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[0,0,2,0]);
			betPan.CustomizedFun = BetListini;
			betPan.CustomizedData = _model.getValue("is_betarr");
			betPan.Create_by_list(betPan.CustomizedData.length,  [ResName.BetButton], 0 , 0, 10, 110.25, 71, "Coin_");
			betPan.mousedown = _betCommand.betTypeMain;
			
			//押分 pan num
			var betlist:MultiObject = prepare("betlist", new MultiObject(), GetSingleItem("_view").parent.parent);
			betlist.container.x = 1416.85;
			betlist.container.y = 160.3;
			betlist.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[0,0,2,0]);
			betlist.CustomizedFun = BetListFun;			
			betlist.CustomizedData = _betCommand.get_my_bet_info("table");			
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
			betmaount_num.CustomizedData = _betCommand.get_my_bet_info("amount");
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
			
			//_tool.SetControlMc(coinob.ItemList[50]);
			//add(_tool);
		}		
		
		[MessageHandler(type="ConnectModule.websocket.WebSoketInternalMsg",selector="betstopHint")]
		public function forbidden():void
		{
			Get("betZone").mousedown = null;
			Get("betamount_sub").mousedown = null;
			Get("betamount_sub").mouseup = null;
			Get("betamount_add").mousedown = null;
			Get("betamount_add").mouseup = null;
			
		}
		
		public function bet_amountFun(mc:MovieClip, idx:int, betamount:Array):void
		{
			mc["_num_0"].gotoAndStop(11);
			mc["_num_1"].gotoAndStop(11);
			mc["_num_2"].gotoAndStop(11);
			mc["_num_3"].gotoAndStop(11);
			mc["_num_4"].gotoAndStop(11);
			
			if (betamount &&  betamount[idx] != undefined)
			{							
				var arr:Array = String(betamount[idx]).split("");
				var re:Array = arr.reverse();
				//utilFun.Log("reverse = "+re);			
				for ( var i:int = 0; i < 5; i++)
				{
					if ( re[i] != undefined)
					{
						if ( re[i] == "0" ) re[i] = "10";
						mc["_num_" + i].gotoAndStop( parseInt(re[i]));
					}
					else mc["_num_" + i].gotoAndStop(11);
					
				}			
			}
		
			
		}
				
		public function BetListFun(mc:MovieClip, idx:int, IsBetInfo:Array):void
		{
			utilFun.scaleXY(mc, 0.7, 0.7);
			var str:String = idx >= IsBetInfo.length ? "" : IsBetInfo[idx];
			utilFun.SetText( mc["tableNo"],str );	
			
		}
		
		public function BetListCustomizedFun(mc:MovieClip,idx:int,IsBetInfo:Array):void
		{			
			utilFun.SetText(mc["tableNo"], utilFun.Format(idx, 2));
			//1,無人 2為自己, 3自己最後一注,4,為他人
			var arr:Array =  _betCommand.get_Bet_type();			
			var cnt:int =  arr.length;
			
			//先調回無人下注
			mc.gotoAndStop( 1 );
			
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
		
		public function BetListini(mc:MovieClip,idx:int,IsBetInfo:Array):void
		{			
			utilFun.SetText(mc["tableNo"], utilFun.Format(idx, 2));
			//1,無人 2為自己, 3自己最後一注,4,為他人
			var arr:Array =  _betCommand.get_Bet_type();
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
		
		[MessageHandler(type = "Model.ModelEvent", selector = "bet_list_update")]
		public function betlist_update():void
		{			
			var tab_no:Array = _betCommand.get_my_bet_info("table");
			var amount_no:Array = _betCommand.get_my_bet_info("amount");		
				
			//自己下注 pan號
			Get("betlist").CustomizedFun = BetListFun;
			Get("betlist").CustomizedData = tab_no;
			Get("betlist").FlushObject();
			
			//pan 金額
			Get("betamount_num").CustomizedFun = bet_amountFun;
			Get("betamount_num").CustomizedData =  amount_no;
			Get("betamount_num").FlushObject();
			
			//比自己押注結果更早收到
			//所有盤號更新
			Get("betZone").CustomizedFun = BetListCustomizedFun;
			Get("betZone").CustomizedData = _model.getValue("is_betarr");
			Get("betZone").FlushObject();
			
			
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