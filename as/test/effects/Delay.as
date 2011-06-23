package test.effects
{
	import tonfall.core.BlockInfo;
	import tonfall.core.Processor;
	import tonfall.core.Signal;
	import tonfall.core.SignalBuffer;
	import tonfall.core.samplingRate;

	/**
	 * Simple static delay
	 * 
	 * @author Andre Michelle
	 */
	public final class Delay extends Processor
	{
		public const signalOutput: SignalBuffer = new SignalBuffer();
		
		private var _signalInput: SignalBuffer;
		
		private var _buffer: SignalBuffer;
		private var _bufferIndex: int;
		private var _bufferSize: int;
		
		private var _wet: Number = 0.5;
		private var _dry: Number = 0.8;
		private var _feedback: Number = 0.4;
		
		public function Delay( millis: int )
		{
			_bufferSize = millis / 1000.0 * samplingRate;

			_buffer = new SignalBuffer( _bufferSize );
			_bufferIndex = 0;
		}
		
		override public function process( info: BlockInfo ) : void
		{
			var dly: Signal = _buffer.current;
			var inp: Signal = _signalInput.current;
			var out: Signal = signalOutput.current;
			
			var readL: Number;
			var readR: Number;
			
			var i: int = 0;
			var n: int = info.numSignals;
			
			for( ; i < n ; ++i )
			{
				// READ FROM DELAY BUFFER
				readL = dly.l;
				readR = dly.r;
				
				// WRITE INPUT TO DELAY BUFFER
				dly.l = inp.l + readL * _feedback;
				dly.r = inp.r + readR * _feedback;

				// MIX INPUT AND DELAY TO OUTPUT
				out.l = inp.l * _dry + dly.l * _wet;
				out.r = inp.r * _dry + dly.r * _wet;
				
				dly = dly.next;
				inp = inp.next;
				out = out.next;
			}
			
			_buffer.advancePointer( info.numSignals );
			 signalOutput.advancePointer( info.numSignals );
		}

		public function get signalInput() : SignalBuffer
		{
			return _signalInput;
		}

		public function set signalInput( value: SignalBuffer ) : void
		{
			_signalInput = value;
		}

		public function get wet() : Number
		{
			return _wet;
		}

		public function set wet( value: Number ) : void
		{
			_wet = value;
		}

		public function get dry() : Number
		{
			return _dry;
		}

		public function set dry( value: Number ) : void
		{
			_dry = value;
		}

		public function get feedback() : Number
		{
			return _feedback;
		}

		public function set feedback( value: Number ) : void
		{
			_feedback = value;
		}
	}
}
