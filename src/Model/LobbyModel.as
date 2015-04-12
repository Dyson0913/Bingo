package Model 
{
	import Model.PageStyleModel;
	/**
	 * ...
	 * @author hhg4092
	 */
	public class LobbyModel 
	{
		public var _pageModel:PageStyleModel;		
		
		[MessageBinding(type="Model.valueObject.ArrayObject",messageProperty="array",selector="roomNo")]
		public var _table:Array;
		
		[MessageBinding(type="Model.valueObject.ArrayObject",messageProperty="array",selector="room_player")]		
		public var _player:Array;
		
		[MessageBinding(type="Model.valueObject.Intobject",messageProperty="InterValue",selector="CleanAllBet")]
		public var _CleanAllbet:int ;
		
		public var _currentRoomNum:int 
		
		public function LobbyModel() 
		{
			_CleanAllbet = 0;
		}
		
		public function UpDateModel():void
		{
			var arr:Array = [];
			
			var cnt:int = _table.length;
			for (var i:int = 0; i < cnt; i++)
			{
				var ob:Object= new Object();
				ob.roomNo = _table[i];
				ob.PlayerNum = _player[i];
				arr.push(ob);
			}
			
			_pageModel = new PageStyleModel();
			_pageModel.UpDateModel(arr.concat(), 20);
			
		}
		
	}

}