package View.ViewComponent 
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import View.ViewBase.Visual_Text;
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
	public class Visual_bingoPan  extends VisualHandler
	{
		
		[Inject]
		public var _Actionmodel:ActionQueue;
		
		public function Visual_bingoPan() 
		{
			
		}
		
		public function init():void
		{
			//盤號 內盤,外盤
			var balls:Array = _model.getValue("ballarr");			
			var bingo_pan:MultiObject = prepare("bingo_pan", new MultiObject(), GetSingleItem("_view").parent.parent);	
			bingo_pan.CustomizedFun = info_initFun;
			bingo_pan.CustomizedData = balls[0];
			bingo_pan.container.x = 1409;
			bingo_pan.container.y = 751.9;
			bingo_pan.Create_by_list(1, [ResName.bingo_pan], 0, 0, 1, 0, 0, "time_");
			
			utilFun.SetText( bingo_pan.ItemList[0]["_panNum"]["tableNo"], "01");
			
			bingo_pan.ItemList[0]["_pan_amount"].x = -180.6
			bingo_pan.ItemList[0]["_pan_amount"].y = -25.9;
			_text.textSetting_s(bingo_pan.ItemList[0]["_pan_amount"], [ { size:40, color:0xB50004, align:_text.align_center }, ""]);
		
			//局號
			var round_code:int = _model.getValue("game_round");			
			var round:MultiObject = prepare("game_round", new MultiObject(), GetSingleItem("_view").parent.parent);
			round.CustomizedFun = _text.textSetting;
			round.CustomizedData = [ { size:24, color:0xFFFFFF }, "局號: ", round_code.toString()];
			round.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			round.Post_CustomizedData = [2, 60, 0];
			round.container.x = 1742;
			round.container.y = 75;			
			round.Create_by_list(2, [ResName.Paninfo_font], 0, 0, 1, 0, 0, "time_");
			
			//_tool.SetControlMc(round.container);
			//_tool.y = 200;
			//add(_tool);
		}
		
		public function info_initFun(mc:MovieClip, idx:int, data:Array):void
		{				
			utilFun.scaleXY(mc, 0.742, 0.742);
			mc["_start"].visible = false;
			
			//cell
			var pan:MultiObject = prepare("select_pan", new MultiObject(), mc);	
			pan.CustomizedFun = PanMatrixCustomizedFun;
			pan.CustomizedData = data ; // select pan_num
			pan.container.x = 50;
			pan.container.y = 33;
			pan.Create_by_list(25, [ResName.bingo_pancell_new], 0, 0, 5, 63, 63, "time_");
			
			
		}
		
		public function bet_amountFun(mc:MovieClip, amount:int):void
		{
			var arr:Array = String(amount).split("");
			var re:Array = arr.reverse();
			//utilFun.Log("reverse = "+re);			
			for ( var i:int = 0; i < 4; i++)
			{
				if ( re[i] != undefined)
				{
					if ( re[i] == "0" ) re[i] = "10";
					mc["_num_" + i].gotoAndStop( parseInt(re[i]));
				}
				else mc["_num_" + i].gotoAndStop(11);
				
			}			
		}
		
		public function PanMatrixCustomizedFun(mc:MovieClip,idx:int,CustomizedData:Array):void
		{			
			var str:String;
			var RowCnt:int = 5;
			var ColCnt:int = 5;
			
			var rowNum:int = idx  / RowCnt;			
			var colNum:int = idx  % ColCnt;
			var myidx:int = rowNum + (colNum * ColCnt) ;
			
			
			var color:uint = _model.getValue("bingo_color")[idx % 5];		
			
			if( idx == 12) 
			{
				str = "";		
				mc.gotoAndStop(4);
			}
			else
			{				
				if ( rowNum >=3 && colNum == 2 )  myidx -= 1;
				if ( colNum >= 3)	 myidx -= 1;
				str = CustomizedData[myidx];
				mc["_text"].textColor = color;
				utilFun.SetText( mc["_text"], str);	
				
			}
					
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "update_bingoPanNum")]		
		public function select_pan(msg:ModelEvent):void
		{
			
			var bet_ob:Object = _Actionmodel.excutionMsg();
			//var tableNo:int = bet_ob["betType"];			
			var tableNo:int = msg.Value;
			
			//桌號
			utilFun.SetText( GetSingleItem("bingo_pan")["_panNum"]["tableNo"], utilFun.Format(tableNo,2));
			
			
			//押注額 			
			utilFun.Clear_ItemChildren(GetSingleItem("bingo_pan")["_pan_amount"]);
			
			var total_amount:int = 0;
			if (bet_ob == null) {
				total_amount = 0;
			}else {
				total_amount = bet_ob["total_amount"];
			}
			
			_text.textSetting_s(GetSingleItem("bingo_pan")["_pan_amount"], [ { size:40, color:0xB50004, align:_text.align_center }, total_amount]);
			
			//var font:Array = [{size:40,color:0xB50004,bold:true,align:_text.align_center}];
			//font = font.concat(bet_ob["total_amount"]);
			//utilFun.Log("fornt = "+amount_no);						
			//Get("select_pan_amount").CustomizedData = font;
			//Get("select_pan_amount").Create_by_list(1, [ResName.Paninfo_font], 0, 0, 1, 0, 0, "time_");
			//bet_amountFun(  GetSingleItem("bingo_pan")["_pan_amount"], bet_ob["total_amount"]);
			
			//TODO dynamic can't get
			//GetSingleItem("bingo_pan")["pan_amount_con"]["pan_amount_0"].CustomizedFun = bet_amountFun;			
			//GetSingleItem("bingo_pan")["pan_amount_con"]["pan_amount_0"].CustomizedData = bet_ob["bet_amount"];		
			//GetSingleItem("bingo_pan")["pan_amount_con"]["pan_amount_0"].FlushObject();			
			
			//盤號 TODO clean
			var balls:Array = _model.getValue("ballarr");			
			var pan:MultiObject = prepare("select_pan", new MultiObject(), GetSingleItem("bingo_pan"));	
			pan.CustomizedFun = PanMatrixCustomizedFun;
			pan.CustomizedData = balls[tableNo]; // select pan_num
			pan.container.x = 50;
			pan.container.y = 30;
			pan.Create_by_list(25, [ResName.bingo_pancell_new], 0, 0, 5, 63, 63, "time_");
			
		}
	}

}