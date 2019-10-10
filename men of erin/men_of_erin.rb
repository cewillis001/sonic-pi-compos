# see https://musescore.com/user/26936575/scores/5668559

pianissimo = 0.1
piano = 0.2
mezzo_piano = 0.3
mezzo_forte = 0.4
forte = 0.5
fortissimo = 0.6

use_bpm 100

use_synth :beep

play_soprano = true
play_alto = true
play_tenor = true
play_bass = true


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
  [[:b4,:d5,:b4],[0.5,2,0.5],mezzo_forte,mezzo_forte],
  [[:a4,:a4,:b4],[0.5,2,0.5],mezzo_forte,mezzo_forte],
  [[:a4,:b4,:d5],[2,0.25,0.75],mezzo_forte,mezzo_forte],
  
  [[:e5,:d5,:d5,:d5],[1,1,0.5,0.5],mezzo_forte,mezzo_forte],
  [[:e5,:d5,:b4,:b4],[0.25,1.75,0.5,0.5],mezzo_forte,mezzo_forte],
  [[:a4,:g4,:e4],[0.5,2,0.5],mezzo_forte,mezzo_forte],
  [[:d4,:d4,:e4],[2,0.25,0.75],mezzo_forte,mezzo_forte],
  
  [[:g4,:e4,:d4],[2,0.25,0.75],mezzo_forte,mezzo_forte],
  [[:b4,:g4,:g4],[1,1.5,0.5],mezzo_forte,mezzo_forte],
  [[:g4],[3],mezzo_forte,mezzo_forte]
]

tenor_line = [
  [[:r,:d3,:e3],[2,0.5,0.5],mezzo_forte,mezzo_forte],
  
  [[:g3,:a3],[2.75,0.25],mezzo_forte,mezzo_forte],
  [[:b3,:a3,:g3],[2,0.25,0.75],mezzo_forte,mezzo_forte],
  [[:g3,:g3,:e3],[0.5,2,0.5],mezzo_forte,mezzo_forte],
  [[:d3,:d3,:e3],[2,0.5,0.5],mezzo_forte,mezzo_forte],
  
  [[:g3,:g3,:g3],[2,0.75,0.25],mezzo_forte,mezzo_forte],
  [[:b3,:d4,:b3],[0.5,2,0.5],mezzo_forte,mezzo_forte],
  [[:a3,:a3,:b3],[0.5,2,0.5],mezzo_forte,mezzo_forte],
  [[:a3,:b3,:d4],[2,0.25,0.75],mezzo_forte,mezzo_forte],
  
  [[:e4,:d4,:d4,:d4],[1,1,0.5,0.5],mezzo_forte,mezzo_forte],
  [[:e4,:d4,:b3,:b3],[0.25,1.75,0.5,0.5],mezzo_forte,mezzo_forte],
  [[:a3,:g3,:e3],[0.5,2,0.5],mezzo_forte,mezzo_forte],
  [[:d3,:d3,:e3],[2,0.25,0.75],mezzo_forte,mezzo_forte],
  
  [[:g3,:e3,:d3],[2,0.25,0.75],mezzo_forte,mezzo_forte],
  [[:b3,:g3,:g3],[1,1.5,0.5],mezzo_forte,mezzo_forte],
  [[:g3],[3],mezzo_forte,mezzo_forte]
]

if play_soprano
  in_thread do
    6.times do
      for bar in soprano_line
        play_bar(bar[0], bar[1], bar[2], bar[3])
      end
    end
  end
end

if play_alto
  in_thread do
    
  end
end

if play_tenor
  in_thread do
    6.times do
      for bar in tenor_line
        play_bar(bar[0], bar[1], bar[2], bar[3])
      end
    end
  end
end


if play_bass
  in_thread do
    
  end
end


