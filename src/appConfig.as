package  
{
	import com.hexagonstar.util.debug.Debug;
	import Command.*;
	import flash.display.MovieClip;
	import Model.*;
	import org.spicefactory.parsley.asconfig.processor.ActionScriptConfigurationProcessor;
	import org.spicefactory.parsley.core.registry.ObjectDefinition;
	import util.math.Path_Generator;
	import View.ViewBase.ViewBase;
	import ConnectModule.websocket.WebSoketComponent;
	import View.ViewComponent.*;
	
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
		public var _Lobby:LobbyView = new LobbyView();
		public var _betView:betView = new betView();
		public var _ballview:OpenBallView = new OpenBallView();
		public var _HudView:HudView = new HudView();		
		
		//model		
		public var _Model:Model = new Model();
		public var _MsgModel:MsgQueue = new MsgQueue();
		public var _Actionmodel:ActionQueue = new ActionQueue();
		
		
		//connect module
		public var _socket:WebSoketComponent = new WebSoketComponent();
		
		//command 
		public var _viewcom:ViewCommand = new ViewCommand();
		public var _state:StateCommand = new StateCommand();
		public var _dataoperation:DataOperation = new DataOperation();
		public var _betcom:BetCommand = new BetCommand();
		public var _regular:RegularSetting = new RegularSetting();
		
		//util
		public var _path:Path_Generator = new Path_Generator();
		
		
		//visual		
		public var _timer:Visual_timer = new Visual_timer();
		public var _hint:Visual_Hintmsg = new Visual_Hintmsg();
		public var _playerinfo:Visual_PlayerInfo = new Visual_PlayerInfo();		
		public var _betzone:Visual_betZone = new Visual_betZone();
		public var _ball:Visual_ball = new Visual_ball();
		public var _staticinfo:Visual_staticInfo = new Visual_staticInfo();
		public var _bingo:Visual_bingoPan = new Visual_bingoPan();
		public var _ticket:Visual_ticket = new Visual_ticket();
		
		public var _settle:Visual_Settle = new Visual_Settle();
		
		//test
		public var _test:Visual_testInterface = new Visual_testInterface();
		public var _primitive:Visual_primitive = new Visual_primitive();
		
		//[ProcessSuperclass]
		//public var _vibase:ViewBase = new ViewBase();
		
		
		public function appConfig() 
		{
			Debug.trace("bingo init");
		}
	
	}

}