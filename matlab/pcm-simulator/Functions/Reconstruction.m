function ReconstructedSoundSignal = Reconstruction(DecodedSignal, QuantizationLevels, SampleRate, SampleDataSize, SamplingFreq, SoundDuration, ListeningOption)
    if (nargin == 6)
        ListeningOption = 0;
        SignalType = 2;
    elseif (nargin == 1 || nargin == 3 || nargin == 4 || nargin == 5)
        return;
    elseif (nargin == 2)
        SignalType = 1;
    else
        SignalType = 2;
    end
    ReconstructedSignal = zeros(1,size(DecodedSignal,2));
    % To reconstruct the original signal, we will use the DecodedSignal as
    % index for the QuantizationLevels, because it has values varies from 0 to
    % 7, i.e. 8 numbers, which is the same size as QuantizationLevels so it
    % will be convenient to use it as index but we will increase it by 1,
    % because MATLAB does not accept 0 index
    for i=1:size(DecodedSignal,2)
        j = DecodedSignal(i) + 1;
        ReconstructedSignal(i) = QuantizationLevels(j);
    end
    ReconstructedSoundSignal = ReconstructedSignal;
    if(SignalType == 2)
        j=1;
        ReconstructedSoundSignal = zeros(SampleDataSize,1);
        for i = unique(round(linspace(1,SampleDataSize,round(SamplingFreq*SoundDuration))))
            ReconstructedSoundSignal(i,1) = ReconstructedSignal(1,j);
            j=j+1;
        end
        if(ListeningOption == 1)
            playblocking(audioplayer(ReconstructedSoundSignal,SampleRate));
        end
        audiowrite("output.wav",ReconstructedSoundSignal,SampleRate);
    end
end