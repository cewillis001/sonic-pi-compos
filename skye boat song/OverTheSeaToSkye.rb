pianissimo = 0.1
piano = 0.2
mezzo_piano = 0.3
mezzo_forte = 0.4
forte = 0.5
fortissimo = 0.6

use_bpm 50 * 3

use_synth :piano

play_soprano = true
play_alto = true
play_tenor = true
play_bass = true

if play_soprano
  in_thread do
    4.times do
      soprano_chorus_phrase
      #sailors cry
      play_pattern_timed [:e4, :e4, :d4], [2, 1, 6], amp: piano
      soprano_chorus_phrase
      #sea to Skye
      play_pattern_timed [:d4, :g4, :g4], [2, 1, 6], amp: mezzo_forte
      
      #start verse
      play_pattern_timed [:b4, :g4, :b4, :b4], [1.5, 0.5, 1, 3], amp: mezzo_forte
      play_pattern_timed [:a4, :e4, :a4, :a4], [1.5, 0.5, 1, 3], amp: mezzo_forte
      play_pattern_timed [:g4, :e4, :g4, :g4, :g4, :e4], [1.5, 0.5, 1, 2, 1, 6], amp: mezzo_forte
      play_pattern_timed [:b4, :g4, :b4, :b4], [1.5, 0.5, 1, 3], amp: mezzo_forte
      play_pattern_timed [:a4, :e4, :a4, :a4], [1.5, 0.5, 1, 3], amp: mezzo_forte
      play_pattern_timed [:g4, :e4, :g4, :g4, :g4, :e4, :d4], [1.5, 0.5, 1, 2, 1, 3, 3], amp: mezzo_forte
    end
    soprano_chorus_phrase
    #sailors cry
    play_pattern_timed [:e4, :e4, :d4], [2, 1, 6], amp: piano
    soprano_chorus_phrase
    #sea to Skye
    play_pattern_timed [:d4, :g4, :g4], [2, 1, 6], amp: mezzo_forte
  end
end

if play_alto
  in_thread do
    4.times do
      alto_chorus_phrase
      #sailors cry
      play_pattern_timed [:g4, :g4, :g4, :fs4], [2, 1, 3, 3], amp: piano
      alto_chorus_phrase
      #sea to Skye
      play_pattern_timed [:g4, :g4, :g4], [2, 1, 6], amp: mezzo_forte
      
      #start verse
      play_pattern_timed [:r, :g4, :e4, :g4, :e4], [3, 1.5, 0.5, 1, 3], amp: piano
      play_pattern_timed [:e4, :c4, :e4, :e4], [1.5, 0.5, 1, 3], amp: piano
      play_pattern_timed [:e4, :b3, :e4, :b3, :b3, :b3], [1.5, 0.5, 1, 2, 1, 3], amp: piano
      play_pattern_timed [:r, :g4, :e4, :g4, :e4], [3, 1.5, 0.5, 1, 3], amp: piano
      play_pattern_timed [:e4, :c4, :e4, :e4], [1.5, 0.5, 1, 3], amp: piano
      play_pattern_timed [:e4, :b3, :e4, :b3, :b3, :a3], [1.5, 0.5, 1, 2, 1, 3], amp: piano
    end
    alto_chorus_phrase
    #sailors cry
    play_pattern_timed [:g4, :g4, :g4, :fs4], [2, 1, 3, 3], amp: piano
    alto_chorus_phrase
    #sea to Skye
    play_pattern_timed [:g4, :g4, :g4], [2, 1, 6], amp: mezzo_forte
  end
end

if play_tenor
  in_thread do
    4.times do
      tenor_chorus_phrase
      #sailors cry
      play_pattern_timed [:a3, :b3, :b3, :a3], [1.5, 1, 2, 3], amp: piano
      tenor_chorus_phrase
      #sea to Skye
      play_pattern_timed [:a3, :b3, :b3, :b3], [1.5, 1, 2, 3], amp: mezzo_forte
      
      #start verse
      play_pattern_timed [:g3, :e3, :g3, :g3, :g3, :e3, :g3], [6], amp: pianissimo
      play_pattern_timed [:e3, :fs3], [3,3], amp: pianissimo
    end
    tenor_chorus_phrase
    #sailors cry
    play_pattern_timed [:a3, :b3, :b3, :a3], [1.5, 1, 2, 3], amp: piano
    tenor_chorus_phrase
    #sea to Skye
    play_pattern_timed [:a3, :b3, :b3, :b3], [1.5, 1, 2, 3], amp: mezzo_forte
  end
end

if play_bass
  in_thread do
    4.times do
      bass_chorus_phrase
      #sailors cry
      play_pattern_timed [:e3, :g3, :g3, :d3], [1.5, 1, 2, 3], amp: piano
      bass_chorus_phrase
      #sea to Skye
      play_pattern_timed [:e3, :g3, :g3, :g3], [1.5, 1, 2, 3], amp: mezzo_forte
      
      #start verse
      play_pattern_timed [:e3,:a3, :e3, :e3, :e3,:a3,:e3], [6], amp: pianissimo
      play_pattern_timed [:a3,:d3], [3,3], amp: pianissimo
    end
    bass_chorus_phrase
    #sailors cry
    play_pattern_timed [:e3, :g3, :g3, :d3], [1.5, 1, 2, 3], amp: piano
    bass_chorus_phrase
    #sea to Skye
    play_pattern_timed [:e3, :g3, :g3, :g3], [1.5, 1, 2, 3], amp: mezzo_forte
  end
end



define :soprano_chorus_phrase do
  #speed bonnie boat/ carry the lad
  play_pattern_timed [:d4, :e4, :d4, :g4], [1.5,0.5,1,2], amp: piano
  #like a bird on the wing / that is born to be king
  play_pattern_timed [:g4, :g4, :a4, :b4, :a4, :d5], [0.5, 0.5, 1.5, 0.5,1,3], amp: forte
  #onward the / over the
  play_pattern_timed [:b4, :a4, :b4], [1.5, 0.5, 1], amp: forte
end

define :alto_chorus_phrase do
  #speed bonnie boat
  play_pattern_timed [:b3, :b3, :b3, :e4], [1.5,0.5,1,2], amp: piano
  #like a bird on the wing
  play_pattern_timed [:e4, :e4, :e4, :e4, :fs4, :fs4], [0.5, 0.5, 1.5, 0.5,1,3], amp: forte
  #onward the
  play_pattern_timed [:g4, :g4, :g4], [1.5, 0.5, 1], amp: forte
end

define :tenor_chorus_phrase do
  #speed bonnie boat
  play_pattern_timed [:r, :g3, :a3, :g3, :b3], [1.5, 1.5,0.5,1,1.5], amp: piano
  #like a bird on the wing
  play_pattern_timed [:c4, :c4, :c4, :a3, :a3, :a3], [1, 1, 1, 0.5,0.5,2], amp: forte
  #onward the
  play_pattern_timed [:r, :d4, :c4, :c4], [1.5, 1.5, 0.5, 1], amp: forte
end

define :bass_chorus_phrase do
  #speed bonnie boat
  play_pattern_timed [:r, :g3, :e3, :e3, :e3], [1.5, 1.5,0.5,1,1.5], amp: piano
  #like a bird on the wing
  play_pattern_timed [:c3, :c3, :c3, :d3, :d3, :d3], [1, 1, 1, 0.5,0.5,2], amp: forte
  #onward the
  play_pattern_timed [:r, :g3, :e3, :e3], [1.5, 1.5, 0.5, 1], amp: forte
end
