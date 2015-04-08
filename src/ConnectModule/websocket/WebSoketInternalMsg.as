package ConnectModule.websocket
{
	/**
	 * ...
	 * @author hhg
	 */
	public class WebSoketInternalMsg 
	{
		//public var stopBetView:Function;
	
		//public var HalfEnterInit:Function;
		//public var UpdataBallInfo:Function;
		//public var UpdateBetInfo:Function;
		
		//public var BetResult:Function;
		//public var cleanResult:Function;
		//public var UpTableBetInfo:Function;
		//public var BingoHint:Function;
		public static var Num:int = 0;
		
		
		public static const CHOOSE_ROOM:String = "chooseRoom";
		public static const BET:String = "Bet";
		public static const BETRESULT:String = "Betresult";
		public static const BET_STATE_UPDATE:String = "betstateupdate";
		
		
		[Selector]
		public var selector:String
		
		public function WebSoketInternalMsg(select:String) 
		{
			selector = select;
		}
		
	
		
	}

}