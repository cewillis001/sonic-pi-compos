pianissimo = 0.1
piano = 0.2
mezzo_piano = 0.3
mezzo_forte = 0.4
forte = 0.5
fortissimo = 0.6

use_bpm 90

use_synth :piano

play_soprano = true
play_alto = true
play_tenor = true
play_bass = true

if play_soprano
  in_thread do
    #still, still, still
    play_pattern_timed [:c5,:f5,:a4,:c5, :f4], [1,1,1,1, 3], amp: mezzo_piano
    # let all the world be still
    play_pattern_timed [:f4,:a4,:g4, :g4,:bf4,:e4, :e4,:g4,:f4], [0.5,0.5, 1,0.5,0.5,1,0.5,0.5, 3], amp: mezzo_piano
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


