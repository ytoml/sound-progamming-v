module wave

const mask16 = 65535
const pow2_16 = 65536

// assume that the range of `data` is [-1.0, 1.0]
pub fn clip_into_16bit(data []f64) []i16 {
	mut result := []i16{len: data.len}
	for i, val in data {
		// quantize to 16bit
		q := int((val + 1) / 2 * wave.pow2_16 + 0.5)

		// clip
		if q > wave.mask16 {
			result[i] = i16(wave.mask16)
		} else if result[i] < 0 {
			result[i] = 0
		} else {
			result[i] = i16(q)
		}
	}
	return result
}
