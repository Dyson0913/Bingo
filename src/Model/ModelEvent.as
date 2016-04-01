package Model 
{	
	/**
	 * model值有更新,發送事件
	 * @author hhg4092
	 */
	public class ModelEvent 
	{
		[Selector]
		public var selector:String
		
		public var Value:*;
		
		public function ModelEvent(select:String, ...args) 
		{			
			selector = select;
			Value = args;
		}
		
	}

}