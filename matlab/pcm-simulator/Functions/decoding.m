function DecodedSignal = decoding(RequiredEncodedSignal, NumOfLevels, EncoderType)
    preDecodedSignal = zeros(1,size(RequiredEncodedSignal,2));
    if (EncoderType == 1) % Unipolar NRZ signaling
        preDecodedSignal = RequiredEncodedSignal;
    elseif (EncoderType == 2) % Polar NRZ signaling
        preDecodedSignal = RequiredEncodedSignal;
        for i = 1:size(preDecodedSignal,2)
            if (preDecodedSignal(i) == -1)
                preDecodedSignal(i) = 0;
            end
        end
    else % Manchester
        j=1;
        for i = 1:2:size(preDecodedSignal,2)
            preDecodedSignal(j) = RequiredEncodedSignal(i);
            j=j+1;
        end
        preDecodedSignal = preDecodedSignal(1:0.5*size(preDecodedSignal,2));
    end
    DecodedSignal = zeros(1,size(preDecodedSignal,2)/log2(NumOfLevels));
    for i = 1:size(preDecodedSignal,2)/log2(NumOfLevels)
        level = num2str(preDecodedSignal(1,(i-1)*log2(NumOfLevels)+1:i*log2(NumOfLevels)));
        DecodedSignal(1,i) = bin2dec(level(~isspace(level)));
    end
end