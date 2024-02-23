module main

import consts
import math { sin }
import vtl { Tensor, TensorData }
import path_util { output_path }
import wave { write_16bit_mono }

const array_size = consts.sampling_rate * 1 // 1 second

// generate a sine wave
// amp: amplitude
// freq: frequency in Hz
fn make_sine(amp f64, freq f64) !&Tensor[f64] {
	mut arr := vtl.zeros[f64]([array_size], TensorData{})

	// fill the array with sine wave
	for i in 0 .. array_size {
		wave_amp := amp * sin(2 * math.pi * freq * i / consts.sampling_rate)
		arr.set([i], wave_amp)
	}

	// fade in and fade out
	fade_window_size := int(0.01 * consts.sampling_rate)
	for i in 0 .. fade_window_size {
		fade_in_amp := arr.get([i]) * f64(i) / f64(fade_window_size)
		arr.set([i], fade_in_amp)

		fade_out_amp := arr.get([array_size - i - 1]) * f64(i) / f64(fade_window_size)
		arr.set([array_size - i - 1], fade_out_amp)
	}

	// vtl.concatenate seems to have a bug?
	// println('add padding')
	// no_sound := vtl.zeros[f64]([array_size / 2], TensorData{})
	// return vtl.concatenate[f64]([no_sound, arr, no_sound], AxisData{ axis: 0 })
	return arr
}

fn main() {
	path := output_path('p2_1_output.wav')
	sine_wave := make_sine(0.2, 1000.0)!
	write_16bit_mono(path, consts.sampling_rate, sine_wave.to_array())!
}
