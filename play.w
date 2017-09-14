@* Usage.
  \.{./play <file}

@d PCM_DEVICE "default"

@c
#include <alsa/asoundlib.h>
#include <stdio.h>
#include <stdlib.h>

int main(void)
{
        int err;
	unsigned int tmp;
	snd_pcm_t *play_handle;
	snd_pcm_hw_params_t *hw_params;
	snd_pcm_uframes_t uframes;
        snd_pcm_sframes_t sframes;
	char *buff;
	size_t buff_size;
	unsigned int loops;

	unsigned int rate = 8000;
	unsigned int channels = 1;
	unsigned int seconds = 0;

	if ((err = snd_pcm_open(&play_handle, PCM_DEVICE, SND_PCM_STREAM_PLAYBACK, 0)) < 0) {
	  printf("Can't open audio device %s: %s\n", PCM_DEVICE, snd_strerror(err));
          exit(1);
        }

	/* Allocate parameters object and fill it with default values*/
	snd_pcm_hw_params_alloca(&hw_params); /* FIXME: snd_pcm_hw_params_malloc = ? (and check
          exit status?) */

	if ((err = snd_pcm_hw_params_any(play_handle, hw_params)) < 0) {
          printf("Can't initialize hardware parameter structure: %s\n", snd_strerror(err));
          exit(1);
        }

	/* Set parameters */
	if ((err = snd_pcm_hw_params_set_access(play_handle, hw_params,
					SND_PCM_ACCESS_RW_INTERLEAVED)) < 0) {
		printf("Can't set interleaved mode: %s\n", snd_strerror(err));
                exit(1);
        }
	if ((err = snd_pcm_hw_params_set_format(play_handle, hw_params,
						SND_PCM_FORMAT_S16_LE)) < 0) {
		printf("Can't set sample format: %s\n", snd_strerror(err));
                exit(1);
        }
	if ((err = snd_pcm_hw_params_set_channels(play_handle, hw_params, channels)) < 0) { /*
                                 FIXME: must it be before set_rate_near or after? */
		printf("Can't set number of channels: %s\n", snd_strerror(err));
                exit(1);
        }
	if ((err = snd_pcm_hw_params_set_rate_near(play_handle, hw_params, &rate, NULL)) < 0) {
		printf("Can't set sample rate: %s\n", snd_strerror(err));
                exit(1);
        }
	
	if ((err = snd_pcm_hw_params(play_handle, hw_params)) < 0) {
		printf("Can't set harware parameters: %s\n", snd_strerror(err));
                exit(1);
        }

        /* FIXME: snd_pcm_hw_params_free (hw_params); ? - check with valgrind */

	/* Resume information */
	printf("PCM name: '%s'\n", snd_pcm_name(play_handle));

	printf("PCM state: %s\n", snd_pcm_state_name(snd_pcm_state(play_handle)));

	snd_pcm_hw_params_get_channels(hw_params, &tmp);
	printf("channels: %i ", tmp);

	if (tmp == 1)
		printf("(mono)\n");
	else if (tmp == 2)
		printf("(stereo)\n");

	snd_pcm_hw_params_get_rate(hw_params, &tmp, 0);
	printf("rate: %d bps\n", tmp);

	printf("seconds: %d\n", seconds);	

	/* Allocate buffer to hold single period */
	snd_pcm_hw_params_get_period_size(hw_params, &uframes, NULL);

	buff_size = uframes * channels * 2 /* 2 -> sample size */;
	buff = malloc(buff_size);

	snd_pcm_hw_params_get_period_time(hw_params, &tmp, NULL);

        /* FIXME: snd_pcm_prepare() here ? - and check its exit status ? */

	for (loops = (seconds * 1000000) / tmp; loops > 0; loops--) {
		if (read(STDIN_FILENO, buff, buff_size) == 0) {
			printf("Early end of file.\n");
			return 0;
		}

		if ((sframes = snd_pcm_writei(play_handle, buff, uframes)) == -EPIPE) {
			printf("XRUN.\n");
			snd_pcm_prepare(play_handle); /* FIXME: check exit status ? */
		}
                else if (sframes < 0) {
			printf("Can't write to PCM device: %s\n", snd_strerror(err));
                        /* FIXME: exit(1); ? */
		}
	}

	snd_pcm_drain(play_handle);
	snd_pcm_close(play_handle);
	free(buff);

	return 0;
}
