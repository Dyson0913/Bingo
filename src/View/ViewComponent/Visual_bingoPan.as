package View.ViewComponent 
{
	import flash.display.MovieClip;
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
			var bingo_pan:MultiObject = prepare("bingo_pan", new MultiObject(), GetSingleItem("_view").parent.parent);	
			bingo_pan.CustomizedFun = info_initFun;
			bingo_pan.CustomizedData = [1,2,3,4,5,6,7,8,9,10,11,12,13,1,4,15,1,6,17,18,19,20,21,22,23,24]; // select pan_num
			bingo_pan.container.x = 1409;
			bingo_pan.container.y = 751.9;
			bingo_pan.Create_by_list(1, [ResName.bingo_pan], 0, 0, 1, 0, 0, "time_");
			
			utilFun.SetText( bingo_pan.ItemList[0]["_panNum"]["tableNo"], "2");
			bet_amountFun( bingo_pan.ItemList[0]["_pan_amount"], 0);
			//bingo_pan.ItemList[0]["_pan_amount"].CustomizedFun = bet_amountFun;			
			//bingo_pan.ItemList[0]["_pan_amount"].CustomizedData = [0];
			
			_tool.SetControlMc(bingo_pan.container);
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
			pan.container.x = 60;
			pan.container.y = 30;
			pan.Create_by_list(25, [ResName.bingo_pancell], 0, 0, 5, 63, 63, "time_");
			
			
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
			//ToolsFunction.Log("idx = "+ idx +" rowNum +"+ rowNum + " colNum "+ colNum);
			var myidx:int = rowNum + (colNum * ColCnt) ;			
			if( idx == 12) 
			{
				str = "";		
				mc.gotoAndStop(4);
			}
			else
			{
				if ( rowNum >=3 && colNum == 2 )  myidx -= 1;
				if ( colNum >= 3)	 myidx -= 1;
				//utilFun.Log("myidx = "+ myidx);
				str = CustomizedData[myidx ];	
				utilFun.SetText( mc["_text"], str);	
			}
			
					
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "bet_list_update")]
		public function select_pan():void
		{
			
			var bet_ob:Object = _Actionmodel.excutionMsg();
			var tableNo:int = bet_ob["betType"];
			
			utilFun.Log("select_pan = tableNo"+tableNo);
			utilFun.Log("select_pan = amount"+ bet_ob["bet_amount"]);
			
			//桌號
			utilFun.SetText( GetSingleItem("bingo_pan")["_panNum"]["tableNo"], String( tableNo));			
			
			
			//押注額 
			bet_amountFun(  GetSingleItem("bingo_pan")["_pan_amount"], bet_ob["bet_amount"]);
			
			//TODO dynamic can't get
			//GetSingleItem("bingo_pan")["pan_amount_con"]["pan_amount_0"].CustomizedFun = bet_amountFun;			
			//GetSingleItem("bingo_pan")["pan_amount_con"]["pan_amount_0"].CustomizedData = bet_ob["bet_amount"];		
			//GetSingleItem("bingo_pan")["pan_amount_con"]["pan_amount_0"].FlushObject();			
			
			//盤號 TODO clean
			var balls:Array = _model.getValue("ballarr");
			var pan:MultiObject = prepare("select_pan", new MultiObject(), GetSingleItem("bingo_pan"));	
			pan.CustomizedFun = PanMatrixCustomizedFun;
			pan.CustomizedData = balls[tableNo]; // select pan_num
			pan.container.x = 60;
			pan.container.y = 30;
			pan.Create_by_list(25, [ResName.bingo_pancell], 0, 0, 5, 63, 63, "time_");
			
		}
	}

}