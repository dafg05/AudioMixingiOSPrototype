# Audio Mixing in iOS

## AVAudioEngine and AVAudioPlayerNode

### Pros

* Easy to set up
* Playback of different tracks simple with multiple instances of AVAudioPlayerNode
### Cons

* Seeking to middle of audio needs [sample rate calculation](https://stackoverflow.com/questions/29954206/avaudioengine-seek-the-time-of-the-song)
