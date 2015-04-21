package View.GameView
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import Model.PlayerModel;
	import View.ViewBase.ViewBase;
	import ConnectModule.websocket.WebSoketComponent
	
	
	import util.utilFun;
	import caurina.transitions.Tweener;
	/**
	 * ...
	 * @author hhg
	 */

	public class LoadingView extends ViewBase
	{	
		public var _LoadingView:MovieClip;		
		
		[Inject]
		public var _socket:WebSoketComponent;
		
		public function LoadingView()  
		{
			
		}
		
		
		public function FirstLoad():void
		{
			dispatcher(new ViewState(ViewState.Loading,ViewState.ENTER) );
		}
		
		[MessageHandler(selector="Enter")] 
		override public function EnterView (View:ViewState):void
		{
			if (View._view != ViewState.Loading) return;
			
			_LoadingView = utilFun.GetClassByString("Loadingbg");
			addChild(_LoadingView);
			
			Tweener.addCaller(this, { time:2 , count: 1, onUpdate: this.connet } );
		}
		
		private function connet():void
		{	
			_socket.Connect();
		}
		
		[MessageHandler(selector="Leave")]
		override public function ExitView(View:ViewState):void
		{
			if (View._view != ViewState.Loading) return;
			utilFun.ClearContainerChildren(_LoadingView);
			utilFun.Log("LoadingView ExitView");
		}
		
		
	}

}