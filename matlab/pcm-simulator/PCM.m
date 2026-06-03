%% Clear command window, and last workspace; close all opened figures
clc;
close all;
clear;

% Resolve paths relative to this script so the project can run from any folder.
projectRoot = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(projectRoot, 'Functions')));
originalFolder = pwd;
cleanupObj = onCleanup(@() cd(originalFolder));
cd(projectRoot);
%% Taking input from user using GUI:
uiwait(msgbox('Pulse Code Modulation Simulator Started!'));
SignalType = menu("Choose a signal",["Sinewave signal" "Sound signal"]);
if(SignalType == 0)
    return;
end
if (SignalType == 1)
    prompt = {'Enter the frequency of the message:'; 'Enter the amplitude of the message:'};
    dlgtitle = 'Sinewave signal inputs';
    dims = [1 50];
    definput = {'10', '5'};
    userInputs = str2double(inputdlg(prompt, dlgtitle, dims, definput));
    if(size(userInputs,1) == 0)
        return;
    end
    MessageFrequency = userInputs(1);
    Amplitude = userInputs(2);
    while (MessageFrequency <= 0 || MessageFrequency > 5000)
        if (MessageFrequency <= 0)
            uiwait(msgbox('Frequency should be greater than 0! Try again.','Invalid input','error'));
            MessageFrequency = str2double(inputdlg('Enter the frequency of the message:', 'Message Frequency input', dims, {'10'}));
        else
            uiwait(msgbox('Enter a smaller frequency.','Invalid input','error'));
            MessageFrequency = str2double(inputdlg('Enter the frequency of the message:', 'Message Frequency input', dims, {'10'}));
        end
    end
    while(Amplitude <= 0 || Amplitude > 1000)
        if (Amplitude <= 0)
            uiwait(msgbox('Amplitude should be greater than 0! Try again.','Invalid input','error'));
            Amplitude = str2double(inputdlg('Enter the amplitude of the message:', 'Amplitude input', dims, {'5'}));
        else
            uiwait(msgbox('Enter a smaller amplitude.','Invalid input','error'));
            Amplitude = str2double(inputdlg('Enter a smaller amplitude.', 'Amplitude input', dims, {'5'}));
        end
    end
else
    SoundName = 'Test.wav';
    Folder = projectRoot;
    SoundPath = fullfile(Folder, SoundName);
    if (isfile(SoundPath))
        uiwait(msgbox('The sound signal will be used is "Test.wav" which is placed in this project''s folder','Sound','none'));
    else
        uiwait(msgbox({'There is no "Test.wav" file in this project''s folder.';'You have to choose a sound.'},'Sound not found','error'));
        [SoundName, Folder] = uigetfile({'*.wav' 'Sound'},'Select a sound file less than 1 mb','');
        SoundPath = fullfile(Folder, SoundName);
    end
    if (size(SoundName,2) == 1 || size(Folder,2) == 1)
        uiwait(msgbox('You didn''t choose a sound file.','Sound not chosen','error'));
        return;
    else
        SoundSize = dir(SoundPath).bytes;
        while(SoundSize > 2^20)
            uiwait(msgbox({'Sound size exceeds 1 MB.';'Choose another one!'},'Sound size','error'));
            [SoundName, Folder] = uigetfile({'*.wav' 'Sound'},'Select a sound file less than 1 mb','');
            SoundPath = fullfile(Folder, SoundName);
            if (size(SoundName,2) == 1 || size(Folder,2) == 1)
                uiwait(msgbox('You didn''t choose a sound file.','Sound not chosen','error'));
                return;
            end
            SoundSize = dir(SoundPath).bytes;
        end
        [SampledData, SampleRate] = audioread(SoundPath);
        SoundDuration = size(SampledData,1)/SampleRate;
        uiwait(msgbox({'The chosen sound has the following information:';...
            sprintf('* Sound Name: %s',SoundName);...
            sprintf('* Sound Path: %s',SoundPath);...
            sprintf('* Sound Size: %.0f KB',SoundSize/2^10); ...
            sprintf('* Sound Duration: %.2f seconds',SoundDuration)},...
            'Sound Info','none'));
        PlaySound = menu("Do you want to play the sound?",["Yes" "No"]);
        if(PlaySound == 1)
            playblocking(audioplayer(SampledData, SampleRate));
        end
    end
end
if (SignalType == 2)
    Amplitude = max(max(SampledData));
end
prompt = {'Enter Sampling Frequency:';'Enter the number of levels:';'Enter peak quantization level:'};
dlgtitle = 'PCM inputs';
dims = [1 50];
definput = {'40' '8' num2str(floor(Amplitude*100)/100)};
userInputs = str2double(inputdlg(prompt, dlgtitle, dims, definput));
if(size(userInputs,1) == 0)
    return;
