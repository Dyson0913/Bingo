package ConnectModule.websocket
{
	/**
	 * ...
	 * @author hhg
	 */
	public class WebSoketInternalMsg 
	{		
		public static var Num:int = 0;
		
		public static const CHOOSE_ROOM:String = "chooseRoom";
		public static const BET:String = "Bet";
		public static const BETRESULT:String = "Betresult";
		public static const BET_STATE_UPDATE:String = "betstateupdate";
		public static const BALL_UPDATE:String = "ball_update";
		public static const BET_STOP_HINT:String = "betstopHint";
		public static const BET_CLEARN_ALL:String = "clearnAllbet";
		public static const HUD_UPDATA:String = "hudupdata";
		public static const BINGO:String = "bingo";
		
		
		
		[Selector]
		public var selector:String
		
		public function WebSoketInternalMsg(select:String) 
		{
			selector = select;
		}
		
	
		
	}

}