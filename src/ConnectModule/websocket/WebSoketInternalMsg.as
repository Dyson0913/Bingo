package ConnectModule.websocket
{
	/**
	 * View msg <-> socket msg
	 * @author hhg
	 */
	public class WebSoketInternalMsg 
	{
		public static const CONNECT:String = "connect";
		public static const CHOOSE_ROOM:String = "chooseRoom";
		public static const BET:String = "Bet";
		public static const NO_CREDIT:String = "CreditNotEnough";
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