end
SamplingFreq = userInputs(1);
while (SamplingFreq <= 0 || (SamplingFreq > 667)&&(SignalType == 1) || (SamplingFreq > 32000)&&(SignalType == 2))
    if (SamplingFreq <= 0)
        uiwait(msgbox('Sampling Frequency should be greater than zero! Try again.','Invalid input','error'));
        SamplingFreq = str2double(inputdlg('Enter Sampling Frequency:', 'Sampling Frequency input', dims, {'40'}));
    else
        uiwait(msgbox('Enter a smaller sampling frequency','Invalid input','error'));
        SamplingFreq = str2double(inputdlg('Enter Sampling Frequency:', 'Sampling Frequency input', dims, {'40'}));
    end
end
% Input for quantizing
NumOfLevels = userInputs(2);
while (NumOfLevels <= 0 || NumOfLevels > 2^13)
    if (NumOfLevels <= 0)
        uiwait(msgbox('Number of levels should be greater than 0! Try again.','Invalid input','error'));
        NumOfLevels = str2double(inputdlg('Enter the number of levels:', 'Number of levels input', dims, {'8'}));
    else
        uiwait(msgbox('Enter a smaller number of levels.','Invalid input','error'));
        NumOfLevels = str2double(inputdlg('Enter the number of levels:', 'Number of levels input', dims, {'8'}));
    end
end
PeakQuantizationLevel = userInputs(3);
while (PeakQuantizationLevel <= 0 || PeakQuantizationLevel > Amplitude)
    if (PeakQuantizationLevel <= 0)
        uiwait(msgbox('Peak quantization level should be greater than 0! Try again.','Invalid input','error'));
        PeakQuantizationLevel = str2double(inputdlg('Enter peak quantization level:', 'Peak quantization level input', dims, {num2str(floor(Amplitude*100)/100)}));
    else
        userChoice = menu({['It is recommended that the peak quantization level does not'...
         ' exceed the amplitude of the signal.'];['If you want to change it, choose "Yes"'...
         ' else, choose "No"']},["Yes" "No"]);
        if (userChoice == 1)
            PeakQuantizationLevel = str2double(inputdlg('Enter peak quantization level:', 'Peak quantization level input', dims, {num2str(floor(Amplitude*100)/100)}));
        else
            break;
        end
    end
end
QuantizerType = menu("Choose a quatizer type",["Uniform mid-rise quantizer" "Non-uniform mu-Law quantizer"]);
if (QuantizerType == 0)
    return;
end
if(QuantizerType == 2)
    prompt = {'Enter value of mu:'};
    dlgtitle = 'mu input';
    dims = [1 50];
    definput = {'255'};
    userInputs = str2double(inputdlg(prompt, dlgtitle, dims, definput));
    if(size(userInputs,1) == 0)
        return;
    end
    mu = userInputs(1);
    while (mu < 0)
        uiwait(msgbox('mu should have a value greater than or equal to zero! Try again.','Invalid input','error'));
        mu = str2double(inputdlg('Enter value of mu:', 'mu input', dims, {'255'}));
    end
end
% Input for encoder
EncoderType = menu("Choose an encoder type:",["Unipolar NRZ signaling" "Polar NRZ signaling" "Manchester signaling"]);
if (EncoderType == 0)
    return;
end
% Input for decoder
if (SignalType == 2)
    ListeningOption = menu("Do you want to listen to the audio after decoding?",["Yes" "No"]);
    if (ListeningOption == 0)
        ListeningOption = 2;
    end
end
%% For the sake of time, initialize the variables in this section
% The Functions folder is added at startup using projectRoot.
NumOfLevels = 2^ceil(log(NumOfLevels)/log(2)); % Approximating the
% number of levels to the nearest next power of 2.
tic
%% Instantiation of objects
if (SignalType == 1)
    Duration = 1;
    NumOfTimestamps = 1000;
    Signal = SinSignal(Duration, NumOfTimestamps, Amplitude, MessageFrequency);
else
    Signal = SoundSignal(SampledData, SampleRate);
end
%% Sampling
SampledSignal = Signal.Sampling(SamplingFreq);
%% Quantizing
if (QuantizerType == 1)
    QuantizedSignal = Signal.Quantizing(SampledSignal, NumOfLevels, PeakQuantizationLevel);
else
    QuantizedSignal = Signal.Quantizing(SampledSignal, NumOfLevels, PeakQuantizationLevel, mu);
end
%% Encoding
RequiredEncodedSignal = Signal.Encoding(QuantizedSignal, EncoderType);
%% Decoding
DecodedSignal = Signal.Decoding(RequiredEncodedSignal, EncoderType);
%% Reconstruction Filter
if(SignalType == 1)
    ReconstructedSignal = Signal.Reconstructing(DecodedSignal);
else
    ReconstructedSignal = Signal.Reconstructing(DecodedSignal, ListeningOption);
