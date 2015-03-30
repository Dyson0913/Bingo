package Model 
{
	
	/**
	 * ...
	 * @author hhg4092
	 */
	public class TableModel 
	{
		[MessageBinding(type="Model.valueObject.ArrayObject",messageProperty="array",selector="table")]
		public var _TableNo:Array
		
		
		[MessageBinding(type="Model.valueObject.ArrayObject",messageProperty="array",selector="is_betarr")]
		public var _isBet:Array = [];
		
		[MessageBinding(type="Model.valueObject.ArrayObject",messageProperty="array",selector="ballarr")]
		public var _BallList:Array = [];
		
		private var _BetCnt:int = 0;
		
		[MessageBinding(type="Model.valueObject.Intobject",messageProperty="InterValue",selector="remainTime")]
		public var _remainTime:int 
		
		public function TableModel() 
		{
			
		}
		
		public function UpDateModel(Table:Array ,isBet:Array,Ball:Array):void
		{
			_TableNo.length = 0;
			_isBet.length = 0;
			_BallList.length = 0;
			
			_TableNo = Table.concat();
			_isBet = isBet.concat();
			_BallList = Ball.concat();
			
		}
		
		public function GetBallByIdx(idx:int):Array
		{
			return _BallList[idx];
		}
		
		public function GetTableByIdx(idx:int):int
		{
			if (idx > _TableNo.length) return 0;
			return _TableNo[idx];
		}
		
		public function GetisBetbyIdx(idx:int):int
		{
			if (idx > _isBet.length) return 0;
			return _isBet[idx];
		}
		
		public function GetisBet():Array
		{			
			return _isBet;
		}
		
		public function GetisBallList():Array
		{			
			return _BallList;
		}
		
		public function GetTableIdx(TableNo:int):int
		{
			var idx:int = _TableNo.indexOf(TableNo);
			return idx;
		}
		
		public function GetBetCnt():int
		{
			var Cnt:int = 0;
			for (var i:int = 0; i < _isBet.length; i++)
			{
				if ( _isBet[i] == 1)
				{
					Cnt++;
				}
			}
			
			_BetCnt = Cnt;
			return Cnt;
		}
		
		
		public function GetNoOneBetCnt():int
		{
			return _isBet.length - _BetCnt;
		}
		
		
	}

}