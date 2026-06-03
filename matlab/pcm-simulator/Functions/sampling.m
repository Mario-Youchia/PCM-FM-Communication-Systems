function SampledSignal = sampling(thisSinSignal, SamplingFreq)
    if(SamplingFreq*thisSinSignal.Duration > size(thisSinSignal.OriginalSignal,2))
        SampledSignal = zeros(1,size(thisSinSignal.OriginalSignal,2));
    else
        SampledSignal = zeros(1,round(SamplingFreq*thisSinSignal.Duration));
    end
    j=1;
    for i = unique(round(linspace(1,size(thisSinSignal.OriginalSignal,2),round(SamplingFreq*thisSinSignal.Duration))))
        SampledSignal(j) = thisSinSignal.OriginalSignal(i);
        j=j+1;
    end
end