end
%%
fprintf("Total simulation time = %f seconds\n",toc);
Show = 1;
%% Setting Figure
if(Show == 1)
    figure('Name','Pulse Code Modulation Simulator', 'NumberTitle', 'off');
    set(gcf,'WindowState','Maximize');
    Figure = uitabgroup('Parent',gcf);
    CreateNewTab = uitab(Figure,'Title', 'Original Signal');
    axes('Parent',CreateNewTab);
    plot(Signal.t, Signal.OriginalSignal);
    title("Original Signal");
    xlabel("time (s)");
    ylabel("Amplitude (V)");
    grid on;
    
    CreateNewTab = uitab(Figure,'Title', 'Sampling');
    axes('Parent',CreateNewTab);
    subplot(2,1,1);
    plot(Signal.t, Signal.OriginalSignal);
    title("Original Signal");
    xlabel("time (s)");
    ylabel("Amplitude (V)");
    grid on;
    subplot(2,1,2);
    stem(SampledSignal);
    title("Sampled Signal");
    grid on;
    
    CreateNewTab = uitab(Figure,'Title', 'Quantizing');
    axes('Parent',CreateNewTab);
    subplot(3,1,1);
    plot(Signal.t, Signal.OriginalSignal);
    title("Original Signal");
    xlabel("time (s)");
    ylabel("Amplitude (V)");
    grid on;
    subplot(3,1,2);
    stem(SampledSignal);
    title("Sampled Signal");
    grid on;
    subplot(3,1,3);
    stairs(QuantizedSignal);
    title("Quantized Signal");
    grid on;
    
    CreateNewTab = uitab(Figure,'Title', 'Encoding');
    axes('Parent',CreateNewTab);
    subplot(4,1,1);
    plot(Signal.t, Signal.OriginalSignal);
    title("Original Signal");
    xlabel("time (s)");
    ylabel("Amplitude (V)");
    grid on;
    subplot(4,1,2);
    stem(SampledSignal);
    title("Sampled Signal");
    grid on;
    subplot(4,1,3);
    stairs(QuantizedSignal);
    title("Quantized Signal");
    grid on;
    subplot(4,1,4);
    if (EncoderType == 3)
        Denominator = 2;
    else
        Denominator = 1;
    end
    stairs(linspace(1,size(RequiredEncodedSignal,2)/Denominator,size(RequiredEncodedSignal,2)),RequiredEncodedSignal);
    title("Encoded Signal");
    if (EncoderType == 2)
        ylim([-1.2 1.2]);
    else
        ylim([-0.2 1.2]);
    end
    grid on;
    
    CreateNewTab = uitab(Figure,'Title', 'Decoding');
    axes('Parent',CreateNewTab);
    subplot(5,1,1);
    plot(Signal.t, Signal.OriginalSignal);
    xlabel("time (s)");
    ylabel("Amplitude (V)");
    grid on;
    title("Original Signal");
    subplot(5,1,2);
    stem(SampledSignal);
    grid on;
    title("Sampled Signal");
    subplot(5,1,3);
    stairs(QuantizedSignal);
    grid on;
    title("Quantized Signal");
    subplot(5,1,4);
    if (EncoderType == 3)
        Denominator = 2;
    else
        Denominator = 1;
    end
    stairs(linspace(1,size(RequiredEncodedSignal,2)/Denominator,size(RequiredEncodedSignal,2)),RequiredEncodedSignal);
    if (EncoderType == 2)
        ylim([-1.2 1.2]);
    else
        ylim([-0.2 1.2]);
    end
    grid on;
    title("Encoded Signal");
    subplot(5,1,5);
    stairs(DecodedSignal);
    title("Decoded Signal");
    
    CreateNewTab = uitab(Figure,'Title', 'Reconstruction');
    axes('Parent',CreateNewTab);
    subplot(6,1,1);
    plot(Signal.t, Signal.OriginalSignal);
    xlabel("time (s)");
    ylabel("Amplitude (V)");
    grid on;
    title("Original Signal");
    subplot(6,1,2);
    stem(SampledSignal);
    grid on;
    title("Sampled Signal");
    subplot(6,1,3);
    stairs(QuantizedSignal);
    title("Quantized Signal");
    grid on;
    subplot(6,1,4);
    if (EncoderType == 3)
        Denominator = 2;
    else
        Denominator = 1;
    end
    stairs(linspace(1,size(RequiredEncodedSignal,2)/Denominator,size(RequiredEncodedSignal,2)),RequiredEncodedSignal);
    if (EncoderType == 2)
        ylim([-1.2 1.2]);
    else
        ylim([-0.2 1.2]);
    end
    grid on;
    title("Encoded Signal");
    subplot(6,1,5);
    stairs(DecodedSignal);
    title("Decoded Signal");
    subplot(6,1,6);
    plot(ReconstructedSignal);
    title("Reconstructed Signal");
end