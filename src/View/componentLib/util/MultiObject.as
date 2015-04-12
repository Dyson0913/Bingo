package View.componentLib.util 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import View.componentLib.util.utilFun;
	
	
	/**
	 * 一次生成多個有規則排列的元件 
	 * @author hhg4092
	 */
	public class MultiObject 
	{
		private var _Container:MovieClip;
		
		//元件列表
		private var _ItemList:Array = [];		
		
		public function get ItemList():Array
		{
			return _ItemList;
		}
		
		//客制化功能
		public var CustomizedFun:Function = null;
		public var CustomizedData:Array = null;
		public var MouseFrame:Array = [];
		
		//各事件接口
		public var rollout:Function;
		public var rollover:Function;
		public var mousedown:Function;
		public var mouseup:Function;
		
		//元件命名
		private var _ItemName:String;		
		private var _contido:Boolean;
		
		public function MultiObject() 
		{
			
		}
		
		/**
		 * 生成N個物件 			E.X BetPointList.Create(12, "OrderBtn",1397.35 ,131.75 , 1, 0, 50.55, "BetPoint_", betView);
		 * @param	ItemNum  	總數量
		 * @param	LinkName 	fla裡的link名
		 * @param	StartX			起始X
		 * @param	StartY			起始Y
		 * @param	RowCnt		一列數量
		 * @param	Xdiff			X間隔
		 * @param	Ydiff			Y間隔
		 * @param	ItemName	元件命名 XXX_id(判定事件為那個元件觸發,會取其ID做判斷)
		 * @param	Container		父節點
		 */
		public function Create(ItemNum:int,LinkName:String,StartX:Number,StartY:Number,RowCnt:int,Xdiff:Number,Ydiff:Number,ItemName:String,Container:MovieClip):void
		{			
			for (var i:int = 0 ; i < ItemNum; i++)
			{
				var mc:MovieClip = utilFun.GetClassByString(LinkName);
				mc.x = StartX + (i % RowCnt * Xdiff);
				mc.y = StartY + ( Math.floor(i / RowCnt) * Ydiff);
				
				if (CustomizedFun != null)
				{
					CustomizedFun(mc, i,CustomizedData);
				}
				
				mc.name = ItemName + i;
				_ItemName = ItemName;
				ItemList.push(mc);
				Container.addChild(mc);
			}
			_Container = Container;
			Listen();
		}
		
		public function FlushObject():void
		{
			var ItemNum:int = ItemList.length;
			for (var i:int = 0 ; i < ItemNum; i++)
			{			
				if (CustomizedFun != null)
				{
					CustomizedFun(ItemList[i], i,CustomizedData);
				}
			}
		}
		
		public function CleanList():void
		{
			//removeListen();
			var cnt:int = ItemList.length;
			for ( var i:int = 0; i < cnt; i++)
			{
				_Container.removeChild(ItemList[i]);
			}
			
			ItemList.length = 0;
		}
		
		public function Getidx(name:String):int 
		{
			var s:String = utilFun.Regex_CutPatten(name, new RegExp(_ItemName, "i"));
			return parseInt(s);
		}
		
		private function Listen():void
		{
			var N:int =  ItemList.length;
			for (var i:int = 0 ;  i < N ;  i++)
			{
				if ( MouseFrame[0] != 0) ItemList[i].addEventListener(MouseEvent.ROLL_OUT, eventListen);
				if ( MouseFrame[1] != 0) ItemList[i].addEventListener(MouseEvent.ROLL_OVER, eventListen);
				if ( MouseFrame[2] != 0) ItemList[i].addEventListener(MouseEvent.MOUSE_DOWN, eventListen);
				if ( MouseFrame[3] != 0) ItemList[i].addEventListener(MouseEvent.MOUSE_UP, eventListen);
			}
		}
		
		public function removeListen():void
		{
			var N:int =  ItemList.length;
			for (var i:int = 0 ;  i < N ;  i++)
			{
				if ( MouseFrame[0] != 0) ItemList[i].removeEventListener(MouseEvent.ROLL_OUT, eventListen);
				if ( MouseFrame[1] != 0) ItemList[i].removeEventListener(MouseEvent.ROLL_OVER, eventListen);
				if ( MouseFrame[2] != 0) ItemList[i].removeEventListener(MouseEvent.MOUSE_DOWN, eventListen);
				if ( MouseFrame[3] != 0) ItemList[i].removeEventListener(MouseEvent.MOUSE_UP, eventListen);
			}
		}
		
		public function eventListen(e:Event):void
		{
			var idx:int = Getidx(e.currentTarget.name);
			switch (e.type)
			{
				case MouseEvent.ROLL_OUT:
				{
					if ( rollout != null) _contido = rollout(e,idx);
					if( _contido ) utilFun.GotoAndStop(e, MouseFrame[0]);					
				}
				break;
				case MouseEvent.ROLL_OVER:
				{
					if ( rollover != null) _contido = rollover(e,idx);
					if( _contido ) utilFun.GotoAndStop(e, MouseFrame[1]);
				}
				break;
				case MouseEvent.MOUSE_DOWN:
				{
					if ( mousedown != null) _contido = mousedown(e,idx);
					if( _contido ) utilFun.GotoAndStop(e, MouseFrame[2]);					
				}
				break;
				case MouseEvent.MOUSE_UP:
				{
					if ( mouseup != null) _contido = mouseup(e,idx);
					if( _contido ) utilFun.GotoAndStop(e, MouseFrame[3]);
				}
				break;
			}
		}
		
	}

}