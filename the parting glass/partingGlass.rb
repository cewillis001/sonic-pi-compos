# the parting glass
# arrangement from https://musescore.com/user/2145496/scores/1077036

pianissimo = 0.1
piano = 0.2
mezzo_piano = 0.3
mezzo_forte = 0.4
forte = 0.5
fortissimo = 0.6

use_bpm 80 * 2

use_synth :beep

play_soprano = true
play_alto = true
play_tenor = true
play_bass = true

if play_soprano
  in_thread do
    # of all the money that
    play_pattern_timed [:a4,:g4, :f4,:d4,:d4,:c4,:d4 ], [0.5,0.5, 1,1,1,0.5,0.5 ], amp: mezzo_forte
    #ever I had, I
    play_pattern_timed [:f4,:f4,:g4,:f4,:g4], [1,1,1,0.5,0.5], amp: mezzo_forte
    # spent it in good company
    play_pattern_timed [:a4,:a4,:a4,:f4,:g4, :a4,:c4,:c4], [1,1,1,0.5,0.5, 1,1,1], amp: mezzo_forte
    #and of all the harm that ever I done
    play_pattern_timed [:a4, :g4, :f4,:f4,:f4,:f4, :f4,:f4,:g4], [0.5, 0.5, 1,1,1,1, 1,1,1], amp: mezzo_forte
    # alas it was to none but me
    play_pattern_timed [:f4,:g4, :a4,:d5,:c5,:a4, :g4,:a4,:a4], [0.5,0.5, 1,1,1,1, 1,1,1], amp: mezzo_forte
    # and all ive done, for want of wit
    2.times do
      play_pattern_timed [:r,:a4, :c5,:a4,:d5,:c5], [0.5,0.5, 0.5,0.5,1,1], amp: forte
    end
    # to memory now i cant recall
    play_pattern_timed [:r,:a4, :bf4,:a4,:g4,:f4, :bf4,:a4,:d4,:c4], [0.5,0.5, 1,0.25,0.25,2, 0.5,1,0.5,1.5], amp: forte
    #  so fill to me the
    play_pattern_timed [:a4,:g4, :f4,:d4,:d4,:c4], [0.25,0.25, 1.5,0.5,1,1], amp: forte
    # parting glass, good night and joy
    play_pattern_timed [:f4,:f4,:g4,:f4,:g4, :a4,:d5,:c5,], [1,1,1,0.5,0.5, 1,0.5,1.5], amp: fortissimo
    #be to you all
    play_pattern_timed [:a4,:a4,:d4,:d4], [1, 1,1,2], amp: mezzo_forte
    
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


