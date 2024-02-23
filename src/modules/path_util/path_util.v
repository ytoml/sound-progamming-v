module path_util

import os

const output_dir_name = 'sound_output'

pub fn output_path(rel_path string) string {
	path := os.join_path(os.dir(@FILE), '..', '..', '..', path_util.output_dir_name, rel_path)
	return os.real_path(path)
}
