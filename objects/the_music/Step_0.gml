/// @desc Fade in music.
if (gain < 0.1) {
	gain += 0.0001;
	if (gain > 0.1) {
		gain = 0.1;
	}
}
audio_emitter_gain(audio, gain);