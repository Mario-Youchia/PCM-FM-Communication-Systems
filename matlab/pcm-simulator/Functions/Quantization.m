function [QuantizedSignal, QuantizationLevels, HalfDistanceBetweenTwoLevels] = Quantization(SampledSignal, NumOfLevels, PeakQuantizationLevel, mu)
if nargin == 3
    QuantizerType = 1;
else
    QuantizerType = 2;
end
    % Since the signal type is sinusoidal and not shifted up or down, then
    % it is symmetric about the x-axis and then we can multiply the
    % amplitude by 2.
    %DeltaV = (2*Amplitude)/(NumOfLevels-1); % DeltaV is the difference in
    DeltaV = (2*PeakQuantizationLevel)/(NumOfLevels-1); % DeltaV is the difference in
    % Voltage between two successive levels, and it is equal to twice the
    % amplitude of the message divided by the number of levels - 1 to
    % obtain the mid-rise quantizer
    %QuantizationLevels = -Amplitude:DeltaV:Amplitude;
    QuantizationLevels = -PeakQuantizationLevel:DeltaV:PeakQuantizationLevel;
    % HalfDistanceBetweenTwoLevels is a vector used to calculate the
    % 0.5DeltaV before and after each level, will be used to
    % approximate the amplitude of the sample to the nearest level
    HalfDistanceBetweenTwoLevels = -(PeakQuantizationLevel+DeltaV/2):DeltaV:(PeakQuantizationLevel+DeltaV/2);
    QuantizedSignal = zeros(1,size(SampledSignal,2));
    if (QuantizerType == 1) % Uniform Quantization
        for i = 1:size(SampledSignal,2)
            for j = 1:size(QuantizationLevels,2)
                if (SampledSignal(i) >= HalfDistanceBetweenTwoLevels(j) && ...
                        SampledSignal(i)< HalfDistanceBetweenTwoLevels(j+1))
                    QuantizedSignal(i) = QuantizationLevels(j);
                elseif (SampledSignal(i) > HalfDistanceBetweenTwoLevels(end))
                    QuantizedSignal(i) = QuantizationLevels(end);
                elseif (SampledSignal(i) < HalfDistanceBetweenTwoLevels(1))
                    QuantizedSignal(i) = QuantizationLevels(1);
                end 
            end
        end
    else % Mu-law
        if(mu == 0)
            QuantizedSignal = PeakQuantizationLevel*(abs(SampledSignal)/max(SampledSignal)).*sign(SampledSignal);
        else
            QuantizedSignal = PeakQuantizationLevel*(log(1+mu*(abs(SampledSignal)/max(SampledSignal)))/log(1+mu)).*sign(SampledSignal);
        end
    end
end