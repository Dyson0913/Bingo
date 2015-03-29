package Model.valueObject 
{
	/**
	 * ...
	 * @author hhg
	 */
	public class ArrayObject 
	{
		public var array:Array;
		
		[Selector]
		public var selector:String
		
		public function ArrayObject(ob:Array,selec:String) 
		{
			array = ob;
			selector = selec;
		}
		
	}

}