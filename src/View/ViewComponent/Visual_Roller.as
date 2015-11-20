package View.ViewComponent 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import View.ViewBase.Visual_Text;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.*;
	import Res.ResName;
	import caurina.transitions.Tweener;
	
	import flash.filters.*;
	
	/**
	 * Roller present way
	 * @author ...
	 */
	public class Visual_Roller  extends VisualHandler
	{
		[Inject]
		public var _betCommand:BetCommand;
		public const Roller_2:String = "Roller";
		//public const Roller_Num:String = "testque";
		public const Roller_Num:String = "RollerNum";
		
		public const Res_switchbtn:String = "switch_btn";
		private var mapping_model_name:Array = ["Roller_Num","Roller2"];
		
		private var _stop_roll_name;
		
		private var blur:BlurFilter = new BlurFilter();
		
		public function Visual_Roller() 
		{
			
		}
		
		public function init():void
		{
			blur = new BlurFilter(0, 0, 1);
			
			//roller
			var Roller_2:MultiObject = create("Roller_2",  [Roller_2]);
			Roller_2.Create_(1, "Roller_2");
			Roller_2.ItemList[0]["_num_0"].gotoAndStop(10);
			Roller_2.ItemList[0]["_num_1"].gotoAndStop(1);
			Roller_2.ItemList[0]["_num_2"].gotoAndStop(2);
			Roller_2.ItemList[0]["_num_3"].gotoAndStop(3);
			Roller_2.ItemList[0]["_num2_0"].gotoAndStop(10);
			Roller_2.ItemList[0]["_num2_1"].gotoAndStop(1);
			Roller_2.ItemList[0]["_num2_2"].gotoAndStop(2);
			Roller_2.ItemList[0]["_num2_3"].gotoAndStop(3);
			Roller_2.container.x = 10.8;
			Roller_2.container.y = 113.6;
			Roller_2.container.visible = false;			
			
			//easy for test
			var Roller_Num:MultiObject = create("Roller_Num",  [ResName.empty]);			
			Roller_Num.put_item_reference(Roller_2.ItemList[0]["_num_0"]);
			Roller_Num.put_item_reference(Roller_2.ItemList[0]["_num_1"]);
			Roller_Num.put_item_reference(Roller_2.ItemList[0]["_num_2"]);
			Roller_Num.put_item_reference(Roller_2.ItemList[0]["_num_3"]);
			
			
			
			var Roller2:MultiObject = create("Roller2",  [ResName.empty]);			
			Roller2.put_item_reference(Roller_2.ItemList[0]["_num2_0"]);
			Roller2.put_item_reference(Roller_2.ItemList[0]["_num2_1"]);
			Roller2.put_item_reference(Roller_2.ItemList[0]["_num2_2"]);
			Roller2.put_item_reference(Roller_2.ItemList[0]["_num2_3"]);
			
			//var switchbtn_2:MultiObject = create("switchbtn_a", [Res_switchbtn]);
			//switchbtn_2.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [1, 2, 2, 1]);			
			//switchbtn_2.mousedown = stop_roller;
			//switchbtn_2.mouseup = _betCommand.empty_reaction;
			//switchbtn_2.rollout = _betCommand.empty_reaction;
			//switchbtn_2.rollover = _betCommand.empty_reaction;
			//switchbtn_2.container.x = 1770;
			//switchbtn_2.container.y = 900;
			//switchbtn_2.Create_(1, "switchbtn_a");
			
			roller_model();
			
			//var switchbtn_b:MultiObject = create("switchbtn_b", [Res_switchbtn]);
			//switchbtn_b.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [1, 2, 2, 1]);			
			//switchbtn_b.mousedown = change_roller;
			//switchbtn_b.mouseup = _betCommand.empty_reaction;
			//switchbtn_b.rollout = _betCommand.empty_reaction;
			//switchbtn_b.rollover = _betCommand.empty_reaction;
			//switchbtn_b.container.x = 1770;
			//switchbtn_b.container.y = 800;
			//switchbtn_b.Create_(1, "switchbtn_b");
			
		
		}
		
		public function start_roller(e:Event, idx:int):Boolean
		{			
			//roller();
			return true;
		}
		
		
		
		public function stop_roller(e:Event, idx:int):Boolean
		{		
			//setdata(mapping_model_name[0]);			
			//setdata(mapping_model_name[1]);			
			//setdata(_stop_roll_name);			
			return true;
		}
		
		public function change_roller(e:Event, idx:int):Boolean
		{						
			_stop_roll_name = mapping_model_name[1];
			return true;
		}	
		
		[MessageHandler(type = "Model.ModelEvent", selector = "lotty_first_ok")]
		public function fist_ball_ok():void
		{			
			setdata(mapping_model_name[0],0);
			setdata(mapping_model_name[1],0);			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "pan_ok")]		
		public function pan_ok():void
		{
			setdata(mapping_model_name[0],1);
			setdata(mapping_model_name[1],1);		
		}		
		
		public function setdata(rollerName:String,ball_idx:int):void
		{
			var stopCount:int = _model.getValue(rollerName + "_stopCount");
			var exe_tims:Array = _model.getValue(rollerName + "_excute_times");
			stopCount = exe_tims[0];
			_model.putValue(rollerName + "_stopCount",stopCount);		
			
			var arr = 	_model.getValue(rollerName + "_roll_idx");			
			//utilFun.Log(" roller =" + arr );			
			var ball:Array = _model.getValue(modelName.SPCIAL_BALL);				
			var balls:String  = ball[ball_idx];
			var ballarr:Array = balls.split("");
			var num:int = ballarr[mapping_model_name.indexOf(rollerName)];			
			var data:Array = [num - 1 , num, num + 1, num + 2];			
			GetSingleItem(rollerName,arr[0]).gotoAndStop(data[0]);
			GetSingleItem(rollerName,arr[1]).gotoAndStop(data[1]);
			GetSingleItem(rollerName, arr[2]).gotoAndStop(data[2]);
			GetSingleItem(rollerName, arr[3]).gotoAndStop(data[3]);
			
			blur.blurY =  0 ;
			blur.blurX =  0 ;
			GetSingleItem(rollerName, arr[0]).filters = [blur];
			GetSingleItem(rollerName, arr[1]).filters = [blur];
			GetSingleItem(rollerName,arr[2]).filters = [blur];
			GetSingleItem(rollerName, arr[3]).filters = [blur];
			
			GetSingleItem(rollerName, arr[0]).y = 0;
			GetSingleItem(rollerName, arr[1]).y = 140;
			GetSingleItem(rollerName, arr[2]).y = 280;
			GetSingleItem(rollerName, arr[3]).y = 420;
			
			if (ball_idx !=1) utilFun.SetTime(reset_roller, 1);
		}
			
		public function reset_roller():void
		{
			roller_model();
			roller(mapping_model_name[0]);
			roller(mapping_model_name[1]);
		}
		
		public function roller(rollerName:String):void
		{
			var arr = 	_model.getValue(rollerName + "_roll_idx");			
			utilFun.Log(" rollerName =" + rollerName );
			utilFun.Log(" roller =" + arr );
					
			Tweener.addTween(GetSingleItem(rollerName, arr[0]), { time:10,   transition:"linear", onUpdate:this.reset, onUpdateParams:[GetSingleItem(rollerName,arr[0]), arr[0],rollerName] } );		
			Tweener.addTween(GetSingleItem(rollerName,arr[1]), {  time:10, transition:"linear",onUpdate:this.reset,onUpdateParams:[GetSingleItem(rollerName,arr[1]),arr[1],rollerName] } );		
			Tweener.addTween(GetSingleItem(rollerName,arr[2]), {  time:10, transition:"linear", onUpdate:this.reset, onUpdateParams:[GetSingleItem(rollerName, arr[2]),arr[2],rollerName] } );		
			Tweener.addTween(GetSingleItem(rollerName,arr[3]), {  time:10, transition:"linear",onUpdate:this.reset,onUpdateParams:[GetSingleItem(rollerName,arr[3]),arr[3],rollerName] } );			
		}
		
		
		public function reset(mc:DisplayObjectContainer,idx:int,rollerName:String):void
		{			
			//control stop			
			var exe_times:Array = _model.getValue(rollerName + "_excute_times");
			var stopCount:int = _model.getValue(rollerName + "_stopCount");
			//utilFun.Log("exe_times = " + exe_times); 
			//utilFun.Log("stopCount = " + stopCount); 
			if ( exe_times[idx] == stopCount) 
			{
				utilFun.Log("y excute stop"  + " y =" +GetSingleItem(rollerName, idx).y + " idx =" + idx );				
				Tweener.pauseTweens(GetSingleItem(rollerName, idx));
				return;
			}
			//utilFun.Log("_excute = " +_excute);
			
			//naturme stop
			var speed:Array  = _model.getValue(rollerName + "_speed");
			var acceleration:Array  = _model.getValue(rollerName + "_acceleration");
			var delta:Array  = _model.getValue(rollerName + "_acceleration_delta");			
			if ( speed[idx] == 0) 
			{
				Tweener.pauseTweens(GetSingleItem(rollerName, idx));
				utilFun.Log("y stop"  + " y =" +GetSingleItem(rollerName, idx).y);
				utilFun.Log("re move listen= " +idx + " mc " + mc.y);
				
				return;
			}
		   //
			//var delta:Number = 0;
			//delta = Math.max( -140 - mc.y, _speed[idx]);
			//else delta = _speed[idx];
		   mc.y  -= speed[idx];		   
		   speed[idx] += acceleration[idx];
		  
		  if ( speed[idx] <= 0 ) speed[idx] = 0;
		   //top speed
		   if ( speed[idx] >= 30)   speed[idx] = 30;		  
		 
		   
		   //de speed
		   if ( delta[idx] ) 
		   {			   
			   acceleration[idx] = -0.5;		   
			   delta[idx] = 0;
		   }
		   
		   if ( speed[idx] > 25)  blur.blurY =  30 ;
		   else blur.blurY =  0 ;		   
			mc.filters = [blur];
			
			exe_times[idx] += 1;
		   //change po 
		   	if ( mc.y < -140) 
			{	
				//utilFun.Log("_excute = " +_excute);
				//utilFun.Log("change y = " +GetSingleItem("Roller_Num",0).y);
				//utilFun.Log("change y = " +GetSingleItem("Roller_Num",1).y);
				//utilFun.Log("change y = " +GetSingleItem("Roller_Num",2).y);
				//utilFun.Log("change y = " +GetSingleItem("Roller_Num",3).y);
				//
						
				var arr:Array  = _opration.array_Item_loop(rollerName+"_roll_idx");
				//utilFun.Log("arr = " + arr);
				//utilFun.Log("arr3 y = " +GetSingleItem("Roller_Num", arr[2]).y);
				//utilFun.Log("arr2 = " + _speed[arr[2]]); 
				
				//最後一個還未減最後一次的位移,需要再 - arr[2]才是最後一個的位置
				mc.y = GetSingleItem(rollerName, arr[2]).y + 140 - speed[arr[2]];
				
				
				var symble:Array  = _opration.array_Item_loop(rollerName+"_roll_symble");
				var toMc:MovieClip = mc as MovieClip;
				var frame:int = symble[3];
				if ( frame == 0) frame = 10;
				//utilFun.Log("frame = " + frame);
				toMc.gotoAndStop(frame);
				
				
				//if( _stop_count ==1) _stop = true;
				
				//start  dec speed condi
				//if ( arr[0] == 0) 
				//{
					//_count ++;
					//utilFun.Log("_count = "+_count);
					//if ( _count == 5)
					//{
						//utilFun.Log("de_cred");
						//_stop_count = _excute[0];
						//_dec = [1, 1, 1, 1];
					//}
				//}
				
			}
		   
		   
		}
		
		[MessageHandler(type = "ConnectModule.websocket.WebSoketInternalMsg", selector = "specail_round")]
		public function sp():void
		{
			Get("Roller_2").container.visible = true;
			roller(mapping_model_name[0]);
			roller(mapping_model_name[1]);
		}	
		
		[MessageHandler(type = "ConnectModule.websocket.WebSoketInternalMsg", selector = "win_hint")]
		public function winhint():void
		{
			//hide spical item
			Get("Roller_2").container.visible = false;
		}
		
		//expandable model 
		public function roller_model():void
		{			
			for ( var i:int = 0; i < mapping_model_name.length; i++)
			{
				_model.putValue(mapping_model_name[i] + "_roll_idx", [0, 1, 2, 3]);
				_model.putValue(mapping_model_name[i] + "_speed", [1, 1, 1, 1]);
				_model.putValue(mapping_model_name[i] + "_acceleration", [1, 1, 1, 1]);
				_model.putValue(mapping_model_name[i] + "_acceleration_delta", [0, 0, 0, 0]);
				_model.putValue(mapping_model_name[i] + "_excute_times", [0, 0, 0, 0]);
				_model.putValue(mapping_model_name[i] + "_stopCount", -1);
				_model.putValue(mapping_model_name[i] + "_roll_symble", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);				
			}
			_stop_roll_name = mapping_model_name[0];
		}
		
	}

}