class Tth < Formula
  homepage "http://hutchinson.belmont.ma.us/tth/"
  url "http://hutchinson.belmont.ma.us/tth/tth_distribution/tth_4.06.tgz"
  sha1 "ba3c653bf05d25ac8a907fb1d51184da1ac42721"
  revision 1

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
