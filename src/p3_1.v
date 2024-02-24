import vtl { Tensor, TensorData }
import wave { make_sine, write_16bit_mono }
import path_util { output_path }
import consts

struct Note {
pub:
	track        int // 1-indexed
	start_sec    int
	pitch        f64 // in Hz
	velocity     f64
	duration_sec f64
}

fn build_wave_from_score(score []Note, tempo f64, n_tracks int, sampling_rate int) !&Tensor[f64] {
	end_of_track := (4 + 16) * (60.0 / tempo)
	array_size := int(sampling_rate * (end_of_track + 2))
	mut track := vtl.zeros[f64]([array_size, n_tracks], TensorData{})
	for note in score {
		sine := make_sine(note.velocity, note.pitch, sampling_rate, note.duration_sec)!
		offset := int(sampling_rate * note.start_sec)
		for i in 0 .. sine.shape[0] {
			track.set([offset + i, note.track - 1], sine.get([i]))
		}
	}

	mut music := vtl.zeros[f64]([array_size], TensorData{})
	for i in 0 .. n_tracks {
		for j in 0 .. array_size {
			current := music.get([j])
			music.set([j], current + track.get([j, i]))
		}
	}
	return music
}

fn main() {
	// convert array above to score with Note struct
	score := [
		Note{
			track: 1
			start_sec: 2
			pitch: 659.26
			velocity: 0.5
			duration_sec: 1
		},
		Note{
			track: 1
			start_sec: 3
			pitch: 587.33
			velocity: 0.5
			duration_sec: 1
		},
		Note{
			track: 1
			start_sec: 4
			pitch: 523.25
			velocity: 0.5
			duration_sec: 1
		},
		Note{
			track: 1
			start_sec: 5
			pitch: 493.88
			velocity: 0.5
			duration_sec: 1
		},
		Note{
			track: 1
			start_sec: 6
			pitch: 440.00
			velocity: 0.5
			duration_sec: 1
		},
		Note{
			track: 1
			start_sec: 7
			pitch: 392.00
			velocity: 0.5
			duration_sec: 1
		},
		Note{
			track: 1
			start_sec: 8
			pitch: 440.00
			velocity: 0.5
			duration_sec: 1
		},
		Note{
			track: 1
			start_sec: 9
			pitch: 493.88
			velocity: 0.5
			duration_sec: 1
		},
		Note{
			track: 2
			start_sec: 2
			pitch: 261.63
			velocity: 0.5
			duration_sec: 1
		},
		Note{
			track: 2
			start_sec: 3
			pitch: 196.00
			velocity: 0.5
			duration_sec: 1
		},
		Note{
			track: 2
			start_sec: 4
			pitch: 220.00
			velocity: 0.5
			duration_sec: 1
		},
		Note{
			track: 2
			start_sec: 5
			pitch: 164.81
			velocity: 0.5
			duration_sec: 1
		},
		Note{
			track: 2
			start_sec: 6
			pitch: 174.61
			velocity: 0.5
			duration_sec: 1
		},
		Note{
			track: 2
			start_sec: 7
			pitch: 130.81
			velocity: 0.5
			duration_sec: 1
		},
		Note{
			track: 2
			start_sec: 8
			pitch: 174.61
			velocity: 0.5
			duration_sec: 1
		},
		Note{
			track: 2
			start_sec: 9
			pitch: 196.00
			velocity: 0.5
			duration_sec: 1
		},
	]

	path := output_path('p3_1_output.wav')
	music := build_wave_from_score(score, 120.0, 2, consts.sampling_rate)!
	write_16bit_mono(path, consts.sampling_rate, music.to_array())!
}
