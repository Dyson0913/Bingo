package View.ViewBase
{
	import Command.BetCommand;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import Model.Model;
	import Command.*;
	import Interface.ViewComponentInterface;
	import util.*;
	import Model.*;
	import View.Viewutil.AdjustTool;
	import View.Viewutil.MultiObject;
	
	/**
	 * handle display item how to presentation
	 * * @author hhg
	 */
	

	public class VisualHandler
	{
		[MessageDispatcher]
        public var dispatcher:Function;
		
		[Inject]
		public var _model:Model;
		
		[Inject]
		public var _viewcom:ViewCommand;
		
		[Inject]
		public var _regular:RegularSetting;
		
		[Inject]
		public var _opration:DataOperation;
		
		[Inject]
		public var _text:Visual_Text;
		
		public var _tool:AdjustTool;
		
		public function VisualHandler() 
		{
			_tool = new AdjustTool();
		}
		
		protected function changeBG(name:String):void
		{
			var view:MultiObject = Get("_view");
			view.CleanList();
			view.resList = [name];
			view.Create_(1, "_view");
		}
		
		//only for same view clean item
		protected function Del(name:*):void
		{			
			_viewcom.currentViewDI.Del(name);
		}
		
		protected function Get(name:*):*
		{			
			return _viewcom.currentViewDI.getValue(name);
		}
		
		protected function GetSingleItem(name:*,idx:int = 0):*
		{
			if( _viewcom.currentViewDI .getValue(name) )
			{
				var ob:* = _viewcom.currentViewDI .getValue(name);
				return ob.ItemList[idx];
			}
			return null;
		}
		
		protected function add(item:*):void
		{
			//item ->container ->view
			GetSingleItem("_view").parent.parent.addChild(item);
		}
		
		protected function removie(item:*):void
		{
			GetSingleItem("_view").parent.parent.removeChild(item);
		}
		
		protected function prepare(name:*, ob:ViewComponentInterface, container:DisplayObjectContainer = null):*
		{
			var sp:Sprite = new Sprite();
			sp.name = name + "_con";
			ob.setContainer(sp);
			return utilFun.prepare(name,ob , _viewcom.currentViewDI , container);
		}
		
		public function empty_reaction(e:Event, idx:int):Boolean
		{
			return true;
		}
		
		//========================= better way		
		protected function create(name:*,resNameArr:Array, Stick_in_container:DisplayObjectContainer = null):*
		{
			if ( Stick_in_container == null) Stick_in_container = GetSingleItem("_view").parent.parent;
			var ob:MultiObject = new MultiObject();
			ob.resList = resNameArr;
			
			var sp:Sprite = new Sprite();
			sp.name  = name;
			ob.setContainer(sp);
			return utilFun.prepare(name,ob , _viewcom.currentViewDI , Stick_in_container);
		}		
		
		protected function setFrame(name:*, frame:int):void
		{
			var a:MultiObject = Get(name);
			for ( var i:int = 0; i <  a.ItemList.length; i++)
			{				
				GetSingleItem(name, i).gotoAndStop(frame);
			}
		}
	}

}