pianissimo = 0.1
piano = 0.2
mezzo_piano = 0.3
mezzo_forte = 0.4
forte = 0.5
fortissimo = 0.6

# use_bpm 50 * 3

use_synth :piano

play_soprano = true
play_alto = true
play_tenor = true
play_bass = true

# pitches, durations, volumes should have same number of elements
# maybe I could make volumes a ring?

def play_bar (pitches, durations, dynamic_start, dynamic_end)
  volumes = (line dynamic_start, dynamic_end, steps: (pitches.length), inclusive: true)
  pitches.each_with_index do |pitch, index|
    play_pattern_timed [pitch], [durations[index]], amp: volumes[index]
  end
end


if play_soprano
  in_thread do
    
  end
end

if play_alto
  in_thread do
    
  end
end

if play_tenor
  #define bars
  bars = Array.new(1)
  note_list = [:c4,:d4,:e4,:c4]
  len_list = [1,2,1,1]
  play_bar(note_list, len_list, forte, pianissimo)
  
  in_thread do
    bars.each do |bar|
      #bar.play
    end
  end
end


if play_bass
  in_thread do
    
  end
end


