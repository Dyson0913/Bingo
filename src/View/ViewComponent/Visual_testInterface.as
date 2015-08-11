package View.ViewComponent 
{
	import ConnectModule.websocket.WebSoketInternalMsg;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import util.math.Path_Generator;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	import View.Viewutil.*;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import View.GameView.*;
	import Res.ResName;
	import caurina.transitions.Tweener;
	import flash.events.MouseEvent;
	
	
	/**
	 * testinterface to fun quick test
	 * @author ...
	 */
	public class Visual_testInterface  extends VisualHandler
	{
		public var mouse:MouseTracker;	
		
		public function Visual_testInterface() 
		{
			
		}
		
		public function init():void
		{
			
			var btn:MultiObject = prepare("aa", new MultiObject() ,GetSingleItem("_view").parent.parent );			
			btn.MouseFrame = utilFun.Frametype(MouseBehavior.ClickBtn);			
			btn.stop_Propagation = true;
			btn.mousedown = test;			
			btn.mouseup = up;			
			btn.Create_by_list(5, ["BetTableBtn"], 0, 0, 5, 110, 0, "Btn_");
			
			//TODO check view to do prepare model
			///////////////////////////			
			
			//bet _view
				//var is_bet:Array = [];
							//var balls:Array = [];
							//var table_no:Array = [];
							//for ( var i:int = 0; i < 100 ; i++)
							//{						
								//is_bet.push( 0);
								//balls.push( []);
								//table_no.push( i);
							//}					
							//_model.putValue("is_betarr",is_bet);
							//_model.putValue("ballarr",balls);
							//_model.putValue("table", table_no);			
							
			//open view
			
			var bsetlist:Array = [];
			var sendlist:Array = [];
			for (var i:int = 0; i < 30; i ++ )
			{
				var bet:Object;			
				bet = { "table_no": i, 											
			                           "ball_list":  [1,2,3,4]									   
									   };
									   
				 bsetlist.push(bet);
			}
			_model.putValue("best_list",bsetlist );
			_model.putValue("second_list", bsetlist );
			
		}		
		
		public function test(e:Event, idx:int):Boolean
		{
			utilFun.Log("aa=" + idx);	
			
			if ( idx == 0) 
			{				
				//for ( var i:int = 1; i < 76; i++)
				//{
					//_model.putValue("Curball", i);
					//dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BALL_UPDATE));
				//}
				dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BALL_UPDATE));
            }
			  else if (idx == 1)
			  {
				  _model.putValue("Curball", 17);
				  	_model.putValue("best_remain", 3 );
					_model.putValue("second_remain", 2 );
			  _model.putValue("best_list", [1,1,1,1]);
							_model.putValue("second_list", [2,2,2,2,2,2,2] );
				dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BALL_UPDATE));				
				  
			  }
			   else if (idx == 2)
			  {
				  _model.putValue("Curball", 37);
				dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BALL_UPDATE));				
			
			  }
            else if (idx == 3)
			{				
				 _model.putValue("Curball", 47);
				dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BALL_UPDATE));	
			}
				  else if (idx == 4)
			{				
				 _model.putValue("Curball", 57);
				dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BALL_UPDATE));	
			}
			
			
			
			return true;
		}			
		
		public function up(e:Event, idx:int):Boolean
		{			
			return true;
		}	
		
	}

}