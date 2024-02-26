module midi

import os
import vtl { TensorData }

pub enum MessageType {
	note_off                = 8
	note_on                 = 9
	poliphonic_key_pressure = 10
	control_change          = 11
	program_change          = 12
	channel_pressure        = 13
	pitch_bend              = 14
	system                  = 15
}

struct MIDIReader {
	data         []u8
	chunk_type   u32
	chunk_length u32
	format       u32
	n_tracks     u16
	division     u16
mut:
	offset int
}

fn load_inner(path string) !MIDIReader {
	bytes := os.read_bytes(path)!
	return MIDIReader{
		data: bytes
		offset: 14
		chunk_type: u32(bytes[0]) << 24 | u32(bytes[1]) << 16 | u32(bytes[2]) << 8 | bytes[3]
		chunk_length: u32(bytes[4]) << 24 | u32(bytes[5]) << 16 | u32(bytes[6]) << 8 | bytes[7]
		format: u32(bytes[8]) << 8 | bytes[9]
		n_tracks: u16(bytes[10]) << 8 | bytes[11]
		division: u16(bytes[12]) << 8 | bytes[13]
	}
}

fn (mut reader MIDIReader) read_data() {
	// TODO
}

fn (mut reader MIDIReader) read_4bytes() u32 {
	off := reader.offset
	d := reader.data
	value := u32(d[off]) << 24 | u32(d[off + 1]) << 16 | u32(d[off + 2]) << 8 | d[off + 3]
	reader.offset += 4
	return value
}

fn (mut reader MIDIReader) skip_bytes(delta int) {
	reader.offset += delta
}

fn load(path string) ! {
	mut reader := load_inner(path)!
	notes := vtl.zeros[int]([256, 3], TensorData{})
	for i_track in 0 .. reader.n_tracks {
		// MKrk, track length, track data
		reader.skip_bytes(4)
		track_length := reader.read_4bytes()
		end_offset := reader.offset + track_length
		// TODO
		reader.offset = end_offset
	}
}
