package  
{
	import com.hexagonstar.util.debug.Debug;
	import org.spicefactory.parsley.asconfig.processor.ActionScriptConfigurationProcessor;
	import org.spicefactory.parsley.core.registry.ObjectDefinition;
	
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
		//
		public var _LobbView:LobbView = new LobbView();
		//
		public var _betView:betView = new betView();
		//
		public var _HudView:HudView = new HudView();
		
		
		public function appConfig() 
		{
			
			
			Debug.trace("my init");
		}
		
	}

}