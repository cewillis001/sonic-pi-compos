# Stand-ins for the Sonic Pi built-ins that the compos and lib/ call, so they
# can run in plain Ruby under minitest. They copy how Sonic Pi itself behaves
# (checked against Sonic Pi's source, app/server/ruby in sonic-pi-net/sonic-pi):
#
# - every thread has its own settings (bpm, synth, transpose, synth defaults,
#   the FX it plays through), and in_thread starts the new thread with a copy
#   of its parent's
# - with_bpm_mul multiplies the bpm as a separate layer, so a use_bpm inside
#   the block changes the base bpm but keeps the multiplier
# - time is virtual: sleep moves the thread's clock on by beats * 60 / bpm
#   seconds, and in_thread starts at its parent's time without moving it
#
# Threads run one after another instead of side by side, which gives the same
# times and keeps tests repeatable. Pass stop_at: (seconds) to stop the run at
# that point, like pressing Stop, so loops that never end can be tested.
# Everything played ends up in #events.
class SonicPiStub
  class Stopped < StandardError; end

  Event = Struct.new(:kind, :name, :time, :bpm, :transpose, :synth, :opts, :fx, keyword_init: true)

  NOTE_INTERVALS = { "c" => 0, "d" => 2, "e" => 4, "f" => 5, "g" => 7, "a" => 9, "b" => 11 }.freeze

  attr_reader :events

  def initialize(stop_at: nil)
    @stop_at = stop_at
    @events = []
    @thread = { time: 0.0, bpm: 60.0, bpm_mul: 1.0, synth: :beep, transpose: 0, synth_defaults: {}, fx: [] }
  end

  # Runs compo source code (like pressing Run on a buffer) or a block.
  def run(code = nil, path = "(buffer)", &block)
    code ? instance_eval(code, path) : instance_eval(&block)
    self
  rescue Stopped
    self
  end

  # The MIDI number for a note name, read the way Sonic Pi reads it:
  # :c4 is 60, :fs3 is 54, :bf4 and :bb4 are 70.
  def self.midi(note)
    m = /\A([a-g])([sbf]?)(-?\d*)\z/i.match(note.to_s)
    raise ArgumentError, "Invalid note: #{note.inspect}" unless m

    octave = m[3].empty? ? 4 : m[3].to_i
    accidental = { "s" => 1, "b" => -1, "f" => -1 }.fetch(m[2].downcase, 0)
    (octave * 12) + NOTE_INTERVALS[m[1].downcase] + accidental + 12
  end

  # tempo

  def use_bpm(bpm)
    @thread[:bpm] = bpm.to_f
  end

  def with_bpm_mul(mul, &block)
    with_setting(:bpm_mul, @thread[:bpm_mul] * mul, &block)
  end

  def current_bpm
    @thread[:bpm] * @thread[:bpm_mul]
  end

  # synths, notes and samples

  def use_synth(name)
    @thread[:synth] = name
  end

  def with_synth(name, &block)
    with_setting(:synth, name, &block)
  end

  def use_transpose(shift)
    @thread[:transpose] = shift
  end

  def with_transpose(shift, &block)
    with_setting(:transpose, shift, &block)
  end

  def current_transpose
    @thread[:transpose]
  end

  def with_merged_synth_defaults(opts, &block)
    with_setting(:synth_defaults, @thread[:synth_defaults].merge(opts), &block)
  end

  def with_fx(name, _opts = {}, &block)
    with_setting(:fx, @thread[:fx] + [name], &block)
  end

  # nil, :r and :rest are rests; a note's own opts win over the synth defaults
  def play(note, opts = {})
    return if note.nil? || note == :r || note == :rest

    record(:synth, note, @thread[:synth_defaults].merge(opts))
  end

  # plays each note then sleeps for its time, cycling through times if it's shorter
  def play_pattern_timed(notes, times, opts = {})
    times = Array(times)
    notes.each_with_index do |note, i|
      play(note, opts)
      sleep(times[i % times.size])
    end
  end

  def sample(name, opts = {})
    record(:sample, name, opts)
  end

  # time and threads

  def sleep(beats)
    @thread[:time] += beats * 60.0 / current_bpm
    raise Stopped if @stop_at && @thread[:time] > @stop_at
  end

  def in_thread(*_opts)
    parent = @thread
    @thread = parent.dup
    yield
  rescue Stopped
    nil
  ensure
    @thread = parent
  end

  # the rest of the language

  def define(name, &block)
    define_singleton_method(name, &block)
  end

  # like Sonic Pi, runs the file's code right here, without knowing its path
  def eval_file(path)
    instance_eval(File.read(File.expand_path(path.to_s)))
  end

  # like Sonic Pi, a line from a value to the same value is empty
  def line(start, finish, steps: 4, inclusive: false)
    start = start.to_f
    finish = finish.to_f
    return [] if start == finish

    step = (finish - start) / (inclusive ? steps - 1 : steps)
    Array.new(steps) { |i| start + (i * step) }
  end

  private

  def with_setting(key, value)
    saved = @thread[key]
    @thread[key] = value
    yield
  ensure
    @thread[key] = saved
  end

  def record(kind, name, opts)
    @events << Event.new(kind: kind, name: name, time: @thread[:time], bpm: current_bpm,
                         transpose: @thread[:transpose], synth: @thread[:synth],
                         opts: opts, fx: @thread[:fx])
  end
end

# Sonic Pi lets compos do arithmetic on note names (:d4 + -2 is 60) and leaves
# rests alone (lang/western_theory.rb). men_of_erin.rb's transpose needs it.
class Symbol
  def +(other)
    return self if self == :r || self == :rest

    SonicPiStub.midi(self) + (other.is_a?(Numeric) ? other : SonicPiStub.midi(other))
  end

  def -(other)
    return self if self == :r || self == :rest

    SonicPiStub.midi(self) - (other.is_a?(Numeric) ? other : SonicPiStub.midi(other))
  end
end
