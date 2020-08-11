clc ;
clear;

%%This Code simply take your RTTTL note and the output a wav file corresponding to the note
%%you can also listen to the sound corresponding to this RTTTL note


%%Get The Input From User and perpare it to make processing on the notes.
%% these examples for rtttl note for testing
%Abdelazer:d=4, o=5, b=160:2d, 2f, 2a, d6, 8e6, 8f6, 8g6, 8f6, 8e6, 8d6, 2c#6, a6, 8d6, 8f6, 8a6, 8f6, d6, 2a6, g6, 8c6, 8e6, 8g6, 8e6, c6, 2a6, f6, 8b, 8d6, 8f6, 8d6, b, 2g6, e6, 8a, 8c#6, 8e6, 8c6, a, 2f6, 8e6, 8f6, 8e6, 8d6, c#6, f6, 8e6, 8f6, 8e6, 8d6, a, d6, 8c#6, 8d6, 8e6, 8d6, 2d6
%007:d=4, o=5, b=320:c, 8d, 8d, d, 2d, c, c, c, c, 8d#, 8d#, 2d#, d, d, d, c, 8d, 8d, d, 2d, c, c, c, c, 8d#, 8d#, d#, 2d#, d, c#, c, c6, 1b., g, f, 1g.
%Bolero:d=4, o=5, b=80:c6, 8c6, 16b, 16c6, 16d6, 16c6, 16b, 16a, 8c6, 16c6, 16a, c6, 8c6, 16b, 16c6, 16a, 16g, 16e, 16f, 2g, 16g, 16f, 16e, 16d, 16e, 16f, 16g, 16a, g, g, 16g, 16a, 16b, 16a, 16g, 16f, 16e, 16d, 16e, 16d, 8c, 8c, 16c, 16d, 8e, 8f, d, 2g
prompt = {'Enter Your RTTTL Composing Input:'};  %%Get from the user the standard format for RTTTL note
dlgtitle = 'Generic RTTTL Composer';             %%title of the Dialog box that will be shown to user
RTTTL = inputdlg(prompt,dlgtitle);               %%function that create Dialog box 
A=char(RTTTL);                 %%convert the input from cell array to char array to prepare it to split the fields of it
Z=strsplit( A , ':');          %%split the input to three fields(Song Name,Defaults,Notes)
Song_Name=Z{1};                %% store the first field song name
defaults=Z{2};                 %%perpare the scond field(defaults) to split it too
B=strsplit(defaults , ',');    %%split the second field to three sections(duration,Octave,beats_per_min)
dauration=B{1};                %% here is the format is'd=value'
Octave=B{2};                   %% here is the format is'o=value'
Beats_per_min=B{3};            %% here is the format is'b=value'
dd=num2cell(dauration) ;       %%sperate duartion to get value of d
oo=num2cell(Octave);           %%sperate octave to get value of o
bb=num2cell(Beats_per_min);    %%sperate beats_per_minute to get value of b

d=str2num(dd{3});   %%  here we get value of d
o=str2num(oo{4});   %%  here we get value of o

%%we need to get the value of b so we did some steps
h={};
   for k=4:numel(bb)
     h{k-3}=bb{k};
   end
   y=strjoin(h);
   V=erase(y,' ') 
   b=str2double(V);  %%  here we get value of b
   
notes=Z{3};   %% get the third field(notes)

C=strsplit(notes , ',');       %% split the notes to get the coressponding  freq of each



                  %% determine the Whole_note Duration

%%each quarter note worth beat then the duration for whole note=4*quarter

whole_dur=(60/b)*4;   %%caluclate the whole note duration from b(beats/minute)
Fs= 8192 ;            %% sampling rate
Ts=1/Fs ;
a =[];

%%processing on notes to get the duration and the coressponding freq

for i=1:numel(C)
    space=erase(C{i},' ')     %% remove space from note
    
%%check if the note has dot and if erase it and then Multiply duration by 1.5

    if(contains(space,'.'))
       newnote= erase(space,'.')
        dur=whole_dur*1.5;
    else
        newnote=space;
        dur=whole_dur;
    end
    
%%check the duration of each note
%%in this part after we check the duration and then remove it bfore calling
%%function as the function get the freq of note without its duration

if(contains(newnote,'2'))
         nduartion=[0:Ts:dur/2];
    duartion=round(nduartion,5) ;
    f=note2freq(erase(newnote,'2'));
elseif(contains(newnote,'8'))
        nduartion=[0:Ts:dur/8];
    duartion=round(nduartion,5) ;
     f=note2freq(erase(newnote,'8'));
elseif(contains(newnote,'16'))
     nduartion=[0:Ts:dur/16];
    duartion=round(nduartion,5) ;
    f=note2freq(erase(newnote,'16'));
elseif(contains(newnote,'32'))
        nduartion=[0:Ts:dur/32];
    duartion=round(nduartion,5) ;
    f=note2freq(erase(newnote,'32'));
    elseif(contains(newnote,'1'))
        nduartion=[0:Ts:dur];
    duartion=round(nduartion,5) ;
    f=note2freq(erase(newnote,'1'));
else
    nduartion=[0:Ts:dur/4];
    duartion=round(nduartion,5) ;
 f=note2freq(newnote);
end
    
a = [a sin(2*pi*f(1)*duartion)];       %%create the melody by the variables defined above
end
sound(a)           %%show the ringtone
filename =strcat(Song_Name,'.wav');   %%name the file with name that user has entered it
audiowrite(filename,a,Fs)        %%get the coressponding wav file for the ringtone 


           %%generation function that get coressponding freq of each note
                     
                     
function Q=note2freq(N)
  
note = {'p' 'c4' 'c#4' 'd4' 'd#4' 'e4' 'f4' 'f#4' 'g4' 'g#4' 'a4' 'a#4' 'b4' 'c' 'c#' 'd' 'd#' 'e' 'f' 'f#' 'g' 'g#' 'a' 'a#' 'b' 'c6' 'c#6' 'd6' 'd#6' 'e6' 'f6' 'f#6' 'g6' 'g#6' 'a6' 'b6' 'c7' 'c#7' 'd7' 'd#7' 'e7' 'f7' 'f#7' 'g7' 'g#7' 'a7' 'a#7' 'b7'} ; %%musical notes
    %%look up table of frequencies
frequency=[1,261.625565300599,277.182630976872,293.664767917408,311.126983722081,329.627556912870,349.228231433004,369.994422711634,391.995435981749,415.304697579945,440,466.163761518090,493.883301256124,523.251130601197,554.365261953744,587.329535834815,622.253967444162,659.255113825740,698.456462866008,739.988845423269,783.990871963499,830.609395159890,880,932.327523036180,987.766602512248,1046.50226120239,1108.73052390749,1174.65907166963,1244.50793488832,1318.51022765148,1396.91292573202,1479.97769084654,1567.98174392700,1661.21879031978,1760,1864.65504607236,1975.53320502450,2093.00452240479,2217.46104781498,2349.31814333926,2489.01586977665,2637.02045530296,2793.82585146403,2959.95538169308,3135.96348785399,3322.43758063956,3520,3729.31009214472,3951.06641004899] ;

  Q=frequency(strcmpi(note,N));      %%get the freq of note
end


