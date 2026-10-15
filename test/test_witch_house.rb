require "minitest/autorun"
require "sonic_pi_stubs"
require "witch_house"

class TestWitchHouse < Minitest::Test
  ROOT = File.expand_path("..", __dir__)

  # every compo, plus the template new compos start from
  COMPOS = Dir[File.join(ROOT, "{*,*/*}.rb")].reject do |path|
    path.start_with?(File.join(ROOT, "lib/"), File.join(ROOT, "test/"))
  end.sort

  # shaped like the real compos: tempo and synth set at the top, a thread per voice
  SETUP = "use_bpm 100\nuse_synth :piano\n".freeze
  VOICES = <<~RUBY.freeze
    in_thread do
      play_pattern_timed [:g4, :r, :a4], [1, 0.5, 1.5], amp: 0.4
    end
    in_thread do
      play_pattern_timed [:g3, :d3], [2, 1], amp: 0.2
    end
  RUBY

  def play_compo(code, stop_at: 60)
    SonicPiStub.new(stop_at: stop_at).run(code)
  end

  def witch_house(options = "")
    "#{SETUP}witch_house_ify #{options} do\n#{VOICES}end\n"
  end

  # what the README says to do: witch_house_ify do after the compo's use_bpm and
  # use_synth lines, end at the bottom
  def witch_house_ified(source)
    lines = source.lines
    last_setting = lines.rindex { |line| line.start_with?("use_bpm", "use_synth") }
    at = last_setting ? last_setting + 1 : 0
    (lines[0...at] + ["witch_house_ify do\n"] + lines[at..] + ["\nend\n"]).join
  end

  def notes(pi)
    pi.events.select { |event| event.kind == :synth }
  end

  def hits(pi, name)
    pi.events.select { |event| event.kind == :sample && event.name == name }
  end

  def beats(events)
    events.map { |event| (event.time * event.bpm / 60).round(9) }
  end

  def steps_with(bar, hit)
    bar.each_index.select { |step| bar[step].include?(hit) }
  end

  # the way the README says to load it into a compo
  def test_loads_into_a_compo_with_eval_file
    pi = play_compo("eval_file #{File.join(ROOT, 'lib', 'witch_house.rb').inspect}\n#{witch_house}")

    assert_includes pi.singleton_methods, :witch_house_ify
    assert(notes(pi).all? { |note| note.synth == :prophet })
  end

  def test_needs_the_voices_in_a_block
    error = assert_raises(ArgumentError) { SonicPiStub.new.run { witch_house_ify } }
    assert_match(/do \.\.\. end/, error.message)
  end

  def test_slows_the_compo_to_two_thirds_and_drops_it_a_fifth_like_a_screwed_tape
    plain = notes(play_compo(SETUP + VOICES))
    witch = notes(play_compo(witch_house))

    assert_equal plain.map(&:name), witch.map(&:name)
    plain.zip(witch).each do |before, after|
      assert_in_delta before.time * 1.5, after.time, 1e-9
      assert_equal before.transpose - 7, after.transpose
    end
  end

  def test_transpose_follows_the_slowdown_unless_given
    assert(notes(play_compo(witch_house("slowdown: 0.5"))).all? { |note| note.transpose == -12 })
    assert(notes(play_compo(witch_house("transpose: 0"))).all? { |note| note.transpose.zero? })
  end

  def test_transpose_adds_to_the_compos_own
    assert(notes(play_compo("use_transpose 2\n#{witch_house}")).all? { |note| note.transpose == -5 })
  end

  # so wrapping the use_bpm line too still slows the compo down
  def test_slowdown_survives_a_use_bpm_inside_the_block
    pi = play_compo("witch_house_ify do\n#{SETUP}#{VOICES}end\n")
    assert(notes(pi).all? { |note| (note.bpm - (100 * 2.0 / 3)).abs < 1e-9 })
  end

  def test_swaps_the_piano_for_a_dark_pad_but_keeps_the_dynamics
    plain = notes(play_compo(SETUP + VOICES))
    witch = notes(play_compo(witch_house))

    assert(witch.all? { |note| note.synth == :prophet })
    assert_equal plain.map { |note| note.opts[:amp] }, witch.map { |note| note.opts[:amp] }
    # longer tails than :prophet's release: 1, darker than its cutoff: 110
    assert(witch.all? { |note| note.opts.fetch(:release, 1) > 1 && note.opts.fetch(:cutoff, 110) < 110 })
  end

  def test_plays_voices_and_beat_through_reverb
    pi = play_compo(witch_house)
    refute_empty hits(pi, :bd_808)
    assert(pi.events.all? { |event| event.fx == [:reverb] })
  end

  def test_only_whats_inside_the_block_is_witch_housed
    after = play_compo("#{witch_house}play :c5\n").events.last
    assert_equal [:c5, :piano, 0, [], 100.0], [after.name, after.synth, after.transpose, after.fx, after.bpm]
  end

  def test_a_bar_has_kick_on_one_clap_on_three_and_hats_on_the_eighths
    bar = witch_house_bar(3)
    assert_equal 12, bar.size
    assert_equal [0], steps_with(bar, :kick)
    assert_equal [8], steps_with(bar, :clap)
    assert_equal [0, 2, 4, 6, 8, 10], steps_with(bar, :hat)
  end

  def test_a_rolled_bar_rattles_the_hats_through_the_last_beat
    assert_equal [0, 2, 4, 6, 8, 9, 10, 11], steps_with(witch_house_bar(3, roll: true), :hat)
  end

  def test_a_bar_of_four_claps_on_three
    bar = witch_house_bar(4)
    assert_equal 16, bar.size
    assert_equal [8], steps_with(bar, :clap)
  end

  def test_beat_starts_after_the_pickup_and_rolls_every_other_bar
    pi = play_compo(witch_house("bars: 2, pickup: 1"))

    assert_equal [1, 4], beats(hits(pi, :bd_808))
    assert_equal [3, 6], beats(hits(pi, :sn_dolf))
    assert_equal [1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5, 5.5, 6, 6.25, 6.5, 6.75], beats(hits(pi, :drum_cymbal_closed))
  end

  def test_bars_of_four
    pi = play_compo(witch_house("bars: 2, beats_per_bar: 4"))

    assert_equal [0, 4], beats(hits(pi, :bd_808))
    assert_equal [2, 6], beats(hits(pi, :sn_dolf))
  end

  def test_beat_keeps_going_until_stop_without_bars
    # 36.5s at 100 * 2/3 bpm is 40.5 beats: bars of 3 start on beats 0, 3, ... 39
    pi = play_compo(witch_house, stop_at: 36.5)
    assert_equal (0..39).step(3).to_a, beats(hits(pi, :bd_808))
  end

  def test_beat_false_leaves_out_the_drums
    pi = play_compo(witch_house("beat: false"))
    assert_empty pi.events.select { |event| event.kind == :sample }
    refute_empty notes(pi)
  end

  COMPOS.each do |path|
    define_method("test_#{File.basename(path, '.rb')}_keeps_its_notes_and_dynamics_when_witch_house_ified") do
      source = File.read(path)
      plain = notes(SonicPiStub.new.run(source, path))
      stop_at = (plain.map(&:time).max || 0) * 1.5 + 1
      witch = notes(SonicPiStub.new(stop_at: stop_at).run(witch_house_ified(source), path))

      refute_empty plain
      assert_equal plain.map(&:name), witch.map(&:name)
      assert_equal plain.map { |note| note.opts[:amp] }, witch.map { |note| note.opts[:amp] }
      plain.zip(witch).each do |before, after|
        assert_in_delta before.time * 1.5, after.time, 1e-6
        assert_equal before.transpose - 7, after.transpose
        assert_equal [:prophet, [:reverb]], [after.synth, after.fx]
      end
    end
  end
end
