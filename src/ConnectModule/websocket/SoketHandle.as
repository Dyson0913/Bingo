package ConnectModule.websocket 
{
	import View.GameView.ViewState;
		
	/**
	 * ...
	 * @author hhg
	 */
	public class SoketHandle 
	{
		[MessageDispatcher]
        public var dispatcher:Function;
		
		public function SoketHandle() 
		{
			
		}
		
		
		public function EnterLobby():void
		{
			dispatcher(new ViewState(ViewState.Lobb,ViewState.ENTER) );
			dispatcher(new ViewState(ViewState.Loading,ViewState.LEAVE) );
		}
		
	}

}
