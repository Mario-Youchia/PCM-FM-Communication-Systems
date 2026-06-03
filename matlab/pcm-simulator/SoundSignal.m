%% This is an abstract class to perform PCM encoding and decoding on sound signals
classdef SoundSignal < handle
     properties (SetAccess = private)
         Duration % #sec
         t
         OriginalSignal
         QuantizationLevels
         HalfDistanceBetweenTwoLevels
         NumOfLevels
         SampleRate
         SamplingFreq
     end
    methods
        function thisSoundSignal = SoundSignal(SampledData, SampleRate)
            thisSoundSignal.Duration = size(SampledData,1)/SampleRate;
            thisSoundSignal.t = linspace(0,thisSoundSignal.Duration,size(SampledData,1));
            thisSoundSignal.OriginalSignal = SampledData(:,1)';
            thisSoundSignal.SampleRate = SampleRate;
        end
        function SampledSignal = Sampling(thisSoundSignal, SamplingFreq)
            thisSoundSignal.SamplingFreq = SamplingFreq;
            SampledSignal = sampling(thisSoundSignal, SamplingFreq);
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
        function RequiredEncodedSignal = Encoding(thisSoundSignal, QuantizedSignal, EncoderType)
            RequiredEncodedSignal = encoding(thisSoundSignal.NumOfLevels, QuantizedSignal, thisSoundSignal.QuantizationLevels, thisSoundSignal.HalfDistanceBetweenTwoLevels, EncoderType);
        end
        function DecodedSignal = Decoding(thisSoundSignal, RequiredEncodedSignal, EncoderType)
            DecodedSignal = decoding(RequiredEncodedSignal, thisSoundSignal.NumOfLevels, EncoderType);
        end
        function ReconstructedSignal = Reconstructing(thisSoundSignal, DecodedSignal, ListeningOption)
            if nargin == 2
                ReconstructedSignal = Reconstruction(DecodedSignal, thisSoundSignal.QuantizationLevels, thisSoundSignal.SampleRate, size(thisSoundSignal.OriginalSignal,2), thisSoundSignal.SamplingFreq, thisSoundSignal.Duration);
            else
                ReconstructedSignal = Reconstruction(DecodedSignal, thisSoundSignal.QuantizationLevels, thisSoundSignal.SampleRate, size(thisSoundSignal.OriginalSignal,2), thisSoundSignal.SamplingFreq, thisSoundSignal.Duration, ListeningOption);
            end
        end
    end
    
end