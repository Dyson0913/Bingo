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
	 * timer present way
	 * @author ...
	 */
	public class Visual_themes  extends VisualHandler
	{
		[Inject]
		public var _betCommand:BetCommand;
		
		public const bigwinfire:String = "bigwin_fire";
		public const lottymsg:String = "lotty_msg";	
		public const Dark:String = "Dark";	
		public const Roller_2:String = "Roller";
		//public const Roller_Num:String = "testque";
		public const Roller_Num:String = "RollerNum";
		
		public const Res_switchbtn:String = "switch_btn";
		private var blur:BlurFilter = new BlurFilter();		
		private var _excute:Array   = [0,0,0,0];
		private var _speed:Array   = [1,1,1,1];
		private var _acum:Array  = [1, 1, 1, 1];
		private var _dec:Array = [0, 0, 0, 0];
		private var _count:int = 0;
		
		private var _stop_count:int = -1;		
		
		public function Visual_themes() 
		{
			
		}
		
		public function init():void
		{
			var secondhint:MultiObject = prepare("second_hint", new MultiObject()  , GetSingleItem("_view").parent.parent);
			secondhint.Create_by_list(1, [ResName.secondhint], 0, 0, 1, 0, 0, "time_");
			secondhint.container.x = 458.6; 
			secondhint.container.y = 381.7;			
			
			
			var besthint:MultiObject = prepare("besthint", new MultiObject()  , GetSingleItem("_view").parent.parent);
			besthint.Create_by_list(1, [ResName.besthint], 0, 0, 1, 0, 0, "time_");
			besthint.container.x = 417.9;
			besthint.container.y = 81.95;			
			
			//押暗
			var DarkItem:MultiObject = create("Dark",  [Dark]);			
			DarkItem.Create_(1, "Dark");
			GetSingleItem("Dark")["_bg"].alpha = 0;
			
			//金幣泉
			var bigwinfire:MultiObject = create("lotty_fire", [bigwinfire]);
			bigwinfire.Create_(1, "lotty_fire");
			bigwinfire.container.x = 90;
			bigwinfire.container.y = -140;
			setFrame("lotty_fire", 1);
			
			//大獎字樣集
			var lottymsg:MultiObject = create("lottymsg",  [lottymsg]);
			lottymsg.Create_(1, "lottymsg");
			lottymsg.container.x = 1000;
			lottymsg.container.y = 300;
			setFrame("lottymsg", 1);
			
		
		
			blur = new BlurFilter(0,0,1);
			//畫面按鈕,在押暗後生成,才按的到
			var switchbtn:MultiObject = create("switchbtn", [Res_switchbtn]);
			switchbtn.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [1, 2, 2, 1]);			
			switchbtn.mousedown = start_roller;
			switchbtn.mouseup = _betCommand.empty_reaction;
			switchbtn.rollout = _betCommand.empty_reaction;
			switchbtn.rollover = _betCommand.empty_reaction;
			switchbtn.container.x = 1770;
			switchbtn.container.y = 1000;
			switchbtn.Create_(1, "switchbtn");
			
			var switchbtn_2:MultiObject = create("switchbtn_a", [Res_switchbtn]);
			switchbtn_2.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [1, 2, 2, 1]);			
			switchbtn_2.mousedown = stop_roller;
			switchbtn_2.mouseup = _betCommand.empty_reaction;
			switchbtn_2.rollout = _betCommand.empty_reaction;
			switchbtn_2.rollover = _betCommand.empty_reaction;
			switchbtn_2.container.x = 1770;
			switchbtn_2.container.y = 900;
			switchbtn_2.Create_(1, "switchbtn_a");
			
			var switchbtn_b:MultiObject = create("switchbtn_b", [Res_switchbtn]);
			switchbtn_b.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [1, 2, 2, 1]);			
			switchbtn_b.mousedown = change_roller;
			switchbtn_b.mouseup = _betCommand.empty_reaction;
			switchbtn_b.rollout = _betCommand.empty_reaction;
			switchbtn_b.rollover = _betCommand.empty_reaction;
			switchbtn_b.container.x = 1770;
			switchbtn_b.container.y = 800;
			switchbtn_b.Create_(1, "switchbtn_b");
			
			//roller
			var Roller_2:MultiObject = create("Roller_2",  [Roller_2]);
			Roller_2.Create_(1, "Roller_2");
			Roller_2.ItemList[0]["_num_0"].gotoAndStop(10);
			Roller_2.ItemList[0]["_num_1"].gotoAndStop(1);
			Roller_2.ItemList[0]["_num_2"].gotoAndStop(2);
			Roller_2.ItemList[0]["_num_3"].gotoAndStop(3);
			Roller_2.container.x = 10.8;
			Roller_2.container.y = 113.6;
			
			//GetSingleItem("Roller_2")["_title"].gotoAndStop(2);
			
			//easy for test
			var Roller_Num:MultiObject = create("Roller_Num",  [ResName.empty]);			
			Roller_Num.put_item_reference(Roller_2.ItemList[0]["_num_0"]);
			Roller_Num.put_item_reference(Roller_2.ItemList[0]["_num_1"]);
			Roller_Num.put_item_reference(Roller_2.ItemList[0]["_num_2"]);
			Roller_Num.put_item_reference(Roller_2.ItemList[0]["_num_3"]);			
			
			_model.putValue("roll_idx", [0, 1, 2, 3]);			
			_count = 0;
			//test roller
			//var Roller_Num:MultiObject = create("Roller_Num",  [Roller_Num],Roller_2.container);
			//Roller_Num.CustomizedData = [4, 88, 140];
			//Roller_Num.CustomizedFun = _regular.Posi_Colum_first_Setting;
			//Roller_Num.container.x = 1000;
			//Roller_Num.container.y = 300;
			//Roller_Num.container.x = 80;			
			//Roller_Num.Create_(4, "Roller_Num");
			//GetSingleItem("Roller_Num").gotoAndStop(10);
			//GetSingleItem("Roller_Num",1).gotoAndStop(1);
			//GetSingleItem("Roller_Num", 2).gotoAndStop(2);
			//GetSingleItem("Roller_Num", 3).gotoAndStop(3);						
			//
		   //_tool.SetControlMc(Roller_Num.container);
		   //_tool.y = 200;
			//add(_tool);
			
			GetSingleItem("_view")["_CurBal"].visible = true;
		}
		
		public function start_roller(e:Event, idx:int):Boolean
		{
			_speed = [1,1,1,1];
			_acum  = [1, 1, 1, 1];
			_count = 0;			
			_stop_count = -1;
			roller();
			return true;
		}
		
		public function stop_roller(e:Event, idx:int):Boolean
		{								
			_stop_count = _excute[0];
			setdata();
			//setdata();
			return true;
		}
		
		public function change_roller(e:Event, idx:int):Boolean
		{						
			var Roller_2:MultiObject = Get("Roller_2");
			var control:MultiObject = Get("Roller_Num");
			control.CleanList();
			control.put_item_reference(Roller_2.ItemList[0]["_num2_0"]);
			control.put_item_reference(Roller_2.ItemList[0]["_num2_1"]);
			control.put_item_reference(Roller_2.ItemList[0]["_num2_2"]);
			control.put_item_reference(Roller_2.ItemList[0]["_num2_3"]);
			
			return true;
		}
		
		public function setdata():void
		{
			var arr = 	_model.getValue("roll_idx");
			utilFun.Log(" roller =" + arr );
			var data:Array = [6,7,8,9];
			GetSingleItem("Roller_Num",arr[0]).gotoAndStop(data[0]);
			GetSingleItem("Roller_Num",arr[1]).gotoAndStop(data[1]);
			GetSingleItem("Roller_Num", arr[2]).gotoAndStop(data[2]);
			GetSingleItem("Roller_Num", arr[3]).gotoAndStop(data[3]);
			
			blur.blurY =  0 ;
			blur.blurX =  0 ;
			GetSingleItem("Roller_Num", arr[0]).filters = [blur];
			GetSingleItem("Roller_Num", arr[1]).filters = [blur];
			GetSingleItem("Roller_Num",arr[2]).filters = [blur];
			GetSingleItem("Roller_Num", arr[3]).filters = [blur];
			
			GetSingleItem("Roller_Num", arr[0]).y = 0;
			GetSingleItem("Roller_Num", arr[1]).y = 140;
			GetSingleItem("Roller_Num", arr[2]).y = 280;
			GetSingleItem("Roller_Num", arr[3]).y = 420;
		}
			
		public function roller():void
		{
			var arr = 	_model.getValue("roll_idx");
			utilFun.Log(" roller =" + arr );
			
		
			Tweener.addTween(GetSingleItem("Roller_Num", arr[0]), { time:10,   transition:"linear", onUpdate:this.reset, onUpdateParams:[GetSingleItem("Roller_Num",arr[0]), arr[0]] } );		
			Tweener.addTween(GetSingleItem("Roller_Num",arr[1]), {  time:10, transition:"linear",onUpdate:this.reset,onUpdateParams:[GetSingleItem("Roller_Num",arr[1]),arr[1]] } );		
			Tweener.addTween(GetSingleItem("Roller_Num",arr[2]), {  time:10, transition:"linear", onUpdate:this.reset, onUpdateParams:[GetSingleItem("Roller_Num", arr[2]),arr[2]] } );		
			Tweener.addTween(GetSingleItem("Roller_Num",arr[3]), {  time:10, transition:"linear",onUpdate:this.reset,onUpdateParams:[GetSingleItem("Roller_Num",arr[3]),arr[3]] } );		
			
		}
		
		
		public function reset(mc:DisplayObjectContainer,idx:int):void
		{			
			//control stop
			if ( _excute[idx] == _stop_count) 
			{
				utilFun.Log("y excute stop"  + " y =" +GetSingleItem("Roller_Num", idx).y + " idx =" + idx );				
				Tweener.pauseTweens(GetSingleItem("Roller_Num", idx));
				return;
			}
			//utilFun.Log("_excute = " +_excute);
			
			//naturme stop
			if ( _speed[idx] == 0) 
			{
				Tweener.pauseTweens(GetSingleItem("Roller_Num", idx));
				utilFun.Log("y stop"  + " y =" +GetSingleItem("Roller_Num", idx).y);
				utilFun.Log("re move listen= " +idx + " mc " + mc.y);
				
				return;
			}
		   //
			//var delta:Number = 0;
			//delta = Math.max( -140 - mc.y, _speed[idx]);
			//else delta = _speed[idx];
		   mc.y  -= _speed[idx];		   
		   _speed[idx] += _acum[idx];
		  
		  if ( _speed[idx] <= 0 ) _speed[idx] = 0;
		   //top speed
		   if ( _speed[idx] >= 30)   _speed[idx] = 30;		  
		 
		   
		   //de speed
		   if ( _dec[idx] ) 
		   {			   
			   _acum[idx] = -0.5;		   
			   _dec[idx] = 0;
		   }
		   
		   if ( _speed[idx] > 25) 
		   {
			   blur.blurY =  30 ;
			   
		   }
		   else
		   {
			   blur.blurY =  0 ;

		   }
			mc.filters = [blur];
		   //
			_excute[idx] += 1;
		   //change po 
		   	if ( mc.y < -140) 
			{	
				utilFun.Log("_excute = " +_excute);
				//utilFun.Log("change y = " +GetSingleItem("Roller_Num",0).y);
				//utilFun.Log("change y = " +GetSingleItem("Roller_Num",1).y);
				//utilFun.Log("change y = " +GetSingleItem("Roller_Num",2).y);
				//utilFun.Log("change y = " +GetSingleItem("Roller_Num",3).y);
				//
						
				var arr:Array  = _opration.array_Item_loop("roll_idx");
				//utilFun.Log("arr = " + arr);
				//utilFun.Log("arr3 y = " +GetSingleItem("Roller_Num", arr[2]).y);
				//utilFun.Log("arr2 = " + _speed[arr[2]]); 
				
				//最後一個還未減最後一次的位移,需要再 - arr[2]才是最後一個的位置
				mc.y = GetSingleItem("Roller_Num", arr[2]).y + 140 -_speed[arr[2]];
				
				
				var toMc:MovieClip = mc as MovieClip;
				var frame:int = arr[3];
				if ( frame == 0) frame = 10;
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
			GetSingleItem("besthint").gotoAndStop(2);
			//TODO wintype _wintype
			//GetSingleItem("besthint")[" _wintype"].gotoAndStop(2);
			
			_regular.Twinkle_by_JumpFrame(GetSingleItem("besthint"), 30, 90, 2, 3);
			
			GetSingleItem("second_hint").gotoAndStop(2);
			
			GetSingleItem("_view")["_CurBal"].visible = false;
		}	
		
		[MessageHandler(type = "ConnectModule.websocket.WebSoketInternalMsg", selector = "win_hint")]
		public function winhint():void
		{
			//hide spical item
			GetSingleItem("Dark")["_bg"].alpha = 0;
			GetSingleItem("besthint").gotoAndStop(1);
			Tweener.pauseTweens(GetSingleItem("besthint"));
			GetSingleItem("second_hint").gotoAndStop(1);
			
			GetSingleItem("lottymsg").gotoAndStop(1);
			GetSingleItem("lotty_fire").gotoAndStop(1);
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "lotty_first_ok")]
		public function fist_ball_ok():void
		{
			//TODO first ball no
			GetSingleItem("second_hint").gotoAndStop(3);
			var ball:Array = _model.getValue(modelName.SPCIAL_BALL);			
			GetSingleItem("second_hint")["lobbyNum"].text = ball[0];
			
			
			
			//wait seoncball
			utilFun.SetTime(myse, 1);
			
		}
		
		public function myse():void
		{
			GetSingleItem("second_hint").gotoAndStop(4);
			//dispatcher(new ModelEvent("pick_seond_ball"));
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "pan_ok")]		
		public function pan_ok():void
		{			
			GetSingleItem("Dark")["_bg"].alpha = 0.5;
			GetSingleItem("second_hint").gotoAndStop(5);
			var ball:Array = _model.getValue(modelName.SPCIAL_BALL);			
			GetSingleItem("second_hint")["panNum"].text = ball[1];
			
			//fire			
			//TODO wintype _wintype
			GetSingleItem("lottymsg").gotoAndStop(2);			
			//GetSingleItem("lottymsg").gotoAndStop(1);
			
			
			var lo:int = ball[0];
			var arr:Array = utilFun.arrFormat(lo, 2);			
			if ( arr[0] == 0 ) arr[0] = 10;
			if ( arr[1] == 0 ) arr[1] = 10;
			GetSingleItem("lottymsg")["_num_0"].gotoAndStop(arr[0]);
			GetSingleItem("lottymsg")["_num_1"].gotoAndStop(arr[1]);
			
			//pan
			var lo2:int = ball[1];
			var arr2:Array = utilFun.arrFormat(lo2, 2);			
			if ( arr2[0] == 0 ) arr2[0] = 10;
			if ( arr2[1] == 0 ) arr2[1] = 10;
			GetSingleItem("lottymsg")["_num_2"].gotoAndStop(arr2[0]);
			GetSingleItem("lottymsg")["_num_3"].gotoAndStop(arr2[1]);
			
			utilFun.scaleXY(Get("lottymsg").container,4.0, 4.0);
			Get("lottymsg").container.alpha = 0;			
			Tweener.addTween(Get("lottymsg").container, { scaleX: 1, scaleY:1, alpha: 1, time:0.5, transition:"easeInQuart",onComplete:this.fire } );		
			
			
			
		}
		
		public function fire():void 
		{
			GetSingleItem("lotty_fire").gotoAndPlay(2);
		}
	}

}