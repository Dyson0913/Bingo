package View.GameView 
{
	/**
	 * ...
	 * @author hhg
	 */
	public class ViewState 
	{
		static public var Num:int = 0;
		
		//開球畫面動態區塊狀態
		public static const Loading:int = Num++;
		public static const Lobb:int = Num++;
		public static const Bet:int = Num++;
		public static const openball:int = Num++;
		public static const Hud:int = Num++;
		
		public static const ENTER:String = "Enter";
		public static const LEAVE:String = "Leave";
		public static const ADD:String = "add";
		
		public var _view:int = 0;
		public var _preview:int = 0;
		
		[Selector]
		public var selector:String
		
		[MessageDispatcher]
        public var dispatcher:Function;
		
		public function ViewState(view:int,select:String)  
		{
			//if ( select != ViewState.ADD)
			//{
				//dispatcher(new ViewState(_preview, ViewState.LEAVE));
			//}
			_preview = _view;
			_view = view;
			selector = select;
			
		}
		
	}

}