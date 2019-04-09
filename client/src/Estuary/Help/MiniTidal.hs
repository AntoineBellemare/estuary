{-# LANGUAGE OverloadedStrings #-}
module Estuary.Help.MiniTidal where

import Reflex
import Reflex.Dom
import Data.Text
import GHCJS.DOM.EventM
import Estuary.Widgets.Generic

--render multiple sub-help files
miniTidalHelpFile :: MonadWidget t m => m ()
miniTidalHelpFile = divClass "languageHelp" $ do
    about
    functionRef "silence"
    functionRef "stack"
    functionRef "fastcat"
    functionRef "slowcat"
    functionRef "cat"
    -- functionRef "listToPat"
    functionRef "fit"
    functionRef "choose"
    functionRef "randcat"
    -- functionRef "cycleChoose"
    functionRef "run"
    functionRef "scan"
    functionRef "irand"
    -- functionRef "toScale"'
    -- functionRef "toScale"
    -- functionRef "randStruct"
    functionRef "coarse"
    functionRef "cut"
    functionRef "n"
    functionRef "up"
    functionRef "speed"
    functionRef "pan"
    functionRef "shape"
    functionRef "gain"
    functionRef "accelerate"
    functionRef "bandf"
    functionRef "bandq"
    functionRef "begin"
    functionRef "crush"
    functionRef "cutoff"
    functionRef "delayfeedback"
    functionRef "delaytime"
    functionRef "delay"
    functionRef "end"
    functionRef "hcutoff"
    functionRef "hresonance"
    functionRef "resonance"
    functionRef "shape"
    -- functionRef "loop"
    functionRef "s"
    functionRef "sound"
    functionRef "vowel"
    -- functionRef "unit"
    functionRef "chop"
    functionRef "striate"
    functionRef "striate'"
    functionRef "stut"
    functionRef "jux"
    functionRef "brak"
    functionRef "rev"
    functionRef "palindrome"
    -- functionRef "stretch"
    -- functionRef "loopFirst"
    -- functionRef "breakUp"
    functionRef "degrade"
    -- functionRef "fast"
    -- functionRef "fast'"
    functionRef "density"
    functionRef "slow"
    functionRef "iter"
    functionRef "iter'"
    functionRef "trunc"
    -- functionRef "swingBy"
    functionRef "append"
    -- functionRef "append'"
    functionRef "every"
    -- functionRef "every'"
    functionRef "whenmod"
    functionRef "overlay"
    -- functionRef "fastGap"
    -- functionRef "densityGap"
    functionRef "sparsity"
    -- functionRef "slow'"
    -- functionRef "rotL"
    -- functionRef "rotR"
    -- functionRef "playFor"
    -- functionRef "foldEvery"
    -- functionRef "superimpose"
    -- functionRef "linger"
    -- functionRef "zoom"
    -- functionRef "compress"
    -- functionRef "sliceArc"
    -- functionRef "within"
    -- functionRef "within'"
    -- functionRef "revArc"
    -- functionRef "e"
    -- functionRef "e'"
    -- functionRef "einv"
    -- functionRef "distrib"
    -- functionRef "efull"
    functionRef "wedge"
    -- functionRef "prr"
    -- functionRef "preplace"
    -- functionRef "prep"
    -- functionRef "preplace1"
    -- functionRef "protate"
    -- functionRef "prot"
    -- functionRef "prot1"
    -- functionRef "discretise"
    -- functionRef "discretise'"
    functionRef "struct"
    -- functionRef "substruct"
    -- functionRef "compressTo"
    -- functionRef "substruct'"
    -- functionRef "slowstripe"
    functionRef "fit'"
    functionRef "chunk"
    -- functionRef "time
    functionRef "swing"
    functionRef "degradeBy"
    -- functionRef "unDegradeBy"
    -- functionRef "degradeOverBy"
    functionRef "sometimesBy"
    functionRef "sometimes"
    functionRef "often"
    functionRef "rarely"
    functionRef "almostNever"
    functionRef "almostAlways"
    functionRef "never"
    functionRef "always"
    -- functionRef "someCyclesBy" --TODO bug
    -- functionRef "somecycles" --TODO fix bug
    functionRef "repeatCycles"
    -- functionRef "spaceOut"
    -- functionRef "fill"
    functionRef "ply"
    functionRef "shuffle"
    functionRef "scramble"
    functionRef "rand"
    -- functionRef "sinewave1"
    -- functionRef "sinewave"
    -- functionRef "sine1"
    functionRef "sine"
    -- functionRef "sawwave1"
    -- functionRef "sawwave"
    -- functionRef "saw1"
    functionRef "saw"
    -- functionRef "triwave1"
    -- functionRef "triwave"
    -- functionRef "tri1"
    functionRef "tri"
    -- functionRef "squarewave1"
    -- functionRef "square1"
    functionRef "square"
    -- functionRef "squarewave"
    functionRef "cosine"
    -- functionRef "\#"
    -- functionRef "|=|"
    -- functionRef "|+|"
    -- functionRef "|-|"
    -- functionRef "|*|"
    -- functionRef "|/|"
    -- functionRef "\+"
    -- functionRef "\-"
    -- functionRef "\*"
    return ()

-- about
about :: MonadWidget t m => m ()
about = do
  divClass "about foreground-color small-font" $ text  "MiniTidal reference"
  divClass "about foreground-color small-font" $ text  "A live coding langugae that allows you to make musical patterns with text, describing sequences and ways of transforming and combining them, exploring complex interactions between simple parts."

exampleText :: Text -> Text

exampleText "silence" = "silence"
exampleText "stack" = "stack [sound \"bd bd*2\", sound \"hh*2 [sn cp] cp future*4\", sound \"arpy\" +| n \"0 .. 15\"]"
exampleText "fastcat" = "fastcat [sound \"bd*2 sn\", sound \"arpy jvbass*2\"]"
exampleText "slowcat" = "fastcat [sound \"bd*2 sn\", sound \"arpy jvbass*2\"]"
exampleText "cat" = "cat [sound \"bd*2 sn\", sound \"arpy jvbass*2\"]"
-- exampleText "listToPat" =
exampleText "fit" = "sound (fit 3 [\"bd\", \"sn\", \"arpy\", \"arpy:1\", \"casio\"] \"0 [~ 1] 2 1\")"
exampleText "choose" = "sound \"drum ~ drum drum\" # n (choose [0,2,3])"
exampleText "randcat" = "randcat [sound \"bd*2 sn\", sound \"jvbass*3\", sound \"drum*2\", sound \"ht mt\"]"
-- exampleText "cycleChoose" =
exampleText "run" = "n (run \"<4 8 4 6>\") # sound \"amencutup\""
exampleText "scan" = "n (scan 8) # sound \"amencutup\""
exampleText "irand" = "sound \"amencutup*8\" # n (irand 8)"
-- exampleText "toScale"' =
-- exampleText "toScale"
-- exampleText "randStruct"
exampleText "coarse" = "s \"bd*2 arpy*2 cp hh*3\" # coarse \"<4 8 16 24>\""
exampleText "cut" = "sound \"~ [~ [ho:2 hc/2]]\" # cut \"1\""
exampleText "n" = "s \"drum*4\" # n \"0 1 2 3\""
exampleText "up" = "s \"arpy*4\" # up \"0 2 4 6\""
exampleText "speed" = "s \"numbers\" # speed \"0.5\""
exampleText "pan" = "sound \"bd feel odx drum\" # pan \"0 1 0.25 0.75\""
exampleText "shape" = "sound \"feel*4\" # shape \"0 0.2 0.4\""
exampleText "gain" = "sound \"hh*4\" # gain \"1 0.5 0.75 0.3\""
exampleText "accelerate" = "sound \"jvbass*4\" # accelerate \"<0 1 -1 0.25 -0.5 2.1 -3>\""
exampleText "bandf" = "s \"drum*8\" # bandf \"100 1000 2000\""
exampleText "bandq" = "s \"[drum cp]*2 [drum:1 hh*2]\" # bandf \"100 1000 2000\" # bandq \"<0.5 1 2>\""
exampleText "begin" = "s \"rave/2\" # begin \"<0 0.25 0.5>\""
exampleText "crush" = "s \"[bd cp] hh drum arpy*2\" # crush \"<16 4 2>\""
exampleText "cutoff" = "s \"drum*8\" # cutoff \"100 1000 2000\""
exampleText "delayfeedback" = "s \"drum jvbass [cp arpy] jvbass:1\" # delayfeedback \"[0.1 0.5 0.9]/6\" # delay \"0.5\""
exampleText "delaytime" = "s \"drum*4 [drum:1 drum:2/2]\" # delaytime \"<0 0.01 0.1 0.2 0.5>\" # delay \"0.5\""
exampleText "delay" = "s \"[drum cp]*2 jvbass\" # delay \"[0 0.5]/2\" # orbit 1"
exampleText "end" = "s \"rave/2\" # end \"<0 0.25 0.5>\""
exampleText "hcutoff" = "s \"drum*8\" # hcutoff \"100 1000 2000 5000\""
exampleText "hresonance" = "s \"drum*8\" # hpf \"1000\" # hresonance\"0 0.2 0.4 0.6\""
exampleText "resonance" = "s \"drum*8\" # cutoff \"1000\" # resonance \"0 0.2 0.4 0.6\""
exampleText "shape" = "sound \"feel*4\" # shape \"0 0.2 0.4\""
-- exampleText "loop" =
exampleText "s" = "s \"arpy\""
exampleText "sound" = "sound \"arpy\""
exampleText "vowel" = "s \"jvbass*4\" # vowel \"[a e ~ i o u]/8\""
-- exampleText "unit" =
exampleText "chop" = "chop 16 $ sound \"arpy ~ feel*2 newnotes\""
exampleText "striate" = "slow 4 $ striate 3 $ sound \"numbers:0 numbers:1 numbers:2 numbers:3\""
exampleText "striate'" = "slow 32 $ striate' 32 (1/16) $ sound \"bev\""
exampleText "stut" = "stut 4 0.5 0.2 $ sound \"bd sn\""
exampleText "jux" = "slow 32 $ jux (rev) $ striate' 32 (1/16) $ sound \"bev\""
exampleText "brak" = "brak $ sound \"[feel feel:3, hc:3 hc:2 hc:4 ho:1]\""
exampleText "rev" = "every 3 rev $ n \"0 1 [~ 2] 3\" # sound \"arpy\""
exampleText "palindrome" = "palindrome $ sound \"arpy:0 arpy:1 arpy:2 arpy:3\""
-- exampleText "stretch" =
-- exampleText "loopFirst"
-- exampleText "breakUp"
exampleText "degrade" = "slow 2 $ degrade $ sound \"[[[feel:5*8,feel*3] feel:3*8], feel*4]\""
exampleText "fast" = "sound (fast 2 \"bd sn kurt\") # fast 3 (vowel \"a e o\")"
-- exampleText "fast'" =
exampleText "density" =  "sound (density 2 \"bd sn kurt\")"
exampleText "slow" = "sound (slow 2 \"bd sn kurt\") # slow 3 (vowel \"a e o\")"
exampleText "iter" = "iter 4 $ sound \"bd hh sn cp\""
exampleText "iter'" = " iter' 4 $ sound \"bd hh sn cp\""
exampleText "trunc" = "trunc 0.75 $ sound \"bd sn*2 cp hh*4 arpy bd*2 cp bd*2\""
-- exampleText "swingBy" =
exampleText "append" = "append (sound \"bd*2 sn\") (sound \"arpy jvbass*2\")"
-- exampleText "append'" =
exampleText "every" = "every 3 rev $ n \"0 1 [~ 2] 3\" # sound \"arpy\""
-- exampleText "every'" =
exampleText "whenmod" = "whenmod 8 4 (fast 2) (sound \"bd sn kurt\")"
exampleText "overlay" = "sound (overlay \"bd sn:2\" \"cp*3\")"
-- exampleText "fastGap" =
-- exampleText "densityGap"
exampleText "sparsity" = " sound (sparsity 2 \"bd sn kurt\")"
-- exampleText "slow'" = "sound (slow 2 \"bd sn kurt\") # slow 3 (vowel \"a e o\")"
-- exampleText "rotL" =
-- exampleText "rotR"
-- exampleText "playFor"
exampleText "foldEvery" = "foldEvery [3, 4, 5] (fast 2) $ sound \"bd sn kurt\""
exampleText "superimpose" = "superimpose (fast 2) $ sound \"bd sn [cp ht] hh\""
exampleText "linger" = "linger 0.25 $ n \"0 2 [3 4] 2\" # sound \"arpy\""
exampleText "zoom" = "zoom (0.25, 0.75) $ sound \"bd*2 hh*3 [sn bd]*2 drum\""
-- exampleText "compress" =
-- exampleText "sliceArc"
exampleText "within" = "within (0, 0.5) (fast 2) $ sound \"bd*2 sn lt mt hh hh hh hh\""
-- exampleText "within'" =
-- exampleText "revArc"
-- exampleText "e"
-- exampleText "e'"
-- exampleText "einv"
-- exampleText "distrib"
-- exampleText "efull"
exampleText "wedge" = "wedge (1/4) (sound \"bd*2 arpy*3 cp sn*2\") (sound \"odx [feel future]*2 hh hh\")"
-- exampleText "prr" =
-- exampleText "preplace"
-- exampleText "prep"
-- exampleText "preplace1"
-- exampleText "protate"
-- exampleText "prot"
-- exampleText "prot1"
-- exampleText "discretise"
-- exampleText "discretise'"
exampleText "struct" = "struct (\"t ~ t*2 ~\") $ sound \"cp\""
-- exampleText "substruct" =
-- exampleText "compressTo"
-- exampleText "substruct'"
-- exampleText "slowstripe"
exampleText "fit'" = "sound (fit' 1 2 \"0 1\" \"1 0\" \"bd sn\")"
exampleText "chunk" = "chunk 4 (# speed 2) $ sound \"bd hh sn cp\""
-- exampleText "timeLoop"
exampleText "swing" = "swing (1/3) 4 $ sound \"hh*8\""
exampleText "degradeBy" = "degradeBy 0.2 $ sound \"tink*16\""
-- exampleText "unDegradeBy" =
-- exampleText "degradeOverBy"
exampleText "sometimesBy" = "sometimesBy 0.93 (# speed 2) $ n \"0 1 [~ 2] 3\" # sound \"arpy\""
exampleText "sometimes"  = "sometimes (# crush 2) $ n \"0 1 [~ 2] 3\" # sound \"arpy\""
exampleText "often" = "often (# crush 2) $ n \"0 1 [~ 2] 3\" # sound \"arpy\""
exampleText "rarely" = "rarely (# crush 2) $ n \"0 1 [~ 2] 3\" # sound \"arpy\""
exampleText "almostNever" = "almostNever (# crush 2) $ n \"0 1 [~ 2] 3\" # sound \"arpy\""
exampleText "almostAlways" = "almostAlways (# crush 2) $ n \"0 1 [~ 2] 3\" # sound \"arpy\""
exampleText "never" = "never (# crush 2) $ n \"0 1 [~ 2] 3\" # sound \"arpy\""
exampleText "always" = "always (# crush 2) $ n \"0 1 [~ 2] 3\" # sound \"arpy\""
exampleText "someCyclesBy" = "someCyclesBy 0.93 (# speed 2) $ n \"0 1 [~ 2] 3\" # sound \"arpy\""
exampleText "somecycles" = "someCycles (# crush 2) $ n \"0 1 [~ 2] 3\" # sound \"arpy\""
exampleText "repeatCycles" = "repeatCycles 3 $ sound \"arpy(5,8)\" # n (irand 8)"
-- exampleText "spaceOut"
-- exampleText "fill"
exampleText "ply" = "ply 3 $ s \"bd ~ sn cp\""
exampleText "shuffle" = "sound $ shuffle 3 \"bd sn hh\""
exampleText "scramble" = "sound $ scramble 3 \"bd sn hh\""
exampleText "rand" = "sound \"arpy*4\" # speed (rand + 0.5)"
-- exampleText "sinewave1" =
-- exampleText "sinewave"
-- exampleText "sine1"
exampleText "sine" = "sound \"bd*8\" # pan sine"
-- exampleText "sawwave1"
-- exampleText "sawwave"
-- exampleText "saw1"
exampleText "saw" = "sound \"bd*8\" # pan (slow 2 saw)"
-- exampleText "triwave"
-- exampleText "triwave1"
-- exampleText "tri1"
exampleText "tri" = "sound \"bd*16\" # speed (slow 2 $ range 0.5 2 tri)"
-- exampleText "squarewave1"
-- exampleText "square1"
exampleText "square" = "sound \"bd*8\" # pan (cat [square, sine])"
-- exampleText "squarewave"
exampleText "cosine" = "sound \"bd*8\" # pan cosine # speed (sine + 0.5)"
-- exampleText "\#"
-- exampleText "|=|"
-- exampleText "|+|"
-- exampleText "|-|"
-- exampleText "|*|"
-- exampleText "|/|"
-- exampleText "\+"
-- exampleText "\-"
-- exampleText "\*"

referenceText :: Text -> Text

referenceText "silence" = "is the empty pattern, it contains nothing, nada. It's still useful, though!"
referenceText "stack" = "takes a list of patterns and combines them into a new pattern by layering them up - effectively playing all of the patterns in the list simultaneously."
referenceText "fastcat" = "works like cat above, but squashes all the patterns to fit a single cycle. "
referenceText "slowcat" = "concatenates a list of patterns into a new pattern; each pattern in the list will maintain its original duration."
referenceText "cat" = "also known as slowcat, to match with fastcat defined below) concatenates a list of patterns into a new pattern; each pattern in the list will maintain its original duration."
-- referenceText "listToPat"
referenceText "fit" = "takes a pattern of integer numbers, which are used to select values from the given list. What makes this a bit strange is that only a given number of values are selected each cycle."
referenceText "choose" = "emits a stream of randomly choosen values from the given list, as a continuous pattern."
referenceText "randcat" = "is similar to cat, but rather than playing the given patterns in order, it picks them at random."
-- referenceText "cycleChoose"
referenceText "run" = "generates a pattern representing a cycle of numbers from 0 to n-1 inclusive. Notably used to ‘run’ through a folder of samples in order."
referenceText "scan" = "is similar to run, but starts at 1 for the first cycle, adding an additional number each cycle until it reaches n."
referenceText "irand" = " is similar to rand, but generates a continuous oscillator of (pseudo-)random integers between 0 to n-1 inclusive. Notably used to pick random samples from a folder."
-- referenceText "toScale"'
-- referenceText "toScale"
-- referenceText "randStruct"
referenceText "coarse" = "turns a number pattern into a control pattern that lowers the sample rate of a sample. i.e. 1 for original 2 for half, 3 for a third and so on."
referenceText "cut" = "will stop a playing sample as soon as another sample with the same cutgroup is played."
referenceText "n" = "turns a number pattern into a control pattern that changes the sample being played in the specified sound folder on disk. The default value is 0, which plays the first sample in the sound folder. A value of 1 plays the next sample in the folder, a value of 2 plays the next, and so on."
referenceText "up" = ""
referenceText "speed" = " turns a number pattern into a control pattern that sets the playback speed of a sample where 1 means normal speed. Can be used as a cheap way of changing pitch for samples. Negative numbers will cause the sample to be played backwards."
referenceText "pan" = " turns a number pattern (ranging from 0 to 1) into a control pattern that specifies the audio channel. In a 2-channel setup, a value of 0 pans the audio hard left and a value of 1 pans the audio hard right. The default value is 0.5, which produces full volume on both channels."
referenceText "shape" = "produces wave shaping distortion, a pattern of numbers from 0 for no distortion up to 1 for loads of distortion. It can get very loud if you reach 1 - be careful!"
referenceText "gain" = "turns a number pattern into a control pattern that specifies volume. Values less than 1 make the sound quieter. Values greater than 1 make the sound louder."
referenceText "accelerate" = "turns a number pattern into a control pattern that speeds up (or slows down) samples while they play."
referenceText "bandf" = "turns a number pattern into a control pattern that sets the center frequency of a band pass filter. In SuperDirt, this is in Hz (try a range between 0 and 10000). In classic dirt, it is from 0 to 1."
referenceText "bandq" = "turns a number pattern into a control pattern that sets the q-factor of the band-pass filter. Higher values (larger than 1) narrow the band-pass. Has the shorthand bpq."
referenceText "begin" = "takes a pattern of numbers from 0 to 1. It skips the beginning of each sample"
referenceText "crush" = "turns a number pattern into a control pattern that creates a bit-crushing effect."
referenceText "cutoff" = "turns a number pattern into a control pattern that sets the cutoff frequency of a low pass filter. In SuperDirt, this is in Hz (try a range between 0 and 10000). In classic dirt, it is from 0 to 1."
referenceText "delayfeedback" = " turns a number pattern into a control pattern that changes the feedback level of the delay effect. The delay function is required in order for the delayfeedback function to have any effect."
referenceText "delaytime" = " turns a number pattern into a control pattern that changes the length of the delay effect. The delay function is required in order for delaytime to have any effect."
referenceText "delay" = "turns a number pattern into a control pattern that changes the level of the initial delay signal. A value of 1 means the first echo will be as loud as the original sound."
referenceText "end" = "takes a pattern of numbers from 0 to 1. It controls the end point of each sample."
referenceText "hcutoff" = "turns a number pattern into a control pattern that sets the cutoff frequency of a high pass filter. In SuperDirt, this is in Hz (try a range between 0 and 10000). In classic dirt, it is from 0 to 1."
referenceText "hresonance" = "turns a number pattern into a control pattern that sets the resonance of a high pass filter. Values range from 0 to 1."
referenceText "resonance" = "turns a number pattern into a control pattern that sets the resonance of a low pass filter. Values range from 0 to 1."
referenceText "shape" = " produces wave shaping distortion, a pattern of numbers from 0 for no distortion up to 1 for loads of distortion. It can get very loud if you reach 1 - be careful!"
-- referenceText "loop"
referenceText "s" = "tells us we’re making a pattern of sound samples"
referenceText "sound" = "tells us we’re making a pattern of sound samples"
referenceText "vowel"= "turns a Text pattern into a control pattern that creates a formant filter to produce vowel sounds on samples. Use values a, e, i, o, and u to add the effect."
-- referenceText "unit"
referenceText "chop" = "cuts each sample into the given number of parts, allowing you to explore a technique known as 'granular synthesis'. It turns a pattern of samples into a pattern of parts of samples."
referenceText "striate" = "is a kind of granulator, cutting samples into bits in a similar to chop, but the resulting bits are organised differently. "
referenceText "striate'" = " is a variant of striate. with an extra parameter, which specifies the length of each part."
referenceText "stut" = " applies a type of delay to a pattern. It has three parameters, which could be called depth, feedback and time. Depth is an integer and the others floating point."
referenceText "jux" = "creates strange stereo effects, by applying a function to a pattern, but only in the right-hand channel."
referenceText "brak" = "makes a pattern sound a bit like a breakbeat. It does this by every other cycle, squashing the pattern to fit half a cycle, and offsetting it by a quarter of a cycle."
referenceText "rev" = "returns a 'reversed' version of the given pattern."
referenceText "palindrome" = " applies rev to a pattern every other cycle, so that the pattern alternates between forwards and backwards."
-- referenceText "stretch"
-- referenceText "loopFirst"
-- referenceText "breakUp"
referenceText "degrade" = "randomly removes events from a pattern, 50% of the time."
-- referenceText "fast"
-- referenceText "fast'" =
referenceText "density" = "speeds up a pattern."
referenceText "slow" = "lows down a pattern. "
referenceText "iter" = "divides a pattern into a given number of subdivisions, plays the subdivisions in order, but increments the starting subdivision each cycle. The pattern wraps to the first subdivision after the last subdivision is played."
referenceText "iter'" = "does the same as iter but in the other direction."
referenceText "trunc" = "truncates a pattern so that only a fraction of the pattern is played."
-- referenceText "swingBy"
referenceText "append" = "combines two patterns into a new pattern, where cycles alternate between the first and second pattern."
-- referenceText "append'"
referenceText "every" = "allows you to apply another function conditionally. It takes three inputs, how often the function should be applied (e.g. 3 to apply it every 3 cycles), the function to be applied, and the pattern you are applying it to."
-- referenceText "every'"
referenceText "whenmod" = " has a similar form and behavior to every, but requires an additional number. It applies the function to the pattern, when the remainder of the current loop number divided by the first parameter, is greater or equal than"
referenceText "overlay" = "is similar to cat described above, but combines two patterns, rather than a list of patterns."
-- referenceText "fastGap"
-- referenceText "densityGap"
referenceText "sparsity" = "slows down a pattern."
-- referenceText "slow'"
-- referenceText "rotL"
-- referenceText "rotR"
-- referenceText "playFor"
referenceText "foldEvery" = "transforms a pattern with a function, once per any of the given number of cycles. If a particular cycle is the start of more than one of the given cycle periods, then it it applied more than once. It is similar to chaining multiple every functions together."
referenceText "superimpose" = "plays a modified version of a pattern 'on top of' the original pattern, resulting in the modified and original version of the patterns being played at the same time. "
referenceText "linger" = "is similar to trunc, in that it truncates a pattern so that only the first fraction of the pattern is played. However unlike trunk, linger repeats that part to fill the remainder of the cycle."
referenceText "zoom" = "plays a portion of a pattern, specified by the beginning and end of a time span (known as an 'arc')."
-- referenceText "compress"
-- referenceText "sliceArc"
referenceText "within" = "apply a function to only a part of a pattern."
-- referenceText "within'"
-- referenceText "revArc"
-- referenceText "e"
-- referenceText "e'"
-- referenceText "einv"
-- referenceText "distrib"
-- referenceText "efull"
referenceText "wedge" = "combines two patterns by squashing them into a single cycle. It takes a ratio as the first argument. The ratio determines what percentage of the pattern cycle is taken up by the first pattern. The second pattern fills in the remainder of the pattern cycle."
-- referenceText "prr"
-- referenceText "preplace"
-- referenceText "prep"
-- referenceText "preplace1"
-- referenceText "protate"
-- referenceText "prot"
-- referenceText "prot1"
-- referenceText "discretise"
-- referenceText "discretise'"
referenceText "struct" = "places a rhythmic 'boolean' structure on the pattern you given it."
-- referenceText "substruct"
-- referenceText "compressTo"
-- referenceText "substruct'"
-- referenceText "slowstripe"
referenceText "fit'" = "is a generalization of fit, where the list is instead constructed by using another integer pattern to slice up a given pattern. The first argument is the number of cycles of that latter pattern to use when slicing."
referenceText "chunk" = "divides a pattern into a given number of parts, then cycles through those parts in turn, applying the given function to each part in turn (one part per cycle)."
-- referenceText "time
referenceText "swing" = "breaks each cycle into n slices, and then delays events in the second half of each slice by the amount x, which is relative to the size of the (half) slice. So if x is 0 it does nothing, 0.5 delays for half the note duration, and 1 will wrap around to doing nothing again."
referenceText "degradeBy" = "randomly removes events from a pattern, 50% of the time. "
-- referenceText "unDegradeBy"
-- referenceText "degradeOverBy"
referenceText "sometimes" = "applies another function to a pattern, around 50% of the time, at random. It takes two inputs, the function to be applied, and the pattern you are applying it to."
referenceText "sometimesBy" = "same as sometimes. It accepts a number if you want to be specific"
referenceText "often" = "applies another function to a pattern, around 75% of the time, at random. It takes two inputs, the function to be applied, and the pattern you are applying it to."
referenceText "rarely" = "applies another function to a pattern, around 25% of the time, at random. It takes two inputs, the function to be applied, and the pattern you are applying it to."
referenceText "almostNever" = "applies another function to a pattern, around 10% of the time, at random. It takes two inputs, the function to be applied, and the pattern you are applying it to."
referenceText "almostAlways" = "applies another function to a pattern, around 90% of the time, at random. It takes two inputs, the function to be applied, and the pattern you are applying it to."
referenceText "never" = "applies another function to a pattern, around 0% of the time, at random. It takes two inputs, the function to be applied, and the pattern you are applying it to."
referenceText "always" = "applies another function to a pattern, around 100% of the time, at random. It takes two inputs, the function to be applied, and the pattern you are applying it to."
referenceText "someCycles" = "is similar to sometimes, but instead of applying the given function to random events, it applies it to random cycles. For example the following will either distort all of the events in a cycle, or none of them."
referenceText "somecyclesBy" = "As with sometimesBy, if you want to be specific, you can use someCyclesBy and a number."
referenceText "repeatCycles" = "repeats each cycle of a given pattern a given number of times.. It takes two inputs, the number of repeats, and the pattern you are transforming."
-- referenceText "spaceOut"
-- referenceText "fill"
referenceText "ply" = "repeats each event the given number of times. "
referenceText "shuffle" = "takes a number and a pattern as input, divides the pattern into the given number of parts, and returns a new pattern as a random permutation of the parts, picking one of each per cycle. This could also be called \"sampling without replacement\"."
referenceText "scramble" = "takes a number and a pattern as input, divides the pattern into the given number of parts, and returns a new pattern by randomly selecting from the parts. This could also be called \"sampling with replacement\". "
referenceText "rand" = "is an oscillator that generates a pattern of (pseudo-)random, floating point numbers between 0 and 1."
-- referenceText "sinewave1"
-- referenceText "sinewave"
-- referenceText "sine1"
referenceText "sine" = "A sine wave."
-- referenceText "sawwave1"
-- referenceText "sawwave"
-- referenceText "saw1"
referenceText "saw" = "A sawtooth wave starting at 0, then linearly rising to 1 over one cycle, then jumping back to 0."
-- referenceText "triwave1"
-- referenceText "triwave"
-- referenceText "tri1"
referenceText "tri" = "A triangle wave, starting at 0, then linearly rising to 1 halfway through a cycle, then down again."
-- referenceText "squarewave1"
-- referenceText "square1"
referenceText "square" = "A squarewave, starting at 0, then going up to 1 halfway through a cycle."
-- referenceText "squarewave"
referenceText "cosine" = "A cosine wave, i.e. a sine shifted in time by a quarter of a cycle."
-- referenceText "\#"
-- referenceText "|=|"
-- referenceText "|+|"
-- referenceText "|-|"
-- referenceText "|*|"
-- referenceText "|/|"
-- referenceText "\+"
-- referenceText "\-"
-- referenceText "\*"


-- help files for samples
functionRef :: MonadWidget t m => Text -> m ()
functionRef x = divClass "helpWrapper" $ do
   switchToReference <- divClass "" $ button x
   exampleVisible <- toggle True switchToReference
   referenceVisible <- toggle False switchToReference
   hideableWidget exampleVisible "exampleText foreground-color small-font" $ text (exampleText x)
   hideableWidget referenceVisible "referenceText" $ text (referenceText x)
   return ()
