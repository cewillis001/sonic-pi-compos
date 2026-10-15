# sonic pi compos
 
To listen to these compositions, go to https://sonic-pi.net/, then download and install sonic pi for your OS. Clone this repo, and load one of the .rb files into a buffer in the sonic-pi editor. Click "Run" and enjoy!

## Witch house

`lib/witch_house.rb` has `witch_house_ify`, which plays the compo you have open as witch house. It slows the compo to 2/3 speed and drops it a fifth, like a screwed tape, swaps the piano for a dark synth, and plays everything through heavy reverb over a slow 808 trap beat. The compo's notes, rhythms and dynamics stay the same. Only the way they're played changes.

1. Near the top of the compo, load the library from your clone. Forward slashes work on Windows. Don't commit this line, because the path only works on your machine.

   ```ruby
   eval_file "C:/Users/you/sonic-pi-compos/lib/witch_house.rb"
   ```

2. Add a `witch_house_ify do` line after the compo's `use_bpm` and `use_synth` lines, and an `end` line at the bottom of the file, so all the voices are inside it. (A `use_synth` inside the block would switch the piano back on.)
3. Click Run. The beat keeps going after the voices finish, until you press Stop.

The drums assume 3 beats in a bar and no pickup, which fits *Men of Erin* and *Over the Sea to Skye*. For other compos, give the number of beats in a bar and the length of the pickup before the first full bar. *A Lusty Young Smith* starts with a one-beat pickup, for example:

```ruby
witch_house_ify pickup: 1 do
```

All the options:

| Option | Default | What it does |
|---|---|---|
| `beats_per_bar:` | `3` | Beats in a bar, so the kick and clap land on the right beats |
| `pickup:` | `0` | Beats before the first full bar. The drums come in after them |
| `slowdown:` | `2.0 / 3` | How much slower to play. `0.5` is half speed |
| `transpose:` | matches `slowdown:` | Semitones to shift by. The default drops the pitch the way slowing a tape does: 2/3 speed is a fifth lower, half speed is an octave lower |
| `synth:` | `:prophet` | The synth every voice plays on |
| `beat:` | `true` | `false` leaves out the drums |
| `bars:` | none | Stop the beat after this many bars, instead of when you press Stop |

## Tests

The tests run in plain Ruby with minitest. Sonic Pi's built-in functions are stubbed out in `test/sonic_pi_stubs.rb`.

```
ruby -Ilib -Itest test/test_witch_house.rb
```
