module main

import consts
import path_util { output_path }
import wave { make_sine, write_16bit_mono }

fn main() {
	path := output_path('p2_1_output.wav')
	sine_wave := make_sine(0.2, 1000.0, consts.sampling_rate, 1.0)!
	write_16bit_mono(path, consts.sampling_rate, sine_wave.to_array())!
}
