# PCM and FM Communication Systems

This project contains communication-system simulations and implementations developed for Communications Theory and Systems. It includes a MATLAB Pulse Code Modulation (PCM) simulator, an FM communication-system MATLAB script, a Simulink model, a Multisim transmitter-components design, and the final report.

## Contents

* `matlab/pcm-simulator/` — MATLAB PCM simulator source files, helper functions, input audio, and output audio examples
* `matlab/fm-system/` — MATLAB FM communication-system script
* `simulink/` — Simulink model
* `multisim/` — Multisim transmitter-components design
* `docs/` — final report

## PCM Simulator

The PCM simulator processes either a sine-wave signal or an audio signal. For audio input, the project uses `Test.wav`, applies the PCM stages, and produces reconstructed audio outputs.

The PCM workflow includes:

* Sampling
* Quantization
* Encoding
* Decoding
* Reconstruction
* Audio output generation

The main PCM files are:

| File or folder                       | Purpose                                                                             |
| ------------------------------------ | ----------------------------------------------------------------------------------- |
| `matlab/pcm-simulator/PCM.m`         | Main PCM simulator script                                                           |
| `matlab/pcm-simulator/SinSignal.m`   | Class for sine-wave input                                                           |
| `matlab/pcm-simulator/SoundSignal.m` | Class for audio-file input                                                          |
| `matlab/pcm-simulator/Functions/`    | Helper functions for sampling, quantization, encoding, decoding, and reconstruction |
| `matlab/pcm-simulator/Test.wav`      | Original input audio file                                                           |
| `matlab/pcm-simulator/Outputs/`      | Reconstructed PCM audio outputs                                                     |

## PCM Output Examples

The output files are stored under `matlab/pcm-simulator/Outputs/`.

The files use different sampling frequencies, quantization levels, and quantization methods.

| File                                   | Quantizer     | Levels | PCM sampling frequency | Quality/use    |
| -------------------------------------- | ------------- | -----: | ---------------------: | -------------- |
| `pcm_output_uniform_L8_Fs2000.wav`     | Uniform       |      8 |                2000 Hz | Low / degraded |
| `pcm_output_uniform_L16_Fs2000.wav`    | Uniform       |     16 |                2000 Hz | Low / degraded |
| `pcm_output_uniform_L8_Fs4000.wav`     | Uniform       |      8 |                4000 Hz | Low / degraded |
| `pcm_output_mulaw255_L8_Fs4000.wav`    | μ-law (μ=255) |      8 |                4000 Hz | Low / degraded |
| `pcm_output_uniform_L16_Fs4000.wav`    | Uniform       |     16 |                4000 Hz | Low / degraded |
| `pcm_output_mulaw255_L16_Fs4000.wav`   | μ-law (μ=255) |     16 |                4000 Hz | Low / degraded |
| `pcm_output_uniform_L32_Fs8000.wav`    | Uniform       |     32 |                8000 Hz | Medium         |
| `pcm_output_mulaw255_L32_Fs8000.wav`   | μ-law (μ=255) |     32 |                8000 Hz | Medium         |
| `pcm_output_uniform_L64_Fs8000.wav`    | Uniform       |     64 |                8000 Hz | Medium         |
| `pcm_output_mulaw255_L64_Fs8000.wav`   | μ-law (μ=255) |     64 |                8000 Hz | Medium         |
| `pcm_output_uniform_L128_Fs8000.wav`   | Uniform       |    128 |                8000 Hz | Medium         |
| `pcm_output_mulaw255_L128_Fs8000.wav`  | μ-law (μ=255) |    128 |                8000 Hz | Medium         |
| `pcm_output_uniform_L64_Fs11025.wav`   | Uniform       |     64 |               11025 Hz | Medium         |
| `pcm_output_mulaw255_L64_Fs11025.wav`  | μ-law (μ=255) |     64 |               11025 Hz | Medium         |
| `pcm_output_uniform_L128_Fs11025.wav`  | Uniform       |    128 |               11025 Hz | Good           |
| `pcm_output_mulaw255_L128_Fs11025.wav` | μ-law (μ=255) |    128 |               11025 Hz | Good           |
| `pcm_output_uniform_L256_Fs11025.wav`  | Uniform       |    256 |               11025 Hz | Good           |
| `pcm_output_mulaw255_L256_Fs11025.wav` | μ-law (μ=255) |    256 |               11025 Hz | Good           |
| `pcm_output_uniform_L64_Fs16000.wav`   | Uniform       |     64 |               16000 Hz | Medium         |
| `pcm_output_mulaw255_L64_Fs16000.wav`  | μ-law (μ=255) |     64 |               16000 Hz | Medium         |
| `pcm_output_uniform_L128_Fs16000.wav`  | Uniform       |    128 |               16000 Hz | Good           |
| `pcm_output_mulaw255_L128_Fs16000.wav` | μ-law (μ=255) |    128 |               16000 Hz | Good           |
| `pcm_output_uniform_L256_Fs16000.wav`  | Uniform       |    256 |               16000 Hz | High           |
| `pcm_output_mulaw255_L256_Fs16000.wav` | μ-law (μ=255) |    256 |               16000 Hz | High           |
| `pcm_output_uniform_L512_Fs16000.wav`  | Uniform       |    512 |               16000 Hz | High           |
| `pcm_output_mulaw255_L512_Fs16000.wav` | μ-law (μ=255) |    512 |               16000 Hz | High           |

The highest-quality outputs are the `Fs16000` files with `L256` or `L512`.

## FM System

The FM portion includes:

* MATLAB FM communication-system simulation
* Simulink model
* Multisim transmitter-components design

The main FM files are:

| File or folder                         | Purpose                                |
| -------------------------------------- | -------------------------------------- |
| `matlab/fm-system/FM_Com_System.m`     | MATLAB FM communication-system script  |
| `simulink/Simulink.slx`                | Simulink model                         |
| `multisim/Transmitter Components.ms14` | Multisim transmitter-components design |

## How to Run / Review

Open MATLAB and run the PCM simulator:

```matlab
matlab/pcm-simulator/PCM.m
```

The FM MATLAB script is located at:

```text
matlab/fm-system/FM_Com_System.m
```

The Simulink model is located at:

```text
simulink/Simulink.slx
```

The Multisim design is located at:

```text
multisim/Transmitter Components.ms14
```

## Limitations

This is a course-level communications project focused on PCM simulation, FM system modeling, and basic hardware-oriented communication-system design. It is not intended to be a complete production communication system.

