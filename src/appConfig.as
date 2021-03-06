package  
{
	import com.hexagonstar.util.debug.Debug;
	import Command.*;
	import flash.display.MovieClip;
	import Model.*;	
	import org.spicefactory.parsley.core.registry.ObjectDefinition;
	import util.math.Path_Generator;	
	import View.ViewBase.ViewBase;
	import ConnectModule.websocket.WebSoketComponent;
	import View.ViewBase.Visual_Text;
	import View.ViewBase.Visual_Version;
	import View.ViewComponent.*;
	import View.Viewutil.Visual_package_replayer;
	
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
		public var _sound:SoundCommand = new SoundCommand();
		public var _betDelayCommand:BetDelayCommand = new BetDelayCommand();
		
		//util
		public var _path:Path_Generator = new Path_Generator();		
		public var _text:Visual_Text = new Visual_Text();
		public var _fileStream:fileStream = new fileStream();
		public var _replayer:Visual_package_replayer = new Visual_package_replayer();
		public var _Version:Visual_Version = new Visual_Version();
		
		//visual		
		public var _timer:Visual_timer = new Visual_timer();
		public var _hint:Visual_Hintmsg = new Visual_Hintmsg();
		public var _playerinfo:Visual_PlayerInfo = new Visual_PlayerInfo();		
		public var _betzone:Visual_betZone = new Visual_betZone();
		public var _ball:Visual_ball = new Visual_ball();
		public var _staticinfo:Visual_staticInfo = new Visual_staticInfo();
		public var _bingo:Visual_bingoPan = new Visual_bingoPan();
		public var _ticket:Visual_ticket = new Visual_ticket();
		public var _Bigwin_Msg:Visual_Bigwin_Msg = new Visual_Bigwin_Msg();
		public var _Bigwin_Effect:Visual_Bigwin_Effect = new Visual_Bigwin_Effect();
		public var _Roller:Visual_Roller = new Visual_Roller();
		public var _betTimer:Visual_betTimer = new Visual_betTimer();
		public var _strem:Visual_stream = new Visual_stream();
		
		public var _settle:Visual_Settle = new Visual_Settle();
		public var _roomItem:Visual_RoomSelect = new Visual_RoomSelect();
		public var _themes:Visual_themes = new Visual_themes();
		public var _hisotry:Visual_hisotry = new Visual_hisotry();
		public var _page_arrow:Visual_page_arrow = new Visual_page_arrow();
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