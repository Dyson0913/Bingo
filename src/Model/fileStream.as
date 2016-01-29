package Model 
{	
	import flash.events.*;
	import flash.net.FileReference;
	import flash.net.FileFilter;
	import com.adobe.serialization.json.JSON	
	import flash.utils.ByteArray;
	import Model.valueObject.ArrayObject;
	import util.utilFun;
	
	/**
	 * 輸出模型
	 * @author hhg4092
	 */
	public class fileStream 
	{
		[MessageDispatcher]
        public var dispatcher:Function;
		
		private var _recodeData:Array = [];
		
		public var _start:Boolean = false;
		
		private var _openfile:FileReference = new FileReference();
		
		[Inject]
		public var _MsgModel:MsgQueue;
		
		public function fileStream() 
		{
			
		}
		
		//start recoding
		[MessageHandler(type = "Model.ModelEvent", selector = "display")]
		public function recoding():void
		{
			if ( CONFIG::release ) return;
			
			write();
			if( !_start) switch_recode(true);
		}
		
		[MessageHandler(type="Model.valueObject.ArrayObject",selector="pack_recoder")]
		public function get_package(pack:ArrayObject):void
		{
			if ( CONFIG::release ) return;
			
			if ( !_start) return;
			recode(pack.Value[0]);
		}
		
		public function write():void
		{
			if ( !_start ) return;
			
			var file:FileReference = new FileReference();
			
			//var myob:Object = { size:1, aaa:3 };
			//var myob2:Object = { size:3, aaa:2 };
			//_recodeData.push(myob);
			//_recodeData.push(myob2);
			var arr:Array = [];
			for ( var i:int = 0; i < _recodeData.length ; i++)
			{
				var jsonString:String = JSON.encode(_recodeData[i]);				
				arr.push(jsonString);
			}			
			_recodeData.length = 0;
			
			var packhead:String = "{\"packlist\":[\n" + arr.join(",\n") +"]}";			
			file.save(packhead, "pack_.txt");
		}
		
		public function load():void
		{			
			_openfile.addEventListener(Event.SELECT, onFileSelected); 
			   var textTypeFilter:FileFilter = new FileFilter("Text Files (*.txt, *.rtf)", 
                        "*.txt;*.rtf"); 
            _openfile.browse([textTypeFilter]); 
		}
		
		public function onFileSelected(evt:Event):void 
        {            
            _openfile.addEventListener(Event.COMPLETE, onComplete); 
            _openfile.load(); 
        } 
		
		public function onComplete(evt:Event):void 
        { 			
            //utilFun.Log("File was successfully loaded."); 
			var ba:ByteArray = ByteArray(_openfile.data); 
			var utf8Str:String = ba.readMultiByte(ba.length, 'utf8');
			//utilFun.Log("data = "+utf8Str); 
			var result:Object  = JSON.decode(utf8Str);
			
			//create package interface
			dispatcher( new ArrayObject( result.packlist, "replay_pack"));
			
        }
		
		public function switch_recode(recode:Boolean):void
		{
			_start = recode;
		}
		
		public function recode(ob:Object):void
		{
			utilFun.Log("recoe !");
			_recodeData.push(ob);			
		}
	
	}

}