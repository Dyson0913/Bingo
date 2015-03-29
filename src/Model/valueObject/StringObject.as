package Model.valueObject 
{
	/**
	 * ...
	 * @author hhg
	 */
	public class StringObject 
	{
		public var stringValue:String;
		
		[Selector]
		public var selector:String
		
		public function StringObject(ob:String,selec:String) 
		{
			stringValue = ob;
			selector = selec;
		}
		
	}

}