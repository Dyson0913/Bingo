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
		
		[Inject]
		public var _betCommand:BetCommand;
		
		
		
		public function Visual_testInterface() 
		{
			
		}
		
		public function init():void
		{
			utilFun.Log("init test");
			var btn:MultiObject = prepare("aa", new MultiObject() ,GetSingleItem("_view").parent.parent );			
			btn.MouseFrame = utilFun.Frametype(MouseBehavior.ClickBtn);			
			btn.stop_Propagation = true;
			btn.mousedown = test;			
			btn.mouseup = up;			
			btn.Create_by_list(5, ["BetTableBtn"], 0, 0, 5, 110, 0, "Btn_");
			
			//TODO check view to do prepare model
			///////////////////////////	
			//結算,
			//{"result_list": [{"bet_type": "13,26", "settle_amount": 0, "odds": 90, "win_state": "WSLost", "bet_amount": 100.0}], 
			                         //"game_state": "EndRoundState",
									 //"game_result_id": 1111, 
									 //"room_no": 13, 
									 //"timestamp": 1442992744.347524, 
									 //"remain_time": 4,
									 //"game_type": "Bingo",
									 //"bingo_result": [98], 
									 //"game_id": "Bingo-1",
									 //"game_round": 0, 
									 //"message_type": "MsgBPEndRound", 
									 //"id": "5ee8687661c311e5a6fdf23c9189e2a9"}
			
									//{"result_list": [ { "bet_type": "11,0", "settle_amount": 0, "odds": 90, "win_state": "WSLost", "bet_amount": 100 }, 
															//{ "bet_type": "11,1", "settle_amount": 0, "odds": 90, "win_state": "WSLost", "bet_amount": 100 }, 
															//{ "bet_type": "11,2", "settle_amount": 0, "odds": 90, "win_state": "WSLost", "bet_amount": 100 }, 
															//{ "bet_type": "11,3", "settle_amount": 0, "odds": 90, "win_state": "WSLost", "bet_amount": 100 } ],
															//"game_state": "EndRoundState",
															//"game_result_id": 1111,
															//"room_no": 11,
															//"timestamp": 1442993563.346101,
															//"remain_time": 4,
															//"game_type": "Bingo",
															//"bingo_result": [12],
															//"game_id": "Bingo-1",
															//"game_round": 0,
															//"message_type": "MsgBPEndRound", 
															//"id": "4711ad9661c511e5a6fdf23c9189e2a9"}
										
									 
									
									 
									 
			
			
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
			
			//var bsetlist:Array = [];
			//var sendlist:Array = [];
			//for (var i:int = 0; i < 30; i ++ )
			//{
				//var bet:Object;			
				//bet = { "table_no": i, 											
			                           //"ball_list":  []									   
									   //};
									   //
				 //bsetlist.push(bet);
				 //sendlist.push(bet);
			//}
			//_model.putValue("best_list",bsetlist );
			//_model.putValue("second_list", bsetlist );
			
			 
			//========================================= simu bet
			_betCommand.bet_init();		  
			   _model.putValue("ballarr",[])
			for (var i:int = 0; i < 5; i ++ )
			{
				var bet:Object;
			    var amount:int = 100;
			    bet = { "betType": i , 											
			                           "bet_amount":  (i+ 1)*100,
									   "bet_idx":1
									   };
									   _betCommand.test_bet(bet);
									   
									   var mylist:Array = _model.getValue("ballarr");
									   var ran:Array = [];
									    for (var k = 0; k < 24; k++) ran.push(utilFun.Random(75));
									  // mylist.push ([0,1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23,24]);
									   mylist.push (ran);
					_model.putValue("ballarr",mylist);
			}			
		
		}		
		
		public function test(e:Event, idx:int):Boolean
		{
			utilFun.Log("test=" + idx);	
			
			if ( idx == 0) 
			{				
				//var bsetlist:Array = [];
				//var sendlist:Array = [];
				//for (var i:int = 0; i < 30; i ++ )
				//{
					//var bet:Object;			
					//bet = { "table_no": i, 											
										   //"ball_list":  []									   
										   //};
										   //
					 //bsetlist.push(bet);
				//}
				//_model.putValue("best_list",bsetlist );
				//_model.putValue("second_list", bsetlist );
				//dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BALL_UPDATE));
				
				_model.putValue("Curball", utilFun.Random(75) );						
		        dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BALL_UPDATE));
            }
			  else if (idx == 1)
			  {
				  //_model.putValue("Curball", 17);
				  	//_model.putValue("best_remain", 3 );
					//_model.putValue("second_remain", 2 );
			  //_model.putValue("best_list", [1,1,1,1]);
							//_model.putValue("second_list", [2,2,2,2,2,2,2] );
							_model.putValue("Curball", parseInt("2") );						
		        dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BALL_UPDATE));
							
							//var bsetlist:Array = [];
				//var sendlist:Array = [];
				//for (var i:int = 0; i < 30; i ++ )
				//{
					//var bet:Object;			
					//bet = { "table_no": i, 											
										   //"ball_list":  [1]									   
										   //};
										   //
					 //bsetlist.push(bet);
				//}
				//_model.putValue("best_list",bsetlist );
				//_model.putValue("second_list", bsetlist );
				//dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BALL_UPDATE));				
				  
			  }
			   else if (idx == 2)
			  {
				  		var bsetlist:Array = [];
				var sendlist:Array = [];
				for (var i:int = 0; i < 30; i ++ )
				{
					var bet:Object;			
					bet = { "table_no": i, 											
										   "ball_list":  [1,2]									   
										   };
										   
					 bsetlist.push(bet);
				}
				_model.putValue("best_list",bsetlist );
				_model.putValue("second_list", bsetlist );
				dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BALL_UPDATE));				
			
			  }
            else if (idx == 3)
			{				
						var bsetlist:Array = [];
				var sendlist:Array = [];
				for (var i:int = 0; i < 30; i ++ )
				{
					var bet:Object;			
					bet = { "table_no": i, 											
										   "ball_list":  [1,2,3]									   
										   };
										   
					 bsetlist.push(bet);
				}
				_model.putValue("best_list",bsetlist );
				_model.putValue("second_list", bsetlist );
				dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BALL_UPDATE));	
			}
				  else if (idx == 4)
			{				
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