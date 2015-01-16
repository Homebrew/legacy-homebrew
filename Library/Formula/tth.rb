class Tth < Formula
  homepage "http://hutchinson.belmont.ma.us/tth/"
  # upstream has been asked to provide versioned links (Jan 12, 2015)
  url "http://hutchinson.belmont.ma.us/tth/tth-noncom/tth_C.tgz"
  sha1 "27b44970d93f1e1964c92ffa0fa964e6045bae37"
  version "4.06"

  bottle do
    cellar :any
    sha1 "dac2cc7df5b0f2f6c77a186fcf799f12a29aff2e" => :yosemite
    sha1 "d869523cd588ee381ae315aed247f57be379b3be" => :mavericks
    sha1 "2dc34ba1293a14891456d91bc2b243233f7a06fd" => :mountain_lion
  end

  def install
    system ENV.cc, "-o", "tth", "tth.c"
    bin.install %w[tth latex2gif ps2gif ps2png]
    man1.install "tth.1"
  end

  test do
    assert_match(/version #{version}/, pipe_output("#{bin}/tth", ""))
  end
end
