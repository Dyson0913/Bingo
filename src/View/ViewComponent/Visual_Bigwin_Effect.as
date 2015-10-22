package View.ViewComponent 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
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
	 * bigwin effect
	 * @author ...
	 */
	public class Visual_Bigwin_Effect  extends VisualHandler
	{
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _text:Visual_Text;
		
		public const Bigwinmsg:String = "big_win_msg";	
		public const bigwin_num:String = "big_win_num";
		public const bigwinfire:String = "bigwin_fire";
		
		public var _playing:Boolean;
		
		public function Visual_Bigwin_Effect() 
		{
			
		}
		
		public function init():void
		{	
			//金幣泉
			var bigwinfire:MultiObject = create("bigwinfire", [bigwinfire]);
			bigwinfire.Create_(1, "bigwinfire");
			bigwinfire.container.x = 140;
			bigwinfire.container.y = -90;
			
			//大獎字樣集
			var bigwinCon:MultiObject = create("bigwinmsg",  [Bigwinmsg]);
			bigwinCon.Create_(1, "bigwinmsg");
			bigwinCon.container.x = 1111;
			bigwinCon.container.y = 300;		
			
		
			
			//數字表現
			var PowerJPNum:MultiObject = create("bigwin_JP_num",  [bigwin_num], bigwinCon.container);			
			
			
			
			setFrame("bigwinmsg", 1);
			setFrame("bigwin_JP_num", 12);
			
			_playing = false;
			
			 //_tool.SetControlMc(bigwinfire.container);
			 //_tool.y = 200;
			//add(_tool);
		}
		
		public function stop():void
		{
			_playing = false;
			setFrame("bigwinmsg", 1);
			setFrame("bigwinfire", 1);
			Get("bigwin_JP_num").CleanList();
			
			Tweener.pauseTweens(Get("bigwinmsg").container);
			Tweener.pauseTweens(this);
			
			dispatcher(new StringObject("sound_get_big_coin","Music_pause" ) );
		}
		
		public function hitbigwin():void
		{			
			_playing = true;
			GetSingleItem("bigwinmsg").gotoAndStop(2);
				
			//Xodd
			//var s:String = "x" + _model.getValue("win_odd");
			var s:String = "100x10000";
			var arr:Array = utilFun.frameAdj(s.split(""));				
			var PowerJPNum:MultiObject = Get("bigwin_JP_num");
			PowerJPNum.container.x = -45 + (( -91 / 2) * (arr.length - 1));
			PowerJPNum.container.y = 330;		
			PowerJPNum.CustomizedData = arr;
			PowerJPNum.CustomizedFun = settlt_FrameSetting;
			PowerJPNum.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			PowerJPNum.Post_CustomizedData = [arr.length, 91, 0];
			PowerJPNum.Create_(arr.length, "bigwin_JP_num");									
				
						
			utilFun.scaleXY(Get("bigwinmsg").container,4.0, 4.0);
			Get("bigwinmsg").container.alpha = 0;
			
			Tweener.addTween(Get("bigwinmsg").container, { scaleX: 1, scaleY:1, alpha: 1, time:0.5, transition:"easeInQuart", onComplete:this.ready_to_cunt } );			
			dispatcher(new StringObject("sound_odd_show","sound" ) );
		}
		
		public function ready_to_cunt():void
		{
			Tweener.addTween(this, {delay:2, transition:"linear",onComplete:this._cunt } );
		}
		
		public function settlt_FrameSetting(mc:MovieClip, idx:int, data:Array):void
		{			
			if ( data[idx] == "x")  data[idx] = 13;
			mc.gotoAndStop(data[idx]);
		}
		
		public function _cunt():void
		{					
			utilFun.Log("_count");
			//沒下注,中大獎
			//if ( _model.getValue("result_total") == 0)
			//{
				//GetSingleItem("bigwinfire").gotoAndPlay(2);
				//settle(new Intobject(1, "settle_step"));
				//return;
			//}
			
			//_model.putValue("TotalJP_amoount", _model.getValue("result_total"));
			_model.putValue("TotalJP_amoount", 1000000);
			var s:String = "1000000" // _model.getValue("TotalJP_amoount");
			var arr:Array = utilFun.frameAdj(s.split(""));				
			utilFun.Log("arr = "+arr);
			var PowerJPNum:MultiObject = Get("bigwin_JP_num");
			PowerJPNum.CleanList();
			PowerJPNum.container.x = -45 + (( -91 / 2) * (arr.length - 1));
			PowerJPNum.container.y = 330;		
			PowerJPNum.CustomizedData = arr;
			PowerJPNum.CustomizedFun = settlt_FrameSetting;
			PowerJPNum.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			PowerJPNum.Post_CustomizedData = [arr.length, 91, 0];
			PowerJPNum.Create_(arr.length, "bigwin_JP_num");	
			coin_effect();
			
			//N秒內跑完表
			Tweener.addTween(this, {delay:1, transition:"linear",onComplete:this.num_count } );
		}
		
		public function coin_effect():void
		{
			GetSingleItem("bigwinfire").gotoAndPlay(2);
		}
		
		public function num_count():void
		{			
			var PowerJPNum:MultiObject = Get("bigwin_JP_num");			
			PowerJPNum.ItemList[PowerJPNum.ItemList.length-1].gotoAndPlay(11);			
			
			Tweener.addCaller(this, { time:10 , count: PowerJPNum.ItemList.length-1 , transition:"easeInQuad", onUpdateParams:[10], onUpdate: this.add_carray } );
			dispatcher(new StringObject("sound_get_big_coin","loop_sound" ) );
		}
		
		public function add_carray(amount:int):void
		{
			var total:Number = _model.getValue("TotalJP_amoount");			
			total -= amount;		
			total /= amount;			
			_model.putValue("TotalJP_amoount", total);			
			
			var toIn:int = total;
			var arr:Array = utilFun.frameAdj(toIn.toString().split(""));							
				
			var PowerJPNum:MultiObject = Get("bigwin_JP_num");	
			PowerJPNum.CleanList();
			PowerJPNum.container.x = -45 + (( -91 / 2) * (arr.length - 1));
			PowerJPNum.container.y = 330;
			PowerJPNum.CustomizedData = arr;
			PowerJPNum.CustomizedFun = settlt_FrameSetting;
			PowerJPNum.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			PowerJPNum.Post_CustomizedData = [arr.length, 91, 0];
			PowerJPNum.Create_(arr.length, "bigwin_JP_num");	
			PowerJPNum.ItemList[PowerJPNum.ItemList.length-1].gotoAndPlay(11);			
			
			
			if ( toIn <= 10) 
			{
				utilFun.Log("add carry over");
				//settle(new Intobject(1, "settle_step"));
				PowerJPNum.ItemList[PowerJPNum.ItemList.length - 1].gotoAndStop(10);
				dispatcher(new StringObject("sound_get_big_coin","Music_pause" ) );
				return;
			}
			
			
		}
		
	}

}