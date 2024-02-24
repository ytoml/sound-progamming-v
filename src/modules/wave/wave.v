module wave

import math { sin }
import vtl { Tensor, TensorData }

// generate a sine wave
// amp: amplitude
// freq: frequency in Hz
pub fn make_sine(amp f64, freq f64, sampling_rate int, duration f64) !&Tensor[f64] {
	array_size := int(sampling_rate * duration)
	mut arr := vtl.zeros[f64]([array_size], TensorData{})

	// fill the array with sine wave
	for i in 0 .. array_size {
		wave_amp := sin(2 * math.pi * freq * i / sampling_rate)
		arr.set([i], wave_amp)
	}

	// fade in and fade out
	fade_window_size := int(0.01 * f64(sampling_rate))
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
	return arr.multiply_scalar(amp)
}
