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
	 * timer present way
	 * @author ...
	 */
	public class Visual_ball  extends VisualHandler
	{
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _opration:DataOperation;
		
		private var _sball_x_diff:Number = 88;
		private var _sball_y_diff:Number =  85;
		private var _sball_scale:Number =  0.4;
		
		public function Visual_ball() 
		{
			
		}
		
		public function init():void
		{
			var ball:MultiObject = prepare(modelName.Open_Ball_Num, new MultiObject()  , GetSingleItem("_view").parent.parent);
			ball.CustomizedFun = sballFun;		   
		    ball.CustomizedData = [1];	   
		    ball.Create_by_list(1, [ResName.Ball], 0, 0, 1, 0, 0, "time_");
		    ball.container.x = 125;
		    ball.container.y = 184;		 
			ball.container.visible = false;
			
		   var sball:MultiObject = prepare("small_ball", new MultiObject()  , GetSingleItem("_view").parent.parent);
		   sball.CustomizedFun = sballFun;		   
		   sball.CustomizedData = [0.4];	   
		   sball.Create_by_list(3, [ResName.Ball], 0, 0, 3, 110, 0, "time_");
		   sball.container.x = 69;
		   sball.container.y = 392;		  
		   sball.container.visible = false;  
		   
		   var ball_pan:MultiObject = prepare("ball_pan", new MultiObject()  , GetSingleItem("_view").parent.parent);
		   ball_pan.CustomizedFun = ball_panfun;		   
		   ball_pan.Create_by_list(1, [ResName.Ball_pan], 0, 0, 1, 0, 0, "time_");
		   ball_pan.container.x = 443.9;
		   ball_pan.container.y = 557;	
		  if ( _betCommand.get_my_betlist().length == 0) 
		  {
			ball_pan.ItemList[0].gotoAndStop(2);
		  }
		   	
		   
		   	//_tool.SetControlMc(ball_pan.container);
			//add(_tool);
			_model.putValue("open3Balllist", []);						
			
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