package Model 
{
	import util.utilFun;
	/**
	 * ...
	 * @author hhg4092
	 */
	public class BetModel 
	{
		private var _BetTableNo:Array = [];
		private var _Betamount:Array = [];				
		private var _BallList:Array = [];
		
		private var _remain_Ball:Array = [];
		public var _sortArr:Array = [];
	
		public var _Amount:int = 0;
		public var _SetSelectItem:int =0;
		public var _BetState:int = -1;
		
		[MessageBinding(type="Model.valueObject.Intobject",messageProperty="InterValue",selector="credit")]
		public var _credit:int;
		
		//100,200,300,500,1000,1500,2000
		public var BetList:Array = [0,100, 200, 300, 500, 1000];
		
		public var _BetTableid:int = 0;
		public var _Betcredit:int = 0;
		public var _Bet_room_no:int = 0;
		public var _Bet_result:int = 0;
		
		public function BetModel() 
		{
			
		}
		
		public function Clean():void
		{
			_BetTableNo.length = 0;
			_Betamount.length = 0;
			_BallList.length = 0;			
			_remain_Ball.length = 0;
			_sortArr.length = 0;
		}
		
		public function CleanAll():void
		{
			//還錢
			for each(var i:int in _Betamount)
			{				
				_credit += BetList[i];
			}			
			Clean();
		}
		
		public function UpateBetInfo(TableNo:Array,Amount:Array):void
		{
			CleanAll();
			
			_BetTableNo = TableNo.concat();
			utilFun.Log("indside ="+_BetTableNo);
			
			for each( var amount:int in Amount)
			{
				var idx:int = BetList.indexOf(amount);				
				_Betamount.push(idx);
			}
			utilFun.Log("_Betamount ="+_Betamount);
			
		}
		
		public function AddBetInfo(TableId:int):Boolean
		{
			
			if ( _BetTableNo.length > 12) 	return false;
			
			if (_BetTableNo.indexOf(TableId) == -1)
			{
				_BetTableNo.push(TableId);
				_Betamount.push(1);
				_credit -= BetList[1];
				
				_BetState = -1;
			}
			//加注
			else if ( _BetState == 0)
			{
				var idx:int = _BetTableNo.indexOf(TableId);
				if ( idx != -1)
				{
					var diff:int = BetList[_Betamount[idx] ] - BetList[ (_Betamount[idx] -1) ]
					_credit -= diff;
				}
			}
			//減注
			else if ( _BetState == 1)
			{
				var idx:int = _BetTableNo.indexOf(TableId);
				if ( idx != -1)
				{
					var diff:int = BetList[ (_Betamount[idx]+1) ] - BetList[ _Betamount[idx]  ]
					_credit += diff;
				}
				
				if (  _Betamount[idx] == 0)
				{
					_Betamount.splice(idx, 1);					
					_BetTableNo.splice(idx, 1);
				}			
				
			}
			
			
			
			return true;
		}
		
		public function CommfirmAdd(ballArr:Array):void
		{			
			_BallList.push(ballArr.concat());
			_remain_Ball.push(24);			
		}
		
		public function GetSelectTable():int
		{
			return _BetTableNo[_SetSelectItem];
		}
		
		public function request_for_Betamount_Reduce(selectIdx:int):int
		{
			if ( selectIdx >= _Betamount.length ) return -1;
			_Betamount[selectIdx]--;
			
			_BetState = 1;
			_SetSelectItem = selectIdx;
			
			return BetList[ _Betamount[selectIdx]]
		}
		
		public function request_for_Betamount_add(selectIdx:int):int
		{
			if ( selectIdx >= _Betamount.length )  return 0;
			if ( _Betamount[selectIdx]  == BetList.length -1) return 0;
			
			_Betamount[selectIdx]++;
			
			_BetState = 0;
			_SetSelectItem = selectIdx;
			
			return BetList[ _Betamount[selectIdx]]
		}
		
		public function GetBetTableNo():Array
		{
			return _BetTableNo;
		}
		
		public function GetBetamount():Array
		{
			var array:Array = [];
			for ( var i:int = 0; i < _Betamount.length; i++)
			{
				array.push(BetList [_Betamount[i] ]);
			}
			return array;
		}
		
		public function ShowStart(Table:int):Boolean
		{
			//與第一桌有差就不秀,第一桌為最佳
			var ob:Object = _sortArr[Table];		
			var myNum:int = ob["remain"];
			
			ob = _sortArr[0];
			var firstNum:int = ob["remain"];
			
			if ( myNum > firstNum) return false;
			
			return true;
		}
		
		public function GetBetTotal():int
		{
			var total:int = 0;
			for each(var idx:int in _Betamount)
			{
				total += BetList[idx];
			}
			return total;
		}
		
		public function Betamount(idx:int):int
		{
			var ob:Object = _sortArr[idx];		
			return ob["Betamount"];
		}
		
		
		public function GetTable(idx:int):int
		{			
			var ob:Object = _sortArr[idx];		
			return ob["Table"];
		}		
		
		public function GetRemain(idx:int):int
		{
			var ob:Object = _sortArr[idx];		
			return ob["remain"];
		}
		
		public function GetBallList(idx:int):Array
		{
			var ob:Object = _sortArr[idx];		
			return ob["Ball"];
		}
		
		public function CheckBallremain(CurrentballNum:int):void
		{
			for (var i:int =0; i < _BallList.length; i++)
			{
				var ball:Array = _BallList[i];
				
				if (ball.indexOf(CurrentballNum) != -1)
				{
					_remain_Ball[i]--;
				}
				
				//utilFun.Log("remain "+ i+ " = " + _remain_Ball[i])
			}			
		}
		
		public function GetBest3BallList(alreadyOpenCnt:int):Array
		{
			//剩最少的先挑出
			var remainLeast:Array = [];			
			_sortArr.length = 0;	
			
			for (var i:int = 0; i < _BetTableNo.length; i++)
			{
				var ob:Object= new Object();
				ob.Table = _BetTableNo[i];
				ob.remain = _remain_Ball[i];
				ob.Ball = _BallList[i];
				ob.Betamount = BetList[ _Betamount[i] ];
				_sortArr.push(ob);
			}
			
			_sortArr.sort(sortbyremain);
			
			for (var i:int = 0; i < _sortArr.length; i++)
			{
				var ob:Object = _sortArr[i];
				remainLeast.push(ob["Table"]);
			}		
			//utilFun.Log("remainLeast = "+ remainLeast);
			
			return remainLeast.slice(0,3);
		}
		
		//ascending
		//傳回值 -1 表示第一個參數 a 是在第二個參數 b 之前。
		//傳回值 1 表示第二個參數 b 是在第一個參數 a 之前。
		//傳回值 0 指出元素都具有相同的排序優先順序。
		private function sortbyremain(a:Object, b:Object):int
		{
			//要decneding 變 >即可
			if ( a["remain"] < b["remain"]) 			return -1;				
			else if (  a["remain"] == b["remain"]) 	return 0;
			return 1;
		}
		
		
	}

}