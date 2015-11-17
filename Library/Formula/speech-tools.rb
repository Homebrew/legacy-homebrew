class SpeechTools < Formula
  desc "C++ general speech software library from the University of Edinburgh"
  homepage "http://festvox.org/docs/speech_tools-2.4.0/"
  url "http://festvox.org/packed/festival/2.4/speech_tools-2.4-release.tar.gz"
  sha256 "fbc2482c443919aa79d2e599d6a5faee4e793df55a79ef377f1dc7e8ba237010"

  bottle do
    cellar :any
    sha1 "861a04fc277c90118cf88641c2ea2d07e7afa636" => :yosemite
    sha1 "c4b33389281c09184012fb79f53cc1112c8e11ce" => :mavericks
    sha1 "2fe64f901cd995effbcb26edf0ebce2b0a1141fd" => :mountain_lion
  end

  def install
    ENV.deparallelize
    system "./configure"
    system "make"
    # install all executable files in "main" directory
    bin.install Dir["main/*"].select { |f| File.file?(f) && File.executable?(f) }
  end

  test do
    rate_hz = 16000
    frequency_hz = 100
    duration_secs = 5
    basename = "sine"
    txtfile = "#{basename}.txt"
    wavfile = "#{basename}.wav"
    ptcfile = "#{basename}.ptc"

    File.open(txtfile, "w") do |f|
      scale = 2 ** 15 - 1
      f.puts Array.new(duration_secs * rate_hz) { |i| (scale * Math.sin(frequency_hz * 2 * Math::PI * i / rate_hz)).to_i }
    end

    # convert to wav format using ch_wave
    system "ch_wave", txtfile,
      "-itype", "raw",
      "-istype", "ascii",
      "-f", rate_hz.to_s,
      "-o", wavfile,
      "-otype", "riff"

    # pitch tracking to est format using pda
    system "pda", wavfile,
      "-shift", (1 / frequency_hz.to_f).to_s,
      "-o", ptcfile,
      "-otype", "est"

    # extract one frame from the middle using ch_track, capturing stdout
    pitch = `ch_track #{ptcfile} -from #{frequency_hz * duration_secs / 2} -to #{frequency_hz * duration_secs / 2}`.strip

    # should be 100 (Hz)
    assert_equal frequency_hz, pitch.to_i
  end
end
