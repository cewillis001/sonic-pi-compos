# see https://musescore.com/user/26936575/scores/5668559

pianissimo = 0.1
piano = 0.2
mezzo_piano = 0.3
mezzo_forte = 0.4
forte = 0.5
fortissimo = 0.6

octave = 12
semitone = 1
major_second = 2
major_third = 4
perfect_forth = 5
perfect_fifth = 7
major_sixth = 9
major_seventh = 11

use_bpm 100

use_synth :piano

play_soprano = true
play_alto = true
play_tenor = true
play_bass = true

BarStruct = Struct.new(:pitches, :durations, :dynamic_start, :dynamic_end) do
  def to_ary
    [pitches, durations, dynamic_start, dynamic_end]
  end
end

def play_bar (pitches, durations, dynamic_start, dynamic_end)
  volumes = (line dynamic_start, dynamic_end, steps: (pitches.length), inclusive: true)
  pitches.each_with_index do |pitch, index|
    play_pattern_timed [pitch], [durations[index]], amp: volumes[index]
  end
end

# musical_line is array of BarStructs
# interval is a positive or negative number that will be used to shift pitches
# +12 will shift up an octave
# -2 shifts down one whole step
# octave is five whole steps + 2 half steps, because music theory?
def transpose (musical_line, interval)
  new_musical_line = []
  for bar in musical_line
    new_bar = BarStruct.new(bar.pitches, bar.durations, bar.dynamic_start, bar.dynamic_end)
    new_bar.pitches = new_bar.pitches.map { |note| note + interval}
    new_musical_line << new_bar
  end
  new_musical_line
end


# 16 bars
# 1 beat = 1 quarter note
melody_line = [
  BarStruct.new([:r,:d4,:e4],[2,0.5,0.5],mezzo_forte,mezzo_forte),
  
  BarStruct.new([:g4,:a4],[2.75,0.25],mezzo_forte,mezzo_forte),
  BarStruct.new([:b4,:a4,:g4],[2,0.25,0.75],mezzo_forte,mezzo_forte),
  BarStruct.new([:g4,:g4,:e4],[0.5,2,0.5],mezzo_forte,mezzo_forte),
  BarStruct.new([:d4,:d4,:e4],[2,0.5,0.5],mezzo_forte,mezzo_forte),
  
  BarStruct.new([:g4,:g4,:g4],[2,0.75,0.25],mezzo_forte,mezzo_forte),
  BarStruct.new([:b4,:d5,:b4],[0.5,2,0.5],mezzo_forte,mezzo_forte),
  BarStruct.new([:a4,:a4,:b4],[0.5,2,0.5],mezzo_forte,mezzo_forte),
  BarStruct.new([:a4,:b4,:d5],[2,0.25,0.75],mezzo_forte,mezzo_forte),
  
  BarStruct.new([:e5,:d5,:d5,:d5],[1,1,0.5,0.5],mezzo_forte,mezzo_forte),
  BarStruct.new([:e5,:d5,:b4,:b4],[0.25,1.75,0.5,0.5],mezzo_forte,mezzo_forte),
  BarStruct.new([:a4,:g4,:e4],[0.5,2,0.5],mezzo_forte,mezzo_forte),
  BarStruct.new([:d4,:d4,:e4],[2,0.25,0.75],mezzo_forte,mezzo_forte),
  
  BarStruct.new([:g4,:e4,:d4],[2,0.25,0.75],mezzo_forte,mezzo_forte),
  BarStruct.new([:b4,:g4,:g4],[1,1.5,0.5],mezzo_forte,mezzo_forte),
  BarStruct.new([:g4],[3],mezzo_forte,mezzo_forte)
]

t_interval = -(major_second)

if play_soprano
  in_thread do
    soprano_line = Array.new(melody_line)
    soprano_line = transpose(soprano_line, t_interval)
    6.times do
      for bar in soprano_line
        play_bar(bar.pitches, bar.durations, bar.dynamic_start, bar.dynamic_end)
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
    tenor_line = Array.new(melody_line)
    tenor_line = transpose(tenor_line, -(octave))
    tenor_line = transpose(tenor_line, t_interval)
    6.times do
      for bar in tenor_line
        play_bar(bar.pitches, bar.durations, bar.dynamic_start, bar.dynamic_end)
      end
    end
  end
end


if play_bass
  in_thread do
    
  end
end


