package Command 
{
	import Model.Model;
	import util.utilFun;
	import View.Viewutil.*;
	
	/**
	 * data operation
	 * @author hhg
	 */
	public class DataOperation 
	{
		static public var Num:int = 0;
		
		public static const sub:int = Num++;
		public static const add:int = Num++;
		public static const multiply:int = Num++;
		public static const divide:int = Num++;
		public static const mod:int = Num++;
		
		[Inject]
		public var _model:Model;
		
		public function DataOperation()
		{
			
		}
		
		public function  operator(data_name:*,operation:int ,value:int = 1):* 
		{
			var data:* = _model.getValue(data_name);
			switch (operation)
			{
				case sub:
					data -= value;
				break;
				case add:
					data += value;
				break;
				case multiply:
					data *= value;
				break;
				case divide:
					data /= value;
				break;
				case mod:
					data %= value;
				break;
			}
			
			_model.putValue(data_name,data);
			return data;
		}
		
		public function  array_idx(data_name:*, idx_name:*):*
		{
			var data:* = _model.getValue(data_name);
			var idx:int = _model.getValue(idx_name);
			
			return data[idx];
		}
		
		
		/**
		 * loop a item to back. e.x 1,2 ....N  -> 2.3.....N
		 * @param	data_name 
		 * @param	start
		 * @param	len
		 * @return
		 * splice ( start,del_num,new item)
		 */
		public function  array_Item_loop(data_name:*,start:int =0,len:int =1):Array
		{
			var data:Array = _model.getValue(data_name);
			
			var Mistake_proofing_start:int = Math.min(start, data.length);
			var Mistake_proofing_len:int = Math.min(start + len, data.length);
			
			var Item:Array = data.slice(Mistake_proofing_start, Mistake_proofing_len);
			data.splice(start, len);
			data.push.apply(data, Item);
			
			_model.putValue(data_name, data);
			return _model.getValue(data_name);
		}
	}

}