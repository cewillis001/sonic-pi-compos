pianissimo = 0.1
piano = 0.2
mezzo_piano = 0.3
mezzo_forte = 0.4
forte = 0.5
fortissimo = 0.6

use_bpm 120

use_synth :piano

play_soprano = false
play_alto = false
play_tenor = true
play_bass = false

if play_soprano
  in_thread do
    
  end
end

if play_alto
  in_thread do
    # a lusty young smith at his
    in_thread do
      play_pattern_timed [:a3, :d4,:d4,:d4, :d4,:cs4,:d4], [1, 1,1,1, 1,1,1]
    end
    in_thread do
      play_pattern_timed [:r, :d4,:d4,:d4, :d4,:cs4,:d4], [1, 1,1,1, 1,1,1]
    end
    in_thread do
      play_pattern_timed [:r, :r,:d4,:d4, :d4,:cs4,:d4], [1, 1,1,1, 1,1,1]
    end
    in_thread do
      play_pattern_timed [:r, :r,:r,:d4, :d4,:cs4,:d4], [1, 1,1,1, 1,1,1]
    end
    in_thread do
      play_pattern_timed [:r, :r,:r,:r, :d4,:cs4,:d4], [1, 1,1,1, 1,1,1]
    end
    in_thread do
      play_pattern_timed [:r, :r,:r,:r, :r,:cs4,:d4], [1, 1,1,1, 1,1,1]
    end
    in_thread do
      play_pattern_timed [:r, :r,:r,:r, :r,:r,:d4], [1, 1,1,1, 1,1,1]
    end
    
    # vice stood a filing
    play_pattern_timed [:e4,:e4,:e4, :fs4,:d4], [1,1.5,0.5, 1,1]
    # his hammer laid by but his
    play_pattern_timed [:a3, :d4,:d4,:d4, :d4,:cs4,:d4], [1, 1,1,1, 1,1,1]
    # forge still a-glow
    play_pattern_timed [:e4,:fs4,:g4, :a4], [1,1,1, 2]
    # when to him a buxom young
    play_pattern_timed [:a4, :b4,:g4,:b4, :a4,:fs4,:a4], [1, 1,1,1, 1,1,1]
    # damsel came smiling
    play_pattern_timed [:g4,:e4,:g4, :fs4,:d4], [1,1,1, 1,1.5]
    # and asked if to work at her
    play_pattern_timed [:a3, :d4,:d4,:d4, :d4,:e4, :fs4], [0.5, 1,1,1, 1,1,1]
    # forge he would go
    play_pattern_timed [:g4,:e4,:cs4, :d4], [1,1,1, 2]
    # with a jingle bang jingle bang
    play_pattern_timed [:a4,:a4, :fs4,:d4,:d4, :fs4,:a4,:a4], [0.75,0.25, 1,1,1, 1,1,1]
    # jingle bang jingle
    play_pattern_timed [:g4,:e4,:e4, :fs4,:d4], [1,1,1, 1,1]
    # with a jingle bang jingle bang
    play_pattern_timed [:a4,:a4, :fs4,:d4,:d4, :fs4,:a4,:a4], [0.75,0.25, 1,1,1, 1,1,1]
    # jingle hi hooooo
    play_pattern_timed [:g4,:e4,:cs4, :d4], [1,1,1, 2]
  end
end

if play_tenor
  in_thread do
    # a lusty young smith at his
    play_pattern_timed [:a2, :d3,:d3,:d3, :d3,:cs3,:d3], [1, 1,1,1, 1,1,1]
    # vice stood a filing
    play_pattern_timed [:e3,:e3,:e3, :fs3,:d3], [1,1.5,0.5, 1,1]
    # his hammer laid by but his
    play_pattern_timed [:a2, :d3,:d3,:d3, :d3,:cs3,:d3], [1, 1,1,1, 1,1,1]
    # forge still a-glow
    play_pattern_timed [:e3,:fs3,:g3, :a3], [1,1,1, 2]
    # when to him a buxom young
    play_pattern_timed [:a3, :b3,:g3,:b3, :a3,:fs3,:a3], [1, 1,1,1, 1,1,1]
    # damsel came smiling
    play_pattern_timed [:g3,:e3,:g3, :fs3,:d3], [1,1,1, 1,1.5]
    # and asked if to work at her
    play_pattern_timed [:a2, :d3,:d3,:d3, :d3,:e3, :fs3], [0.5, 1,1,1, 1,1,1]
    # forge he would go
    play_pattern_timed [:g3,:e3,:cs3, :d3], [1,1,1, 2]
    # with a jingle bang jingle bang
    play_pattern_timed [:a3,:a3, :fs3,:d3,:d3, :fs3,:a3,:a3], [0.75,0.25, 1,1,1, 1,1,1]
    # jingle bang jingle
    play_pattern_timed [:g3,:e3,:e3, :fs3,:d3], [1,1,1, 1,1]
    # with a jingle bang jingle bang
    play_pattern_timed [:a3,:a3, :fs3,:d3,:d3, :fs3,:a3,:a3], [0.75,0.25, 1,1,1, 1,1,1]
    # jingle hi hooooo
    play_pattern_timed [:g3,:e3,:cs3, :d3], [1,1,1, 2]
  end
end

if play_bass
  in_thread do
    
  end
end


