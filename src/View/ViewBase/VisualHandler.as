package View.ViewBase
{
	import Command.BetCommand;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import Model.Model;
	import Command.*;
	import Interface.ViewComponentInterface;
	import util.*;
	import Model.*;
	import View.Viewutil.AdjustTool;
	
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
		
		public var _tool:AdjustTool;
		
		public function VisualHandler() 
		{
			_tool = new AdjustTool();
		}
		
		protected function changeBG(name:String):void
		{
			utilFun.Clear_ItemChildren(GetSingleItem("_view"));
			GetSingleItem("_view").addChild(utilFun.GetClassByString(name) );
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
		
	}

}