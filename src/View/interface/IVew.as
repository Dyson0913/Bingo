package View.InterFace 
{
	import View.GameView.ViewState;
	
	/**
	 * ...
	 * @author hhg
	 */
	public interface IVew 
	{
		
		function EnterView (View:ViewState):void;
		
		function ExitView():void;
	}
	
}