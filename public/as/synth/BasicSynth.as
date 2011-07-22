package synth
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import test.effects.Delay;
	import test.poly.SimplePolySynthVoiceFactory;
	import tonfall.core.Engine;
	import tonfall.core.TimeConversion;
	import tonfall.display.AbstractApplication;
	import tonfall.prefab.poly.PolySynth;
	import flash.external.ExternalInterface;
	
	/**
	 * Simple implementation of the Tonematrix
	 * 
	 * http://lab.andre-michelle.com/tonematrix
	 * 
	 * @author Andre Michelle
	 */
	[SWF(backgroundColor="#000000", frameRate="31", width="1", height="1")]
	public final class BasicSynth extends AbstractApplication
	{
		private var _voice : Voice = new Voice();
		private var _container: Sprite;
		private var _selectMode: Boolean;

		public function BasicSynth(){
			ExternalInterface.addCallback("queueNote", queueNote);
		}
		public function queueNote(note:int) : void
		{
			_voice.queue(note);
		}

	}

}
import flash.display.Sprite;

final class Button extends Sprite
	{
		private var _u : int;
		private var _v : int;
		
		private var _selected: Boolean;

		public function Button( u : int, v : int )
		{
			_u = u;
			_v = v;
			
			update();
		}

		public function get u() : int
		{
			return _u;
		}

		public function get v() : int
		{
			return _v;
		}

		public function get selected() : Boolean
		{
			return _selected;
		}

		public function set selected( selected : Boolean ) : void
		{
			_selected = selected;
			
			update();
		}
		
		private function update(): void
		{
			graphics.clear();
			graphics.beginFill( _selected ? 0xEDEDED : 0x333333 );
			graphics.drawRoundRect( 2.0, 2.0, 30.0, 30.0, 6, 6 );
			graphics.endFill();
		}
	}