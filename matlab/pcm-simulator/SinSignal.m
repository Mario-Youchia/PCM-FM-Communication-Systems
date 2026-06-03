%% This is an abstract class to perform PCM encoding and decoding on sinusoidal signals
classdef SinSignal < handle
    properties (SetAccess = private)
        Duration % #sec
        NumOfTimestamps % How many time instants does this duration consist of?
        t
        OriginalSignal
        Amplitude
        MessageFrequency
        QuantizationLevels
        HalfDistanceBetweenTwoLevels
        NumOfLevels
    end
    methods
        function thisSinSignal = SinSignal(Duration, NumOfTimestamps, Amplitude, MessageFrequency)
            thisSinSignal.Duration = Duration;
            thisSinSignal.NumOfTimestamps = NumOfTimestamps;
            thisSinSignal.Amplitude = Amplitude;
            thisSinSignal.MessageFrequency = MessageFrequency;
            thisSinSignal.t = linspace(0,Duration,NumOfTimestamps*Duration);
            thisSinSignal.OriginalSignal = Amplitude*cos(2*pi*MessageFrequency*thisSinSignal.t); % Generating the message to be sampled
            
        end
        function SampledSignal = Sampling(thisSinSignal, SamplingFreq)
            SampledSignal = sampling(thisSinSignal, SamplingFreq);
        end
        function [QuantizedSignal, QuantizationLevels, HalfDistanceBetweenTwoLevels] = Quantizing(thisSinSignal, SampledSignal, NumOfLevels, PeakQuantizationLevel, mu)
            thisSinSignal.NumOfLevels = NumOfLevels;
            if nargin == 4
                [QuantizedSignal, QuantizationLevels, HalfDistanceBetweenTwoLevels] = Quantization(SampledSignal, NumOfLevels, PeakQuantizationLevel);
            else
                [QuantizedSignal, QuantizationLevels, HalfDistanceBetweenTwoLevels] = Quantization(SampledSignal, NumOfLevels, PeakQuantizationLevel, mu);
            end
            thisSinSignal.QuantizationLevels = QuantizationLevels;
            thisSinSignal.HalfDistanceBetweenTwoLevels = HalfDistanceBetweenTwoLevels;
        end
        function RequiredEncodedSignal = Encoding(thisSinSignal, QuantizedSignal, EncoderType)
            RequiredEncodedSignal = encoding(thisSinSignal.NumOfLevels, QuantizedSignal, thisSinSignal.QuantizationLevels, thisSinSignal.HalfDistanceBetweenTwoLevels, EncoderType);
        end
        function DecodedSignal = Decoding(thisSinSignal, RequiredEncodedSignal, EncoderType)
            DecodedSignal = decoding(RequiredEncodedSignal, thisSinSignal.NumOfLevels, EncoderType);
        end
        function ReconstructedSignal = Reconstructing(thisSinSignal, DecodedSignal)
            ReconstructedSignal = Reconstruction(DecodedSignal, thisSinSignal.QuantizationLevels);
        end
    end
    
end