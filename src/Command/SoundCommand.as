package Command 
{	
	import Model.*;
	import Model.valueObject.StringObject;
	import treefortress.sound.SoundTween;
	
	import util.*;	
	
	import treefortress.sound.SoundAS;
     import treefortress.sound.SoundInstance;
     import treefortress.sound.SoundManager;

	 
	/**
	 * sound play
	 * @author hhg4092
	 */
	public class SoundCommand 
	{
		[MessageDispatcher]
        public var dispatcher:Function;
		
		[Inject]
		public var _model:Model;
		
		private var _mute:Boolean;
		
		public function SoundCommand() 
		{
			
		}
		
		
		public function init():void
		{
			//SoundAS.addSound("Soun_Bet_BGM", new Soun_Bet_BGM());
			SoundAS.addSound("sound_coin", new sound_coin());
			SoundAS.addSound("sound_msg", new sound_msg());
			SoundAS.addSound("sound_rebet", new sound_rebet());			
						
			SoundAS.addSound("sound_get_big_coin", new sound_get_big_coin());
			SoundAS.addSound("sound_odd_show", new sound_odd_show());
			
			SoundAS.addSound("sound_bingo_b", new sound_bingo_b());
			SoundAS.addSound("sound_bingo_i", new sound_bingo_i());
			SoundAS.addSound("sound_bingo_n", new sound_bingo_n());
			SoundAS.addSound("sound_bingo_g", new sound_bingo_g());
			SoundAS.addSound("sound_bingo_o", new sound_bingo_o());
			
			SoundAS.addSound("sound_bingo_1", new sound_bingo_1());
			SoundAS.addSound("sound_bingo_2", new sound_bingo_2());
			SoundAS.addSound("sound_bingo_3", new sound_bingo_3());
			SoundAS.addSound("sound_bingo_4", new sound_bingo_4());
			SoundAS.addSound("sound_bingo_5", new sound_bingo_5());
			SoundAS.addSound("sound_bingo_6", new sound_bingo_6());
			SoundAS.addSound("sound_bingo_7", new sound_bingo_7());
			SoundAS.addSound("sound_bingo_8", new sound_bingo_8());
			SoundAS.addSound("sound_bingo_9", new sound_bingo_9());
			SoundAS.addSound("sound_bingo_10", new sound_bingo_10());
			SoundAS.addSound("sound_bingo_11", new sound_bingo_11());
			SoundAS.addSound("sound_bingo_12", new sound_bingo_12());
			SoundAS.addSound("sound_bingo_13", new sound_bingo_13());
			SoundAS.addSound("sound_bingo_14", new sound_bingo_14());
			SoundAS.addSound("sound_bingo_15", new sound_bingo_15());
			SoundAS.addSound("sound_bingo_16", new sound_bingo_16());
			SoundAS.addSound("sound_bingo_17", new sound_bingo_17());
			SoundAS.addSound("sound_bingo_18", new sound_bingo_18());
			SoundAS.addSound("sound_bingo_19", new sound_bingo_19());
			SoundAS.addSound("sound_bingo_20", new sound_bingo_20());
			SoundAS.addSound("sound_bingo_21", new sound_bingo_21());
			SoundAS.addSound("sound_bingo_22", new sound_bingo_22());
			SoundAS.addSound("sound_bingo_23", new sound_bingo_23());
			SoundAS.addSound("sound_bingo_24", new sound_bingo_24());
			SoundAS.addSound("sound_bingo_25", new sound_bingo_25());
			SoundAS.addSound("sound_bingo_26", new sound_bingo_26());
			SoundAS.addSound("sound_bingo_27", new sound_bingo_27());
			SoundAS.addSound("sound_bingo_28", new sound_bingo_28());
			SoundAS.addSound("sound_bingo_29", new sound_bingo_29());
			SoundAS.addSound("sound_bingo_30", new sound_bingo_30());
			SoundAS.addSound("sound_bingo_31", new sound_bingo_31());
			SoundAS.addSound("sound_bingo_32", new sound_bingo_32());
			SoundAS.addSound("sound_bingo_33", new sound_bingo_33());
			SoundAS.addSound("sound_bingo_34", new sound_bingo_34());
			SoundAS.addSound("sound_bingo_35", new sound_bingo_35());
			SoundAS.addSound("sound_bingo_36", new sound_bingo_36());
			SoundAS.addSound("sound_bingo_37", new sound_bingo_37());
			SoundAS.addSound("sound_bingo_38", new sound_bingo_38());
			SoundAS.addSound("sound_bingo_39", new sound_bingo_39());
			SoundAS.addSound("sound_bingo_40", new sound_bingo_40());
			SoundAS.addSound("sound_bingo_41", new sound_bingo_41());
			SoundAS.addSound("sound_bingo_42", new sound_bingo_42());
			SoundAS.addSound("sound_bingo_43", new sound_bingo_43());
			SoundAS.addSound("sound_bingo_44", new sound_bingo_44());
			SoundAS.addSound("sound_bingo_45", new sound_bingo_45());
			SoundAS.addSound("sound_bingo_46", new sound_bingo_46());
			SoundAS.addSound("sound_bingo_47", new sound_bingo_47());
			SoundAS.addSound("sound_bingo_48", new sound_bingo_48());
			SoundAS.addSound("sound_bingo_49", new sound_bingo_49());
			SoundAS.addSound("sound_bingo_50", new sound_bingo_50());
			SoundAS.addSound("sound_bingo_51", new sound_bingo_51());
			SoundAS.addSound("sound_bingo_52", new sound_bingo_52());
			SoundAS.addSound("sound_bingo_53", new sound_bingo_53());
			SoundAS.addSound("sound_bingo_54", new sound_bingo_54());
			//SoundAS.addSound("sound_bingo_55", new sound_bingo_55());
			SoundAS.addSound("sound_bingo_56", new sound_bingo_56());
			SoundAS.addSound("sound_bingo_57", new sound_bingo_57());
			SoundAS.addSound("sound_bingo_58", new sound_bingo_58());
			SoundAS.addSound("sound_bingo_59", new sound_bingo_59());
			SoundAS.addSound("sound_bingo_60", new sound_bingo_60());
			SoundAS.addSound("sound_bingo_60", new sound_bingo_60());
			SoundAS.addSound("sound_bingo_61", new sound_bingo_61());
			SoundAS.addSound("sound_bingo_62", new sound_bingo_62());
			SoundAS.addSound("sound_bingo_63", new sound_bingo_63());
			SoundAS.addSound("sound_bingo_64", new sound_bingo_64());
			SoundAS.addSound("sound_bingo_65", new sound_bingo_65());
			//SoundAS.addSound("sound_bingo_66", new sound_bingo_66());
			SoundAS.addSound("sound_bingo_67", new sound_bingo_67());
			SoundAS.addSound("sound_bingo_68", new sound_bingo_68());
			SoundAS.addSound("sound_bingo_69", new sound_bingo_69());
			SoundAS.addSound("sound_bingo_70", new sound_bingo_70());
			SoundAS.addSound("sound_bingo_70", new sound_bingo_70());
			SoundAS.addSound("sound_bingo_71", new sound_bingo_71());
			SoundAS.addSound("sound_bingo_72", new sound_bingo_72());
			SoundAS.addSound("sound_bingo_73", new sound_bingo_73());
			SoundAS.addSound("sound_bingo_74", new sound_bingo_74());
			SoundAS.addSound("sound_bingo_75", new sound_bingo_75());
			                                                                
			                                                                
			                                                               
			//create lobbycall back
			var lobbyevent:Function =  _model.getValue(modelName.HandShake_chanel);			
			if ( lobbyevent != null)
			{
				lobbyevent(_model.getValue(modelName.Client_ID), ["HandShake_callback", this.lobby_callback]);			
			}		
			
			_mute = false;
		}
		
		public function lobby_callback(CMD:Array):void
		{
			utilFun.Log("PA lobby call back = " + CMD);	
			if ( CMD[0] == "STOP_BGM")
			{
				//dispatcher(new StringObject("Soun_Bet_BGM","Music_pause" ) );
			}
			if ( CMD[0] == "START_BGM")
			{
				//dispatcher(new StringObject("Soun_Bet_BGM","Music" ) );
			}
			if ( CMD[0] == "MUTE")
			{
				_mute == true;
			}
			
			if ( CMD[0] == "RESUME")
			{
				_mute == false;
			}
		}
		
		[MessageHandler(type="Model.valueObject.StringObject",selector="Music")]
		public function playMusic(sound:StringObject):void
		{
			
			//var s:SoundTween  = SoundAS.addTween(sound.Value);			
			
			var ss:SoundInstance = SoundAS.playLoop(sound.Value);
			
		}
		
		[MessageHandler(type="Model.valueObject.StringObject",selector="Music_pause")]
		public function stopMusic(sound:StringObject):void
		{
			SoundAS.pause(sound.Value);
		}
		
		[MessageHandler(type="Model.valueObject.StringObject",selector="sound")]
		public function playSound(sound:StringObject):void
		{
			if ( _mute == true ) return;
			SoundAS.playFx(sound.Value);			
		}
		
		[MessageHandler(type="Model.valueObject.StringObject",selector="loop_sound")]
		public function loop_sound(sound:StringObject):void
		{
			if ( _mute == true ) return;
			SoundAS.playLoop(sound.Value);
		}
	}

}