package ConnectModule.websocket
{
	/**
	 * ...
	 * @author hhg
	 */
	public class WebSoketInternalMsg 
	{
		//public var chooseRoom:Function;
		//public var EnterBetView:Function;
		//public var stopBetView:Function;
		//public var OpenBallView:Function;
		//public var HalfEnterInit:Function;
		//public var UpdataBallInfo:Function;
		//public var UpdateBetInfo:Function;
		//public var BetResult:Function;
		//public var cleanResult:Function;
		//public var UpTableBetInfo:Function;
		//public var BingoHint:Function;
		public static var Num:int = 0;
		
		
		public static const CHOOSE_ROOM:String = "chooseRoom";
		
		[Selector]
		public var selector:String
		
		public function WebSoketInternalMsg(select:String) 
		{
			selector = select;
		}
		
	
		
	}

}