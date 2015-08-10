package ConnectModule.websocket 
{
	/**
	 * ...
	 * @author hhg4092
	 */
	public final class Message
	{			
		
		//login		
		public static const MSG_TYPE_PLAYER_INITIAL:int = 0
		public static const MSG_TYPE_PLAYER_AUTH:int = 1
		public static const MSG_TYPE_DISPLAY_ROOMS:int = 2
		public static const MSG_TYPE_ENTER_ROOM:int = 3
		public static const MSG_TYPE_NEW_ROUND_WITH_BALL:int = 11
		public static const MSG_TYPE_NEW_ROUND:int = 12
		public static const MSG_TYPE_BET:int = 13
		public static const MSG_TYPE_UPDATE_BET:int = 14
		public static const MSG_TYPE_END_BET:int = 21
		public static const MSG_TYPE_OPEN_BALL:int = 31
		public static const MSG_TYPE_BINGO:int = 41
		
		public static const GAME_STATE_NEW_ROUND:int = 1
		public static const GAME_STATE_END_BET:int = 2
		public static const GAME_STATE_START_ROUND:int = 3
		public static const GAME_STATE_END_ROUND:int = 4
	}

}