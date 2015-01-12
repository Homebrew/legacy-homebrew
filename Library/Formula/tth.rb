class Tth < Formula
  homepage "http://hutchinson.belmont.ma.us/tth/"
  # upstream has been asked to provide versioned links (Jan 12, 2015)
  url "http://hutchinson.belmont.ma.us/tth/tth-noncom/tth_C.tgz"
  sha1 "27b44970d93f1e1964c92ffa0fa964e6045bae37"
  version "4.06"

  def install
    system ENV.cc, "-o", "tth", "tth.c"
    bin.install %w[tth latex2gif ps2gif ps2png]
    man1.install "tth.1"
  end

  test do
    assert_match(/version #{version}/, pipe_output("#{bin}/tth", ""))
  end
end
