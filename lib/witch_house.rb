# witch house: play the current compo as witch house
#
# Wrap a compo's voices in witch_house_ify and they play slowed down and
# pitched down like a screwed tape, on a dark synth instead of the piano,
# drenched in reverb, over a slow 808 trap beat. The compo's own notes,
# rhythms and dynamics aren't touched: witch_house_ify only changes the tempo,
# transpose and synth settings that every voice's in_thread inherits.
#
# Load this file near the top of the compo, with the path to your clone.
# Forward slashes work on Windows. Don't commit the line, because the path
# only works on your machine:
#
#   eval_file "C:/Users/you/sonic-pi-compos/lib/witch_house.rb"
#
# Then put the voices inside witch_house_ify, after the compo's use_bpm and
# use_synth lines (a use_synth inside the block would bring the piano back):
#
#   use_bpm 100
#   use_synth :piano
#   ...
#   witch_house_ify do
#     if play_soprano
#       in_thread do
#         ...
#       end
#     end
#     ...
#   end
#
# The beat keeps going after the voices finish, until you press Stop (or pass
# bars:). Pass beats_per_bar: and pickup: (in beats) so the drums line up with
# the compo's bar lines.

def witch_house_ify(slowdown: 2.0 / 3, transpose: nil, synth: :prophet,
                    beat: true, beats_per_bar: 3, pickup: 0, bars: nil)
  raise ArgumentError, "witch_house_ify needs the voices inside a do ... end block" unless block_given?

  # a tape slowed to 2/3 speed also drops a fifth (7 semitones)
  transpose ||= (12 * Math.log2(slowdown)).round

  # with_bpm_mul scales whatever bpm the compo sets, even a use_bpm inside the block
  with_bpm_mul slowdown do
    with_transpose current_transpose + transpose do
      with_synth synth do
        with_merged_synth_defaults attack: 0.1, release: 2, cutoff: 90 do
          with_fx :reverb, room: 0.9, mix: 0.6 do
            witch_house_beat(beats_per_bar, pickup, bars) if beat
            yield
          end
        end
      end
    end
  end
end

# the drums, in their own thread: bars of witch_house_bar, starting after the pickup
def witch_house_beat(beats_per_bar, pickup, bars)
  kit = {
    kick: [:bd_808, amp: 1.5],
    clap: [:sn_dolf, amp: 0.6],
    hat: [:drum_cymbal_closed, amp: 0.25]
  }
  in_thread do
    sleep pickup
    bar = 0
    while bars.nil? || bar < bars
      witch_house_bar(beats_per_bar, roll: bar.odd?).each do |hits|
        hits.each { |hit| sample(*kit[hit]) }
        sleep 0.25
      end
      bar += 1
    end
  end
end

# one bar of a slow trap beat, as 16th-note steps listing what to hit on each:
# kick on beat 1, clap on the beat after halfway (beat 3 in 3/4 and 4/4),
# closed hats on the 8ths, and with roll: the hats rattle in 16ths through the
# last beat
def witch_house_bar(beats_per_bar, roll: false)
  steps = beats_per_bar * 4
  clap = (beats_per_bar / 2.0).ceil * 4
  Array.new(steps) do |step|
    hits = []
    hits << :kick if step.zero?
    hits << :clap if step == clap
    hits << :hat if step.even? || (roll && step >= steps - 4)
    hits
  end
end
