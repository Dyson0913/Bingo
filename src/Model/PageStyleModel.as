package Model 
{
	
	/**
	 * 翻頁式資料模型
	 * @author hhg4092
	 */
	public class PageStyleModel 
	{
		//物品列表
		private var _ItemList:Array = [];
		
		//一頁的數量
		private var _PageAmount:int ;
		
		//本頁開始索引
		private var _ItemPageIdx:int ;
		
		//己選擇索引
		private var _Select_item_Idx:int ;
		
		//第幾頁
		private var _currentPageIdx:int;
		
		public function get PageAmount():int
		{
			return _PageAmount;
		}
		
		public function get ItemPageIdx():int
		{
			return _ItemPageIdx;
		}
		
		public function PageStyleModel() 
		{
		}
		
		public function GoLastPage():void {
			var times:int = (_ItemList.length-1) / _PageAmount;
			for (var i:int = 0; i < times; i++) {
				NextPage();
			}
		}
		
		public function UpDateModel(ItemList:Array ,PageNum:int):void
		{
			_ItemList = ItemList;
			_PageAmount = PageNum;
			_ItemPageIdx = 0;
			_currentPageIdx = 0;
			_Select_item_Idx = -1;
		}
		
		public function CurrentPage(Delimiter:String):String
		{			
			var ItemLenth:int = _ItemList.length;
			
			var Denominator:int = ItemLenth / _PageAmount;
			var Remainder:int = ( ItemLenth % _PageAmount ) > 0 ? 1: 0;
			Denominator += Remainder;
			var molecule:int = (_ItemPageIdx / _PageAmount) +1;
			return  molecule.toString() + Delimiter +  Denominator.toString();
		}
		
		public function NextPage():void
		{
			var ItemLenth:int = _ItemList.length;
			
			if ( _ItemPageIdx < ItemLenth)
			{
				_ItemPageIdx += _PageAmount;
				if ( _ItemPageIdx >= ItemLenth)
				{
					_ItemPageIdx -= _PageAmount;
				}
			}			
		}
		
		public function PrePage():void
		{			
			var ItemLenth:int  = _ItemList.length;
			
			if ( _ItemPageIdx > 0 )
			{
				_ItemPageIdx -= _PageAmount;
				
			}		
		}		
		
		public function getRealIdx():int {
			return _ItemPageIdx;
		}
		
		public function  GetPageDate():Array
		{
			var EndIdx:int = _ItemList.length - _ItemPageIdx;

			return _ItemList.slice(_ItemPageIdx, _ItemPageIdx+ Math.min(EndIdx,_PageAmount) );
		}
		
		//取得目前頁數點擊item
		public function  GetOneDate(idx:int):*
		{
			_Select_item_Idx = _ItemPageIdx + idx;	
			return _ItemList[_Select_item_Idx];
		}
		
		//取得己點選item
		public function  Get_Select_Date():*
		{			
			return _ItemList[_Select_item_Idx];
		}
		
	}

}