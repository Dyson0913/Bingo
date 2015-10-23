package View.ViewComponent 
{
	import flash.display.MovieClip;
	import flash.text.TextField;
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
	 * timer present way
	 * @author ...
	 */
	public class Visual_ball  extends VisualHandler
	{
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _opration:DataOperation;
		
		[Inject]
		public var _text:Visual_Text
		
		private var _sball_x_diff:Number = 88;
		private var _sball_y_diff:Number =  85;
		private var _sball_scale:Number =  0.4;
		
		private var _hint:Boolean;
		private var _barmove:Boolean;
		private var _barmove2:Boolean;
		
		private var temp_ball:String = "tempball";
		
		private var _first:Boolean = true;
		
		public function Visual_ball() 
		{
			
		}
		
		public function init():void
		{
			//左上角大球
			var ball:MultiObject = prepare(modelName.Open_Ball_Num, new MultiObject()  , GetSingleItem("_view").parent.parent);
			ball.CustomizedFun = sballFun;		   
		    ball.CustomizedData = [1];	   
		    ball.Create_by_list(1, [ResName.Ball], 0, 0, 1, 0, 0, "time_");
		    ball.container.x = 125;
		    ball.container.y = 184;		 
			ball.container.visible = false;
			
			//左上角小球
		   var sball:MultiObject = prepare("small_ball", new MultiObject()  ,GetSingleItem("_view").parent.parent);
		   sball.CustomizedFun = sballFun;		   
		   sball.CustomizedData = [0.4];	   
		   sball.Create_by_list(3, [ResName.Ball], 0, 0, 3, 110, 0, "time_");
		   sball.container.x = 69;
		   sball.container.y = 392;		  
		   sball.container.visible = false;  
		   
		   //75開球
		   var ball_pan:MultiObject = prepare("ball_pan", new MultiObject()  , GetSingleItem("_view").parent.parent);
		   ball_pan.CustomizedFun = ball_panfun;		   
		   ball_pan.Create_by_list(1, [ResName.Ball_pan], 0, 0, 1, 0, 0, "time_");
		   ball_pan.container.x = 443.9;
		   ball_pan.container.y = 557;
		   
			if(  _betCommand.get_my_betlist().length != 0) ball_pan.container.visible = false		 
		   	
			//倍數提示底圖
			//var multibyball_bg:MultiObject = prepare("multibyball_bg", new MultiObject(), GetSingleItem("_view").parent.parent);			
			//multibyball_bg.container.x =69;
			//multibyball_bg.container.y = 480;
			//multibyball_bg.Create_by_list(1, [ResName.multibyball], 0, 0, 1, 0, 47, "time_")
			//multibyball_bg.container.visible = false;
			
			//倍數提示
			//var multi_by_ball:MultiObject = prepare("multi_by_ball", new MultiObject(), GetSingleItem("_view").parent.parent);
			//multi_by_ball.CustomizedFun = _text.textSetting;
			//multi_by_ball.CustomizedData = [{size:24,color:0xFFFFFF,bold:true}, "54 球     150 倍","60 球     100 倍"," 平常        90 倍"];			
			//multi_by_ball.container.x =139;
			//multi_by_ball.container.y = 482;
			//multi_by_ball.Create_by_list(3, [ResName.Paninfo_font], 0, 0, 1, 0, 47, "time_");
			
			//倍數提示底圖
			var listenpai:MultiObject = prepare("listenpai", new MultiObject(), GetSingleItem("_view").parent.parent);			
			listenpai.container.x =-431;
			listenpai.container.y = 50.5;
			listenpai.Create_by_list(1, [ResName.listenpai], 0, 0, 1, 0, 47, "time_")
			listenpai.container.visible = false;
			//
			_hint = false;
			_barmove = false;
			_barmove2 = false;
			
			
			//免洗球
			var fakeball:MultiObject = prepare("fakeball", new MultiObject(), GetSingleItem("_view").parent.parent);				
			fakeball.Create_by_list(1, [ResName.popBall], 0 , 0, 2, 1880 , 0, "Bet_");
			fakeball.container.x = 50.6;
			fakeball.container.y = 551.75;
			_model.putValue("fakeball", 1);
			
			_first = true;
			
			//var ballNum:int = utilFun.Random(75);
			//utilFun.SetText(GetSingleItem("fakeball")["_fakeBall_0"]["ballNum"], ballNum.toString());			
			//GetSingleItem("fakeball")["_fakeBall_0"].gotoAndStop( Math.ceil( ballNum / 15) ) ;
			//
			//var ballNum2:int = utilFun.Random(75);
			//utilFun.SetText(GetSingleItem("fakeball")["_fakeBall_1"]["ballNum"], ballNum2.toString());			
			//GetSingleItem("fakeball")["_fakeBall_1"].gotoAndStop( Math.ceil( ballNum2 / 15) ) ;
			//
			//var ballNum3:int = utilFun.Random(75);
			//utilFun.SetText(GetSingleItem("fakeball")["_fakeBall_2"]["ballNum"], ballNum3.toString());
			//GetSingleItem("fakeball")["_fakeBall_2"].gotoAndStop( Math.ceil( ballNum3 / 15) ) ;
			
			//Tweener.addCaller(this, { time:30 , count:20, transition:"linear",onUpdate: this.ball_t } );
			
			//免洗球2
			//var mytemp_ball:MultiObject = prepare("tempball", new MultiObject(), GetSingleItem("_view").parent.parent);				
			//mytemp_ball.Create_by_list(1, [temp_ball], 0 , 0, 2, 1880 , 0, "Bet_");
			//mytemp_ball.container.x = 41;
			//mytemp_ball.container.y = 623;
			//
			//_text.roationsword(	mytemp_ball.ItemList[0]["_mc_1"], "13");
			//_text.roationsword(	mytemp_ball.ItemList[0]["_mc_2"], "13");
			//_text.roationsword(	mytemp_ball.ItemList[0]["_mc_3"], "13");
			//_text.roationsword(	mytemp_ball.ItemList[0]["_mc_4"], "13");		
			//_text.roationsword(	mytemp_ball.ItemList[0]["_mc_5"], "13");
			
		   //_tool.SetControlMc(	mytemp_ball.container);
		   //_tool.y = 500;
			//add(_tool);
			_model.putValue("open3Balllist", []);				
			
			
			
		}
		
		public function ball_t():void
		{			
			var ontop:int = _model.getValue("fakeball");
			utilFun.Log("ball_into =" + ontop);		
			var idx_1:int = ontop;
			var idx_2:int = ontop;
			var idx_3:int = ontop;
			var waiing_ball:Array = _model.getValue("waitting_ball");			
			var ball_1:int = waiing_ball[0];
			var ball_2:int = waiing_ball[1];
			utilFun.Log("ball_1 =" + ball_1);			
			utilFun.Log("ball_2 =" + ball_2);
			//第一次不位移
			if ( _first )
			{
				_first = false;
				var cnt:int = _model.getValue("fakeball");
				utilFun.Log("first in=" + cnt);			
				
				//just set ,no move
				utilFun.SetText(GetSingleItem("fakeball")["_fakeBall_"+idx_1]["ballNum"], ball_1.toString());			
				GetSingleItem("fakeball")["_fakeBall_"+idx_1].gotoAndStop( Math.ceil( ball_1 / 15) ) ;
				
				idx_2 = cnt + 1;
				if ( idx_2 == 3) idx_2 = 0;
				utilFun.SetText(GetSingleItem("fakeball")["_fakeBall_"+idx_2]["ballNum"], ball_2.toString());			
				GetSingleItem("fakeball")["_fakeBall_"+idx_2].gotoAndStop( Math.ceil( ball_2 / 15) ) ;
				utilFun.Log("idx_1 =" + idx_1 + " idx_2 =" +idx_2);
				//cnt++;			
				//if ( cnt == 3) cnt = 0;
				//_model.putValue("fakeball", cnt);
				return;
			}			
			
			//第二次要下移一球 
			ontop += 1;
			if ( ontop == 3) ontop = 0;		
			
			idx_1 = ontop;
			utilFun.SetText(GetSingleItem("fakeball")["_fakeBall_"+idx_1]["ballNum"], ball_1.toString());			
			GetSingleItem("fakeball")["_fakeBall_"+idx_1].gotoAndStop( Math.ceil( ball_1 / 15) ) ;
			
			ontop += 1;
			if ( ontop == 3) ontop = 0;
			
			idx_2 = ontop ;
			utilFun.SetText(GetSingleItem("fakeball")["_fakeBall_"+idx_2]["ballNum"], ball_2.toString());			
			GetSingleItem("fakeball")["_fakeBall_"+idx_2].gotoAndStop( Math.ceil( ball_2 / 15) ) ;
			
			ontop += 1;
			if ( ontop == 3) ontop =0;
			idx_3 = ontop;
			utilFun.Log("idx_1 =" + idx_1 + " idx_2 =" +idx_2 +" idx_3 " + idx_3);		
			
			Tweener.addTween(GetSingleItem("fakeball")["_fakeBall_"+idx_1], { y:GetSingleItem("fakeball")["_fakeBall_"+idx_1].y -180.95, time:0.5 } );
			Tweener.addTween(GetSingleItem("fakeball")["_fakeBall_"+idx_2], { y:GetSingleItem("fakeball")["_fakeBall_"+idx_2].y -180.95, time:0.5 } );
			Tweener.addTween(GetSingleItem("fakeball")["_fakeBall_"+idx_3], { y:GetSingleItem("fakeball")["_fakeBall_"+idx_3].y -180.95, time:0.5, onComplete:this.move } );
			
		}
		
		public function move():void
		{
			var cnt:int = _model.getValue("fakeball");
			utilFun.Log("move =" + cnt);
			GetSingleItem("fakeball")["_fakeBall_" + cnt].y = 413.95;
			
			cnt += 1;
			if ( cnt == 3) cnt = 0;				
			_model.putValue("fakeball", cnt);
			
			
		
		}
		
		public function sballFun(mc:MovieClip, idx:int, scalesize:Array):void
		{
			//TODO combination setting ,like scale ,set test ,splite to reuse
			utilFun.scaleXY(mc,scalesize[0], scalesize[0]);
			utilFun.SetText(mc["ballNum"], "");			
		}
		
		public function ball_panfun(mc:MovieClip, idx:int, IsBetInfo:Array):void
		{			
			
		   var ball:MultiObject = prepare("opan_pan_ball", new MultiObject()  ,mc);
		   ball.CustomizedFun = panballFun;
		   ball.CustomizedData = [_sball_scale];
		   ball.Create_by_list(75, [ResName.Ball], 0, 0, 15, _sball_x_diff, _sball_y_diff, "time_");
		   ball.container.x = 118.3;
		   ball.container.y = 18.35;		
		   	//_tool.SetControlMc(ball.container);
			//add(_tool);
		}
		
		public function panballFun(mc:MovieClip, idx:int, scalesize:Array):void
		{
			//TODO combination setting ,like scale ,set test ,splite to reuse
			utilFun.scaleXY(mc, scalesize[0], scalesize[0]);
			mc.gotoAndStop( Math.ceil( (idx + 1) / 15) ) ;
			mc.visible = false;
			utilFun.SetText(mc["ballNum"], utilFun.Format(idx+1 , 2) );
			
		}
		
		[MessageHandler(type="ConnectModule.websocket.WebSoketInternalMsg",selector="ballupdate")]
		public function display():void
		{	
			//fake
			
			ball_t();
			
			//big ball
			var BallNum:int = _model.getValue("Curball");
			Get(modelName.Open_Ball_Num).container.visible = true;
			utilFun.SetText(GetSingleItem(modelName.Open_Ball_Num)["ballNum"] , BallNum.toString());
			GetSingleItem(modelName.Open_Ball_Num).gotoAndStop( Math.ceil( BallNum / 15) ) ;		
			
			//3 smaill ball
			var open3ball:Array = _model.getValue("open3Balllist");
			open3ball.unshift(BallNum);
			if ( open3ball.length > 3)
			{
				open3ball.pop();
			}
			
			//左方小球
			Get("small_ball").container.visible = true;
			for (var i:int = open3ball.length; i >0 ; i--)
			{			
				utilFun.SetText(GetSingleItem("small_ball",i-1)["ballNum"], utilFun.Format(open3ball[i-1], 2) );				
				GetSingleItem("small_ball",i-1).gotoAndStop( Math.ceil( open3ball[i-1] / 15) ) ;
			}
			
			//開球倍率 (525 572)
			var OpenBallList:Array = _model.getValue("openBalllist");
			//Get("multibyball_bg").container.visible = true;
			if ( OpenBallList.length +1 > 55 )
			{
				if ( !_barmove)
				{
					//Tweener.addTween(GetSingleItem("multibyball_bg"), { y:GetSingleItem("multibyball_bg").y + 45, time:1 } ); 
					//_barmove = true;
				}
			}
			if ( OpenBallList.length +1 > 61)  
			{
				if ( !_barmove2)
				{
					//Tweener.addTween(GetSingleItem("multibyball_bg"), { y:GetSingleItem("multibyball_bg").y + 45, time:1 } ); 
					//_barmove2 = true;
				}
			}
			
			//聽牌提示
			var best_list:Array = _model.getValue("best_list");
			if ( best_list[0].ball_list.length == 4) 
			{
				if ( !_hint )
				{
					Get("listenpai").container.visible = true;
					Tweener.addTween(GetSingleItem("listenpai"), { x:GetSingleItem("listenpai").x + 429, onComplete:this.hint_over, time:0.5,transition: "easeOutQuart" } ); 			
					_hint = true;
				}
			}
			
			//server 傳1 base
			//panball handle
			var BallIdx:int =BallNum-1;
			var BallDisPlayIdx:int = BallNum;
			
			var xPos:int = (( BallIdx  % 15 )) *  _sball_x_diff;
			var yPos:int  = Math.floor( BallIdx / 15 )*  _sball_y_diff;
			
			var openball:MovieClip = GetSingleItem("opan_pan_ball", BallIdx);
			openball.x = 528;
			openball.y = 150;
			openball.visible = true;
			utilFun.scaleXY(openball, 1, 1);
		
			
			utilFun.SetText( openball["ballNum"], utilFun.Format( BallDisPlayIdx, 2 ));
			Tweener.addTween(openball, { scaleX:_sball_scale, scaleY:_sball_scale, x: xPos, y:yPos, time:1 } );
			
		}
		
		private function hint_over():void
		{
			
			Tweener.addTween(GetSingleItem("listenpai"), { x:GetSingleItem("listenpai").x-429 ,delay:3, time:0.5,onComplete:this.hint_back,transition: "easeOutQuart" } ); 
		}
		
		private function hint_back():void
		{
			Get("listenpai").container.visible = false;
		}
		
		[MessageHandler(type="ConnectModule.websocket.WebSoketInternalMsg",selector="half_enter_update")]		
		public function HalfEnterInit():void
		{			
			var openballist:Array = _model.getValue("openBalllist");
			utilFun.Log("HalfEnterInit = "+openballist.length);
			//己開球補齊			
			var Cnt:int = openballist.length;
			for ( var i:int = 0; i < Cnt; i++)
			{
				//server 傳1 base
				var BallNum:int = openballist[i];
				var BallIdx:int = BallNum - 1;
				var BallDisPlayIdx:int = BallNum;
			
				var xPos:int = (( BallIdx  % 15 )) *  _sball_x_diff;
				var yPos:int  = Math.floor( BallIdx / 15 )*  _sball_y_diff;				
				var openball:MovieClip = GetSingleItem("opan_pan_ball", BallIdx);
				utilFun.SetText( openball["ballNum"], utilFun.Format( BallDisPlayIdx, 2 ));
				
				openball.visible = true;
				openball.gotoAndStop( Math.ceil( BallDisPlayIdx / 15 ) );
				utilFun.scaleXY(openball, _sball_scale,_sball_scale);								
			}
		}	
		
		
	}

}