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
		
		[Inject]
		public var _text:Visual_Text;
		
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
			
			utilFun.SetText( bingo_pan.ItemList[0]["_panNum"]["tableNo"], "2");
			
			bingo_pan.ItemList[0]["_pan_amount"].x = -180.6
			bingo_pan.ItemList[0]["_pan_amount"].y = -25.9;
			_text.textSetting_s(bingo_pan.ItemList[0]["_pan_amount"], [ { size:40, color:0xB50004, align:_text.align_center }, ""]);
		
			_tool.SetControlMc(bingo_pan.ItemList[0]["_pan_amount"]);
			_tool.y = 200;
			add(_tool);
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
		
		[MessageHandler(type = "Model.ModelEvent", selector = "bet_list_update")]		
		public function select_pan():void
		{
			
			var bet_ob:Object = _Actionmodel.excutionMsg();
			var tableNo:int = bet_ob["betType"];			
			
			//桌號
			utilFun.SetText( GetSingleItem("bingo_pan")["_panNum"]["tableNo"], String( tableNo));			
			
			
			//押注額 			
			utilFun.Clear_ItemChildren(GetSingleItem("bingo_pan")["_pan_amount"]);
			_text.textSetting_s(GetSingleItem("bingo_pan")["_pan_amount"], [ { size:40, color:0xB50004, align:_text.align_center }, bet_ob["total_amount"]]);
			
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