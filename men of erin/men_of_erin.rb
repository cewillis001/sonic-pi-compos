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
BarStruct = Struct.new(:pitches, :durations, :volumes) do
  def play
    pitches.each_with_index do |pitch, index|
      play_pattern_timed pitch, durations[index], volumes[index]
    end
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
  in_thread do
    
  end
end

if play_bass
  in_thread do
    
  end
end


