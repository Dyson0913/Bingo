package  
{
	import com.hexagonstar.util.debug.Debug;
	import flash.display.MovieClip;
	import Model.BallModel;
	import Model.BetModel;
	import Model.LobbyModel;
	import Model.PlayerModel;
	import Model.TableModel;
	import org.spicefactory.parsley.asconfig.processor.ActionScriptConfigurationProcessor;
	import org.spicefactory.parsley.core.registry.ObjectDefinition;
	import View.componentLib.ViewBase.ViewBase;
	import ConnectModule.websocket.WebSoketComponent;
	
	import View.GameView.*;
	/**
	 * ...
	 * @author hhg
	 */
	public class appConfig 
	{
		//要unit test 就切enter來達成
		
		//singleton="false"
		[ObjectDefinition(id="Enter")]
		public var _LoadingView:LoadingView = new LoadingView();
		public var _Lobby:Lobby= new Lobby();
		public var _betView:betView = new betView();
		public var _HudView:HudView = new HudView();
		public var _OpenBall:OpenBallView = new OpenBallView();
		
		//model
		public var _PlayerModel:PlayerModel = new PlayerModel();
		public var _BetModel:BetModel = new BetModel();
		public var _LobbyModel:LobbyModel = new LobbyModel();
		public var _TableModel:TableModel = new TableModel();
		public var _BallModel:BallModel = new BallModel();
		
		
		//connect module
		public var _socket:WebSoketComponent = new WebSoketComponent();
		
		//[ProcessSuperclass]
		//public var _vibase:ViewBase = new ViewBase();
		
		
		public function appConfig() 
		{
			Debug.trace("my init");
		}
	
	}

}