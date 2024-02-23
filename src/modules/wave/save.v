module wave

import miniaudio as ma

const mono = 1

pub fn write_16bit_mono(path string, sampling_rate u32, data []f64) ! {
	engine := &ma.Engine{}
	if ma.engine_init(ma.null, engine) != ma.Result.success {
		return error('Failed to initialize miniaudio engine')
	}
	encoder_config := ma.encoder_config_init(ma.EncodingFormat.wav, ma.Format.s16, wave.mono,
		sampling_rate)

	encoder := &ma.Encoder{}
	if ma.encoder_init_file(path.str, encoder_config, encoder) != ma.Result.success {
		return error('Failed to initialize miniaudio encoder')
	}

	for w in clip_into_16bit(data) {
		if ma.encoder_write_pcm_frames(encoder, w, 1, ma.null) != ma.Result.success {
			return error('Failed to write PCM frames to miniaudio encoder')
		}
	}
	ma.encoder_uninit(encoder)
	ma.engine_uninit(engine)
}
