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
		
		private var _sball_x_diff:Number = 88;
		private var _sball_y_diff:Number =  85;
		private var _sball_scale:Number =  0.4;
		
		private var _hint:Boolean;		
		
		private var temp_ball:String = "tempball";
		
		private var _first:Boolean = true;
		
		private var _shake_po:Array = [];
		private var _shake_po2:Array = [];
		
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
		   
		   	//左上角小球 ->
		   var small_ball_arrow:MultiObject = prepare("small_ball_arrow", new MultiObject()  ,GetSingleItem("_view").parent.parent);
		   small_ball_arrow.Create_by_list(1, [ResName.ballarrorw], 0, 0, 3, 110, 0, "time_");
		   small_ball_arrow.container.x = 147;
		   small_ball_arrow.container.y = 405;		   
		   small_ball_arrow.container.visible = false; 
		   
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
			
			
			//免洗球
			var fakeball:MultiObject = prepare("fakeball", new MultiObject(), GetSingleItem("_view").parent.parent);				
			fakeball.Create_by_list(1, [ResName.popBall], 0 , 0, 2, 1880 , 0, "Bet_");
			fakeball.container.x = 30.6;
			fakeball.container.y = 541.75;
			fakeball.container.visible = true;
			_model.putValue("fakeball", 1);
			
			GetSingleItem("fakeball")["_fakeBall_0"].visible = false;
			GetSingleItem("fakeball")["_fakeBall_1"].visible = false;
			GetSingleItem("fakeball")["_fakeBall_2"].visible = false;
			
			_first = true;
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
			
		   //_tool.SetControlMc(	small_ball_arrow.container);
		   //_tool.y = 500;
			//add(_tool);
			
			//抽獎球
			var lottyball:MultiObject = prepare("lottyball", new MultiObject(), GetSingleItem("_view").parent.parent);				
			lottyball.Create_by_list(1, [ResName.lottyball], 0 , 0, 2, 1880 , 0, "Bet_");
			lottyball.container.x = 30.6;
			lottyball.container.y = 541.75;			
			lottyball.container.visible = false;
			
			_model.putValue("open3Balllist", []);				
			
			
			
		}
		
		public function ball_t():void
		{			
			GetSingleItem("fakeball")["_fakeBall_0"].visible = true;
			GetSingleItem("fakeball")["_fakeBall_1"].visible = true;
			GetSingleItem("fakeball")["_fakeBall_2"].visible = true;
			
			var ontop:int = _model.getValue("fakeball");			
			var idx_1:int = ontop;
			var idx_2:int = ontop;
			var idx_3:int = ontop;
			var waiing_ball:Array = _model.getValue("waitting_ball");			
			var ball_1:int = waiing_ball[0];
			var ball_2:int = waiing_ball[1];
			//utilFun.Log("ball_1 =" + ball_1);			
			//utilFun.Log("ball_2 =" + ball_2);
			//for ( var i:int = 0; i < 40; i+=2)
			//{
				//var pos:int = Math.random() * 5 + 1;
				//var pos2:int = Math.random() * 5 + 1;
				//_shake_po[i] = [pos,pos2];
				//_shake_po[i + 1] = [ -pos, -pos2];
				//
				//var pos3:int = Math.random() * 5 + 1;
				//var pos4:int = Math.random() * 5 + 1;
				//_shake_po2[i] = [pos3,pos4];
				//_shake_po2[i + 1] = [ -pos3, -pos4];
			//}
			
			//第一次不位移
			if ( _first )
			{
				_first = false;
				var cnt:int = _model.getValue("fakeball");				
				
				//just set ,no move
				utilFun.SetText(GetSingleItem("fakeball")["_fakeBall_"+idx_1]["ballNum"], ball_1.toString());			
				GetSingleItem("fakeball")["_fakeBall_"+idx_1].gotoAndStop( Math.ceil( ball_1 / 15) ) ;
				
				idx_2 = cnt + 1;
				if ( idx_2 == 3) idx_2 = 0;
				utilFun.SetText(GetSingleItem("fakeball")["_fakeBall_"+idx_2]["ballNum"], ball_2.toString());			
				GetSingleItem("fakeball")["_fakeBall_" + idx_2].gotoAndStop( Math.ceil( ball_2 / 15) ) ;				
				
				
				//_regular.Call(this, { onUpdate:this.shake,onUpdateParams:[GetSingleItem("fakeball")["_fakeBall_" + idx_1] ] }, 2, 0, 20, "linear");
				//_regular.Call(this, { onUpdate:this.shake2,onUpdateParams:[GetSingleItem("fakeball")["_fakeBall_" + idx_2] ] }, 2, 0, 20, "linear");
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
			//utilFun.Log("idx_1 =" + idx_1 + " idx_2 =" +idx_2 +" idx_3 " + idx_3);		
			
			//reset 			
			//Tweener.pauseTweens(GetSingleItem("fakeball")["_fakeBall_" + idx_1]);
			//Tweener.pauseTweens(GetSingleItem("fakeball")["_fakeBall_" + idx_2]);
			//Tweener.pauseTweens(GetSingleItem("fakeball")["_fakeBall_" + idx_3]);
			//GetSingleItem("fakeball")["_fakeBall_" + idx_1].x = 99.65;
			//GetSingleItem("fakeball")["_fakeBall_" + idx_1].y = 228.50;
			//
			//GetSingleItem("fakeball")["_fakeBall_" + idx_2].x = 99.65;
			//GetSingleItem("fakeball")["_fakeBall_" + idx_2].y = 413.95;
			//
			//GetSingleItem("fakeball")["_fakeBall_" + idx_2].x = 99.65;
			//GetSingleItem("fakeball")["_fakeBall_" + idx_2].y = 47.55;
			//
			//_regular.Call(this, { onUpdate:this.shake,onUpdateParams:[GetSingleItem("fakeball")["_fakeBall_" + idx_1] ] }, 1, 0, 20, "linear");
			//_regular.Call(this, { onUpdate:this.shake,onUpdateParams:[GetSingleItem("fakeball")["_fakeBall_" + idx_2] ] }, 1, 0, 20, "linear");
			
			//first in display
			Tweener.addTween(GetSingleItem("fakeball")["_fakeBall_" + idx_3], { y:GetSingleItem("fakeball")["_fakeBall_" + idx_3].y -180.95, time:0.5,onComplete:this.resetpo,onCompleteParams:[idx_3]  } );
			
			Tweener.addTween(GetSingleItem("fakeball")["_fakeBall_" + idx_1], { y:GetSingleItem("fakeball")["_fakeBall_" + idx_1].y -180.95, time:0.1, delay:0.3 , onComplete:this.pullbar_open } );
			GetSingleItem("fakeball")["_pullbar"].gotoAndPlay(2);
			Tweener.addTween(GetSingleItem("fakeball")["_fakeBall_" + idx_2], { y:GetSingleItem("fakeball")["_fakeBall_" + idx_2].y -180.95, time:0.3,delay:0.3,onComplete:this.move } );
			
			
			
			
			
		
			
			
		}
		
		public function shake(mc:MovieClip):void
		{
			mc.x += _shake_po[0][0];
			mc.y += _shake_po[0][1];			
			
			_shake_po.shift();
		}
		
		public function shake2(mc:MovieClip):void
		{
			mc.x += _shake_po2[0][0];
			mc.y += _shake_po2[0][1];			
			
			_shake_po2.shift();
		}
		
		public function resetpo(idx:int):void
		{
			//GetSingleItem("fakeball")["_fakeBall_" + idx].x = 99.965;
			//GetSingleItem("fakeball")["_fakeBall_" + idx].y = 413.95;
		}
		
		public function pullbar_open():void
		{		
			GetSingleItem("fakeball")["_pullbar"].gotoAndStop(1);
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
			utilFun.scaleXY(mc, scalesize[0], scalesize[0]);
			mc.gotoAndStop( Math.ceil( (idx + 1) / 15) ) ;
			mc.visible = false;
			utilFun.SetText(mc["ballNum"], utilFun.Format(idx+1 , 1) );
			
		}
		
		public function pl(BallNum:int):void
		{
				dispatcher(new StringObject("sound_bingo_" + BallNum, "sound" ) );
			
		}
		
		[MessageHandler(type="ConnectModule.websocket.WebSoketInternalMsg",selector="ballupdate")]
		public function display():void
		{	
			
			//fake			
			ball_t();
			
			//big ball
			var BallNum:int = _model.getValue("Curball");
			Get(modelName.Open_Ball_Num).container.visible = true;			
			utilFun.SetText(GetSingleItem(modelName.Open_Ball_Num)["ballNum"] , utilFun.Format(BallNum,1));
			GetSingleItem(modelName.Open_Ball_Num).gotoAndStop( Math.ceil( BallNum / 15) ) ;		
			
			if( BallNum  >=1 && BallNum <=15) dispatcher(new StringObject("sound_bingo_b","sound" ) );
			if( BallNum  >=16 && BallNum <=30) dispatcher(new StringObject("sound_bingo_i","sound" ) );
			if( BallNum  >=31 && BallNum <=45) dispatcher(new StringObject("sound_bingo_n","sound" ) );
			if( BallNum  >=46 && BallNum <=60) dispatcher(new StringObject("sound_bingo_g","sound" ) );
			if( BallNum  >=61 && BallNum <=75) dispatcher(new StringObject("sound_bingo_o","sound" ) );
			Tweener.addCaller( this,{time:0.5, count:1, onComplete:this.pl, onCompleteParams:[BallNum]});			
			
			
			
			
			//3 smaill ball
			var open3ball:Array = _model.getValue("open3Balllist");
			open3ball.unshift(BallNum);
			if ( open3ball.length > 3)
			{
				open3ball.pop();
			}
			
			//左方小球
			Get("small_ball").container.visible = true;
			Get("small_ball_arrow").container.visible = true;
			for (var i:int = open3ball.length; i >0 ; i--)
			{			
				utilFun.SetText(GetSingleItem("small_ball",i-1)["ballNum"], utilFun.Format(open3ball[i-1], 1) );				
				GetSingleItem("small_ball",i-1).gotoAndStop( Math.ceil( open3ball[i-1] / 15) ) ;
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
		
			
			utilFun.SetText( openball["ballNum"], utilFun.Format( BallDisPlayIdx, 1 ));
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
				utilFun.SetText( openball["ballNum"], utilFun.Format( BallDisPlayIdx, 1 ));
				
				openball.visible = true;
				openball.gotoAndStop( Math.ceil( BallDisPlayIdx / 15 ) );
				utilFun.scaleXY(openball, _sball_scale,_sball_scale);								
			}
		}	
		
		
		[MessageHandler(type = "ConnectModule.websocket.WebSoketInternalMsg", selector = "specail_round")]
		public function into_sp():void
		{
			Get("fakeball").container.visible = false;			
			Get("lottyball").container.visible = true;
		}
		
		[MessageHandler(type = "ConnectModule.websocket.WebSoketInternalMsg", selector = "win_hint")]
		public function winhint():void
		{
			Get("fakeball").container.visible = true;			
			Get("lottyball").container.visible = false;
		}
		
		[MessageHandler(type = "ConnectModule.websocket.WebSoketInternalMsg", selector = "ball_coming")]
		public function display_ball():void
		{			
			var ball:Array = _model.getValue(modelName.SPCIAL_BALL);
			if ( ball.length == 1)
			{
				utilFun.Log("first ball");
				utilFun.SetText(GetSingleItem("lottyball")["lobby_ball"]["ballNum"],ball[0] );		
				Tweener.addTween(GetSingleItem("lottyball")["lobby_ball"], { y:40.85, time:3, onComplete:this.lo_ok , transition:"easeInOutBounce" } );
			}
			else if (ball.length == 2)
			{
				//dispatcher(new ModelEvent("pick_seond_ball"));				
				utilFun.Log("second ball");
				utilFun.SetText(GetSingleItem("lottyball")["pan_ball"]["ballNum"],ball[1] );		
				Tweener.addTween(GetSingleItem("lottyball")["pan_ball"], { y:228.75, time:3, onComplete:this.pan_ok , transition:"easeInOutBounce" } );	
			}
		}
		
		public function lo_ok():void 
		{
			dispatcher(new ModelEvent("lotty_first_ok"));
		}
		
		
		//[MessageHandler(type = "Model.ModelEvent", selector = "pick_seond_ball")]
		//public function se_ball():void
		//{
					//
		//}
		
		public function pan_ok():void 
		{
			dispatcher(new ModelEvent("pan_ok"));
		}
		
		
		
	}

}