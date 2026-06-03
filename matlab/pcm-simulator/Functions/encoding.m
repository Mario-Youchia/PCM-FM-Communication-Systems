function RequiredEncodedSignal = encoding(NumOfLevels, QuantizedSignal, QuantizationLevels, HalfDistanceBetweenTwoLevels, EncoderType)
    EncodedSignal(1,1:log2(NumOfLevels)*size(QuantizedSignal,2)) = 0;
    CharOfbits = '';
    for i = 1:size(QuantizedSignal,2)
        for j = 1:size(QuantizationLevels,2)
            if (QuantizedSignal(i) >= HalfDistanceBetweenTwoLevels(j) && ...
                    QuantizedSignal(i)< HalfDistanceBetweenTwoLevels(j+1))
                CharOfbits = dec2bin(j-1,log2(NumOfLevels));
            end
        end
        for k = 1:log2(NumOfLevels)
            EncodedSignal(1,(i-1)*log2(NumOfLevels)+k) = [str2double(CharOfbits(1,k))];
        end
    end
    if (EncoderType == 1) % Unipolar NRZ signaling
        RequiredEncodedSignal = EncodedSignal;
    elseif (EncoderType == 2) % Polar NRZ signaling
        RequiredEncodedSignal = EncodedSignal;
        for i = 1:size(EncodedSignal,2)
            if (RequiredEncodedSignal(i) == 0)
                RequiredEncodedSignal(i) = -1;
            end
        end
    else % Manchester
        RequiredEncodedSignal = zeros(1,2*size(EncodedSignal,2));
        j=1;
        for i = 1:2:2*size(EncodedSignal,2)
            RequiredEncodedSignal(i) = EncodedSignal(j);
            if (EncodedSignal(j)== 0)
                RequiredEncodedSignal(i+1)= 1;
            else
                RequiredEncodedSignal(i+1)= 0;
            end
            j=j+1;
        end
    end
end