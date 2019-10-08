# see https://musescore.com/user/26936575/scores/5668559

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

# 16 bars
# 1 beat = 1 quarter note
soprano_line = [
  [[:r,:d4,:e4],[2,0.5,0.5],mezzo_forte,mezzo_forte],
  
  [[:g4,:a4],[2.75,0.25],mezzo_forte,mezzo_forte],
  [[:b4,:a4,:g4],[2,0.25,0.75],mezzo_forte,mezzo_forte],
  [[:g4,:g4,:e4],[0.5,2,0.5],mezzo_forte,mezzo_forte],
  [[:d4,:d4,:e4],[2,0.5,0.5],mezzo_forte,mezzo_forte],
  
  [[:g4,:g4,:g4],[2,0.75,0.25],mezzo_forte,mezzo_forte],
  [[],[],mezzo_forte,mezzo_forte],
  [[],[],mezzo_forte,mezzo_forte],
  [[],[],mezzo_forte,mezzo_forte],
  
  [[],[],mezzo_forte,mezzo_forte],
  [[],[],mezzo_forte,mezzo_forte],
  [[],[],mezzo_forte,mezzo_forte],
  [[],[],mezzo_forte,mezzo_forte],
  
  [[],[],mezzo_forte,mezzo_forte],
  [[],[],mezzo_forte,mezzo_forte],
  [[],[],mezzo_forte,mezzo_forte]
]

if play_soprano
  in_thread do
    for bar in soprano_line
      play_bar(bar[0], bar[1], bar[2], bar[3])
    end
    
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


